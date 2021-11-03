class MedicPistol extends KFWeapon
    config(user);


var const   class<ScrnLocalLaserDot>    LaserDotClass;
var         ScrnLocalLaserDot           LaserDot;             // The first person laser site dot

var()       class<InventoryAttachment>  LaserAttachmentClass;      // First person laser attachment class
var         Actor                       LaserAttachment; // First person laser attachment
var         byte                        LaserType;

var transient Vector HealLocation, ClientHealLocation;
var transient Rotator HealRotation;

var Sound HealSound;
var string HealSoundRef;

var name ReloadShortAnim;
var float ReloadShortRate;
var transient bool bShortReload;

var bool bFiringLastRound;

replication
{
    reliable if(Role < ROLE_Authority)
        ServerSetLaserType;

     reliable if( Role == ROLE_Authority )
        ClientSuccessfulHeal;

    reliable if( bNetDirty && Role == ROLE_Authority )
        HealRotation, HealLocation;
}

//=============================================================================
// Dynamic Asset Load
//=============================================================================
static function PreloadAssets(Inventory Inv, optional bool bSkipRefCount)
{
    local MedicPistol W;

    super.PreloadAssets(Inv, bSkipRefCount);

    default.HealSound = sound(DynamicLoadObject(default.HealSoundRef, class'Sound', true));

    if ( W != none ) {
        W.HealSound = default.HealSound;
    }
}

static function bool UnloadAssets()
{
    if ( super.UnloadAssets() )
    {
        default.HealSound = none;
    }

    return true;
}

//=============================================================================
// Functions
//=============================================================================

simulated function PostNetReceive()
{
    if ( Role < ROLE_Authority && ClientHealLocation != HealLocation ) {
        ClientHealLocation = HealLocation;
        HitHealTarget(HealLocation, HealRotation);
    }
}

simulated function Fire(float f)
{
    if ( f == 0)
        bFiringLastRound = MagAmmoRemaining == 1;
    super.Fire(f);
}

simulated function Destroyed()
{
    if (LaserDot != None)
        LaserDot.Destroy();
    if (LaserAttachment != None)
        LaserAttachment.Destroy();

    super.Destroyed();
}

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
    bShortReload = MagAmmoRemaining > 0 && ReloadShortAnim != '';
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
    if ( MagAmmoRemaining <= 0 || ReloadShortAnim == '' )
    {
        PlayAnim(ReloadAnim, ReloadAnimRate*ReloadMulti, 0.1);
    }
    else if ( MagAmmoRemaining >= 1 )
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

simulated function WeaponTick(float dt)
{
//Change the various animations depending on whether the last round was fired
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (MagAmmoRemaining >= 1 || bIsReloading)
        {
            //ReloadAnim = 'ReloadChambered';
            IdleAnim = default.IdleAnim;
            IdleAimAnim = default.IdleAimAnim;
            SelectAnim = default.SelectAnim;
            PutDownAnim = default.PutDownAnim;
            ModeSwitchAnim = default.ModeSwitchAnim;
        }
        else if (MagAmmoRemaining == 0)
        {
            //ReloadAnim = default.ReloadAnim;
            IdleAnim = 'IdleEmpty';
            IdleAimAnim = 'IdleEmpty_Iron';
            SelectAnim = 'SelectEmpty';
            PutDownAnim = 'PutDownEmpty';
            ModeSwitchAnim = 'LightOnEmpty';
        }
    }
//End animation-swapping stuff
    super.WeaponTick(dt);

    if ( (FlashLight != none && FlashLight.bHasLight ) == (LaserType > 0) )
        ToggleLaser(); // automatically turn on laser if flashlight is off
}

//bring Laser to current state, which is indicating by LaserType
simulated function ApplyLaserState()
{
    if( Role < ROLE_Authority  )
        ServerSetLaserType(LaserType);

    if ( ScrnLaserWeaponAttachment(ThirdPersonActor) != none )
        ScrnLaserWeaponAttachment(ThirdPersonActor).SetLaserType(LaserType);

    if ( !Instigator.IsLocallyControlled() )
        return;

    if(LaserType > 0 ) {
        if ( LaserDot == none )
            LaserDot = Spawn(LaserDotClass, self);
        LaserDot.SetLaserType(LaserType);
        //spawn 1-st person laser attachment for weapon owner
        if ( LaserAttachment == none ) {
            LaserAttachment = Spawn(LaserAttachmentClass,,,,);
            AttachToBone(LaserAttachment, FlashBoneName);
        }
        ConstantColor'ScrnTex.Laser.LaserColor'.Color =
            LaserDot.GetLaserColor(); // LaserAttachment's color
        LaserAttachment.bHidden = false;

    }
    else {
        if ( LaserAttachment != none )
            LaserAttachment.bHidden = true;
        if ( LaserDot != none )
            LaserDot.Destroy(); //bHidden = true;
    }
}


// Toggle laser on or off
simulated function ToggleLaser()
{
    if( !Instigator.IsLocallyControlled() )
        return;

    if ( LaserType == 0 )
        LaserType = 3; // Blue
    else
        LaserType = 0;

    ApplyLaserState();
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    ApplyLaserState();
    Super.BringUp(PrevWeapon);
}

simulated function bool PutDown()
{
    TurnOffLaser();
    return super.PutDown();
}

simulated function DetachFromPawn(Pawn P)
{
    TurnOffLaser();
    Super.DetachFromPawn(P);
}

simulated function TurnOffLaser()
{
    if( !Instigator.IsLocallyControlled() )
        return;

    if( Role < ROLE_Authority  )
        ServerSetLaserType(0);

    //don't change Laser type here, because we need to restore it state
    //when next time weapon will be bringed up
    if ( LaserAttachment != none )
        LaserAttachment.bHidden = true;
    if (LaserDot != None)
        LaserDot.Destroy();
}



// Set the new fire mode on the server
function ServerSetLaserType(byte NewLaserType)
{
    LaserType = NewLaserType;
    if ( ScrnLaserWeaponAttachment(ThirdPersonActor) != none )
        ScrnLaserWeaponAttachment(ThirdPersonActor).SetLaserType(LaserType);
}


simulated function RenderOverlays( Canvas Canvas )
{
    local int i;
    local Vector StartTrace, EndTrace;
    local Vector HitLocation, HitNormal;
    local Actor Other;
    local vector X,Y,Z;
    local coords C;
    local KFFire KFM;
    local array<Actor> HitActors;

    if (Instigator == None)
        return;

    if ( Instigator.Controller != None )
        Hand = Instigator.Controller.Handedness;

    if ((Hand < -1.0) || (Hand > 1.0))
        return;

    // draw muzzleflashes/smoke for all fire modes so idle state won't
    // cause emitters to just disappear
    for ( i = 0; i < NUM_FIRE_MODES; ++i ) {
        if (FireMode[i] != None)
            FireMode[i].DrawMuzzleFlash(Canvas);
    }

    SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );
    SetRotation( Instigator.GetViewRotation() + ZoomRotInterp);

    KFM = KFFire(FireMode[0]);

    // Handle drawing the laser dot
    if ( LaserDot != None )
    {
        //move LaserDot during fire animation too  -- PooSH
        if( bIsReloading )
        {
            C = GetBoneCoords(FlashBoneName);
            X = C.XAxis;
            Y = C.YAxis;
            Z = C.ZAxis;
        }
        else
            GetViewAxes(X, Y, Z);

        StartTrace = Instigator.Location + Instigator.EyePosition();
        EndTrace = StartTrace + 65535 * X;

        while (true) {
            Other = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);
            if ( ROBulletWhipAttachment(Other) != none ) {
                HitActors[HitActors.Length] = Other;
                Other.SetCollision(false);
                StartTrace = HitLocation + X;
            }
            else {
                if (Other != None && Other != Instigator && Other.Base != Instigator )
                    EndBeamEffect = HitLocation;
                else
                    EndBeamEffect = EndTrace;
                break;
            }
        }
        // restore collision
        for ( i=0; i<HitActors.Length; ++i )
            HitActors[i].SetCollision(true);

        LaserDot.SetLocation(EndBeamEffect - X*LaserDot.ProjectorPullback);

        if(  Pawn(Other) != none ) {
            LaserDot.SetRotation(Rotator(X));
            LaserDot.SetDrawScale(LaserDot.default.DrawScale * 0.5);
        }
        else if( HitNormal == vect(0,0,0) ) {
            LaserDot.SetRotation(Rotator(-X));
            LaserDot.SetDrawScale(LaserDot.default.DrawScale);
        }
        else {
            LaserDot.SetRotation(Rotator(-HitNormal));
            LaserDot.SetDrawScale(LaserDot.default.DrawScale);
        }
    }

    //PreDrawFPWeapon();    // Laurent -- Hook to override things before render (like rotation if using a staticmesh)

    bDrawingFirstPerson = true;
    Canvas.DrawActor(self, false, false, DisplayFOV);
    bDrawingFirstPerson = false;
}

exec function SwitchModes()
{
    DoToggle();
}


simulated function ClientSuccessfulHeal(PlayerReplicationInfo HealedPRI)
{
    if( PlayerController(Instigator.Controller) != none )
        PlayerController(Instigator.controller).ClientMessage(class'KFMod.MP7MMedicGun'.default.SuccessfulHealMessage $ HealedPRI.PlayerName, 'CriticalEvent');
}

simulated function HitHealTarget(vector HitLocation, rotator HitRotation)
{
    HealLocation = HitLocation;
    HealRotation = HitRotation;

    if( Role == ROLE_Authority ) {
       NetUpdateTime = Level.TimeSeconds - 1;
    }

    PlaySound(HealSound,,2.0);

    if ( EffectIsRelevant(Location,false) )
    {
        Spawn(Class'KFMod.HealingFX',,, HitLocation, HitRotation);
    }
}

defaultproperties
{
    HealSoundRef="KF_MP7Snd.MP7_DartImpact"
     HudImageRef="ScrnWeaponPack_T.MedicPistol.HUD_Single_UnSelected"
     SelectedHudImageRef="ScrnWeaponPack_T.MedicPistol.HUD_Single_Selected"
     SelectSoundRef="KF_9MMSnd.9mm_Select"
     MeshRef="ScrnWeaponPack_A.MedicPistol_1st"
     SkinRefs(1)="ScrnWeaponPack_T.MedicPistol.Slide_cmb"
     SkinRefs(2)="ScrnWeaponPack_T.MedicPistol.Frame_cmb"
     SkinRefs(3)="ScrnWeaponPack_T.MedicPistol.Slide_cmb"
     SkinRefs(4)="ScrnWeaponPack_T.MedicPistol.Slide_shd"

     LaserAttachmentClass=Class'ScrnBalanceSrv.ScrnLaserAttachmentFirstPerson'
     LaserDotClass=Class'ScrnBalanceSrv.ScrnLocalLaserDot'

     MagCapacity=7
     ReloadRate=2.000000
     ReloadShortRate=1.5
     ReloadAnim="Reload"
     ReloadShortAnim="ReloadChambered"
     ReloadAnimRate=1.000000
     FlashBoneName="LightBone"
     WeaponReloadAnim="Reload_Single9mm"
     ModeSwitchAnim="LightOn"
     Weight=2.000000
     bTorchEnabled=True
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=70.000000
     bModeZeroCanDryFire=True
     SleeveNum=0
     ZoomedDisplayFOV=65.000000
     TraderInfoTexture=Texture'ScrnWeaponPack_T.MedicPistol.HUD_Single_UnSelected'
     FireModeClass(0)=Class'ScrnWeaponPack.MedicPistolFire'
     FireModeClass(1)=Class'ScrnWeaponPack.MedicPistolLightFire'
     PutDownAnim="PutDown"
     AIRating=0.250000
     CurrentRating=0.250000
     bShowChargingBar=True
     Description="Primary fire shoots healing darts. Darts heal zeds too, but it doesn't help them much, if titanium needle breaks their skulls first. Shooting multiple dart into the same zed may cause overdose. Alternate fire switch between laser and flashlight."
     DisplayFOV=70.000000
     Priority=60
     InventoryGroup=2
     GroupOffset=1
     PickupClass=Class'ScrnWeaponPack.MedicPistolPickup'
     PlayerViewOffset=(X=20.000000,Y=25.000000,Z=-10.000000)
     BobDamping=6.000000
     AttachmentClass=Class'ScrnWeaponPack.MedicPistolAttachment'
     IconCoords=(X1=434,Y1=253,X2=506,Y2=292)
     ItemName="KF2 Medic Pistol SE"
     bNetNotify=True
}
