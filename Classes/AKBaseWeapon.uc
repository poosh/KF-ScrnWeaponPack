class AKBaseWeapon extends KFWeapon
abstract;

#exec OBJ LOAD FILE=KillingFloorWeapons.utx
#exec OBJ LOAD FILE=KillingFloorHUD.utx
#exec OBJ LOAD FILE=Inf_Weapons_Foley.uax

var         name             ReloadShortAnim;
var         float             ReloadShortRate;

var transient KFWeaponPickup  PendingPickup;
var transient bool  bShortReload;

var const int OriginalMaxAmmo;
var const bool bSharedAmmoPool;

var transient class<KFVeterancyTypes> LastClientVeteranSkill;
var    transient int                      LastClientVeteranSkillLevel;

var KFPlayerReplicationInfo OwnerPRI; // don't access it directly! Use GetOwnerPRI() instead.

simulated function AltFire(float F)
{
    // if(ReadyToFire(0))
    // {
        DoToggle();
    // }
}

exec function SwitchModes()
{
    DoToggle();
}

function byte BestMode()
{
    return 0;
}

simulated function int MaxAmmo(int mode)
{
    if ( Ammo[mode] != none )
        return Ammo[mode].MaxAmmo;
    if ( AmmoClass[mode] != None )
        return AmmoClass[mode].default.MaxAmmo * GetAmmoMulti();
    return 0;
}

function GiveAmmo(int m, WeaponPickup WP, bool bJustSpawned)
{
    local bool bJustSpawnedAmmo;
    local int addAmount, InitialAmount;

    UpdateMagCapacity(Instigator.PlayerReplicationInfo);

    if ( FireMode[m] != None && FireMode[m].AmmoClass != None )
    {
        Ammo[m] = Ammunition(Instigator.FindInventoryType(FireMode[m].AmmoClass));
        bJustSpawnedAmmo = false;

        if ( bNoAmmoInstances )
        {
            if ( (FireMode[m].AmmoClass == None) || ((m != 0) && (FireMode[m].AmmoClass == FireMode[0].AmmoClass)) )
                return;

            InitialAmount = FireMode[m].AmmoClass.Default.InitialAmount;

            if(WP!=none && WP.bThrown==true)
                InitialAmount = WP.AmmoAmount[m];
            else
            {
                // Other change - if not thrown, give the gun a full clip
                MagAmmoRemaining = MagCapacity;
            }

            if ( Ammo[m] != None )
            {
                addamount = InitialAmount + Ammo[m].AmmoAmount;
                Ammo[m].Destroy();
            }
            else
                addAmount = InitialAmount;

            AddAmmo(addAmount,m);
        }
        else
        {
            if ( (Ammo[m] == None) && (FireMode[m].AmmoClass != None) )
            {
                Ammo[m] = Spawn(FireMode[m].AmmoClass, Instigator);
                Instigator.AddInventory(Ammo[m]);
                bJustSpawnedAmmo = true;
            }
            else if ( (m == 0) || (FireMode[m].AmmoClass != FireMode[0].AmmoClass) )
                bJustSpawnedAmmo = ( bJustSpawned || ((WP != None) && !WP.bWeaponStay) );

                // and here is the modification for instanced ammo actors

            SetMaxAmmo();

            if(WP!=none && WP.bThrown==true)
                addAmount = WP.AmmoAmount[m];
            else if ( bJustSpawnedAmmo ) {
                if (default.MagCapacity == 0)
                    addAmount = 0;  // prevent division by zero.
                else
                    addAmount = Ammo[m].InitialAmount * (float(MagCapacity) / float(default.MagCapacity));
            }

            // Don't double add ammo if primary and secondary fire modes share the same ammo class
            if ( WP != none && m > 0 && (FireMode[m].AmmoClass == FireMode[0].AmmoClass) )
                return;

            Ammo[m].AddAmmo(addAmount);
            Ammo[m].GotoState('');
        }
    }
}

simulated function ClientWeaponSet(bool bPossiblySwitch)
{
    super.ClientWeaponSet(bPossiblySwitch);
    if ( Instigator != none )
        SetMaxAmmo();
}


simulated function Destroyed()
{
    SetMaxAmmo();
    super.Destroyed();
}

simulated function SetMaxAmmo()
{
    local Inventory Inv;
    local AKBaseWeapon W;
    local int c, NewMaxAmmo;
    local Actor MyOwner;
    local Ammunition MyAmmo;

    if ( Instigator == none )
        MyOwner = Instigator;
    else
        MyOwner = Owner;

    if ( GetOwnerPRI() != none ) {
        LastClientVeteranSkill = OwnerPRI.ClientVeteranSkill;
        LastClientVeteranSkillLevel = OwnerPRI.ClientVeteranSkillLevel;
    }
    else
        LastClientVeteranSkill = none;
    if ( LastClientVeteranSkill != none )
        LastAmmoResult = LastClientVeteranSkill.static.AddExtraAmmoFor(OwnerPRI, FireMode[0].AmmoClass);
    else
        LastAmmoResult = 1.0;

    MyAmmo = Ammo[0];

    if ( bSharedAmmoPool ) {
        if ( PendingPickup == none && !bPendingDelete )
            NewMaxAmmo = OriginalMaxAmmo;
        for( Inv = MyOwner.Inventory; Inv!=none && (++c)<1000; Inv=Inv.Inventory ) {
            W = AKBaseWeapon(Inv);
            if ( W != none && W!= self && !W.bPendingDelete && W.Ammo[0] != none ) {
                if ( W.Ammo[0] == MyAmmo )
                    NewMaxAmmo += W.OriginalMaxAmmo;
                else if ( MyAmmo == none && W.Ammo[0].class == FireModeClass[0].default.AmmoClass ) {
                    MyAmmo = W.Ammo[0];
                    NewMaxAmmo += W.OriginalMaxAmmo;
                }
            }
        }
    }
    if ( NewMaxAmmo == 0 )
        NewMaxAmmo = FireMode[0].AmmoClass.default.MaxAmmo;

    if ( MyAmmo != none ) {
        MyAmmo.MaxAmmo = NewMaxAmmo * LastAmmoResult;
        LastAmmoResult = float(MyAmmo.MaxAmmo) / MyAmmo.default.MaxAmmo; //used in GetAmmoMulti()
        if ( MyAmmo.AmmoAmount > MyAmmo.MaxAmmo ) {
            if ( PendingPickup != none ) {
                PendingPickup.AmmoAmount[0] += MyAmmo.AmmoAmount - MyAmmo.MaxAmmo;
                PendingPickup.MagAmmoRemaining = min(MagAmmoRemaining, PendingPickup.AmmoAmount[0]);
            }
            MyAmmo.AmmoAmount = MyAmmo.MaxAmmo;
        }
        if ( bSharedAmmoPool ) {
            for( Inv = MyOwner.Inventory; Inv!=none && (++c)<1000; Inv=Inv.Inventory ) {
                W = AKBaseWeapon(Inv);
                if ( W != none && W != self ) {
                    W.LastAmmoResult = LastAmmoResult;
                    W.LastClientVeteranSkill = LastClientVeteranSkill;
                    W.LastClientVeteranSkillLevel = LastClientVeteranSkillLevel;
                }
            }
        }
    }
}

simulated function float GetAmmoMulti()
{
    if ( GetOwnerPRI() == none ) {
        LastClientVeteranSkill = none;
        return 1.0;
    }
    if ( OwnerPRI.ClientVeteranSkill != LastClientVeteranSkill || OwnerPRI.ClientVeteranSkillLevel != LastClientVeteranSkillLevel )
         SetMaxAmmo();

    return LastAmmoResult;
}

simulated function KFPlayerReplicationInfo GetOwnerPRI()
{
    if ( OwnerPRI == none ) {
        if ( Instigator != none )
            OwnerPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
        if ( OwnerPRI == none && Pawn(Owner) != none )
            OwnerPRI = KFPlayerReplicationInfo(Pawn(Owner).PlayerReplicationInfo);
    }
    return OwnerPRI;
}

// ensures that other guns with the same ammunition don't have more bullets in magazine than available
simulated function CheckSharedMags()
{
    local int MaxMagAmmo, c;
    local Inventory Inv;
    local AKBaseWeapon W;

    if ( !bSharedAmmoPool || Instigator == none || Ammo[0] == none )
        return;

    MaxMagAmmo = AmmoAmount(0) - MagAmmoRemaining;
    for( Inv = Instigator.Inventory; Inv!=none && (++c)<1000; Inv=Inv.Inventory ) {
        W = AKBaseWeapon(Inv);
        if ( W != none && W!= self && W.Ammo[0] == Ammo[0] ) {
            if ( W.MagAmmoRemaining > MaxMagAmmo )
                W.MagAmmoRemaining = min(MaxMagAmmo, W.MagCapacity);
            MaxMagAmmo -= W.MagAmmoRemaining;
            if ( MaxMagAmmo < 0)
                MaxMagAmmo = 0;
        }
    }
}

simulated function GetAmmoCount(out float MaxAmmoPrimary, out float CurAmmoPrimary)
{
    if ( Ammo[0] != None ) {
        MaxAmmoPrimary = Ammo[0].MaxAmmo;
        CurAmmoPrimary = Ammo[0].AmmoAmount;
    }
    else {
        MaxAmmoPrimary = 0;
        CurAmmoPrimary = 0;
    }
}

function DropFrom(vector StartLocation)
{
    local int m;
    local Pickup Pickup;
    local vector Direction;

    if (!bCanThrow)
        return;

    ClientWeaponThrown();

    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if (FireMode[m].bIsFiring)
            StopFire(m);
    }

    if ( Instigator != None )
    {
        DetachFromPawn(Instigator);
        Direction = vector(Instigator.Rotation);
    }
    else if ( Owner != none )
    {
        Direction = vector(Owner.Rotation);
    }

    Pickup = Spawn(PickupClass,,, StartLocation);
    if ( Pickup != None )
    {
        Pickup.InitDroppedPickupFor(self);
        Pickup.Velocity = Velocity + (Direction * 100);
        if (Instigator.Health > 0)
            WeaponPickup(Pickup).bThrown = true;
    }
    PendingPickup = KFWeaponPickup(Pickup);

    Destroy();
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

// copy-pasted to add (MagCapacity+1)
simulated function bool AllowReload()
{
    UpdateMagCapacity(Instigator.PlayerReplicationInfo);

    if( !Other.IsHumanControlled() ) {
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
    if ( GetOwnerPRI() != none && OwnerPRI.ClientVeteranSkill != none )
    {
        ReloadMulti = OwnerPRI.ClientVeteranSkill.Static.GetReloadSpeedModifier(OwnerPRI, self);
    }
    else
    {
        ReloadMulti = 1.0;
    }
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
    if ( GetOwnerPRI() != none && OwnerPRI.ClientVeteranSkill != none )
        ReloadMulti = OwnerPRI.ClientVeteranSkill.Static.GetReloadSpeedModifier(OwnerPRI, self);
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

simulated function ActuallyFinishReloading()
{
    super.ActuallyFinishReloading();
    if ( bSharedAmmoPool )
        CheckSharedMags();
}

defaultproperties
{
    OriginalMaxAmmo=300
    bSharedAmmoPool=True
    ReloadShortAnim="Reload"
    ReloadShortRate=3.0
}
