class HuntingRifle extends ScopedWeapon;


defaultproperties
{
    ZoomMatRef="ScrnWeaponPack_T.BDHR.RifleCrossFinal"
    ScriptedTextureFallbackRef="KF_Weapons_Trip_T.Rifles.CBLens_cmb"
    HudImageRef="ScrnWeaponPack_T.BDHR.HR_Unselected"
    SelectedHudImageRef="ScrnWeaponPack_T.BDHR.HR_selected"
    SelectSoundRef="KF_PumpSGSnd.SG_Select"
    MeshRef="ScrnWeaponPack_A.hunt_rifle"
    SkinRefs(0)="ScrnWeaponPack_T.BDHR.HR_Final"
    SkinRefs(1)="KF_Weapons2_Trip_T.hands.BritishPara_Hands_1st_P"
    SkinRefs(2)="KF_Weapons_Trip_T.Rifles.CBLens_cmb"
    CrosshairTexRef="ScrnWeaponPack_T.BDHR.BDHR.HRCross"

    lenseMaterialID=2
    scopePortalFOVHigh=22.000000
    scopePortalFOV=12.000000
    ZoomedDisplayFOVHigh=45.000000
    bHasScope=True
    MagCapacity=5
    ReloadRate=4.000000
    ReloadAnim="Reload"
    ReloadAnimRate=1.15
    ReloadShortAnim="Reload"
    ReloadShortRate=2.78
    WeaponReloadAnim="Reload_M14"
    Weight=7.000000
    bHasAimingMode=True
    IdleAimAnim="Idle_Iron"
    StandardDisplayFOV=65.000000
    bModeZeroCanDryFire=True
    TraderInfoTexture=Texture'ScrnWeaponPack_T.BDHR.huntingrifle_Trader'
    PlayerIronSightFOV=32.000000
    ZoomedDisplayFOV=60.000000
    FireModeClass(0)=Class'ScrnWeaponPack.HuntingRifleFire'
    FireModeClass(1)=Class'KFMod.NoFire'
    PutDownAnim="PutDown"
    SelectForce="SwitchToAssaultRifle"
    AIRating=0.650000
    CurrentRating=0.650000
    Description="A recreational hunting weapon, featuring a firing trigger and a powerful integrated scope. "
    DisplayFOV=65.000000
    Priority=10
    CustomCrosshair=11
    CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
    InventoryGroup=4
    GroupOffset=3
    PickupClass=Class'ScrnWeaponPack.HuntingRiflePickup'
    PlayerViewOffset=(X=15.000000,Y=16.000000,Z=-4.000000)
    BobDamping=6.000000
    AttachmentClass=Class'ScrnWeaponPack.HuntingRifleAttachment'
    IconCoords=(X1=253,Y1=146,X2=333,Y2=181)
    ItemName="Hunting Rifle SE"
}
