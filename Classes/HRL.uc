class HRL extends LAW;

var     float               ForceIdleTime;        //time at which weapon will play idle anim
var     float               ForceIdleOnFireTime;  //time after firing for weapon to play idle anim

//added this to make the HRL rocket draw smaller
simulated function PostBeginPlay()
{
    if ( default.mesh == none )
    {
        PreloadAssets(self, true);
    }

    // Weapon will handle FireMode instantiation
    Super.PostBeginPlay();

    if ( Level.NetMode == NM_DedicatedServer )
        return;

    SetBoneScale(1, 0.70, 'Rocket'); //make the LAW rocket smaller by 30%

    if( !bHasScope )
    {
        KFScopeDetail = KF_None;
    }

    InitFOV();
}

//added to support tweening from new idle position to ironsights
simulated function ZoomIn(bool bAnimateTransition)
{
    if( Level.TimeSeconds < FireMode[0].NextFireTime )
    {
        return;
    }

    super.ZoomIn(bAnimateTransition);

    if( bAnimateTransition )
    {
        if( bZoomOutInterrupted )
        {
            TweenAnim(IdleAimAnim,ZoomTime/2);
        }
        else
        {
            TweenAnim(IdleAimAnim,ZoomTime/2);
        }
    }
}

//overwriting to add ForceIdleTime
simulated function bool StartFire(int Mode)
{
    local bool RetVal;

    RetVal = super.StartFire(Mode);

    if( RetVal )
    {
        if( Mode == 0 && ForceZoomOutOnFireTime > 0 )
        {
            ForceZoomOutTime = Level.TimeSeconds + ForceZoomOutOnFireTime;
        }
        else if( Mode == 1 && ForceZoomOutOnAltFireTime > 0 )
        {
            ForceZoomOutTime = Level.TimeSeconds + ForceZoomOutOnAltFireTime;
        }
        if( Mode == 0 && ForceIdleOnFireTime > 0 )
        {
            ForceIdleTime = Level.TimeSeconds + ForceIdleOnFireTime;
        }
        NumClicks=0;

        InterruptReload();
    }

    return RetVal;
}

//adds a force idle time
simulated function WeaponTick(float dt)
{
    Super.WeaponTick(dt);
    if( ForceIdleTime > 0 )
    {
        if( Level.TimeSeconds - ForceIdleTime > 0 )
        {
            ForceIdleTime = 0;
            PlayIdle();
        }
    }
}

defaultproperties
{
     IdleAnim=AimIdle //added this for new idle position
     ForceIdleOnFireTime=2.25
     PlayerViewOffset=(X=20.0,Y=15.0,Z=-17.000000)
     BobDamping=4.5 //reduced from default of probably 6
     MinimumFireRange=250
     Weight=10.000000
     TraderInfoTexture=Texture'ScrnWeaponPack_T.HRL.Trader_HRL'
     SkinRefs(0)="ScrnWeaponPack_T.HRL.hrl_cmb"
     ZoomTime=0.26000 //Reverted back from 0.180000 because only ZoomTime only affects FOV zoom and fire time for the default LAW
     ZoomedDisplayFOV=40.000000
     PlayerIronSightFOV=70 //Added ironsight zoom
     FireModeClass(0)=class'HRLFire'
     Description="Horzine's modification of L.A.W. Smaller and lighter rockets not only allowing to carry more of them, but also are much easier to reload."
     Priority=190
     PickupClass=class'HRLPickup'
     AttachmentClass=class'HRLAttachment'
     ItemName="HRL-1 Rocket Launcher SE"
     bHoldToReload=false // to show correct ammo amount on classic hud
}
