class CZ805MFire extends KFFire;

defaultproperties
{
     FireSoundRef="ScrnWeaponPack_SND.cz805.Firecz805b"
     NoAmmoSoundRef="KF_SCARSnd.SCAR_DryFire"

     FireAimedAnim="Fire_Iron"
     RecoilRate=0.060000
     maxVerticalRecoilAngle=150
     maxHorizontalRecoilAngle=75
     //ShellEjectClass=Class'ROEffects.KFShellEjectSCAR'
     ShellEjectClass=class'CZ805MShellEject' //changed to m4
     ShellEjectBoneName="Shell_eject"
     bAccuracyBonusForSemiAuto=True
     DamageType=class'DamTypeCZ805M'
     DamageMax=41
     Momentum=12500.000000
     bPawnRapidFireAnim=True
     TransientSoundVolume=1.800000
     FireLoopAnim="Fire"
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.09000 //0.096000
     AmmoClass=class'CZ805MAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=300.000000)
     ShakeRotRate=(X=7500.000000,Y=7500.000000,Z=7500.000000)
     ShakeRotTime=0.650000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=7.500000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.150000
     BotRefireRate=0.990000
     FlashEmitterClass=class'CZ805MMuzzleFlash'
     aimerror=42.000000
     Spread=0.007500
     SpreadStyle=SS_Random
}
