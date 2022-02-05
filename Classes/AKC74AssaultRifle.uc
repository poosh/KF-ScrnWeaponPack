class AKC74AssaultRifle extends AKBaseWeapon
    config(user);

simulated function Notify_ShowBullets()
{
    if ( !Instigator.IsLocallyControlled() )
        return ;
    if (AmmoAmount(0) == 0)
    {
        SetBoneScale (0, 0.0, 'bullet1');
        SetBoneScale (1, 0.0, 'bullet2');
        SetBoneScale (2, 0.0, 'bullet3');
        SetBoneScale (3, 0.0, 'bullet4');
    }
    else if (AmmoAmount(0) == 1)
    {
        SetBoneScale (0, 1.0, 'bullet1');
        SetBoneScale (1, 0.0, 'bullet2');
        SetBoneScale (2, 0.0, 'bullet3');
        SetBoneScale (3, 0.0, 'bullet4');
    }
    else if (AmmoAmount(0) == 2)
    {
        SetBoneScale (0, 1.0, 'bullet1');
        SetBoneScale (1, 1.0, 'bullet2');
        SetBoneScale (2, 0.0, 'bullet3');
        SetBoneScale (3, 0.0, 'bullet4');
    }
    else if (AmmoAmount(0) == 3)
    {
        SetBoneScale (0, 1.0, 'bullet1');
        SetBoneScale (1, 1.0, 'bullet2');
        SetBoneScale (2, 1.0, 'bullet3');
        SetBoneScale (3, 0.0, 'bullet4');
    }
    else if (AmmoAmount(0) >= 4)
    {
        SetBoneScale (0, 1.0, 'bullet1');
        SetBoneScale (1, 1.0, 'bullet2');
        SetBoneScale (2, 1.0, 'bullet3');
        SetBoneScale (3, 1.0, 'bullet4');
    }
}

simulated function Notify_HideBullets()
{
    if ( !Instigator.IsLocallyControlled() )
        return ;
    if (MagAmmoRemaining <= 1)
    {
        SetBoneScale (0, 0.0, 'bullet1');
        SetBoneScale (1, 0.0, 'bullet2');
        SetBoneScale (2, 0.0, 'bullet3');
        SetBoneScale (3, 0.0, 'bullet4');
    }
    else if (MagAmmoRemaining == 2)
    {
        SetBoneScale (0, 1.0, 'bullet1');
        SetBoneScale (1, 0.0, 'bullet2');
        SetBoneScale (2, 0.0, 'bullet3');
        SetBoneScale (3, 0.0, 'bullet4');
    }
    else if (MagAmmoRemaining == 3)
    {
        SetBoneScale (0, 1.0, 'bullet1');
        SetBoneScale (1, 1.0, 'bullet2');
        SetBoneScale (2, 0.0, 'bullet3');
        SetBoneScale (3, 0.0, 'bullet4');
    }
    else if (MagAmmoRemaining >= 4)
    {
        SetBoneScale (0, 1.0, 'bullet1');
        SetBoneScale (1, 1.0, 'bullet2');
        SetBoneScale (2, 0.0, 'bullet3');
        SetBoneScale (3, 0.0, 'bullet4');
    }
}

defaultproperties
{
     MagCapacity=30
     ReloadRate=3.000000
     ReloadAnim="Reload"
     ReloadShortAnim="Reload"
     ReloadShortRate=2.0
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_AK47"
     Weight=4
     bHasAimingMode=True
     IdleAimAnim="Iron_Idle"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'ScrnWeaponPack_T.AK74.ScrnWeaponPack_T.AKC74_Trader'
     bIsTier2Weapon=false
     bIsTier3Weapon=false
     MeshRef="ScrnWeaponPack_A.akc74mesh"
     SkinRefs(0)="ScrnWeaponPack_T.AK74.wpn_ak74"
     SkinRefs(1)="KF_Weapons_Trip_T.hands.hands_1stP_military_cmb"
     SkinRefs(2)="ScrnWeaponPack_T.AK74.wpn_ak74_1"
     SkinRefs(3)="ScrnWeaponPack_T.AK12.AK12_tex_4_cmb" //AK12 magazine
     SelectSoundRef="ScrnWeaponPack_SND.AK74.akc74_draw"
     HudImageRef="ScrnWeaponPack_T.AK74.AKC74_Unselected"
     SelectedHudImageRef="ScrnWeaponPack_T.AK74.AKC74_selected"
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=42.000000 //32.000000
     OriginalMaxAmmo=360
     FireModeClass(0)=Class'ScrnWeaponPack.AKC74Fire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectAnimRate=1.000000
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="A variant of the AK-74 equipped with a side-folding metal shoulder stock."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=65.000000
     Priority=100
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=3
     GroupOffset=7
     PickupClass=Class'ScrnWeaponPack.AKC74Pickup'
     PlayerViewOffset=(X=35.000000,Y=22.000000,Z=-6.000000) //(X=18.000000,Y=22.000000,Z=-6.000000)
     BobDamping=5.000000
     AttachmentClass=Class'ScrnWeaponPack.AKC74Attachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="AKS-74 SE"
     TransientSoundVolume=1.250000
}
