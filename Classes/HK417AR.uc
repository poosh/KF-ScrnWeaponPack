class HK417AR extends ScopedWeapon;

var 		name 			ReloadShortAnim;
var 		float 			ReloadShortRate;

var transient bool  bShortReload;
var bool bChangedViewOffset; //stores if vieweoffset has been changed


//overidden to add PlayerViewOffset change
simulated event OnZoomInFinished()
{
	local name anim;
	local float frame, rate;

	GetAnimParams(0, anim, frame, rate);
	
	if ( !bChangedViewOffset) {
		PlayerViewOffset.X += 1.00; //move the viewmodel further from the camera
		bChangedViewOffset = True;
	}
	if (ClientState == WS_ReadyToFire)
	{
		// Play the iron idle anim when we're finished zooming in
		if (anim == IdleAnim)
		{
		   PlayIdle();
		}
	}
    Super.OnZoomInFinished(); //needed to draw textured scope 
}


//overridden to reset bool without having to wait for zoom out to finish, to fix if player spams ironsight toggle
simulated exec function ToggleIronSights()
{
	if( bHasAimingMode )
	{
		bChangedViewOffset = False; //reset my bool var
		if( bAimingRifle )
		{
			PerformZoom(false);
            TweenAnim(IdleAnim,ZoomTime/2); //fix zoom out
		}
		else
		{
            if( Owner != none && Owner.Physics == PHYS_Falling &&
                Owner.PhysicsVolume.Gravity.Z <= class'PhysicsVolume'.default.Gravity.Z )
            {
                return;
            }

	   		InterruptReload();

			if( bIsReloading || !CanZoomNow() )
				return;

			PerformZoom(True);
            TweenAnim(IdleAimAnim,ZoomTime/2); //fix zoom in
		}
	}
}

exec function ReloadMeNow()
{
	local float ReloadMulti;
    
	if(!AllowReload())
		return;
	if ( bHasAimingMode && bAimingRifle )
	{
		FireMode[1].bIsFiring = False;

		ZoomOut(false);
		if( Role < ROLE_Authority)
			ServerZoomOut(false);
	}
    
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
		ReloadMulti = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetReloadSpeedModifier(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self);
	else
		ReloadMulti = 1.0;
        
	bIsReloading = true;
	ReloadTimer = Level.TimeSeconds;
    bShortReload = MagAmmoRemaining > 0;
	if ( bShortReload )
		ReloadRate = Default.ReloadShortRate / ReloadMulti;
    else
		ReloadRate = Default.ReloadRate / ReloadMulti;
        
	if( bHoldToReload )
	{
		NumLoadedThisReload = 0;
	}
	ClientReload();
	Instigator.SetAnimAction(WeaponReloadAnim);
	if ( Level.Game.NumPlayers > 1 && KFGameType(Level.Game).bWaveInProgress && KFPlayerController(Instigator.Controller) != none &&
		Level.TimeSeconds - KFPlayerController(Instigator.Controller).LastReloadMessageTime > KFPlayerController(Instigator.Controller).ReloadMessageDelay )
	{
		KFPlayerController(Instigator.Controller).Speech('AUTO', 2, "");
		KFPlayerController(Instigator.Controller).LastReloadMessageTime = Level.TimeSeconds;
	}
}

simulated function ClientReload()
{
	local float ReloadMulti;
	if ( bHasAimingMode && bAimingRifle )
	{
		FireMode[1].bIsFiring = False;

		ZoomOut(false);
		if( Role < ROLE_Authority)
			ServerZoomOut(false);
	}
    
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
		ReloadMulti = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetReloadSpeedModifier(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self);
	else
		ReloadMulti = 1.0;
        
	bIsReloading = true;
	if (MagAmmoRemaining <= 0)
	{
		PlayAnim(ReloadAnim, ReloadAnimRate*ReloadMulti, 0.1);
	}
	else if (MagAmmoRemaining >= 1)
	{
		PlayAnim(ReloadShortAnim, ReloadAnimRate*ReloadMulti, 0.1);
	}
}

function AddReloadedAmmo()
{
    local int a;
    
	UpdateMagCapacity(Instigator.PlayerReplicationInfo);

    a = MagCapacity;
    if ( bShortReload )
        a++; // 1 bullet already bolted
    
	if ( AmmoAmount(0) >= a )
		MagAmmoRemaining = a;
    else
        MagAmmoRemaining = AmmoAmount(0);

    // this seems redudant -- PooSH
	// if( !bHoldToReload )
	// {
		// ClientForceKFAmmoUpdate(MagAmmoRemaining,AmmoAmount(0));
	// }

	if ( PlayerController(Instigator.Controller) != none && KFSteamStatsAndAchievements(PlayerController(Instigator.Controller).SteamStatsAndAchievements) != none )
	{
		KFSteamStatsAndAchievements(PlayerController(Instigator.Controller).SteamStatsAndAchievements).OnWeaponReloaded();
	}
}

defaultproperties
{
	CrosshairTexRef="ScrnWeaponPack_T.HK417AR.HK417Scope"
	ZoomMatRef="ScrnWeaponPack_T.HK417AR.HK417Scope_FB"
	ScriptedTextureFallbackRef="KF_Weapons_Trip_T.Rifles.CBLens_cmb"
	HudImageRef="ScrnWeaponPack_T.HK417AR.HK417_Unselected"
	SelectedHudImageRef="ScrnWeaponPack_T.HK417AR.HK417_selected"
	SelectSoundRef="ScrnWeaponPack_SND.HK417AR.HK417_select"
	MeshRef="ScrnWeaponPack_A.HK417_mesh"
	SkinRefs(0)="KF_Weapons3_Trip_T.hands.Priest_Hands_1st_P"
	SkinRefs(1)="ScrnWeaponPack_T.HK417AR.hk417_sk1_d2"
	SkinRefs(2)="ScrnWeaponPack_T.HK417AR.mueller"
	SkinRefs(3)="ScrnWeaponPack_T.HK417AR.body"
	SkinRefs(4)="ScrnWeaponPack_T.HK417AR.body2"
	SkinRefs(5)="ScrnWeaponPack_T.HK417AR.hk416_5"
	SkinRefs(6)="ScrnWeaponPack_T.HK417AR.clip_hk417"
	SkinRefs(7)="ScrnWeaponPack_T.HK417AR.hk416_8"
	SkinRefs(8)="KF_Weapons_Trip_T.Rifles.CBLens_cmb"	 
	 
     lenseMaterialID=8
     bHasScope=True
     scopePortalFOVHigh=40
     scopePortalFOV=40
     ZoomedDisplayFOVHigh=60
     ZoomedDisplayFOV=60
     PlayerIronSightFOV=32.000000
     StandardDisplayFOV=65.000000
     DisplayFOV=65.000000


     MagCapacity=15
     ReloadShortAnim="Reload"
     ReloadShortRate=2.57
     ReloadRate=3.15
     ReloadAnim="Reload"
     ReloadAnimRate=1.0
     WeaponReloadAnim="Reload_M4"
     Weight=8 //6
     bHasAimingMode=True
     IdleAimAnim="Iron_Idle"
     bModeZeroCanDryFire=True
     SleeveNum=0
     TraderInfoTexture=Texture'ScrnWeaponPack_T.HK417AR.HK417_Trader'
     FireModeClass(0)=Class'ScrnWeaponPack.HK417Fire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectAnimRate=1.000000
     BringUpTime=1.000000
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.650000
     CurrentRating=0.650000
     Description="The Heckler & Koch HK417 is a gas-operated, selective fire rifle with a rotating bolt and is essentially an enlarged HK416 assault rifle. Chambered for the full power 7.62x51mm NATO round, instead of a less powerful intermediate cartridge, the HK417 is intended for use as a designated marksman rifle, and in other roles where the greater penetrative power and range of the 7.62x51mm NATO round are required."
     Priority=100
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=4
     GroupOffset=3
     PickupClass=Class'ScrnWeaponPack.HK417Pickup'
     PlayerViewOffset=(X=14.000000,Y=7.000000,Z=-4.000000)
     BobDamping=6.000000
     AttachmentClass=Class'ScrnWeaponPack.HK417Attachment'
     IconCoords=(X1=253,Y1=146,X2=333,Y2=181)
     ItemName="HK-417 SE"
}
