class MedicPistolFire extends KFFire;

var MedicPistol ScrnWeap; // avoid typecasting

var float PenDmgReduction; //penetration damage reduction. 1.0 - no reduction, 0 - no penetration, 0.75 - 25% reduction
var byte  MaxPenetrations; //how many enemies can penetrate a single bullet

var int HealAmount, HealBoost;

function PostBeginPlay()
{
    super.PostBeginPlay();
    ScrnWeap = MedicPistol(Weapon);
}

simulated function DestroyEffects()
{
    super.DestroyEffects();
    ScrnWeap = none;
}

simulated event ModeDoFire()
{
    if ( ScrnWeap.bFiringLastRound ) {
        FireAnim = 'FireLast';
        FireAimedAnim = 'FireLast_Iron';
    }
    else {
        FireAnim = default.FireAnim;
        FireAimedAnim = default.FireAimedAnim;
    }
    Super.ModeDoFire();
}

function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X,Y,Z, End, HitLocation, HitNormal, ArcEnd;
    local Actor Other;
    local byte HitCount, PenCounter;
    local float HitDamage;
    local array<int>    HitPoints;
    local KFPawn HitPawn;
    local array<Actor>    IgnoreActors;
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
    local float HealPotency, HealSum;

    if ( Healed.Health <= 0 )
        return;

    HealPotency = 1.0;

    PRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
    if ( PRI != none && PRI.ClientVeteranSkill != none )
        HealPotency = PRI.ClientVeteranSkill.Static.GetHealPotency(PRI);
    HealSum = HealAmount * HealPotency;

    if ( Healed.Controller != none )
        Healed.Controller.ShakeView(ShakeRotMag, ShakeRotRate, ShakeRotTime, ShakeOffsetMag, ShakeOffsetRate, ShakeOffsetTime);

    if ( ScrnHumanPawn(Healed) != none )
        ScrnHumanPawn(Healed).TakeHealing(ScrnHumanPawn(Instigator), HealSum, HealPotency, KFWeapon(Instigator.Weapon));
    else
        Healed.GiveHealth(HealSum, Healed.HealthMax);

    // instantly raise player health
    Healed.Health += int(HealBoost * HealPotency);
    if (Healed.Health > 250) {
        class'ScrnAchCtrl'.static.Ach2Pawn(Instigator, 'MedicPistol_250', 1);
    }

    // Replaced by ScrnHealMessage
    // MedicPistol(Instigator.Weapon).ClientSuccessfulHeal(Healed.PlayerReplicationInfo);
}



defaultproperties
{
    HealAmount=20
    HealBoost=3
    DamageMax=23
    DamageType=class'DamTypeMedicPistol'
    AmmoClass=class'MedicPistolAmmo'
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
