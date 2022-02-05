class AK12AssaultRifle extends AKBaseWeapon;


defaultproperties
{
    SkinRefs(0)="ScrnWeaponPack_T.AK12.AK12_tex_1_cmb"
    SkinRefs(1)="ScrnWeaponPack_T.AK12.AK12_tex_2_cmb"
    SkinRefs(2)="ScrnWeaponPack_T.AK12.AK12_tex_3_cmb"
    SkinRefs(3)="ScrnWeaponPack_T.AK12.AK12_tex_4_cmb"
    SkinRefs(4)="ScrnWeaponPack_T.AK12.AK12_tex_5_cmb"
    SkinRefs(5)="ScrnWeaponPack_T.AK12.AK12_tex_6_cmb"
    SkinRefs(6)="ScrnWeaponPack_T.AK12.AK12_tex_7_cmb"
    SkinRefs(7)="ScrnWeaponPack_T.AK12.AK12_aimpoint_sh"
    SkinRefs(8)="KF_Weapons_Trip_T.hands.hands_1stP_military_cmb"
    MeshRef="ScrnWeaponPack_A.AK12_mesh"
    SelectSoundRef="ScrnWeaponPack_SND.AK12.AK12_select"
    HudImageRef="ScrnWeaponPack_T.AK12.AK12_Unselect"
    SelectedHudImageRef="ScrnWeaponPack_T.AK12.AK12_select"

    FlashBoneName="tip"
    MagCapacity=30
    ReloadRate=3.6
    ReloadAnim="Reload"
    ReloadShortAnim="Reload_LLI"
    ReloadShortRate=2.5
    ReloadAnimRate=0.75
    WeaponReloadAnim="Reload_AK47"
    SelectAnimRate=1.30
    Weight=6
    bHasAimingMode=True
    IdleAimAnim="Idle_Iron"
    bModeZeroCanDryFire=True
    TraderInfoTexture=Texture'ScrnWeaponPack_T.AK12.AK12_Trader'
    SleeveNum=8
    bIsTier2Weapon=False
    bIsTier3Weapon=True
    DrawScale=1.0
    OriginalMaxAmmo=360
    FireModeClass(0)=class'AK12Fire'
    FireModeClass(1)=Class'KFMod.NoFire'
    PutDownAnim="PutDown"
    SelectForce="SwitchToAssaultRifle"
    AIRating=0.550000
    CurrentRating=0.550000
    bShowChargingBar=True
    Description="The Kalashnikov AK-12 (formerly AK-400) is the newest derivative of the Soviet/Russian AK-74 series of assault rifles and was proposed for possible general issue to the Russian Army. This version uses the 5.45x39mm ammo (the same as AK-74)"
    EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
    Priority=145
    CustomCrosshair=11
    CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
    InventoryGroup=4
    GroupOffset=7
    DisplayFOV=55.000000
    StandardDisplayFOV=55.0//60.0
    PlayerIronSightFOV=65
    ZoomTime=0.25
    FastZoomOutTime=0.2
    ZoomedDisplayFOV=20
    PickupClass=class'AK12Pickup'
    PlayerViewOffset=(X=-0.500000,Y=20.000000,Z=-3.000000)
    BobDamping=6.000000
    AttachmentClass=class'AK12Attachment'
    IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
    ItemName="AK-12 SE"
    TransientSoundVolume=1.250000
}
