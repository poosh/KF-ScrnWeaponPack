class SVDS extends ScopedWeapon;


defaultproperties
{
    CrosshairTexRef="ScrnWeaponPack_T.SVD.PSO1Scope"
    IllumTexRef="ScrnWeaponPack_T.SVD.PSO1Sope_dot" //illuminated reticle
    lenseMaterialID=3
    scopePortalFOVHigh=10.000000
    scopePortalFOV=8.000000 //10
    PlayerIronSightFOV=20.000000 //32
    ZoomedDisplayFOV=70.000000 //50
    ZoomedDisplayFOVHigh=55.000000
    StandardDisplayFOV=65.000000
    ZoomMatRef="ScrnWeaponPack_T.SVD.PSO1ScopeFinalBlend"
    ScriptedTextureFallbackRef="ScrnWeaponPack_T.SVD.AlphaLens"


    bHasScope=True
    MagCapacity=5
    ReloadRate=3.125
    ReloadAnim="Reload"
    ReloadAnimRate=0.800000
    ReloadShortAnim="Reload"
    ReloadShortRate=1.875

    WeaponReloadAnim="Reload_M14"
    Weight=7.000000
    bHasAimingMode=True
    IdleAimAnim="Iron_Idle"
    bModeZeroCanDryFire=True

    // assets
    TraderInfoTexture=Texture'ScrnWeaponPack_T.SVDS.SVD-cTrader'
    MeshRef="ScrnWeaponPack_A.SVDS_mesh"
    SkinRefs(0)="ScrnWeaponPack_T.SVDS.Svd_D_Sh"
    SkinRefs(1)="KF_Weapons2_Trip_T.hands.BritishPara_Hands_1st_P"
    SkinRefs(2)="KF_Weapons_Trip_T.Rifles.CBLens_cmb"
    SkinRefs(3)="ScrnWeaponPack_T.SVD.AlphaLens"
    SelectSoundRef="ScrnWeaponPack_SND.SVD.SVD_select"
    HudImageRef="ScrnWeaponPack_T.SVDS.SVD-cUnselected"
    SelectedHudImageRef="ScrnWeaponPack_T.SVDS.SVD-cSelected"
    FireModeClass(0)=class'SVDSFire'
    FireModeClass(1)=Class'KFMod.NoFire'
    PutDownAnim="PutDown"
    SelectForce="SwitchToAssaultRifle"
    AIRating=0.650000
    CurrentRating=0.650000
    Description="The Dragunov sniper rifle with folding stock (formally Russian: Snayperskaya Vintovka Dragunova Skladnaya, SVDS) is a compact variant of the SVD, which was developed in the early 1990s. Uses Horzine's 5-round 7.62x54mmR magazines to reduce weight."
    DisplayFOV=65.000000
    Priority=150
    CustomCrosshair=11
    CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
    InventoryGroup=4
    GroupOffset=3
    PickupClass=class'SVDSPickup'
    PlayerViewOffset=(X=7.000000,Y=9.000000,Z=-4.000000)
    BobDamping=5.000000
    AttachmentClass=class'SVDSAttachment'
    IconCoords=(X1=253,Y1=146,X2=333,Y2=181)
    ItemName="SVDS SE"
}
