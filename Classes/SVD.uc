class SVD extends SVDS;

function byte BestMode()
{
    return 0;
}

simulated function Notify_ShowBullets()
{
    local int AvailableAmmo;

    AvailableAmmo = AmmoAmount(0);

    if (AvailableAmmo == 0)
    {
        SetBoneScale (0, 0.0, 'bullet1');
        SetBoneScale (1, 0.0, 'Bullet');
    }
    else if (AvailableAmmo == 1)
    {
        SetBoneScale (0, 1.0, 'bullet1');
        SetBoneScale (1, 0.0, 'Bullet');
    }
    else
    {
        SetBoneScale (0, 1.0, 'bullet1');
        SetBoneScale (1, 1.0, 'Bullet');
    }
}

simulated function Notify_HideBullets()
{
    if (MagAmmoRemaining <= 1)
    {
        SetBoneScale (0, 0.0, 'bullet1');
        SetBoneScale (1, 0.0, 'Bullet');
    }
    else if (MagAmmoRemaining == 2)
    {
        SetBoneScale (1, 0.0, 'Bullet');
    }
}


defaultproperties
{
    CrosshairTexRef="ScrnWeaponPack_T.SVD.PSO1Scope"
    IllumTexRef="ScrnWeaponPack_T.SVD.PSO1Sope_dot" //illuminated reticle
    ZoomMatRef="ScrnWeaponPack_T.SVD.PSO1ScopeFinalBlend"
    ScriptedTextureFallbackRef="ScrnWeaponPack_T.SVD.AlphaLens"


    TraderInfoTexture=Texture'ScrnWeaponPack_T.SVD.SVD_Trader'
    HudImageRef="ScrnWeaponPack_T.SVD.SVD_Unselected"
    SelectedHudImageRef="ScrnWeaponPack_T.SVD.SVD_selected"
    SelectSoundRef="ScrnWeaponPack_SND.SVD.SVD_select"
    MeshRef="ScrnWeaponPack_A.SVD_mesh"
    SkinRefs(0)="ScrnWeaponPack_T.SVD.SVD_tex_1_cmb"
    SkinRefs(1)="KF_Weapons5_Trip_T.First_Sleeves.Steampunk_DJ_Scully_First_Person_Sleeves"
    SkinRefs(2)="ScrnWeaponPack_T.SVD.SVD_tex_2_cmb"
    SkinRefs(3)="ScrnWeaponPack_T.SVD.SVD_tex_3_cmb"
    SkinRefs(4)="ScrnWeaponPack_T.SVD.AlphaLens"
    SkinRefs(5)="ScrnWeaponPack_T.SVD.SVD_tex_4_cmb"

    ReloadShortAnim="Reload_Short"
    ReloadShortRate=4.000000
    lenseMaterialID=4
    scopePortalFOVHigh=12.000000
    scopePortalFOV=10.000000 //12
    bHasScope=True
    ZoomedDisplayFOVHigh=35.000000
    ZoomedDisplayFOV=50 //32
    MagCapacity=10
    ReloadRate=5.000000
    ReloadAnim="Reload"
    ReloadAnimRate=1.000000
    WeaponReloadAnim="Reload_AK47"
    Weight=11
    bHasAimingMode=True
    IdleAimAnim="Idle_Iron"
    StandardDisplayFOV=65.000000
    bModeZeroCanDryFire=True

    PlayerIronSightFOV=22.000000
    FireModeClass(0)=Class'ScrnWeaponPack.SVDFire'
    FireModeClass(1)=Class'ScrnWeaponPack.SVDFireB'
    PutDownAnim="PutDown"
    //BringUpTime=0.930000

    SelectForce="SwitchToAssaultRifle"
    AIRating=0.650000
    CurrentRating=0.650000
    Description="The Dragunov sniper rifle (formally Russian: Snayperskaya Vintovka Dragunova, SVD) is a semi-automatic sniper rifle/designated marksman rifle chambered in 7.62x54mmR and developed in the Soviet Union."
    DisplayFOV=65.000000
    Priority=190
    CustomCrosshair=11
    CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
    InventoryGroup=4
    GroupOffset=3
    PickupClass=Class'ScrnWeaponPack.SVDPickup'
    PlayerViewOffset=(X=6.000000,Y=22.000000,Z=-12.000000)
    BobDamping=6.000000
    AttachmentClass=Class'ScrnWeaponPack.SVDAttachment'
    IconCoords=(X1=253,Y1=146,X2=333,Y2=181)
    ItemName="SVD (Dragunov) SE"

}
