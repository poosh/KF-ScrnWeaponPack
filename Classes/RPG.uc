class RPG extends KFWeaponShotgun;


function ServerStopFire(byte Mode)
{
    super.ServerStopFire(Mode);
    if( AmmoAmount(0) <= 0 ) {
        MagAmmoRemaining=0;
        SetBoneScale (0, 0.0, 'Rocket');
    }
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    Super.BringUp(PrevWeapon);
    UpdateRocket();
}

simulated function UpdateRocket()
{
    if ( MagAmmoRemaining >= 1)
        SetBoneScale (0, 1.0, 'Rocket');
    else 
        SetBoneScale (0, 0.0, 'Rocket');
}

simulated function ClientWeaponSet(bool bPossiblySwitch)
{
    super.ClientWeaponSet(bPossiblySwitch);
    UpdateRocket();
}

function Notify_EGpHideRocket ()
{
    if (AmmoAmount(0) <= 0)
        SetBoneScale (0, 0.0, 'Rocket');
}

simulated function bool PutDown()
{
    if (Super.PutDown())
    {
         if (MagAmmoRemaining < 1)
            SetBoneScale (0, 0.0, 'Rocket');

        return true;
    }
    return false;
}


simulated function ClientReload()  
{
    super.ClientReload();
    SetBoneScale (0, 1.0, 'Rocket');
}

///*********************************

/**
 * Handles all the functionality for zooming in including
 * setting the parameters for the weapon, pawn, and playercontroller
 *
 * @param bAnimateTransition whether or not to animate this zoom transition
 */

simulated function ZoomIn(bool bAnimateTransition)
{
    if( Level.TimeSeconds < FireMode[0].NextFireTime )
        return;

    super.ZoomIn(bAnimateTransition);
}


/**
 * Handles all the functionality for zooming out including
 * setting the parameters for the weapon, pawn, and playercontroller
 *
 * @param bAnimateTransition whether or not to animate this zoom transition
 */
simulated function ZoomOut(bool bAnimateTransition)
{
    super.ZoomOut(false);

    if( bAnimateTransition )
    {
        TweenAnim(IdleAnim,FastZoomOutTime);
    }
}

defaultproperties
{
     MagCapacity=1
     ReloadRate=2.666667
     ReloadAnim="Reload"
     ReloadAnimRate=1.0
     bHoldToReload=False
     bDoSingleReload=True
     NumLoadedThisReload=1
     WeaponReloadAnim="Reload_Crossbow"
     MinimumFireRange=200
     bIsReloading=True
     Weight=11.000000
     bAimingRifle=True
     bHasAimingMode=True
     IdleAimAnim="Idle"
     StandardDisplayFOV=75.000000
     bModeZeroCanDryFire=True
     SleeveNum=0
     TraderInfoTexture=Texture'ScrnWeaponPack_T.RPG.BigIcon_RPG'
     MeshRef="ScrnWeaponPack_A.RPG7"
     SkinRefs(1)="ScrnWeaponPack_T.RPG.RPG_Main"
     SelectSoundRef="KF_LAWSnd.LAW_Select"
     HudImageRef="ScrnWeaponPack_T.RPG.rpg_unselected"
     SelectedHudImageRef="ScrnWeaponPack_T.RPG.rpg_selected"
     PlayerIronSightFOV=90.000000
     ZoomTime=0.260000
     ZoomedDisplayFOV=65.000000
     FireModeClass(0)=Class'ScrnWeaponPack.RPGFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     SelectAnim="Pullout"
     PutDownAnim="Putaway"
     SelectForce="SwitchToRocketLauncher"
     AIRating=0.750000
     CurrentRating=0.750000
     bSniping=False
     Description="RPG-7 Rocket Launcher. Very high damage, but narrow blast radius."
     EffectOffset=(X=0.100000,Y=-10.000000,Z=0.100000)
     DisplayFOV=75.000000
     Priority=199
     HudColor=(G=0)
     InventoryGroup=4
     GroupOffset=4
     PickupClass=Class'ScrnWeaponPack.RPGPickup'
     PlayerViewOffset=(X=16.000000,Y=20.000000,Z=-18.000000)
     BobDamping=1.800000
     AttachmentClass=Class'ScrnWeaponPack.RPGAttachment'
     IconCoords=(X1=429,Y1=212,X2=508,Y2=251)
     ItemName="RPG-7 SE"
     AmbientGlow=2
}
