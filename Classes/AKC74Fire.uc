class AKC74Fire extends KFFire;

defaultproperties
{
     FireAimedAnim="Fire_Iron"
     RecoilRate=0.040000
     maxVerticalRecoilAngle=400
     maxHorizontalRecoilAngle=200
     bRecoilRightOnly=True
     ShellEjectClass=Class'ROEffects.KFShellEjectAK'
     ShellEjectBoneName="Shell_eject"
     bAccuracyBonusForSemiAuto=True
     bRandomPitchFireSound=False
     FireSoundRef="ScrnWeaponPack_SND.AK74.akc74_shoot_mono"
     StereoFireSoundRef="ScrnWeaponPack_SND.AK74.akc74_shoot_stereo"
     NoAmmoSoundRef="ScrnWeaponPack_SND.AK74.akc74__empty"
     DamageType=Class'ScrnWeaponPack.DamTypeAK74AssaultRifle'
     DamageMin=38
     DamageMax=38
     Momentum=9500.000000
     bPawnRapidFireAnim=True
     TransientSoundVolume=1.800000
     FireLoopAnim="Fire"
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.104000
     AmmoClass=Class'ScrnWeaponPack.AK545Ammo'
     AmmoPerFire=1
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=350.000000)
     ShakeRotRate=(X=5000.000000,Y=5000.000000,Z=5000.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=7.500000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
     BotRefireRate=0.990000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stSTG'
     aimerror=42.000000
     Spread=0.010000
     SpreadStyle=SS_Random
}
