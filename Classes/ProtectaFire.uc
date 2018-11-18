class ProtectaFire extends ShotgunFire;

simulated function bool AllowFire()
{
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

    if( KFWeapon(Weapon).MagAmmoRemaining<1 )
        return false;

    return super(WeaponFire).AllowFire();
}


defaultproperties
{
     // FireSoundRef="KF_IJC_HalloweenSnd.FlarePistol_Fire_M"
     // StereoFireSoundRef="KF_IJC_HalloweenSnd.FlarePistol_Fire_S"

     FireSoundRef="ScrnWeaponPack_SND.Protecta.striker_shot_stereo"
     StereoFireSoundRef="ScrnWeaponPack_SND.Protecta.striker_shot_stereo"
     NoAmmoSoundRef="ScrnWeaponPack_SND.Protecta.striker_empty"

     maxVerticalRecoilAngle=500 //1000
     maxHorizontalRecoilAngle=250 //500
     FireAimedAnim="Fire_Iron"
     FireLoopAimedAnim=
     bRandomPitchFireSound=False
     bWaitForRelease=False
     bModeExclusive=False
     ProjPerFire=1
     bAttachSmokeEmitter=True
     TransientSoundVolume=2.000000
     TransientSoundRadius=500.000000
     FireRate=0.300000
     RecoilRate=0.05
     FireAnimRate=1.75 
     AmmoClass=Class'ScrnWeaponPack.ProtectaAmmo'
     KickMomentum=(X=0,Y=0,Z=0)
     ShakeOffsetMag=(X=6.0,Y=2.0,Z=6.0)
     ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
     ShakeOffsetTime=1.25
     ShakeRotMag=(X=50.0,Y=50.0,Z=250.0)
     ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
     ShakeRotTime=3.0
     ProjectileClass=Class'ScrnWeaponPack.ProtectaFlare'
     BotRefireRate=0.250000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stKar'
     aimerror=2.000000
     Spread=0.000
     SpreadStyle=SS_None
}
