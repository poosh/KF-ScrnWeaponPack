//=============================================================================
// Colt Fire
//=============================================================================
class ColtFire extends KFFire;

var float PenDmgReduction; //penetration damage reduction. 1.0 - no reduction, 25% reduction
var byte  MaxPenetrations; //how many enemies can penetrate a single bullet

function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X,Y,Z, End, HitLocation, HitNormal, ArcEnd;
    local Actor Other;
    local byte HitCount, PenCounter, KillCount;
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
        {
            Break;
        }
        else if( Other==Instigator || Other.Base == Instigator )
        {
            IgnoreActors[IgnoreActors.Length] = Other;
            Other.SetCollision(false);
            Start = HitLocation;
            Continue;
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
                 // Hit detection debugging
                 /*log("PreLaunchTrace hit "$HitPawn.PlayerReplicationInfo.PlayerName);
                 HitPawn.HitStart = Start;
                 HitPawn.HitEnd = End;*/
                 if(!HitPawn.bDeleteMe)
                     HitPawn.ProcessLocationalDamage(int(HitDamage), Instigator, HitLocation, Momentum*X,DamageType,HitPoints);

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
                Other.TakeDamage(int(HitDamage), Instigator, HitLocation, Momentum*X, DamageType);
                if ( DamagePawn != none && (DamagePawn.Health <= 0 || (Monster != none
                        && !bWasDecapitated && Monster.bDecapitated)) )
                {
                    KillCount++;
                }

                // debug info
                // if ( KFMonster(Other) != none )
                    // log(String(class) $ ": Damage("$PenCounter$") = "
                        // $ int(HitDamage) $"/"$ (OldHealth-KFMonster(Other).Health)
                        // @ KFMonster(Other).MenuName , class.outer.name);
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

defaultproperties
{
     StereoFireSoundRef="ScrnWeaponPack_SND.Colt.ScrnWeaponPack.357_fire3_ST"
     FireSoundRef="ScrnWeaponPack_SND.Colt.357_fire3"
     NoAmmoSoundRef="KF_HandcannonSnd.50AE_DryFire"

     PenDmgReduction=0.5
     MaxPenetrations=2
     RecoilRate=0.400000 //0.85
     maxVerticalRecoilAngle=3000 //300
     maxHorizontalRecoilAngle=500 //50
     DamageType=Class'ScrnWeaponPack.DamTypeColt'
     DamageMin=350
     DamageMax=350
     Momentum=10000.000000
     bWaitForRelease=True
     bAttachSmokeEmitter=True
     TransientSoundVolume=2.00 // 2.5
     TransientSoundRadius=150 // 400
     FireAnimRate=1.50000 //synced better with fire animation
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.900000
     AmmoClass=Class'ScrnWeaponPack.ColtAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=75.000000,Y=75.000000,Z=400.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=10000.000000)
     ShakeRotTime=3.500000
     ShakeOffsetMag=(X=6.000000,Y=1.000000,Z=8.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=2.500000
     BotRefireRate=0.350000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stKar'
     aimerror=30.000000
     Spread=0.015000
     SpreadStyle=SS_Random
     ShellEjectClass=None
}
