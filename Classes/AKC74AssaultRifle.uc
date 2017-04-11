class AKC74AssaultRifle extends AKBaseWeapon
	config(user);


defaultproperties
{
     MagCapacity=30
     ReloadRate=3.000000
     ReloadAnim="Reload"
	ReloadShortAnim="Reload"
	ReloadShortRate=2.0     
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_AK47"
     Weight=5.000000
     bHasAimingMode=True
     IdleAimAnim="Iron_Idle"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'ScrnWeaponPack_T.AK74.ScrnWeaponPack_T.AKC74_Trader'
     bIsTier2Weapon=True
     MeshRef="ScrnWeaponPack_A.akc74mesh"
     SkinRefs(0)="ScrnWeaponPack_T.AK74.wpn_ak74"
     SkinRefs(1)="KF_Weapons_Trip_T.hands.hands_1stP_military_cmb"
     SkinRefs(2)="ScrnWeaponPack_T.AK74.wpn_ak74_1"
     SelectSoundRef="ScrnWeaponPack_SND.AK74.akc74_draw"
     HudImageRef="ScrnWeaponPack_T.AK74.AKC74_Unselected"
     SelectedHudImageRef="ScrnWeaponPack_T.AK74.AKC74_selected"
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=32.000000
     FireModeClass(0)=Class'ScrnWeaponPack.AKC74Fire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectAnimRate=1.000000
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="The AK-74 is an assault rifle developed in the early 1970s in the Soviet Union as the replacement for the earlier AKM (itself a refined version of the AK-47). It uses a smaller intermediate cartridge, the 5.45x39mm, replacing the 7.62x39mm chambering of earlier Kalashnikov-pattern weapons. Smaller ammunition lowers damage, but makes weapon lighter."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=65.000000
     Priority=100
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=3
     GroupOffset=7
     PickupClass=Class'ScrnWeaponPack.AKC74Pickup'
     PlayerViewOffset=(X=18.000000,Y=22.000000,Z=-6.000000)
     BobDamping=5.000000
     AttachmentClass=Class'ScrnWeaponPack.AKC74Attachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="AK-74 SE"
     TransientSoundVolume=1.250000
}
