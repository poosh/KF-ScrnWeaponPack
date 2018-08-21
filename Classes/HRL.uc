class HRL extends LAW;

//this replaces the raise animation with a tween to support the new Idle position
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
	IdleAnim=AimIdle //added this
	PlayerViewOffset=(X=10.0,Y=6.0,Z=-4.000000) //changed
	BobDamping=4.0
     MinimumFireRange=250
     Weight=10.000000
     TraderInfoTexture=Texture'ScrnWeaponPack_T.HRL.Trader_HRL'
     SkinRefs(0)="ScrnWeaponPack_T.HRL.hrl_cmb"
     ZoomTime=0.260000 //only affects FOV zoom, so changed from 0.15 to 0.26 to match LAW
     DisplayFOV=65.000000
     StandardDisplayFOV=75.0
     ZoomedDisplayFOV=40.000000
     PlayerIronSightFOV=65 //give some zoom when aiming
     FireModeClass(0)=Class'ScrnWeaponPack.HRLFire'
     Description="Horzine's modification of L.A.W. Smaller and lighter rockets not only allowing to carry more of them, but also are much easier to reload."
     Priority=190
     PickupClass=Class'ScrnWeaponPack.HRLPickup'
     AttachmentClass=Class'ScrnWeaponPack.HRLAttachment'
     ItemName="HRL-1 Rocket Launcher SE"
     DrawScale=0.35 //attempt to make it look smaller
}
