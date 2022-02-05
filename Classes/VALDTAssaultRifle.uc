class VALDTAssaultRifle extends KFWeapon
	config(user);

var 		name 			ReloadShortAnim;
var 		float 			ReloadShortRate;

var transient bool  bShortReload;

// copy-pasted to add (MagCapacity+1)
simulated function bool AllowReload()
{
    UpdateMagCapacity(Instigator.PlayerReplicationInfo);

    if( !Instigator.IsHumanControlled() ) {
        return !bIsReloading && MagAmmoRemaining <= MagCapacity && AmmoAmount(0) > MagAmmoRemaining;
    }

    return !( FireMode[0].IsFiring() || FireMode[1].IsFiring() || bIsReloading || ClientState == WS_BringUp
            || MagAmmoRemaining >= MagCapacity + 1 || AmmoAmount(0) <= MagAmmoRemaining
            || (FireMode[0].NextFireTime - Level.TimeSeconds) > 0.1 );
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

// Use alt fire to switch fire modes
simulated function AltFire(float F)
{
    if(ReadyToFire(0))
    {
        DoToggle();
    }
}

exec function SwitchModes()
{
	DoToggle();
}

function bool RecommendRangedAttack()
{
	return true;
}

//TODO: LONG ranged?
function bool RecommendLongRangedAttack()
{
	return true;
}

function float SuggestAttackStyle()
{
	return -1.0;
}

function float GetAIRating()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return AIRating;

	return AIRating;
}

function byte BestMode()
{
	return 0;
}

simulated function SetZoomBlendColor(Canvas c)
{
	local Byte    val;
	local Color   clr;
	local Color   fog;

	clr.R = 255;
	clr.G = 255;
	clr.B = 255;
	clr.A = 255;

	if( Instigator.Region.Zone.bDistanceFog )
	{
		fog = Instigator.Region.Zone.DistanceFogColor;
		val = 0;
		val = Max( val, fog.R);
		val = Max( val, fog.G);
		val = Max( val, fog.B);
		if( val > 128 )
		{
			val -= 128;
			clr.R -= val;
			clr.G -= val;
			clr.B -= val;
		}
	}
	c.DrawColor = clr;
}

defaultproperties
{
    HudImageRef="ScrnWeaponPack_T.VAL.ValDT_unselected"
    SelectedHudImageRef="ScrnWeaponPack_T.VAL.ValDT_selected"
    SelectSoundRef="KF_PumpSGSnd.SG_Select"
    MeshRef="ScrnWeaponPack_A.ValDTmesh"
    SkinRefs(0)="ScrnWeaponPack_T.Val.wpn_vss_cmb"
    SkinRefs(1)="ScrnWeaponPack_T.Val.newvss_cmb"
    SkinRefs(2)="ScrnWeaponPack_T.VAL.wpn_bullet1_545"
    SkinRefs(3)="KF_Weapons2_Trip_T.hands.BritishPara_Hands_1st_P"

    MagCapacity=20
    ReloadShortAnim="Reload"
    ReloadShortRate=2.05
    ReloadRate=3.50
    ReloadAnim="Reload"
    ReloadAnimRate=1.1
    WeaponReloadAnim="Reload_AK47"
    Weight=7 // 5
    bHasAimingMode=True
    IdleAimAnim="Iron_Idle"
    StandardDisplayFOV=65.000000
    bModeZeroCanDryFire=True
    SleeveNum=3
    TraderInfoTexture=Texture'ScrnWeaponPack_T.VAL.ValDT_Trader'
    bIsTier2Weapon=True
    PlayerIronSightFOV=65.000000
    ZoomedDisplayFOV=32.000000
    FireModeClass(0)=class'VALDTFire'
    FireModeClass(1)=Class'KFMod.NoFire'
    PutDownAnim="PutDown"
    SelectForce="SwitchToAssaultRifle"
    AIRating=0.550000
    CurrentRating=0.550000
    bShowChargingBar=True
    Description="The AS VAL (Avtomat Specialnyj Val or Special Assault Rifle) is a Soviet designed assault rifle featuring an integrated suppressor. It was developed during the late 1980s by TsNIITochMash (Central Institute for Precision Machine Building) and is used by Russian Spetsnaz special forces and select units of the Russian Army. Loaded with a lower-cost version of 9x39mm rounds: PAB-9."
    EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
    DisplayFOV=65.000000
    Priority=135
    CustomCrosshair=11
    CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
    InventoryGroup=3
    GroupOffset=7
    PickupClass=class'VALDTPickup'
    PlayerViewOffset=(X=10.000000,Y=10.000000,Z=-5.000000)
    BobDamping=5.000000
    AttachmentClass=class'VALDTAttachment'
    IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
    ItemName="AS 'VAL' SE"
    TransientSoundVolume=1.250000
}
