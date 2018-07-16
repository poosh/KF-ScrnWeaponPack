class Saiga12c extends AKBaseWeapon;

defaultproperties
{
    bSharedAmmoPool=False
    OriginalMaxAmmo=56
    
    MagCapacity=8
    ReloadRate=3.133000
    ReloadAnim="Reload"
    ReloadShortAnim="Reload"
    ReloadShortRate=2.15      
    
    ReloadAnimRate=1.000000
    WeaponReloadAnim="Reload_AK47"
    
    Weight=8.000000
    bHasAimingMode=True
    IdleAimAnim="Iron_Idle"
    StandardDisplayFOV=65.000000
    bModeZeroCanDryFire=True
    SleeveNum=2
    TraderInfoTexture=Texture'ScrnWeaponPack_T.saiga.Saiga_Trader'
    bIsTier3Weapon=True
    MeshRef="ScrnWeaponPack_A.saigacmesh"
    SkinRefs(0)="ScrnWeaponPack_T.saiga.saiga"
    SkinRefs(1)="ScrnWeaponPack_T.saiga.saigaparts"
    SkinRefs(2)="KF_Weapons_Trip_T.hands.hands_1stP_military_cmb"
    SkinRefs(3)="ScrnWeaponPack_T.saiga.wpn_gilza1"
    SelectSoundRef="KF_PumpSGSnd.SG_Select"
    HudImageRef="ScrnWeaponPack_T.saiga.Saiga_Unselected"
    SelectedHudImageRef="ScrnWeaponPack_T.saiga.Saiga_selected"
    PlayerIronSightFOV=65.000000
    ZoomedDisplayFOV=32.000000
    FireModeClass(0)=Class'ScrnWeaponPack.Saiga12cFire'
    FireModeClass(1)=Class'KFMod.NoFire'
    PutDownAnim="PutDown"
    SelectForce="SwitchToAssaultRifle"
    AIRating=0.550000
    CurrentRating=0.550000
    Description="12-gauge combat shotgun, visually patterned after the Kalashnikov series of assault rifles. Huge damage, but low penetration."
    EffectOffset=(X=100.000000,Y=25.000000,Z=-100.000000)
    DisplayFOV=65.000000
    Priority=160
    InventoryGroup=4
    GroupOffset=10
    PickupClass=Class'ScrnWeaponPack.Saiga12cPickup'
    PlayerViewOffset=(X=10.000000,Y=8.000000,Z=-4.000000)
    BobDamping=4.000000
    AttachmentClass=Class'ScrnWeaponPack.Saiga12cAttachment'
    IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
    ItemName="Saiga-12s SE"
    DrawScale=0.850000
    TransientSoundVolume=1.250000
}
