class ScopedWeapon extends KFWeapon
    abstract;

//=============================================================================
// Execs
//=============================================================================
#exec OBJ LOAD FILE=ScopeShaders.utx
#exec OBJ LOAD FILE=ScrnWeaponPack_T.utx
#exec OBJ LOAD FILE=ScrnWeaponPack_A.ukx

//=============================================================================
// Variables
//=============================================================================

var() Material ZoomMat;
var() Sound ZoomSound;

var() int lenseMaterialID;  // used since material id's seem to change alot

var() float scopePortalFOVHigh;  // The FOV to zoom the scope portal by.
var() float scopePortalFOV;  // The FOV to zoom the scope portal by.
var() vector XoffsetScoped;
var() vector XoffsetHighDetail;

// Not sure if these pitch vars are still needed now that we use Scripted Textures. We'll keep for now in case they are. - Ramm 08/14/04
// var() int scopePitch;  // Tweaks the pitch of the scope firing angle
// var() int scopeYaw;  // Tweaks the yaw of the scope firing angle
// var() int scopePitchHigh;  // Tweaks the pitch of the scope firing angle high detail scope
// var() int scopeYawHigh;  // Tweaks the yaw of the scope firing angle high detail scope

// 3d Scope vars
var ScriptedTexture ScopeScriptedTexture;  // Scripted texture for 3d scopes
var Shader ScopeScriptedShader;  // The shader that combines the scripted texture with the sight overlay
var Material ScriptedTextureFallback;// The texture to render if the users system doesn't support shaders

// new scope vars
var Combiner ScriptedScopeCombiner;
var Combiner ScriptedScopeStatic; //for illuminated reticle
var texture TexturedScopeTexture;

var bool bInitializedScope;  // Set to true when the scope has been initialized

var string ZoomMatRef;
var string ScriptedTextureFallbackRef;

var texture CrosshairTex;
var string CrosshairTexRef;

//illuminated reticle support
var texture IllumTex;
var string IllumTexRef;

var const bool bDebugMode;  // flag for whether debug commands can be run

var name ReloadShortAnim;
var float ReloadShortRate;
var transient bool bShortReload;


//=============================================================================
// Dynamic Asset Load
//=============================================================================
static function PreloadAssets(Inventory Inv, optional bool bSkipRefCount)
{
    local ScopedWeapon W;

    super.PreloadAssets(Inv, bSkipRefCount);

    default.ZoomMat = FinalBlend(DynamicLoadObject(default.ZoomMatRef, class'FinalBlend', true));
    default.ScriptedTextureFallback = texture(DynamicLoadObject(default.ScriptedTextureFallbackRef, class'texture', true));
    default.CrosshairTex = texture(DynamicLoadObject(default.CrosshairTexRef, class'texture', true));
    default.IllumTex = texture(DynamicLoadObject(default.IllumTexRef, class'texture', true)); //illuminated reticle texture

    W = ScopedWeapon(Inv);
    if ( W != none ) {
        W.ZoomMat = default.ZoomMat;
        W.ScriptedTextureFallback = default.ScriptedTextureFallback;
        W.CrosshairTex = default.CrosshairTex;
        W.IllumTex = default.IllumTex;
    }
}
static function bool UnloadAssets()
{
    if ( super.UnloadAssets() )
    {
        default.ZoomMat = none;
        default.ScriptedTextureFallback = none;
        default.CrosshairTex = none;
        default.IllumTex = none;
    }

    return true;
}


//=============================================================================
// Functions
//=============================================================================

exec function pfov(int thisFOV)
{
    if( !bDebugMode )
        return;

    scopePortalFOV = thisFOV;
    scopePortalFOVHigh = thisFOV;
}

exec function zfov(int thisFOV)
{
    if( !bDebugMode )
        return;

    default.ZoomedDisplayFOV = thisFOV;
    default.ZoomedDisplayFOVHigh = thisFOV;
}


// exec function pPitch(int num)
// {
    // if( !bDebugMode )
        // return;

    // scopePitch = num;
    // scopePitchHigh = num;
// }

// exec function pYaw(int num)
// {
    // if( !bDebugMode )
        // return;

    // scopeYaw = num;
    // scopeYawHigh = num;
// }

simulated exec function TexSize(int i, int j)
{
    if( !bDebugMode )
        return;

    ScopeScriptedTexture.SetSize(i, j);
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



// Helper function for the scope system. The scope system checks here to see when it should draw the portal.
// if you want to limit any times the portal should/shouldn't be drawn, add them here.
// Ramm 10/27/03
simulated function bool ShouldDrawPortal()
{
//    local     name    thisAnim;
//    local    float     animframe;
//    local    float     animrate;
//
//    GetAnimParams(0, thisAnim,animframe,animrate);

//    if(bUsingSights && (IsInState('Idle') || IsInState('PostFiring')) && thisAnim != 'scope_shoot_last')
    if( bAimingRifle )
        return true;
    else
        return false;
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    // Get new scope detail value from KFWeapon
    KFScopeDetail = class'KFMod.KFWeapon'.default.KFScopeDetail;

    UpdateScopeMode();
}

// Handles initializing and swithing between different scope modes
simulated function UpdateScopeMode()
{
    if (Level.NetMode != NM_DedicatedServer && Instigator != none && Instigator.IsLocallyControlled() &&
        Instigator.IsHumanControlled() )
    {
        if( KFScopeDetail == KF_ModelScope)
        {
            scopePortalFOV = default.scopePortalFOV;
            ZoomedDisplayFOV = default.ZoomedDisplayFOV;
            //bPlayerFOVZooms = false;
            if (bUsingSights)
                PlayerViewOffset = XoffsetScoped;

            if( ScopeScriptedTexture == none )
                ScopeScriptedTexture = ScriptedTexture(Level.ObjectPool.AllocateObject(class'ScriptedTexture'));
            ScopeScriptedTexture.FallBackMaterial = ScriptedTextureFallback;
            ScopeScriptedTexture.SetSize(512,512);
            ScopeScriptedTexture.Client = Self;

            if( ScriptedScopeCombiner == none ) {
                ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
                ScriptedScopeCombiner.Material1 = CrosshairTex;
                ScriptedScopeCombiner.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
                ScriptedScopeCombiner.CombineOperation = CO_Multiply;
                ScriptedScopeCombiner.AlphaOperation = AO_Use_Mask;
                ScriptedScopeCombiner.Material2 = ScopeScriptedTexture;
            }
    
			if( IllumTex != none && ScriptedScopeStatic == none )
			{
				// Construct the Combiner (Self Illumination)
				ScriptedScopeStatic = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
	            ScriptedScopeStatic.Material1 = IllumTex;
	            ScriptedScopeStatic.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
	            ScriptedScopeStatic.CombineOperation = CO_Add;
	            ScriptedScopeStatic.AlphaOperation = AO_Use_Mask;
	            ScriptedScopeStatic.Material2 = ScriptedScopeCombiner;
	        }
            
            if( ScopeScriptedShader == none ) {
                ScopeScriptedShader = Shader(Level.ObjectPool.AllocateObject(class'Shader'));
                ScopeScriptedShader.Diffuse = ScriptedScopeCombiner;
                if (IllumTex != none)
                {
                    ScopeScriptedShader.SelfIllumination = ScriptedScopeStatic;
                }
                else
                {
                    ScopeScriptedShader.SelfIllumination = ScriptedScopeCombiner;
                }
                ScopeScriptedShader.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
            }

            bInitializedScope = true;
        }
        else if( KFScopeDetail == KF_ModelScopeHigh )
        {
            scopePortalFOV = scopePortalFOVHigh;
            ZoomedDisplayFOV = default.ZoomedDisplayFOVHigh;
            if (bUsingSights)
                PlayerViewOffset = XoffsetHighDetail;

            if( ScopeScriptedTexture == none )
                ScopeScriptedTexture = ScriptedTexture(Level.ObjectPool.AllocateObject(class'ScriptedTexture'));
            ScopeScriptedTexture.FallBackMaterial = ScriptedTextureFallback;
            ScopeScriptedTexture.SetSize(1024,1024);
            ScopeScriptedTexture.Client = Self;

            if( ScriptedScopeCombiner == none ) {
                ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
                ScriptedScopeCombiner.Material1 = CrosshairTex;
                ScriptedScopeCombiner.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
                ScriptedScopeCombiner.CombineOperation = CO_Multiply;
                ScriptedScopeCombiner.AlphaOperation = AO_Use_Mask;
                ScriptedScopeCombiner.Material2 = ScopeScriptedTexture;
            }

            if( ScopeScriptedShader == none ) {
                ScopeScriptedShader = Shader(Level.ObjectPool.AllocateObject(class'Shader'));
                ScopeScriptedShader.Diffuse = ScriptedScopeCombiner;
                ScopeScriptedShader.SelfIllumination = ScriptedScopeCombiner;
                ScopeScriptedShader.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
            }

            bInitializedScope = true;
        }
        else if (KFScopeDetail == KF_TextureScope)
        {
            ZoomedDisplayFOV = default.ZoomedDisplayFOV;
            PlayerViewOffset.X = default.PlayerViewOffset.X;

            bInitializedScope = true;
        }
    }
}

simulated event RenderTexture(ScriptedTexture Tex)
{
    local rotator RollMod;

    RollMod = Instigator.GetViewRotation();
    //RollMod.Roll -= 16384;

//    Rpawn = ROPawn(Instigator);
//    // Subtract roll from view while leaning - Ramm
//    if (Rpawn != none && rpawn.LeanAmount != 0)
//    {
//        RollMod.Roll += rpawn.LeanAmount;
//    }

    if(Owner != none && Instigator != none && Tex != none && Tex.Client != none)
        Tex.DrawPortal(0,0,Tex.USize,Tex.VSize,Owner,(Instigator.Location + Instigator.EyePosition()), RollMod,  scopePortalFOV );
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


/**
 * Handles all the functionality for zooming in including
 * setting the parameters for the weapon, pawn, and playercontroller
 *
 * @param bAnimateTransition whether or not to animate this zoom transition
 */
simulated function ZoomIn(bool bAnimateTransition)
{
    super(BaseKFWeapon).ZoomIn(bAnimateTransition);

    bAimingRifle = True;

    if( KFHumanPawn(Instigator)!=None )
        KFHumanPawn(Instigator).SetAiming(True);

    if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
    {
        if( AimInSound != none )
        {
            PlayOwnedSound(AimInSound, SLOT_Interact,,,,, false);
        }
    }
}

/**
 * Handles all the functionality for zooming out including
 * setting the parameters for the weapon, pawn, and playercontroller
 *
 * @param bAnimateTransition whether or not to animate this zoom transition
 */
simulated function ZoomOut(bool bAnimateTransition)
{
    super.ZoomOut(bAnimateTransition);

    bAimingRifle = False;

    if( KFHumanPawn(Instigator)!=None )
        KFHumanPawn(Instigator).SetAiming(False);

    if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
    {
        if( AimOutSound != none )
        {
            PlayOwnedSound(AimOutSound, SLOT_Interact,,,,, false);
        }
        KFPlayerController(Instigator.Controller).TransitionFOV(KFPlayerController(Instigator.Controller).DefaultFOV,0.0);
    }
}

simulated function WeaponTick(float dt)
{
    super.WeaponTick(dt);

    if( bAimingRifle && ForceZoomOutTime > 0 && Level.TimeSeconds - ForceZoomOutTime > 0 )
    {
        ForceZoomOutTime = 0;

        ZoomOut(false);

        if( Role < ROLE_Authority)
            ServerZoomOut(false);
    }
}


/**
 * Called by the native code when the interpolation of the first person weapon to the zoomed position finishes
 */
simulated event OnZoomInFinished()
{
    local name anim;
    local float frame, rate;

    GetAnimParams(0, anim, frame, rate);

    if (ClientState == WS_ReadyToFire)
    {
        // Play the iron idle anim when we're finished zooming in
        if (anim == IdleAnim)
        {
           PlayIdle();
        }
    }

    if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none &&
        KFScopeDetail == KF_TextureScope )
    {
        KFPlayerController(Instigator.Controller).TransitionFOV(PlayerIronSightFOV,0.0);
    }
}

simulated function bool CanZoomNow()
{
    Return (!FireMode[0].bIsFiring && !FireMode[1].bIsFiring && Instigator!=None && Instigator.Physics!=PHYS_Falling);
}

simulated event RenderOverlays(Canvas Canvas)
{
    local int m;
    local PlayerController PC;

    if (Instigator == None)
        return;

    PC = PlayerController(Instigator.Controller);

    if(PC == None)
        return;

    if(!bInitializedScope && PC != none )
    {
        UpdateScopeMode();
    }

    Canvas.DrawActor(None, false, true);

    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if (FireMode[m] != None)
        {
            FireMode[m].DrawMuzzleFlash(Canvas);
        }
    }


    SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );
    SetRotation( Instigator.GetViewRotation() + ZoomRotInterp);

    PreDrawFPWeapon();

    if(bAimingRifle && PC != none && (KFScopeDetail == KF_ModelScope || KFScopeDetail == KF_ModelScopeHigh))
    {
        if (ShouldDrawPortal())
        {
            if ( ScopeScriptedTexture != none )
            {
                Skins[LenseMaterialID] = ScopeScriptedShader;
                ScopeScriptedTexture.Client = Self;
                ScopeScriptedTexture.Revision = (ScopeScriptedTexture.Revision +1);
            }
        }

        bDrawingFirstPerson = true;
        Canvas.DrawBoundActor(self, false, false,DisplayFOV,PC.Rotation,rot(0,0,0),Instigator.CalcZoomedDrawOffset(self));
        bDrawingFirstPerson = false;
    }
    else if( KFScopeDetail == KF_TextureScope && PC.DesiredFOV == PlayerIronSightFOV && bAimingRifle)
    {
        Skins[LenseMaterialID] = ScriptedTextureFallback;

        SetZoomBlendColor(Canvas);

        Canvas.Style = ERenderStyle.STY_Normal;
        Canvas.SetPos(0, 0);
        Canvas.DrawTile(ZoomMat, (Canvas.SizeX - Canvas.SizeY) / 2, Canvas.SizeY, 0.0, 0.0, 8, 8);
        Canvas.SetPos(Canvas.SizeX, 0);
        Canvas.DrawTile(ZoomMat, -(Canvas.SizeX - Canvas.SizeY) / 2, Canvas.SizeY, 0.0, 0.0, 8, 8);

        Canvas.Style = 255;
        Canvas.SetPos((Canvas.SizeX - Canvas.SizeY) / 2,0);
        Canvas.DrawTile(ZoomMat, Canvas.SizeY, Canvas.SizeY, 0.0, 0.0, 1024, 1024);

        Canvas.Font = Canvas.MedFont;
        Canvas.SetDrawColor(200,150,0);

        Canvas.SetPos(Canvas.SizeX * 0.16, Canvas.SizeY * 0.43);
        Canvas.DrawText(" ");

        Canvas.SetPos(Canvas.SizeX * 0.16, Canvas.SizeY * 0.47);
    }
    else
    {
        Skins[LenseMaterialID] = ScriptedTextureFallback;
        bDrawingFirstPerson = true;
        Canvas.DrawActor(self, false, false, DisplayFOV);
        bDrawingFirstPerson = false;
    }
}

//=============================================================================
// Scopes
//=============================================================================

//------------------------------------------------------------------------------
// SetScopeDetail(RO) - Allow the players to change scope detail while ingame.
//    Changes are saved to the ini file.
//------------------------------------------------------------------------------
//simulated exec function SetScopeDetail()
//{
//    if( !bHasScope )
//        return;
//
//    if (KFScopeDetail == KF_ModelScope)
//        KFScopeDetail = KF_TextureScope;
//    else if ( KFScopeDetail == KF_TextureScope)
//        KFScopeDetail = KF_ModelScopeHigh;
//    else if ( KFScopeDetail == KF_ModelScopeHigh)
//        KFScopeDetail = KF_ModelScope;
//
//    AdjustIngameScope();
//    class'KFMod.KFWeapon'.default.KFScopeDetail = KFScopeDetail;
//    class'KFMod.KFWeapon'.static.StaticSaveConfig();        // saves the new scope detail value to the ini
//}

//------------------------------------------------------------------------------
// AdjustIngameScope(RO) - Takes the changes to the ScopeDetail variable and
//    sets the scope to the new detail mode. Called when the player switches the
//    scope setting ingame, or when the scope setting is changed from the menu
//------------------------------------------------------------------------------
simulated function AdjustIngameScope()
{
    local PlayerController PC;

    // Lets avoid having to do multiple casts every tick - Ramm
    PC = PlayerController(Instigator.Controller);

    if( !bHasScope )
        return;

    switch (KFScopeDetail)
    {
        case KF_ModelScope:
            if( bAimingRifle )
                DisplayFOV = default.ZoomedDisplayFOV;
            if ( PC.DesiredFOV == PlayerIronSightFOV && bAimingRifle )
            {
                if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
                {
                    KFPlayerController(Instigator.Controller).TransitionFOV(KFPlayerController(Instigator.Controller).DefaultFOV,0.0);
}
            }
            break;

        case KF_TextureScope:
            if( bAimingRifle )
                DisplayFOV = default.ZoomedDisplayFOV;
            if ( bAimingRifle && PC.DesiredFOV != PlayerIronSightFOV )
            {
                if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
                {
                    KFPlayerController(Instigator.Controller).TransitionFOV(PlayerIronSightFOV,0.0);
                }
            }
            break;

        case KF_ModelScopeHigh:
            if( bAimingRifle )
            {
                if( default.ZoomedDisplayFOVHigh > 0 )
                    DisplayFOV = default.ZoomedDisplayFOVHigh;
                else
                    DisplayFOV = default.ZoomedDisplayFOV;
            }
            if ( bAimingRifle && PC.DesiredFOV == PlayerIronSightFOV )
            {
                if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
                {
                    KFPlayerController(Instigator.Controller).TransitionFOV(KFPlayerController(Instigator.Controller).DefaultFOV,0.0);
                }
            }
            break;
    }

    // Make any chagned to the scope setup
    UpdateScopeMode();
}

simulated event Destroyed()
{
    PreTravelCleanUp();

    Super.Destroyed();
}

simulated function PreTravelCleanUp()
{
    if (ScopeScriptedTexture != None)
    {
        ScopeScriptedTexture.Client = None;
        Level.ObjectPool.FreeObject(ScopeScriptedTexture);
        ScopeScriptedTexture=None;
    }

    if (ScriptedScopeCombiner != None)
    {
        ScriptedScopeCombiner.Material2 = none;
        Level.ObjectPool.FreeObject(ScriptedScopeCombiner);
        ScriptedScopeCombiner = none;
    }

    if (ScopeScriptedShader != None)
    {
        ScopeScriptedShader.Diffuse = none;
        ScopeScriptedShader.SelfIllumination = none;
        Level.ObjectPool.FreeObject(ScopeScriptedShader);
        ScopeScriptedShader = none;
    }
}

simulated function bool AllowReload()
{
    UpdateMagCapacity(Instigator.PlayerReplicationInfo);

    if(KFInvasionBot(Instigator.Controller) != none && !bIsReloading &&
        MagAmmoRemaining <= MagCapacity && AmmoAmount(0) > MagAmmoRemaining)
        return true;

    if(KFFriendlyAI(Instigator.Controller) != none && !bIsReloading &&
        MagAmmoRemaining <= MagCapacity && AmmoAmount(0) > MagAmmoRemaining)
        return true;


    if(FireMode[0].IsFiring() || FireMode[1].IsFiring() ||
           bIsReloading || MagAmmoRemaining > MagCapacity ||
           ClientState == WS_BringUp ||
           AmmoAmount(0) <= MagAmmoRemaining ||
                   (FireMode[0].NextFireTime - Level.TimeSeconds) > 0.1 )
        return false;
    return true;
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

defaultproperties
{
    ReloadShortRate=
    bDebugMode = false;
}