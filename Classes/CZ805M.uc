class CZ805M extends MP7MMedicGun;

var int MaxHealAmmo;

var MedicDartAttachment FakedHealDartAttach; //faked healing dart attachment

var         name             ReloadShortAnim;
var         float             ReloadShortRate;

var transient bool  bShortReload;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    
    if ( Level.NetMode != NM_DedicatedServer ) {
        if ( FakedHealDartAttach == none )
        FakedHealDartAttach = spawn(class'MedicDartAttachment',self);
        if ( FakedHealDartAttach != none ) {
            FakedHealDartAttach.SetDrawScale(4.0); //scale
            AttachToBone(FakedHealDartAttach, 'body'); //attach to the CZ805M main bone, 'body'
			FakedHealDartAttach.SetRelativeRotation(rot(-250,-16834,0)); //pitch yaw roll
			FakedHealDartAttach.SetRelativeLocation(vect(1.14, 9.5, 1.13)); //x y z
        }
    }
}

//destroy it 
simulated function Destroyed()
{
    if ( FakedHealDartAttach != None )
        FakedHealDartAttach.Destroy();
    super.Destroyed();
}

//hides mag1 bullets when firing, bullets 1 to 10 are in the magwell so you'll never see them though, bullets 11 to 30 are scaled according to magazine size
simulated function Notify_HideBullets()
{
    local float MagFloat; 
    local int MyAmmos;
    
    //don't do any of this stuff on servers
    if ( (Level.NetMode == NM_DedicatedServer) || (AIController(Instigator.Controller) != None) )
		return;
    
    MyAmmos = MagAmmoRemaining;
    if (MyAmmos > 9)
    {
        MagFloat = (MyAmmos-10)/(MagCapacity-10);
    }
    if (MyAmmos < 1)
    SetBoneScale(1, 0.0, 'mag1b1');
    if (MyAmmos < 2)
    SetBoneScale(2, 0.0, 'mag1b2');
    if (MyAmmos < 3)
    SetBoneScale(3, 0.0, 'mag1b3');
    if (MyAmmos < 4)
    SetBoneScale(4, 0.0, 'mag1b4');
    if (MyAmmos < 5)
    SetBoneScale(5, 0.0, 'mag1b5');
    if (MyAmmos < 6)
    SetBoneScale(6, 0.0, 'mag1b6');
    if (MyAmmos < 7)
    SetBoneScale(7, 0.0, 'mag1b7');
    if (MyAmmos < 8)
    SetBoneScale(8, 0.0, 'mag1b8');
    if (MyAmmos < 9)
    SetBoneScale(9, 0.0, 'mag1b9');
    if (MyAmmos < 10)
    SetBoneScale(10, 0.0, 'mag1b10'); 
    if (MagFloat < 0.05)
    SetBoneScale(11, 0.0, 'mag1b11');
    if (MagFloat < 0.1)
    SetBoneScale(12, 0.0, 'mag1b12');
    if (MagFloat < 0.15)
    SetBoneScale(13, 0.0, 'mag1b13');
    if (MagFloat < 0.2)
    SetBoneScale(14, 0.0, 'mag1b14'); 
    if (MagFloat < 0.25)
    SetBoneScale(15, 0.0, 'mag1b15'); 
    if (MagFloat < 0.3)
    SetBoneScale(16, 0.0, 'mag1b16'); 
    if (MagFloat < 0.35)
    SetBoneScale(17, 0.0, 'mag1b17'); 
    if (MagFloat < 0.40)
    SetBoneScale(18, 0.0, 'mag1b18'); 
    if (MagFloat < 0.45)
    SetBoneScale(19, 0.0, 'mag1b19'); 
    if (MagFloat < 0.50)
    SetBoneScale(20, 0.0, 'mag1b20'); 
    if (MagFloat < 0.55)
    SetBoneScale(21, 0.0, 'mag1b21'); 
    if (MagFloat < 0.60)
    SetBoneScale(22, 0.0, 'mag1b22'); 
    if (MagFloat < 0.65)
    SetBoneScale(23, 0.0, 'mag1b23'); 
    if (MagFloat < 0.70)
    SetBoneScale(24, 0.0, 'mag1b24'); 
    if (MagFloat < 0.75)
    SetBoneScale(25, 0.0, 'mag1b25'); 
    if (MagFloat < 0.80)
    SetBoneScale(26, 0.0, 'mag1b26'); 
    if (MagFloat < 0.85)
    SetBoneScale(27, 0.0, 'mag1b27'); 
    if (MagFloat < 0.90)
    SetBoneScale(28, 0.0, 'mag1b28'); 
    if (MagFloat < 0.95)
    SetBoneScale(29, 0.0, 'mag1b29'); 
    if (MagFloat < 1.00)
    SetBoneScale(30, 0.0, 'mag1b30'); 
}

//mag2 gets mag1 bullets on reload start and mag1 gets fresh bullets 
simulated function Notify_ReloadStarted()
{
    local float MagFloat; 
    local int MyAmmos;
    local float AmmoFloat;
    
    if ( (Level.NetMode == NM_DedicatedServer) || (AIController(Instigator.Controller) != None) )
		return;
    
    MyAmmos = AmmoAmount(0);
    MagFloat = (MagAmmoRemaining-10)/(MagCapacity-10);
    AmmoFloat = (AmmoAmount(0)-10)/(MagCapacity-10);
    
    if (MagAmmoRemaining < 1)
    SetBoneScale(31, 0.0, 'mag2b1');
    if (MagAmmoRemaining < 2)
    SetBoneScale(32, 0.0, 'mag2b2');
    if (MagAmmoRemaining < 3)
    SetBoneScale(33, 0.0, 'mag2b3');
    if (MagAmmoRemaining < 4)
    SetBoneScale(34, 0.0, 'mag2b4');
    if (MagAmmoRemaining < 5)
    SetBoneScale(35, 0.0, 'mag2b5');
    if (MagAmmoRemaining < 6)
    SetBoneScale(36, 0.0, 'mag2b6');
    if (MagAmmoRemaining < 7)
    SetBoneScale(37, 0.0, 'mag2b7');
    if (MagAmmoRemaining < 8)
    SetBoneScale(38, 0.0, 'mag2b8');
    if (MagAmmoRemaining < 9)
    SetBoneScale(39, 0.0, 'mag2b9');
    if (MagAmmoRemaining < 10)
    SetBoneScale(40, 0.0, 'mag2b10'); 
    if (MagFloat < 0.05)
    SetBoneScale(41, 0.0, 'mag2b11');
    if (MagFloat < 0.1)
    SetBoneScale(42, 0.0, 'mag2b12');
    if (MagFloat < 0.15)
    SetBoneScale(43, 0.0, 'mag2b13');
    if (MagFloat < 0.2)
    SetBoneScale(44, 0.0, 'mag2b14'); 
    if (MagFloat < 0.25)
    SetBoneScale(45, 0.0, 'mag2b15'); 
    if (MagFloat < 0.3)
    SetBoneScale(46, 0.0, 'mag2b16'); 
    if (MagFloat < 0.35)
    SetBoneScale(47, 0.0, 'mag2b17'); 
    if (MagFloat < 0.40)
    SetBoneScale(48, 0.0, 'mag2b18'); 
    if (MagFloat < 0.45)
    SetBoneScale(49, 0.0, 'mag2b19'); 
    if (MagFloat < 0.50)
    SetBoneScale(50, 0.0, 'mag2b20'); 
    if (MagFloat < 0.55)
    SetBoneScale(51, 0.0, 'mag2b21'); 
    if (MagFloat < 0.60)
    SetBoneScale(52, 0.0, 'mag2b22'); 
    if (MagFloat < 0.65)
    SetBoneScale(53, 0.0, 'mag2b23'); 
    if (MagFloat < 0.70)
    SetBoneScale(54, 0.0, 'mag2b24'); 
    if (MagFloat < 0.75)
    SetBoneScale(55, 0.0, 'mag2b25'); 
    if (MagFloat < 0.80)
    SetBoneScale(56, 0.0, 'mag2b26'); 
    if (MagFloat < 0.85)
    SetBoneScale(57, 0.0, 'mag2b27'); 
    if (MagFloat < 0.90)
    SetBoneScale(58, 0.0, 'mag2b28'); 
    if (MagFloat < 0.95)
    SetBoneScale(59, 0.0, 'mag2b29'); 
    if (MagFloat < 1.00)
    SetBoneScale(60, 0.0, 'mag2b30'); 
    
    //show all mag 1 bullets first
    SetBoneScale(1, 1.0, 'mag1b1');
    SetBoneScale(2, 1.0, 'mag1b2');
    SetBoneScale(3, 1.0, 'mag1b3');
    SetBoneScale(4, 1.0, 'mag1b4');
    SetBoneScale(5, 1.0, 'mag1b5');
    SetBoneScale(6, 1.0, 'mag1b6');
    SetBoneScale(7, 1.0, 'mag1b7');
    SetBoneScale(8, 1.0, 'mag1b8');
    SetBoneScale(9, 1.0, 'mag1b9');
    SetBoneScale(10, 1.0, 'mag1b10'); 
    SetBoneScale(11, 1.0, 'mag1b11');
    SetBoneScale(12, 1.0, 'mag1b12');
    SetBoneScale(13, 1.0, 'mag1b13');
    SetBoneScale(14, 1.0, 'mag1b14'); 
    SetBoneScale(15, 1.0, 'mag1b15'); 
    SetBoneScale(16, 1.0, 'mag1b16'); 
    SetBoneScale(17, 1.0, 'mag1b17'); 
    SetBoneScale(18, 1.0, 'mag1b18'); 
    SetBoneScale(19, 1.0, 'mag1b19'); 
    SetBoneScale(20, 1.0, 'mag1b20'); 
    SetBoneScale(21, 1.0, 'mag1b21'); 
    SetBoneScale(22, 1.0, 'mag1b22'); 
    SetBoneScale(23, 1.0, 'mag1b23'); 
    SetBoneScale(24, 1.0, 'mag1b24'); 
    SetBoneScale(25, 1.0, 'mag1b25'); 
    SetBoneScale(26, 1.0, 'mag1b26'); 
    SetBoneScale(27, 1.0, 'mag1b27'); 
    SetBoneScale(28, 1.0, 'mag1b28'); 
    SetBoneScale(29, 1.0, 'mag1b29');
    SetBoneScale(30, 1.0, 'mag1b30'); 
    
    //hide mag1 bullets depending on AmmoAmount(0)
    if (MyAmmos < 1)
    SetBoneScale(1, 0.0, 'mag1b1');
    if (MyAmmos < 2)
    SetBoneScale(2, 0.0, 'mag1b2');
    if (MyAmmos < 3)
    SetBoneScale(3, 0.0, 'mag1b3');
    if (MyAmmos < 4)
    SetBoneScale(4, 0.0, 'mag1b4');
    if (MyAmmos < 5)
    SetBoneScale(5, 0.0, 'mag1b5');
    if (MyAmmos < 6)
    SetBoneScale(6, 0.0, 'mag1b6');
    if (MyAmmos < 7)
    SetBoneScale(7, 0.0, 'mag1b7');
    if (MyAmmos < 8)
    SetBoneScale(8, 0.0, 'mag1b8');
    if (MyAmmos < 9)
    SetBoneScale(9, 0.0, 'mag1b9');
    if (MyAmmos < 10)
    SetBoneScale(10, 0.0, 'mag1b10'); 
    if (AmmoFloat < 0.05)
    SetBoneScale(11, 0.0, 'mag1b11');
    if (AmmoFloat < 0.1)
    SetBoneScale(12, 0.0, 'mag1b12');
    if (AmmoFloat < 0.15)
    SetBoneScale(13, 0.0, 'mag1b13');
    if (AmmoFloat < 0.2)
    SetBoneScale(14, 0.0, 'mag1b14'); 
    if (AmmoFloat < 0.25)
    SetBoneScale(15, 0.0, 'mag1b15'); 
    if (AmmoFloat < 0.3)
    SetBoneScale(16, 0.0, 'mag1b16'); 
    if (AmmoFloat < 0.35)
    SetBoneScale(17, 0.0, 'mag1b17'); 
    if (AmmoFloat < 0.40)
    SetBoneScale(18, 0.0, 'mag1b18'); 
    if (AmmoFloat < 0.45)
    SetBoneScale(19, 0.0, 'mag1b19'); 
    if (AmmoFloat < 0.50)
    SetBoneScale(20, 0.0, 'mag1b20'); 
    if (AmmoFloat < 0.55)
    SetBoneScale(21, 0.0, 'mag1b21'); 
    if (AmmoFloat < 0.60)
    SetBoneScale(22, 0.0, 'mag1b22'); 
    if (AmmoFloat < 0.65)
    SetBoneScale(23, 0.0, 'mag1b23'); 
    if (AmmoFloat < 0.70)
    SetBoneScale(24, 0.0, 'mag1b24'); 
    if (AmmoFloat < 0.75)
    SetBoneScale(25, 0.0, 'mag1b25'); 
    if (AmmoFloat < 0.80)
    SetBoneScale(26, 0.0, 'mag1b26'); 
    if (AmmoFloat < 0.85)
    SetBoneScale(27, 0.0, 'mag1b27'); 
    if (AmmoFloat < 0.90)
    SetBoneScale(28, 0.0, 'mag1b28'); 
    if (AmmoFloat < 0.95)
    SetBoneScale(29, 0.0, 'mag1b29'); 
    if (AmmoFloat < 1.00)
    SetBoneScale(30, 0.0, 'mag1b30'); 
}

//this function is called somewhere in the reload and on select when mag2 is offscreen, this is needed so subsequent reloads may get full bullets again and just unhides all Mag2 Bullets
simulated function Notify_ShowMag2Bullets()
{
    if ( (Level.NetMode == NM_DedicatedServer) || (AIController(Instigator.Controller) != None) )
		return;

    SetBoneScale(31, 1.0, 'mag2b1');
    SetBoneScale(32, 1.0, 'mag2b2');
    SetBoneScale(33, 1.0, 'mag2b3');
    SetBoneScale(34, 1.0, 'mag2b4');
    SetBoneScale(35, 1.0, 'mag2b5');
    SetBoneScale(36, 1.0, 'mag2b6');
    SetBoneScale(37, 1.0, 'mag2b7');
    SetBoneScale(38, 1.0, 'mag2b8');
    SetBoneScale(39, 1.0, 'mag2b9');
    SetBoneScale(40, 1.0, 'mag2b10');
    SetBoneScale(41, 1.0, 'mag2b11');
    SetBoneScale(42, 1.0, 'mag2b12');
    SetBoneScale(43, 1.0, 'mag2b13');
    SetBoneScale(44, 1.0, 'mag2b14'); 
    SetBoneScale(45, 1.0, 'mag2b15'); 
    SetBoneScale(46, 1.0, 'mag2b16'); 
    SetBoneScale(47, 1.0, 'mag2b17'); 
    SetBoneScale(48, 1.0, 'mag2b18'); 
    SetBoneScale(49, 1.0, 'mag2b19'); 
    SetBoneScale(50, 1.0, 'mag2b20'); 
    SetBoneScale(51, 1.0, 'mag2b21'); 
    SetBoneScale(52, 1.0, 'mag2b22'); 
    SetBoneScale(53, 1.0, 'mag2b23'); 
    SetBoneScale(54, 1.0, 'mag2b24'); 
    SetBoneScale(55, 1.0, 'mag2b25'); 
    SetBoneScale(56, 1.0, 'mag2b26'); 
    SetBoneScale(57, 1.0, 'mag2b27'); 
    SetBoneScale(58, 1.0, 'mag2b28'); 
    SetBoneScale(59, 1.0, 'mag2b29'); 
    SetBoneScale(60, 1.0, 'mag2b30'); 
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
     SkinRefs(5)="ScrnWeaponPack_T.cz805.Magint_cmb"
     SkinRefs(6)="ScrnWeaponPack_T.cz805.Magazine_alpha" //"ScrnWeaponPack_T.cz805.Magazine_cmb"
     MeshRef="ScrnWeaponPack_A.CZ805_Mesh"
     SelectSoundRef="ScrnWeaponPack_SND.cz805.foldback"
     HudImageRef="ScrnWeaponPack_T.cz805.UnselectCZ805"
     SelectedHudImageRef="ScrnWeaponPack_T.cz805.SelectCZ805"
     
     MaxHealAmmo=625
     AmmoRegenRate=0.300000
     
     ReloadShortAnim="Reload"
     ReloadShortRate=1.83 //2.11   
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
     PlayerViewOffset=(X=10.000000,Y=12.000000,Z=-3.500000) //(X=10.000000,Y=15.000000,Z=-3.000000)
     BobDamping=5.000000
     AttachmentClass=Class'ScrnWeaponPack.CZ805MAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="CZ-805M Medic/Assault Rifle SE"
     TransientSoundVolume=1.250000
}
