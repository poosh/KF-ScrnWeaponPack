//=============================================================================
// Shotgun Inventory class
//=============================================================================
class Spas extends KFWeaponShotgun;

// Allow this weapon to auto reload on alt fire
simulated function AltFire(float F)
{
	if( MagAmmoRemaining < FireMode[1].AmmoPerFire && !bIsReloading &&
		 FireMode[1].NextFireTime <= Level.TimeSeconds )
	{
		// We're dry, ask the server to autoreload
		ServerRequestAutoReload();

		PlayOwnedSound(FireMode[1].NoAmmoSound,SLOT_None,2.0,,,,false);
	}

	super.AltFire(F);
}

defaultproperties
{
     HudImageRef="ScrnWeaponPack_T.SPAS.Spas_Unselected"
     SelectedHudImageRef="ScrnWeaponPack_T.SPAS.Spas_Selected"
     SkinRefs(0)="ScrnWeaponPack_T.SPAS.shotgun_cmb"
     SelectSoundRef="KF_PumpSGSnd.SG_Select"
     MeshRef="ScrnWeaponPack_A.spas12_1st"

     MagCapacity=8
     ReloadRate=0.666667
     ReloadAnim="Reload"
     ReloadAnimRate=1.0
     bHasSecondaryAmmo=False
     bReduceMagAmmoOnSecondaryFire=True
     IdleAimAnim=Idle_Iron
     Weight=9
     bModeZeroCanDryFire=True
     FireModeClass(0)=Class'ScrnWeaponPack.SpasFire'
     FireModeClass(1)=Class'ScrnWeaponPack.SpasAltFire'
     PutDownAnim="PutDown"
     
     bShowChargingBar=False
     Description="The Franchi SPAS12 is a combat shotgun manufactured by Italian firearms company Franchi from 1979 to 2000. The SPAS12 is a dual-mode shotgun, adjustable for semi-automatic or pump-action operation."

     Priority=135
     InventoryGroup=3
     GroupOffset=2
     PickupClass=Class'ScrnWeaponPack.SpasPickup'

     BobDamping=7.000000
     AttachmentClass=Class'ScrnWeaponPack.SpasAttachment'
     IconCoords=(X1=169,Y1=172,X2=245,Y2=208)
     ItemName="SPAS-12 SE"
     TransientSoundVolume=1.000000
     PlayerViewOffset=(X=20.000000,Y=18.750000,Z=-7.500000)
     AmbientGlow=0
     AIRating=0.6
     CurrentRating=0.6

     ZoomTime=0.25
     FastZoomOutTime=0.2
     ZoomInRotation=(Pitch=-910,Yaw=0,Roll=2910)
     bHasAimingMode=true
     ForceZoomOutOnFireTime=0.01

     DisplayFOV=65.0
     StandardDisplayFOV=65.0
     PlayerIronSightFOV=70
     ZoomedDisplayFOV=40

     TraderInfoTexture=Texture'ScrnWeaponPack_T.SPAS.Spas_Unselected'
}
