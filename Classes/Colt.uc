//==================================================
//==================================================
// Whisky's Colt Python
// Balance job by PooSH
//==================================================
class Colt extends ScrnRevolver;

var float ReloadMulti;
var float BulletUnloadRate; // how long does it takes to unload empty bullets
var float BulletLoadRate;   // how long does it takes to load a single bullet
var transient bool bInterruptedReload;
var transient float NextBulletLoadTime;


// Implemented revolver-specific reloading
// Reload State 1 (uninterruptable): opening drum and unloading empty bullets. Lasts BulletUnloadRate seconds.
// Reload State 2: loading bullets. Each bullet load takes BulletLoadRate seconds.
// Reload State 3: closing drum.
simulated function WeaponTick(float dt)
{
    local float LastSeenSeconds;

    if( bHasAimingMode ) {
        if( bForceLeaveIronsights ) {
            if( bAimingRifle ) {
                ZoomOut(true);

                if( Role < ROLE_Authority)
                    ServerZoomOut(false);
            }
            bForceLeaveIronsights = false;
        }

        if( ForceZoomOutTime > 0 ) {
            if( bAimingRifle ) {
                if( Level.TimeSeconds - ForceZoomOutTime > 0 ) {
                    ForceZoomOutTime = 0;
                    ZoomOut(true);
                    if( Role < ROLE_Authority)
                        ServerZoomOut(false);
                }
            }
            else {
                ForceZoomOutTime = 0;
            }
        }
    }

    if ( Role < ROLE_Authority )
        return;

    if ( bIsReloading ) {
        if (AmmoAmount(0) <= MagAmmoRemaining )
            InterruptReload(); //force interrupt if loaded last bullet
        if( Level.TimeSeconds >= ReloadTimer ) {
            ActuallyFinishReloading();
        }
        else if ( !bInterruptedReload && Level.TimeSeconds >= NextBulletLoadTime ) {
            if ( MagAmmoRemaining >= MagCapacity || MagAmmoRemaining >= AmmoAmount(0) )
                NextBulletLoadTime += 1000; // don't load bullets anymore
            else {
                MagAmmoRemaining++;
                NextBulletLoadTime += BulletLoadRate;
            }
        }
    }
    else if( !Instigator.IsHumanControlled() ) { // bot
        LastSeenSeconds = Level.TimeSeconds - Instigator.Controller.LastSeenTime;
        if(MagAmmoRemaining == 0 || ((LastSeenSeconds >= 5 || LastSeenSeconds > MagAmmoRemaining) && MagAmmoRemaining < MagCapacity))
            ReloadMeNow();
    }

    // Turn it off on death  / battery expenditure
    if (FlashLight != none)
    {
        // Keep the 1Pweapon client beam up to date.
        AdjustLightGraphic();
        if (FlashLight.bHasLight)
        {
            if (Instigator.Health <= 0 || KFHumanPawn(Instigator).TorchBatteryLife <= 0 || Instigator.PendingWeapon != none )
            {
                //Log("Killing Light...you're out of batteries, or switched / dropped weapons");
                KFHumanPawn(Instigator).bTorchOn = false;
                ServerSpawnLight();
            }
        }
    }
}


simulated function bool AllowReload()
{
    if ( bIsReloading || MagAmmoRemaining >= AmmoAmount(0) )
        return false;

    UpdateMagCapacity(Instigator.PlayerReplicationInfo);
    if ( MagAmmoRemaining >= MagCapacity )
        return false;

    if( !Instigator.IsHumanControlled() )
        return true;

    return !FireMode[0].IsFiring() && !FireMode[1].IsFiring()
        && Level.TimeSeconds > (FireMode[0].NextFireTime - 0.1);
}


// Since vanilla reloading replication is totally fucked, I moved base code into separate,
// replication-free function, which is executed on both server and client side
// -- PooSH
simulated function DoReload()
{
    if ( bHasAimingMode && bAimingRifle ) {
        FireMode[1].bIsFiring = False;
        ZoomOut(false);
        // ZoomOut() just a moment ago was executed on server side - why to force it again?  -- PooSH
        // if( Role < ROLE_Authority)
            // ServerZoomOut(false);
    }

    if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
        ReloadMulti = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetReloadSpeedModifier(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self);
    else
        ReloadMulti = 1.0;

    bIsReloading = true;
    bInterruptedReload = false;

    BulletUnloadRate = default.BulletUnloadRate / ReloadMulti;
    BulletLoadRate = default.BulletLoadRate / ReloadMulti;
    NextBulletLoadTime = Level.TimeSeconds + BulletUnloadRate + BulletLoadRate;
    // more bullets left = less time to reload
    ReloadRate = default.ReloadRate / ReloadMulti;
    ReloadRate -= MagAmmoRemaining * BulletLoadRate;
    ReloadTimer = Level.TimeSeconds + ReloadRate;

    Instigator.SetAnimAction(WeaponReloadAnim);
}

// This function is triggered by client, replicated to server and NOT EXECUTED on client,
// even if marked as simulated
exec function ReloadMeNow()
{
    local KFPlayerController PC;

    if ( !AllowReload() )
        return;

    DoReload();
    ClientReload();

    PC = KFPlayerController(Instigator.Controller);
    if ( PC != none && Level.Game.NumPlayers > 1 && KFGameType(Level.Game).bWaveInProgress
            && Level.TimeSeconds - PC.LastReloadMessageTime > PC.ReloadMessageDelay )
    {
        KFPlayerController(Instigator.Controller).Speech('AUTO', 2, "");
        KFPlayerController(Instigator.Controller).LastReloadMessageTime = Level.TimeSeconds;
    }
}

function ServerRequestAutoReload()
{
    ReloadMeNow();
}

// This function now is triggered by ReloadMeNow() and executed on local side only
simulated function ClientReload()
{
    DoReload();
    PlayAnim(ReloadAnim, ReloadAnimRate*ReloadMulti, 0.1);
}


function AddReloadedAmmo() {} // magazine is filled in WeaponTick now


simulated function bool StartFire(int Mode)
{
    if ( MagAmmoRemaining <= 0 )
        return false;
    if ( bIsReloading ) {
        InterruptReload();
        return false;
    }
    return super(Weapon).StartFire(Mode);
}

simulated function AltFire(float F)
{
    InterruptReload();
}

// another fucked up replication...
// By the looks if it, InterruptReload() is called only on client, which triggers ServerInterruptReload().
// Anyway, why server would want to interrupt reload by its own?..
simulated function bool InterruptReload()
{
    if( bIsReloading && !bInterruptedReload && (ReloadTimer - Level.TimeSeconds)*ReloadMulti > 0.7/ReloadMulti )
    {
        // that's very lame how to do stuff like that - don't repeat it at home ;)
        // in theory client should send server a request to interrupt the reload,
        // and the server send back accept to client.
        // But in such case we have a double chance of screwing the shit up, so let's just
        // do it lazy way.
        ServerInterruptReload();
        ClientInterruptReload();
        return true;
    }

    return false;
}

function ServerInterruptReload()
{
    if ( Role == ROLE_Authority ) {
        ReloadTimer = Level.TimeSeconds + 0.5/ReloadMulti;
        bInterruptedReload = true;
        SetAnimFrame(112, 0 , 1);  // go to closing drum stage
    }
}

simulated function ClientInterruptReload()
{
    if ( Role < ROLE_Authority ) {
        bInterruptedReload = true;
        SetAnimFrame(112, 0 , 1);  // go to closing drum stage
        ShowAllBullets();
    }
}

simulated exec function ToggleIronSights()
{
    if( bHasAimingMode ) {
        if( bAimingRifle )
            PerformZoom(false);
        else
            IronSightZoomIn();
    }
}

simulated exec function IronSightZoomIn()
{
    if( bHasAimingMode ) {
        if( Owner != none && Owner.Physics == PHYS_Falling
                && Owner.PhysicsVolume.Gravity.Z <= class'PhysicsVolume'.default.Gravity.Z )
            return;

        if( bIsReloading )
            InterruptReload(); // finish reloading while zooming in  -- PooSH
        PerformZoom(True);
    }
}

simulated function bool PutDown()
{
    local int Mode;

    // continue here, because there is nothing to stop us from interrupting the reload  -- PooSH
    if ( bIsReloading )
        InterruptReload();

    if( bAimingRifle )
        ZoomOut(False);

    // From Weapon.uc
    if (ClientState == WS_BringUp || ClientState == WS_ReadyToFire)
    {
        if ( (Instigator.PendingWeapon != None) && !Instigator.PendingWeapon.bForceSwitch )
        {
            for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
            {
                // if _RO_
                if( FireMode[Mode] == none )
                    continue;
                // End _RO_

                if ( FireMode[Mode].bFireOnRelease && FireMode[Mode].bIsFiring )
                    return false;
                if ( FireMode[Mode].NextFireTime > Level.TimeSeconds + FireMode[Mode].FireRate*(1.f - MinReloadPct))
                    DownDelay = FMax(DownDelay, FireMode[Mode].NextFireTime - Level.TimeSeconds - FireMode[Mode].FireRate*(1.f - MinReloadPct));
            }
        }

        if (Instigator.IsLocallyControlled())
        {
            for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
            {
                // if _RO_
                if( FireMode[Mode] == none )
                    continue;
                // End _RO_

                if ( FireMode[Mode].bIsFiring )
                    ClientStopFire(Mode);
            }

            if (  DownDelay <= 0  || KFPawn(Instigator).bIsQuickHealing > 0)
            {
                if ( ClientState == WS_BringUp || KFPawn(Instigator).bIsQuickHealing > 0 )
                    TweenAnim(SelectAnim,PutDownTime);
                else if ( HasAnim(PutDownAnim) )
                {
                    if( ClientGrenadeState == GN_TempDown || KFPawn(Instigator).bIsQuickHealing > 0)
                    {
                       PlayAnim(PutDownAnim, PutDownAnimRate * (PutDownTime/QuickPutDownTime), 0.0);
                    }
                    else
                    {
                       PlayAnim(PutDownAnim, PutDownAnimRate, 0.0);
                    }

                }
            }
        }
        ClientState = WS_PutDown;
        if ( Level.GRI.bFastWeaponSwitching )
            DownDelay = 0;
        if ( DownDelay > 0 )
        {
            SetTimer(DownDelay, false);
        }
        else
        {
            if( ClientGrenadeState == GN_TempDown )
            {
               SetTimer(QuickPutDownTime, false);
            }
            else
            {
               SetTimer(PutDownTime, false);
            }
        }
    }
    for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
    {
        // if _RO_
        if( FireMode[Mode] == none )
            continue;
        // End _RO_

        FireMode[Mode].bServerDelayStartFire = false;
        FireMode[Mode].bServerDelayStopFire = false;
    }
    Instigator.AmbientSound = None;
    OldWeapon = None;
    return true; // return false if preventing weapon switch
}


simulated function Notify_DropBullets()
{
    if ( !Instigator.IsLocallyControlled() )
        return ;
    // bullets are reloaded in this order: 2,1,5,4,6,3
    switch ( MagAmmoRemaining ) {
        case 5:
           SetBoneScale(1, 0.0, 'b1');
           SetBoneScale(2, 0.0, 'b2');
           SetBoneScale(3, 1.0, 'b3');
           SetBoneScale(4, 0.0, 'b4');
           SetBoneScale(5, 0.0, 'b5');
           SetBoneScale(6, 0.0, 'b6');
            break;
        case 4:
           SetBoneScale(1, 0.0, 'b1');
           SetBoneScale(2, 0.0, 'b2');
           SetBoneScale(3, 1.0, 'b3');
           SetBoneScale(4, 0.0, 'b4');
           SetBoneScale(5, 0.0, 'b5');
           SetBoneScale(6, 1.0, 'b6');
            break;
        case 3:
           SetBoneScale(1, 0.0, 'b1');
           SetBoneScale(2, 0.0, 'b2');
           SetBoneScale(3, 1.0, 'b3');
           SetBoneScale(4, 1.0, 'b4');
           SetBoneScale(5, 0.0, 'b5');
           SetBoneScale(6, 1.0, 'b6');
            break;
        case 2:
           SetBoneScale(1, 0.0, 'b1');
           SetBoneScale(2, 0.0, 'b2');
           SetBoneScale(3, 1.0, 'b3');
           SetBoneScale(4, 1.0, 'b4');
           SetBoneScale(5, 1.0, 'b5');
           SetBoneScale(6, 1.0, 'b6');
            break;
        case 1:
           SetBoneScale(1, 1.0, 'b1');
           SetBoneScale(2, 0.0, 'b2');
           SetBoneScale(3, 1.0, 'b3');
           SetBoneScale(4, 1.0, 'b4');
           SetBoneScale(5, 1.0, 'b5');
           SetBoneScale(6, 1.0, 'b6');
            break;
        default:
           SetBoneScale(1, 1.0, 'b1');
           SetBoneScale(2, 1.0, 'b2');
           SetBoneScale(3, 1.0, 'b3');
           SetBoneScale(4, 1.0, 'b4');
           SetBoneScale(5, 1.0, 'b5');
           SetBoneScale(6, 1.0, 'b6');
    }
}

simulated function Notify_InsertBullets()
{
    ShowAllBullets();

    switch ( MagAmmoRemaining ) {
        case 5: SetAnimFrame(82, 0 , 1); break;
        case 4: SetAnimFrame(71.5, 0 , 1); break;
        case 3: SetAnimFrame(61, 0 , 1); break;
        case 2: SetAnimFrame(50.5, 0 , 1); break;
        case 1: SetAnimFrame(38.5, 0 , 1); break;
    }
}

simulated function ShowAllBullets()
{
    if ( !Instigator.IsLocallyControlled() )
        return ;

   // restore bones
   // bullets are reloaded in this order: 2,1,5,4,6,3
   SetBoneScale(1, 1.0, 'b1');
   SetBoneScale(2, 1.0, 'b2');
   SetBoneScale(3, 1.0, 'b3');
   SetBoneScale(4, 1.0, 'b4');
   SetBoneScale(5, 1.0, 'b5');
   SetBoneScale(6, 1.0, 'b6');
}

defaultproperties
{
    MeshRef="ScrnWeaponPack_A.colt_weapon"
    SkinRefs(1)="ScrnWeaponPack_T.Colt.ColtV2_T"
    HudImageRef="ScrnWeaponPack_T.Colt.WColt_Unselected"
    SelectedHudImageRef="ScrnWeaponPack_T.Colt.WColt"


    FirstPersonFlashlightOffset=(X=-20.000000,Y=-22.000000,Z=8.000000)
    MagCapacity=6
    ReloadRate=5.5 //6.1
    ReloadAnim="Reload"
    bHoldToReload=True
    BulletLoadRate=0.475 // 0.525
    BulletUnloadRate=1.0 // 1.4
    ReloadAnimRate=1.200000
    WeaponReloadAnim="Reload_Revolver"
    Weight=5 // 3
    bHasAimingMode=True
    IdleAimAnim="IronIdle"
    StandardDisplayFOV=70.000000
    bModeZeroCanDryFire=True
    SleeveNum=0
    TraderInfoTexture=Texture'ScrnWeaponPack_T.Colt.Trader_WColt'
    ZoomedDisplayFOV=65.000000
    FireModeClass(0)=class'ColtFire'
    FireModeClass(1)=Class'KFMod.NoFire'
    PutDownAnim="PutDown"
    SelectSound=Sound'KF_9MMSnd.9mm_Select'
    AIRating=0.250000
    CurrentRating=0.250000
    bShowChargingBar=True
    Description="Horzine modified Colt Python to .50 xAE expansive Action-Express (xAE) rounds. Horzine xAE rounds combine the best of two worlds (AP+HP): they penetrate armor and weak targets but expand inside strong targets, dealing massive damage."
    DisplayFOV=70.000000
    Priority=110 // 5
    InventoryGroup=2
    GroupOffset=1
    PickupClass=class'ColtPickup'
    PlayerViewOffset=(X=20.000000,Y=25.000000,Z=-10.000000)
    BobDamping=6.000000
    AttachmentClass=class'ColtAttachment'
    IconCoords=(X1=434,Y1=253,X2=506,Y2=292)
    ItemName="Colt .50 xAE"

    PutDownAnimRate=3.7778
    SelectAnimRate=3.7778
    BringUpTime=0.15
    PutDownTime=0.15
}
