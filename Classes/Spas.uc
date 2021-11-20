//=============================================================================
// Shotgun Inventory class
//=============================================================================
class Spas extends KFWeaponShotgun;

var bool bChamberThisReload; //if full reload is uninterrupted, play chambering animation
var ScrnFakedProjectile FakedShell;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    if ( !Instigator.IsLocallyControlled() )
        return;

    if ( FakedShell == none ) //only spawn fakedshell once
        FakedShell = spawn(class'ScrnFakedShell',self);
    if ( FakedShell != none )
    {
        AttachToBone(FakedShell, 'bullet_shell'); //attach faked shell
        FakedShell.SetDrawScale(4.7); //4.7
        FakedShell.SetRelativeRotation(rot(0,32768,0));
    }
}

simulated function Destroyed()
{
    if ( FakedShell != none && !FakedShell.bDeleteMe )
        FakedShell.Destroy();

    super.Destroyed();
}

//add notify triggered shell eject
simulated function Notify_EjectShell()
{
    if ( SpasFire(FireMode[0]).ShellEjectEmitter != None )
    {
        SpasFire(FireMode[0]).ShellEjectEmitter.Trigger(Self, Instigator);
    }
}


simulated function ClientReload()
{
    bChamberThisReload = ( MagAmmoRemaining == 0 && (AmmoAmount(0) - MagAmmoRemaining > MagCapacity) ); //for chambering animation
    Super.ClientReload();
}

simulated function ClientFinishReloading()
{
    bIsReloading = false;

    //play chambering animation if finished reloading from empty
    if ( !bChamberThisReload )
    {
        PlayIdle();
    }
    bChamberThisReload = false;

    if(Instigator.PendingWeapon != none && Instigator.PendingWeapon != self)
        Instigator.Controller.ClientSwitchToBestWeapon();
}

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
     ReloadRate=0.44444444
     ReloadAnim="Reload"
     ReloadAnimRate=1.38
     WeaponReloadAnim="Reload_Shotgun"
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
     PlayerViewOffset=(X=5.000000,Y=17.0000,Z=-7.000000) //(X=20.000000,Y=18.750000,Z=-7.500000)
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
