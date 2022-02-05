class Protecta extends KFWeaponShotgun;

// Use alt fire to switch fire modes
simulated function AltFire(float F)
{
    if(ReadyToFire(0))
    {
        DoToggle();
    }
}

exec function SwitchModes()
{
    DoToggle();
}


defaultproperties
{
     SkinRefs(0)="ScrnWeaponPack_T.Protecta.Protecta_tex_1_cmb"
     SkinRefs(1)="ScrnWeaponPack_T.Protecta.Protecta_tex_2_cmb"
     SkinRefs(2)="ScrnWeaponPack_T.Protecta.Protecta_tex_3_cmb"
     SkinRefs(3)="ScrnWeaponPack_T.Effects.RedColor"
     SkinRefs(4)="KF_Weapons2_Trip_T.Special.Aimpoint_sight_shdr"
     MeshRef="ScrnWeaponPack_A.Protecta_mesh"
     HudImageRef="ScrnWeaponPack_T.Protecta.Protecta_Unselected"
     SelectedHudImageRef="ScrnWeaponPack_T.Protecta.Protecta_selected"
     SelectSoundRef="ScrnWeaponPack_SND.Protecta.striker_select"


     MagCapacity=12
     ReloadRate=0.455 //0.91
     ReloadAnim="Reload"
     ReloadAnimRate=2.0
     WeaponReloadAnim="Reload_Shotgun"
     Weight=8
     bTorchEnabled=false
     bHoldToReload=True
     bHasAimingMode=True
     IdleAimAnim="Iron_Idle"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     SleeveNum=3
     TraderInfoTexture=Texture'ScrnWeaponPack_T.Protecta.Protecta_Trader'
     PlayerIronSightFOV=70.000000
     ZoomedDisplayFOV=40.000000
     FireModeClass(0)=class'ProtectaFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     AIRating=0.600000
     CurrentRating=0.600000
     bShowChargingBar=True
     Description="Protecta Automatic Shotgun was outshined by AA12 in every aspect until Horzine technicians managed to load it with flares..."
     DisplayFOV=65.000000
     Priority=199
     InventoryGroup=4
     GroupOffset=9
     PickupClass=class'ProtectaPickup'
     PlayerViewOffset=(X=25.000000,Y=20.000000,Z=-7.000000)
     BobDamping=5.000000
     AttachmentClass=class'ProtectaAttachment'
     IconCoords=(X1=169,Y1=172,X2=245,Y2=208)
     ItemName="Flare Shotgun 'Protecta' SE"
     TransientSoundVolume=1.250000
     PlayerViewPivot=(Pitch=20,Roll=0,Yaw=20) //sight alignment fix
}
