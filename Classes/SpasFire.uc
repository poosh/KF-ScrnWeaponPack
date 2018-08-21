//=============================================================================
// Shotgun Fire
//=============================================================================
class SpasFire extends ShotgunFire;

simulated function bool AllowFire()
{
                                                                             //changed to 1 -- PooSH
    if( KFWeapon(Weapon).bIsReloading && KFWeapon(Weapon).MagAmmoRemaining < 1)
        return false;

    if(KFPawn(Instigator).SecondaryItem!=none)
        return false;
    if( KFPawn(Instigator).bThrowingNade )
        return false;

    if( Level.TimeSeconds - LastClickTime>FireRate )
    {
        LastClickTime = Level.TimeSeconds;
    }

    if( KFWeaponShotgun(Weapon).MagAmmoRemaining<1 )
    {
            return false;
    }

    return super(WeaponFire).AllowFire();
}

defaultproperties
{
     FireSoundRef="KF_PumpSGSnd.SG_Fire"
     StereoFireSoundRef="KF_PumpSGSnd.SG_FireST"
     NoAmmoSoundRef="KF_PumpSGSnd.SG_DryFire"

     KickMomentum=(X=-85.000000,Z=15.000000)
     ProjPerFire=7//10
     bAttachSmokeEmitter=True
     TransientSoundVolume=2.000000
     TransientSoundRadius=500.000000
     FireRate=0.965
     FireAnimRate=0.95
     AmmoClass=Class'ScrnWeaponPack.SpasAmmo'
     ProjectileClass=Class'ScrnWeaponPack.SpasBullet'
     BotRefireRate=1.500000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stKar'
     aimerror=1.000000
     Spread=1025.000000
     maxVerticalRecoilAngle=1500
     maxHorizontalRecoilAngle=900
     FireAimedAnim="Fire_Iron"

     //** View shake **//
     ShakeOffsetMag=(X=6.0,Y=2.0,Z=10.0)
     ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
     ShakeOffsetTime=3.0
     ShakeRotMag=(X=50.0,Y=50.0,Z=400.0)
     ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
     ShakeRotTime=5.0
     bWaitForRelease=true
     bRandomPitchFireSound=false
}
