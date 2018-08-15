class newHRL extends HRL;


var     float               ForceIdleTime;        //time at which weapon will play idle anim
var     float               ForceIdleOnFireTime;  //time after firing for weapon to play idle anim

//added this to make the HRL draw smaller
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
    
    //make the LAW rocket smoler
    SetBoneScale(1, 0.70, 'Rocket');

	if( !bHasScope )
	{
		KFScopeDetail = KF_None;
	}

	InitFOV();
}

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
			//PlayAnim('Raise',1.75,0.1); //increased to 1.75
        }
        else
        {
			TweenAnim(IdleAimAnim,ZoomTime/2);
            //PlayAnim('Raise',1.75,0.1);
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
	 IdleAnim=AimIdle //added this
     ForceIdleOnFireTime=2.25 //copypasta from HRLfire
     PlayerViewOffset=(X=20.0,Y=15.0,Z=-17.000000)
	 BobDamping=5.0
     TraderInfoTexture=Texture'ScrnWeaponPack_T.HRL.Trader_HRL'
     SkinRefs(0)="ScrnWeaponPack_T.HRL.hrl_cmb"
     //ZoomTime=0.250000 //only affects FOV zoom, so back to 0.25
	 ZoomTime=0.25000 //0.25 by default
          
     ZoomedDisplayFOV=40.000000 //40
	 DisplayFOV=85.000000
     StandardDisplayFOV=85.0
     PlayerIronSightFOV=70 //90
     FireModeClass(0)=Class'newRLs.newHRLFire'
     Description="Horzine's modification of L.A.W. Smaller and lighter rockets not only allowing to carry more of them, but also are much easier to reload."
     Priority=190
     PickupClass=Class'newRLs.newHRLPickup'
     AttachmentClass=Class'ScrnWeaponPack.HRLAttachment'
     ItemName="HRL-1 Rocket Launcher SE"
}
