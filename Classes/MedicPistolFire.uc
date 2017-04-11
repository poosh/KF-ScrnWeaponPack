class MedicPistolFire extends KFFire;

var float PenDmgReduction; //penetration damage reduction. 1.0 - no reduction, 0 - no penetration, 0.75 - 25% reduction
var byte  MaxPenetrations; //how many enemies can penetrate a single bullet

var int HealAmount, HealBoost;


function DoTrace(Vector Start, Rotator Dir)
{
	local Vector X,Y,Z, End, HitLocation, HitNormal, ArcEnd;
	local Actor Other;
	local byte HitCount, PenCounter;
	local float HitDamage;
	local array<int>	HitPoints;
	local KFPawn HitPawn;
	local array<Actor>	IgnoreActors;
	local Pawn DamagePawn;
	local int i;
    
    local KFMonster Monster;
    local bool bWasDecapitated;
	//local int OldHealth;

	MaxRange();

	Weapon.GetViewAxes(X, Y, Z);
	if ( Weapon.WeaponCentered() )
	{
		ArcEnd = (Instigator.Location + Weapon.EffectOffset.X * X + 1.5 * Weapon.EffectOffset.Z * Z);
	}
	else
    {
        ArcEnd = (Instigator.Location + Instigator.CalcDrawOffset(Weapon) + Weapon.EffectOffset.X * X +
		 Weapon.Hand * Weapon.EffectOffset.Y * Y + Weapon.EffectOffset.Z * Z);
    }

	X = Vector(Dir);
	End = Start + TraceRange * X;
	HitDamage = DamageMax;
	
	// HitCount isn't a number of max penetration. It is just to be sure we won't stuck in infinite loop
	While( ++HitCount < 127 ) 
	{
        DamagePawn = none;
        Monster = none;

		Other = Instigator.HitPointTrace(HitLocation, HitNormal, End, HitPoints, Start,, 1);
		if( Other==None )
			Break;
		else if( Other==Instigator || Other.Base == Instigator ) {
			IgnoreActors[IgnoreActors.Length] = Other;
			Other.SetCollision(false);
			Start = HitLocation;
			Continue;
		}
        else if ( ROBulletWhipAttachment(Other) != none ) {
             IgnoreActors[IgnoreActors.Length] = Other;
             Start = HitLocation;
             continue;
        }

		if( ExtendedZCollision(Other)!=None && Other.Owner!=None )
		{
            IgnoreActors[IgnoreActors.Length] = Other;
            IgnoreActors[IgnoreActors.Length] = Other.Owner;
			Other.SetCollision(false);
			Other.Owner.SetCollision(false);
			DamagePawn = Pawn(Other.Owner);
            Monster = KFMonster(Other.Owner);
		}

		if ( !Other.bWorldGeometry && Other!=Level )
		{
			HitPawn = KFPawn(Other);

	    	if ( HitPawn != none )
	    	{
                if ( HitPawn.Health > 0 ) {
                    MedicPistol(Instigator.Weapon).HitHealTarget(HitLocation, Rotator(-HitNormal));
                    HealPawn(HitPawn);
                    break;
                }
                 // Hit detection debugging
				 /*log("PreLaunchTrace hit "$HitPawn.PlayerReplicationInfo.PlayerName);
				 HitPawn.HitStart = Start;
				 HitPawn.HitEnd = End;*/

                 // Hit detection debugging
				 /*if( Level.NetMode == NM_Standalone)
				 	  HitPawn.DrawBoneLocation();*/

                IgnoreActors[IgnoreActors.Length] = Other;
                IgnoreActors[IgnoreActors.Length] = HitPawn.AuxCollisionCylinder;
    			Other.SetCollision(false);
    			HitPawn.AuxCollisionCylinder.SetCollision(false);
    			DamagePawn = HitPawn;
			}
            else
            {
    			if( DamagePawn == none )
        			DamagePawn = Pawn(Other);

                if( KFMonster(Other)!=None )
    			{
                    IgnoreActors[IgnoreActors.Length] = Other;
        			Other.SetCollision(false);
                    Monster = KFMonster(Other);
					//OldHealth = KFMonster(Other).Health;
    			}
                bWasDecapitated = Monster != none && Monster.bDecapitated;
                
                // DAMAGE & HEAL
    			Other.TakeDamage(int(HitDamage), Instigator, HitLocation, Momentum*X, DamageType);
                if ( Monster != none && !Monster.bDecapitated && Monster.Health > 0 ) {
                    MedicPistol(Instigator.Weapon).HitHealTarget(HitLocation, Rotator(-HitNormal));
                    Monster.Health += int(HitDamage * class<KFWeaponDamageType>(DamageType).default.HeadShotDamageMult);
                    if ( Monster.Health > 2 * Monster.HealthMax ) {
                        Monster.TakeDamage(Monster.Health * 10, Instigator, Monster.Location, vect(0,0,1), class'DamTypeMedicOvercharge' ); 
                    }
                }
			}
			if( ++PenCounter > MaxPenetrations || DamagePawn==None )
			{
				Break;
			}
			HitDamage *= PenDmgReduction;
			Start = HitLocation;
		}
		else if ( HitScanBlockingVolume(Other)==None )
		{
			if( KFWeaponAttachment(Weapon.ThirdPersonActor)!=None )
		      KFWeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other,HitLocation,HitNormal);
			Break;
		}
	}

    // Turn the collision back on for any actors we turned it off
	if ( IgnoreActors.Length > 0 )
	{
		for (i=0; i<IgnoreActors.Length; i++)
		{
            if ( IgnoreActors[i] != none )
                IgnoreActors[i].SetCollision(true);
		}
	}
}

function HealPawn(KFPawn Healed)
{
    local KFPlayerReplicationInfo PRI;
    local SRStatsBase Stats;
    local int MedicReward;
    local float HealPotency, HealSum;
    
    if ( Healed.Health <= 0 )
        return;
    
    //if( Instigator != none && Healed.Health > 0 && Healed.Health <  Healed.HealthMax ) {
    PRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
    if ( PRI != none )
        Stats = SRStatsBase(PRI.SteamStatsAndAchievements);
    HealPotency = 1.0;

    if ( PRI != none && PRI.ClientVeteranSkill != none )
        HealPotency = PRI.ClientVeteranSkill.Static.GetHealPotency(PRI);

    MedicReward = HealAmount * HealPotency;
    HealSum = MedicReward;

    if ( (Healed.Health + Healed.healthToGive + MedicReward) > Healed.HealthMax ) {
        MedicReward = max(0, Healed.HealthMax - (Healed.Health + Healed.healthToGive));
    }

    if ( Healed.Controller != none )
        Healed.Controller.ShakeView(ShakeRotMag, ShakeRotRate, ShakeRotTime, ShakeOffsetMag, ShakeOffsetRate, ShakeOffsetTime);
    
    if ( ScrnHumanPawn(Healed) != none )
        ScrnHumanPawn(Healed).TakeHealing(ScrnHumanPawn(Instigator), HealSum, HealPotency, KFWeapon(Instigator.Weapon));
    else 
        Healed.GiveHealth(HealSum, Healed.HealthMax);
    
    // instantly raise player health
    Healed.Health += int(HealBoost * HealPotency);
    if ( Healed.Health > 250 && Stats != none )  
        class'ScrnAchievements'.static.ProgressAchievementByID(Stats.Rep, 'MedicPistol_250', 1);

    if ( PRI != None && Stats != none ) {
        Stats.AddDamageHealed(MedicReward + int(HealBoost * HealPotency), false, false);

        // Give the medic reward money as a percentage of how much of the person's health they healed
        MedicReward *= 0.6;

        if ( class'ScrnBalance'.default.Mut.bMedicRewardFromTeam && Healed.PlayerReplicationInfo != none && Healed.PlayerReplicationInfo.Team != none ) {
            // give money from team budget
            if ( Healed.PlayerReplicationInfo.Team.Score >= MedicReward ) {
                Healed.PlayerReplicationInfo.Team.Score -= MedicReward;
                PRI.Score += MedicReward;
            }
        }
        else 
            PRI.Score += MedicReward;

        if ( KFHumanPawn(Instigator) != none )
            KFHumanPawn(Instigator).AlphaAmount = 255;

        MedicPistol(Instigator.Weapon).ClientSuccessfulHeal(Healed.PlayerReplicationInfo);
    }
}



defaultproperties
{
    HealAmount=20
    HealBoost=3
    DamageMax=23
    DamageType=Class'ScrnWeaponPack.DamTypeMedicPistol'
    AmmoClass=Class'ScrnWeaponPack.MedicPistolAmmo'
    PenDmgReduction=0.50
    MaxPenetrations=0
    bWaitForRelease=True
    
    maxVerticalRecoilAngle=250
    maxHorizontalRecoilAngle=50
    FireAimedAnim="Fire_Iron"
    FireSoundRef="KF_MP7Snd.Medicgun_Fire"
    StereoFireSoundRef="KF_MP7Snd.Medicgun_FireST"
    NoAmmoSoundRef="KF_PumpSGSnd.SG_DryFire"
    bAttachSmokeEmitter=False
    TransientSoundVolume=2.000000
    TransientSoundRadius=500.000000
    FireRate=0.25
    AmmoPerFire=1
    ShakeRotMag=(X=75.000000,Y=75.000000,Z=290.000000)
    ShakeRotRate=(X=10080.000000,Y=10080.000000,Z=10000.000000)
    ShakeRotTime=3.500000
    ShakeOffsetMag=(X=6.000000,Y=1.000000,Z=8.000000)
    ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
    ShakeOffsetTime=2.500000
    BotRefireRate=0.40
    FlashEmitterClass=Class'ROEffects.MuzzleFlash1stKar'
    aimerror=1.000000
    Spread=0.010000
    SpreadStyle=SS_Random
}
