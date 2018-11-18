class CZ805M extends MP7MMedicGun;

var int MaxHealAmmo;

var         name             ReloadShortAnim;
var         float             ReloadShortRate;

var transient bool  bShortReload;


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

simulated function float ChargeBar()
{
    return FClamp(float(HealAmmoCharge)/float(MaxAmmoCount),0,9.99);
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

simulated function Tick(float dt)
{
    super(KFWeapon).Tick(dt);
    
    if ( Level.NetMode!=NM_Client && HealAmmoCharge < MaxHealAmmo && RegenTimer<Level.TimeSeconds )    {
        RegenTimer = Level.TimeSeconds + AmmoRegenRate;

        if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
            HealAmmoCharge += 10 * KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetSyringeChargeRate(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo));
        else
            HealAmmoCharge += 10;
        if ( HealAmmoCharge > MaxHealAmmo )
            HealAmmoCharge = MaxHealAmmo;
    }
}

defaultproperties
{
     SkinRefs(0)="ScrnWeaponPack_T.cz805.cz805_cmb"
     SkinRefs(1)="ScrnWeaponPack_T.cz805.Grip_cmb"
     SkinRefs(2)="KF_Weapons_Trip_T.hands.hands_1stP_military_cmb"
     SkinRefs(3)="KF_Weapons_Trip_T.Rifles.reflex_sight_A_unlit"
     SkinRefs(4)="ScrnWeaponPack_T.cz805.eotech_cmb"
     SkinRefs(5)="ScrnWeaponPack_T.cz805.Magint"
     SkinRefs(6)="ScrnWeaponPack_T.cz805.Magazine_cmb"
     MeshRef="ScrnWeaponPack_A.CZ805_Mesh"
     SelectSoundRef="ScrnWeaponPack_SND.cz805.foldback"
     HudImageRef="ScrnWeaponPack_T.cz805.UnselectCZ805"
     SelectedHudImageRef="ScrnWeaponPack_T.cz805.SelectCZ805"
     
     MaxHealAmmo=625
     AmmoRegenRate=0.300000
     
     ReloadShortAnim="Reload"
     ReloadShortRate=1.91 //2.11   
     MagCapacity=30
     ReloadRate=3.250000 //3.3
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_AK47"
     Weight=6.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=60.000000
     bModeZeroCanDryFire=True
     SleeveNum=2
     TraderInfoTexture=Texture'ScrnWeaponPack_T.cz805.TraderCZ805'
     bIsTier2Weapon=True
     
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=32.000000
     FireModeClass(0)=Class'ScrnWeaponPack.CZ805MFire'
     FireModeClass(1)=Class'ScrnWeaponPack.CZ805MAltFire'
     PutDownAnim="Put_Down"
     //BringUpTime=0.33
     //SelectAnimRate=5
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="Horzine's modification of CZ-805 BREN rifle with attached healing dart launcher. Usefull for both Medic and Commando perks."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=60.000000
     Priority=95
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=3
     GroupOffset=7
     PickupClass=Class'ScrnWeaponPack.CZ805MPickup'
     PlayerViewOffset=(X=10.000000,Y=15.000000,Z=-3.000000)
     BobDamping=6.000000
     AttachmentClass=Class'ScrnWeaponPack.CZ805MAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="CZ-805M Medic/Assault Rifle SE"
     TransientSoundVolume=1.250000
}
