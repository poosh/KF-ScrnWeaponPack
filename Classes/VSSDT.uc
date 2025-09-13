class VSSDT extends ScopedWeapon;


// Use alt fire to switch fire modes
simulated function AltFire(float F)
{
    DoToggle();
}

exec function SwitchModes()
{
    DoToggle();
}



defaultproperties
{
    CrosshairTexRef="ScrnWeaponPack_T.VSS.PSO1Sope"
    ScriptedTextureFallbackRef="ScrnWeaponPack_T.SVD.AlphaLens"
    IllumTexRef="ScrnWeaponPack_T.SVD.PSO1Sope_dot" //illuminated reticle


     lenseMaterialID=2
     scopePortalFOVHigh=20.000000
     scopePortalFOV=10.000000
     ZoomedDisplayFOVHigh=55
     ZoomedDisplayFOV=65
     StandardDisplayFOV=65.000000
     PlayerIronSightFOV=30 //32

     ZoomMatRef="ScrnWeaponPack_T.VSS.PSO1ScopeFinalBlend"
     bHasScope=True
     MagCapacity=10
     ReloadRate=3.000000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     ReloadShortAnim="Reload"
     ReloadShortRate=2.27
     WeaponReloadAnim="Reload_AK47"
     Weight=6.000000
     bHasAimingMode=True
     IdleAimAnim="Iron_Idle"
     bModeZeroCanDryFire=True
     SleeveNum=0
     TraderInfoTexture=Texture'ScrnWeaponPack_T.VSS.VSSDT_Trader'
     MeshRef="ScrnWeaponPack_A.vintorezDTmesh"
     SkinRefs(0)="KF_Weapons2_Trip_T.hands.BritishPara_Hands_1st_P"
     SkinRefs(1)="KF_Weapons_Trip_T.Rifles.CBLens_cmb"
     SkinRefs(2)="ScrnWeaponPack_T.SVD.AlphaLens"
     SkinRefs(3)="ScrnWeaponPack_T.VSS.newvss_cmb"
     SkinRefs(4)="ScrnWeaponPack_T.VSS.mag_9x39_cmb"
     SkinRefs(5)="ScrnWeaponPack_T.VSS.Scope"
     SelectSoundRef="ScrnWeaponPack_SND.VSS.VSS_Draw"
     HudImageRef="ScrnWeaponPack_T.VSS.vssDT_Unselected"
     SelectedHudImageRef="ScrnWeaponPack_T.VSS.vssDT_selected"
     FireModeClass(0)=class'VSSDTFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.650000
     CurrentRating=0.650000
     Description="The VSS (Special Sniper Rifle), also called the Vintorez (thread cutter), is a suppressed sniper rifle developed in the late 1980s by TsNIITochMash and manufactured by the Tula Arsenal. It is issued primarily to Spetsnaz units for undercover or clandestine operations, a role made evident by its ability to be stripped down for transport in a specially fitted briefcase."
     DisplayFOV=65.000000
     Priority=160
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=3
     GroupOffset=3
     PickupClass=class'VSSDTPickup'
     PlayerViewOffset=(X=12.000000,Y=12.000000,Z=-3.000000)
     BobDamping=6.000000
     AttachmentClass=class'VSSDTAttachment'
     IconCoords=(X1=253,Y1=146,X2=333,Y2=181)
     ItemName="VSS (Vintorez) SE"
}
