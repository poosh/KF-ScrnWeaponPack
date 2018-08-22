class SVDFire extends SVDSFire;


defaultproperties
{
     StereoFireSoundRef="ScrnWeaponPack_SND.SVD.SVD_shot"
     FireSoundRef="ScrnWeaponPack_SND.SVD.SVD_shot"
     NoAmmoSoundRef="ScrnWeaponPack_SND.SVD.SVD_empty"
     TransientSoundVolume=3.800000

     FireForce="AssaultRifleFire"
     FireRate=0.70 //0.350000
     FireAnimRate=0.70
     AmmoClass=Class'ScrnWeaponPack.SVDAmmo'
     BotRefireRate=1.2
     FireAimedAnim="Fire_Iron"
     RecoilRate=0.15 // 0.3
     maxVerticalRecoilAngle=1500
     maxHorizontalRecoilAngle=50
     ProjectileClass=Class'ScrnWeaponPack.SVDBullet'
     FireLoopAnim="Fire"
     TweenTime=0.025000
}
