//=============================================================================
// HuntingRifleFire
//=============================================================================
class HuntingRifleFire extends KFFire;

var vector ScopedShakeOffsetMag; //Shake offset mag used for 3d scopes
var vector ScopedShakeOffsetRate; //Shake offset rate used for 3d scopes

//adds limited shot penetration
function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X,Y,Z, End, HitLocation, HitNormal, ArcEnd;
    local Actor Other;
    local byte HitCount,HCounter;
    local float HitDamage;
    local array<int>    HitPoints;
    local KFPawn HitPawn;
    local array<Actor>    IgnoreActors;
    local Actor DamageActor;
    local int i;

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
    While( (HitCount++)<10 )
    {
        DamageActor = none;

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
            DamageActor = Pawn(Other.Owner);
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
                DamageActor = Other;
            }
            else
            {
                if( KFMonster(Other)!=None )
                {
                    IgnoreActors[IgnoreActors.Length] = Other;
                    Other.SetCollision(false);
                    DamageActor = Other;
                }
                else if( DamageActor == none )
                {
                    DamageActor = Other;
                }
                Other.TakeDamage(int(HitDamage), Instigator, HitLocation, Momentum*X, DamageType);
            }
            if( (HCounter++)>=5 || Pawn(DamageActor)==None )
            {
                Break;
            }
            HitDamage*=0.75;
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
    for (i=0; i<IgnoreActors.Length; i++)
        if ( IgnoreActors[i] != none )
            IgnoreActors[i].SetCollision(true);
}

//adds faked recoil to 3d scope zoom
event ModeDoFire()
{
    if( KFWeapon(Weapon).bAimingRifle )
    {
        if ( KFWeapon(Weapon).KFScopeDetail != KF_TextureScope)
        {
            ShakeOffsetMag=default.ScopedShakeOffsetMag;
            ShakeOffsetRate=default.ScopedShakeOffsetRate;
        }
    }
    else 
    {
        ShakeOffsetMag=default.ShakeOffsetMag;
        ShakeOffsetRate=default.ShakeOffsetRate;
    }
    Super.ModeDoFire();
}

defaultproperties
{
     FireSoundRef="ScrnWeaponPack_SND.BDHR.awp1_mono"
     StereoFireSoundRef="ScrnWeaponPack_SND.BDHR.awp1_stereo"
     NoAmmoSoundRef="KF_RifleSnd.Rifle_DryFire"

     FireAimedAnim="Fire_Iron"
     RecoilRate=0.100000
     maxVerticalRecoilAngle=800
     maxHorizontalRecoilAngle=250
     DamageType=class'DamTypeHuntingRifle'
     DamageMin=190
     DamageMax=220
     Momentum=18000.000000
     bWaitForRelease=True
     bModeExclusive=False
     bAttachSmokeEmitter=True
     TransientSoundVolume=1.800000
     FireLoopAnim=
     FireEndAnim=
     FireForce="ShockRifleFire"
     FireRate=1.900000
     AmmoClass=class'HuntingRifleAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=100.000000,Y=100.000000,Z=500.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=0.000000,Y=0.000000,Z=0.000000)
     ScopedShakeOffsetMag=(X=3.000000,Y=0.000000,Z=0.000000) //faked recoil for 3d scope
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ScopedShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000) //faked recoil for 3d scope
     ShakeOffsetTime=2.000000
     BotRefireRate=0.650000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stKar'
     aimerror=0.000000
     Spread=0.007000
}
