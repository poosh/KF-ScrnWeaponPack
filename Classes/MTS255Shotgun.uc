class MTS255Shotgun extends KFWeapon;

#exec OBJ LOAD FILE=ScrnWeaponPack_T.utx
#exec OBJ LOAD FILE=ScrnWeaponPack_A.ukx
#exec OBJ LOAD FILE=ScrnWeaponPack_SM.usx


defaultproperties
{
     HudImageRef="ScrnWeaponPack_T.MTS.MTS255_unselected"
     SelectedHudImageRef="ScrnWeaponPack_T.MTS.MTS255_selected"
     SelectSoundRef="KF_M4ShotgunSnd.foley.WEP_Benelli_Foley_Select"

     MeshRef="ScrnWeaponPack_A.MTS255_1st"
     //MeshRef="MTS255_Anim.MTS255"
     SkinRefs(0)="KF_Weapons_Trip_T.hands.hands_1stP_military_cmb"
     SkinRefs(1)="ScrnWeaponPack_T.MTS.Osnova_cmb"
     SkinRefs(2)="ScrnWeaponPack_T.MTS.Pricel_cmb"
     SkinRefs(3)="ScrnWeaponPack_T.MTS.Zaryadka_cmb"
     SkinRefs(4)="ScrnWeaponPack_T.MTS.Patron_cmb"     

     MagCapacity=5
     ReloadRate=2.200000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_Winchester"
     Weight=7
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     SleeveNum=0
     TraderInfoTexture=Texture'ScrnWeaponPack_T.MTS.MTS255_Trader'
     PlayerIronSightFOV=80.000000
     ZoomedDisplayFOV=45.000000
     FireModeClass(0)=class'MTS255Fire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="The MTs-255 is a 12-gauge shotgun fed by a 5-round internal revolving cylinder. Holds up to 5 explosive slugs."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=65.000000
     Priority=200
     InventoryGroup=3
     GroupOffset=10
     PickupClass=class'MTS255Pickup'
     PlayerViewOffset=(X=19.700001,Y=18.750000,Z=-7.500000)
     BobDamping=6.000000
     AttachmentClass=class'MTS255Attachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="MTs-255 Shotgun SE"
     TransientSoundVolume=1.250000
     bHoldToReload=False
}
