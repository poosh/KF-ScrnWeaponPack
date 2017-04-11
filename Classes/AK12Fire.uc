class AK12Fire extends KFFire;


defaultproperties
{
    FireSoundRef="ScrnWeaponPack_SND.AK12.AK12_shot"
    StereoFireSoundRef="ScrnWeaponPack_SND.AK12.AK12_shot"
    NoAmmoSoundRef="ScrnWeaponPack_SND.AK12.AK12_empty"

    FireAimedAnim="Fire_Iron"
    RecoilRate=0.040000
    maxVerticalRecoilAngle=250
    maxHorizontalRecoilAngle=150
    bRecoilRightOnly=True
    ShellEjectClass=Class'ScrnWeaponPack.KFShellEjectAK12AR'
    ShellEjectBoneName="Shell_eject"
    bAccuracyBonusForSemiAuto=True
    bRandomPitchFireSound=False
    DamageType=Class'ScrnWeaponPack.DamTypeAK12AssaultRifle'
    DamageMax=50
    Momentum=18500.000000
    bPawnRapidFireAnim=True
    TransientSoundVolume=3.800000
    FireLoopAnim="Fire"
    TweenTime=0.025000
    FireForce="AssaultRifleFire"
    FireRate=0.095
    AmmoClass=Class'ScrnWeaponPack.AK545Ammo'
    AmmoPerFire=1
    ShakeRotMag=(X=50.000000,Y=50.000000,Z=350.000000)
    ShakeRotRate=(X=5000.000000,Y=5000.000000,Z=5000.000000)
    ShakeRotTime=0.750000
    ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=7.500000)
    ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
    ShakeOffsetTime=1.250000
    BotRefireRate=0.990000
    FlashEmitterClass=Class'ScrnWeaponPack.MuzzleFlashAK12AR'
    aimerror=42.0
    Spread=0.0075
    SpreadStyle=SS_Random
}
