class HRL extends LAW;

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

    SetBoneScale(1, 0.70, 'Rocket'); //make the LAW rocket smoler by 30%

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
			//PlayAnim('Raise',1.75,0.1); //increased to 1.75
        }
        else
        {
			TweenAnim(IdleAimAnim,ZoomTime/2);
            //PlayAnim('Raise',1.75,0.1);
        }
    }
}

defaultproperties
{
     IdleAnim=AimIdle //added this for new idle position
	PlayerViewOffset=(X=10.0,Y=6.0,Z=-4.000000) //position adjust
	BobDamping=4.0 //reduced from default of probably 6
     MinimumFireRange=250
     Weight=10.000000
     TraderInfoTexture=Texture'ScrnWeaponPack_T.HRL.Trader_HRL'
     SkinRefs(0)="ScrnWeaponPack_T.HRL.hrl_cmb"
     ZoomTime=0.26000 //Reverted back from 0.180000 because only ZoomTime only affects FOV zoom and fire time for the default LAW
     ZoomedDisplayFOV=40.000000
     PlayerIronSightFOV=70 //Added ironsight zoom
     FireModeClass(0)=Class'ScrnWeaponPack.HRLFire'
     Description="Horzine's modification of L.A.W. Smaller and lighter rockets not only allowing to carry more of them, but also are much easier to reload."
     Priority=190
     PickupClass=Class'ScrnWeaponPack.HRLPickup'
     AttachmentClass=Class'ScrnWeaponPack.HRLAttachment'
     ItemName="HRL-1 Rocket Launcher SE"
}
