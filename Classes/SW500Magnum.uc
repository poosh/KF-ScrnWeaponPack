class SW500Magnum extends Colt;

var name FullBulletEjectAnim;
var name PartialBulletEjectAnim;
var name NoBulletEjectAnim;
var name CylinderCloseAnim;
var name ScopedAimAnim; // for scope
var int NumShellsFired; //stores number of bullets to eject

var float CylinderOpenRate;
var float FirstBulletLoadRate; //new var

var int LastMagAmmoRemaining; //stores last mag ammo for setting cylinder shell state immediately

var bool bShouldAttachScope; //stores if should attach scope next time
var bool bScopeAttached; //stores actual state if weapon has scope or not

//3d scope stuff
var() Material ZoomMat;
var() int lenseMaterialID;  // used since material id's seem to change alot
var() float scopePortalFOVHigh;  // The FOV to zoom the scope portal by.
var() float scopePortalFOV;  // The FOV to zoom the scope portal by.

// 3d Scope vars
var ScriptedTexture ScopeScriptedTexture;  // Scripted texture for 3d scopes
var Shader ScopeScriptedShader;  // The shader that combines the scripted texture with the sight overlay
var Material ScriptedTextureFallback;// The texture to render if the users system doesn't support shaders

// new scope vars
var Combiner ScriptedScopeCombiner;
var texture TexturedScopeTexture;
var bool bInitializedScope;  // Set to true when the scope has been initialized
var string ZoomMatRef;
var string ScriptedTextureFallbackRef;
var texture CrosshairTex;
var string CrosshairTexRef;
var const bool bDebugMode;  // flag for whether debug commands can be run

var vector ZoomedViewOffset, ScopedViewOffset; //for handling new scoped zoom position without ruining firing animation
var(Zooming) float ScopedSightFOV; 	// The fov to use for this weapon when in ironsights


//bullet hiding is controlled by firing and animation notifies
//firing converts bullets into shells

//eject
//play one of the three eject anims, all of them have Notify_GoToReload at the end
//has notify Notify_ShellsEjected in middle somewhere to reset count of ejected shells early

//reload
//reload starts, has notifies Notify_ReloadStart to handle hiding all shells and showing all bullets and Notify_SkipReloadAnim to skip ahead depending on how many bullets are currently in cylinder
//reload end has Notify_CylinderClose to handle showing post-reload bullets for cylinder close in animation 'Reload'

//reload interrupt
//called when reload is unterrupted, hides bullets that are not loaded and tweens quickly to animation 'Cylinderclose'
//also has Notify_CylinderClose

replication
{
    reliable if (Role < ROLE_Authority)
        ServerAttachScope;
}

static function PreloadAssets(Inventory Inv, optional bool bSkipRefCount)
{
    local SW500Magnum W;

    super.PreloadAssets(Inv, bSkipRefCount);

    default.ZoomMat = FinalBlend(DynamicLoadObject(default.ZoomMatRef, class'FinalBlend', true));
    default.ScriptedTextureFallback = texture(DynamicLoadObject(default.ScriptedTextureFallbackRef, class'texture', true));
    default.CrosshairTex = texture(DynamicLoadObject(default.CrosshairTexRef, class'texture', true));

    W = SW500Magnum(Inv);
    if ( W != none ) {
        W.ZoomMat = default.ZoomMat;
        W.ScriptedTextureFallback = default.ScriptedTextureFallback;
        W.CrosshairTex = default.CrosshairTex;
    }
}
static function bool UnloadAssets()
{
    if ( super.UnloadAssets() )
    {
        default.ZoomMat = none;
        default.ScriptedTextureFallback = none;
        default.CrosshairTex = none;
    }

    return true;
}

// exec function pfov(int thisFOV)
// {
//     if( !bDebugMode )
//         return;
//     scopePortalFOV = thisFOV;
//     scopePortalFOVHigh = thisFOV;
// }

// exec function zfov(int thisFOV)
// {
//     if( !bDebugMode )
//         return;
//     default.ZoomedDisplayFOV = thisFOV;
//     default.ZoomedDisplayFOVHigh = thisFOV;
// }

// simulated exec function TexSize(int i, int j)
// {
//     if( !bDebugMode )
//         return;
//     ScopeScriptedTexture.SetSize(i, j);
// }

// Helper function for the scope system. The scope system checks here to see when it should draw the portal.
// if you want to limit any times the portal should/shouldn't be drawn, add them here.
// Ramm 10/27/03
simulated function bool ShouldDrawPortal()
{
    return bScopeAttached && bAimingRifle;
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
        if (KFScopeDetail == KF_TextureScope) {
            KFScopeDetail = KF_ModelScopeHigh;
        }

        if( KFScopeDetail == KF_ModelScope)
        {
            scopePortalFOV = default.scopePortalFOV;
            ZoomedDisplayFOV = CalcAspectRatioAdjustedFOV(default.ZoomedDisplayFOVHigh);
            //bPlayerFOVZooms = false;

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

            if( ScopeScriptedShader == none ) {
                ScopeScriptedShader = Shader(Level.ObjectPool.AllocateObject(class'Shader'));
                ScopeScriptedShader.Diffuse = ScriptedScopeCombiner;
                ScopeScriptedShader.SelfIllumination = ScriptedScopeCombiner;
                ScopeScriptedShader.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
            }

            bInitializedScope = true;
        }
        else /* if( KFScopeDetail == KF_ModelScopeHigh ) */
        {
            scopePortalFOV = scopePortalFOVHigh;
            ZoomedDisplayFOV = CalcAspectRatioAdjustedFOV(default.ZoomedDisplayFOVHigh);

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
        // else if (KFScopeDetail == KF_TextureScope)
        // {
        //     ZoomedDisplayFOV = default.ZoomedDisplayFOV;
        //     PlayerViewOffset.X = default.PlayerViewOffset.X;

        //     bInitializedScope = true;
        // }
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

simulated function float CalcAspectRatioAdjustedFOV(float AdjustFOV)
{
    local KFPlayerController KFPC;
    local float ResX, ResY;
    local float AspectRatio;

    KFPC = KFPlayerController(Level.GetLocalPlayerController());

    if( KFPC == none )
    {
        return AdjustFOV;
    }

    ResX = float(GUIController(KFPC.Player.GUIController).ResX);
    ResY = float(GUIController(KFPC.Player.GUIController).ResY);
    AspectRatio = ResX / ResY;

    if ( KFPC.bUseTrueWideScreenFOV && AspectRatio >= 1.60 ) //1.6 = 16/10 which is 16:10 ratio and 16:9 comes to 1.77
    {
        return CalcFOVForAspectRatio(AdjustFOV);
    }
    else
    {
        return AdjustFOV;
    }
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
    if (!bScopeAttached)
    {
        KFPlayerController(Instigator.Controller).TransitionFOV(PlayerIronSightFOV+(KFPlayerController(Instigator.Controller).DefaultFOV-PlayerIronSightFOV)*0.5,ZoomTime); //modified because reasons
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
        //KFPlayerController(Instigator.Controller).TransitionFOV(KFPlayerController(Instigator.Controller).DefaultFOV,0.0);
        if (!bScopeAttached)
        {
            KFPlayerController(Instigator.Controller).TransitionFOV(KFPlayerController(Instigator.Controller).DefaultFOV,ZoomTime);
        }
        // else if ( KFScopeDetail == KF_TextureScope )
        // {
        //     KFPlayerController(Instigator.Controller).TransitionFOV(KFPlayerController(Instigator.Controller).DefaultFOV,0.0);
        // }
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

    // if( bScopeAttached && Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none &&
    //     KFScopeDetail == KF_TextureScope )
    // {
    //     KFPlayerController(Instigator.Controller).TransitionFOV(PlayerIronSightFOV,0.0);
    // }
}

simulated function bool CanZoomNow()
{
    Return (!FireMode[0].bIsFiring && !FireMode[1].bIsFiring && Instigator!=None && Instigator.Physics!=PHYS_Falling);
}


simulated event RenderOverlays(Canvas Canvas)
{
    local vector DrawOffset;
    local vector ScopedDrawOffset;
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

    DrawOffset = (90/DisplayFOV * ZoomedViewOffset) >> Instigator.GetViewRotation(); //calculate additional offset
    SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) + DrawOffset); //add additional offset
    //SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );
    SetRotation( Instigator.GetViewRotation() + ZoomRotInterp);

    PreDrawFPWeapon();

    if(bAimingRifle && PC != none /* && (KFScopeDetail == KF_ModelScope || KFScopeDetail == KF_ModelScopeHigh) */ )
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
        //applies to 3d scope
        ScopedDrawOffset = (0.9/DisplayFOV * 100 * -ZoomedViewOffset);
        Canvas.DrawBoundActor(self, false, false,DisplayFOV,PC.Rotation,rot(0,0,0),Instigator.CalcZoomedDrawOffset(self)+ScopedDrawOffset);
        bDrawingFirstPerson = false;
    }
    // else if( bScopeAttached && (KFScopeDetail == KF_TextureScope) && PC.DesiredFOV == PlayerIronSightFOV && bAimingRifle)
    // {
    //     Skins[LenseMaterialID] = ScriptedTextureFallback;

    //     SetZoomBlendColor(Canvas);

    //     Canvas.Style = ERenderStyle.STY_Normal;
    //     Canvas.SetPos(0, 0);
    //     Canvas.DrawTile(ZoomMat, (Canvas.SizeX - Canvas.SizeY) / 2, Canvas.SizeY, 0.0, 0.0, 8, 8);
    //     Canvas.SetPos(Canvas.SizeX, 0);
    //     Canvas.DrawTile(ZoomMat, -(Canvas.SizeX - Canvas.SizeY) / 2, Canvas.SizeY, 0.0, 0.0, 8, 8);

    //     Canvas.Style = 255;
    //     Canvas.SetPos((Canvas.SizeX - Canvas.SizeY) / 2,0);
    //     Canvas.DrawTile(ZoomMat, Canvas.SizeY, Canvas.SizeY, 0.0, 0.0, 1024, 1024);

    //     Canvas.Font = Canvas.MedFont;
    //     Canvas.SetDrawColor(200,150,0);

    //     Canvas.SetPos(Canvas.SizeX * 0.16, Canvas.SizeY * 0.43);
    //     Canvas.DrawText(" ");

    //     Canvas.SetPos(Canvas.SizeX * 0.16, Canvas.SizeY * 0.47);
    // }
    else
    {
        Skins[LenseMaterialID] = ScriptedTextureFallback;
        bDrawingFirstPerson = true;
        Canvas.DrawActor(self, false, false, DisplayFOV);
        bDrawingFirstPerson = false;
    }
}

//------------------------------------------------------------------------------
// AdjustIngameScope(RO) - Takes the changes to the ScopeDetail variable and
//    sets the scope to the new detail mode. Called when the player switches the
//    scope setting ingame, or when the scope setting is changed from the menu
//------------------------------------------------------------------------------
simulated function AdjustIngameScope()
{
    local PlayerController PC;

    if (!bHasScope || Instigator == none)
        return;
    PC = PlayerController(Instigator.Controller);
    if (PC == none)
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
            // if( bAimingRifle )
            //     DisplayFOV = default.ZoomedDisplayFOV;
            // if ( bAimingRifle && PC.DesiredFOV != PlayerIronSightFOV )
            // {
            //     if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
            //     {
            //         KFPlayerController(Instigator.Controller).TransitionFOV(PlayerIronSightFOV,0.0);
            //     }
            // }
            // break;

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


//allow firemode switch even if empty
simulated function AltFire(float F)
{
    if (ClientState == WS_ReadyToFire )
    {
        DoToggle();
    }
}

simulated function DoToggle()
{
    if (IsFiring())
       return;

    bShouldAttachScope = !bShouldAttachScope;
    Instigator.PendingWeapon = self;
    PutDown();
}

function ServerAttachScope(bool bAttach)
{
    bScopeAttached = bAttach;
    SW500MagnumAttachment(ThirdPersonActor).bScopeAttached = bScopeAttached;
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);
    if (Level.NetMode != NM_DedicatedServer) {
        if (bShouldAttachScope != bScopeAttached) {
            ServerAttachScope(bShouldAttachScope);
        }

        if (bShouldAttachScope) {
            bScopeAttached = true;
            SetBoneScale(14, 1.0, 'Scope'); //hide scope
            SetBoneScale(15, 1.0, 'scope_reticle'); //hide scope texture
            SetBoneScale(16, 0.0, 'rearsight'); //hide rear sight
            //IdleAimAnim = default.ScopedAimAnim;
            ZoomedDisplayFOV = default.ZoomedDisplayFOVHigh;
            ZoomedViewOffset = ScopedViewOffset;
            PlayerIronSightFOV = ScopedSightFOV;
        }
        else {
            bScopeAttached = false;
            SetBoneScale(14, 0.0, 'Scope'); //hide scope
            SetBoneScale(15, 0.0, 'scope_reticle'); //hide scope texture
            SetBoneScale(16, 1.0, 'rearsight'); //show rear sight
            //IdleAimAnim = default.IdleAimAnim;
            ZoomedDisplayFOV = default.ZoomedDisplayFOV;
            ZoomedViewOffset = default.ZoomedViewOffset;
            PlayerIronSightFOV = default.PlayerIronSightFOV;
        }
    }
}

simulated function AddSpentShell()
{
    NumShellsFired++;
}

simulated function Fire(float F)
{
    LastMagAmmoRemaining = MagAmmoRemaining - 1;
    SetVisibleBullets(LastMagAmmoRemaining);
    super.Fire(f);
}

simulated function SetVisibleBullets(int num)
{
    if (Level.NetMode == NM_DedicatedServer)
        return;
    SetBoneScale(1, float(num >= 1), 'b1');
    SetBoneScale(2, float(num >= 2), 'b2');
    SetBoneScale(3, float(num >= 3), 'b3');
    SetBoneScale(4, float(num >= 4), 'b4');
    SetBoneScale(5, float(num >= 5), 'b5');
}

simulated function SetVisibleShells(int num)
{
    if (Level.NetMode == NM_DedicatedServer)
        return;
    SetBoneScale( 6, float(num >= 5), 'shell1');
    SetBoneScale( 7, float(num >= 4), 'shell2');
    SetBoneScale( 8, float(num >= 3), 'shell3');
    SetBoneScale( 9, float(num >= 2), 'shell4');
    SetBoneScale(10, float(num >= 1), 'shell5');
}

//updates cylinder so it looks okay after firing
simulated function Notify_UpdateCylinderShells()
{
    SetVisibleBullets(MagAmmoRemaining);
    SetVisibleShells(NumShellsFired);
}

simulated function Notify_ShellsEjected()
{
    NumShellsFired = 0;
}

//notify in case eject none timer gets fixed
simulated function Notify_EjectNone()
{

}

//called at the end of eject anim
simulated function Notify_GoToReload()
{
    PlayAnim(ReloadAnim, ReloadAnimRate*ReloadMulti, 0.01/ReloadMulti);
    //just hide all the shells otherwise they will tween back into the cylinder
    SetVisibleShells(0);
}

//called at the end of eject anim
simulated function Notify_ReloadStart()
{
    //show all bullets in case they get loaded
    SetVisibleBullets(MagCapacity);
    SetVisibleShells(0);
}

//called by reload anim, skips to reload and does something
simulated function Notify_SkipReloadAnim()
{
    if (MagAmmoRemaining > 0 && MagAmmoRemaining < 5) {
        SetAnimFrame(20 * MagAmmoRemaining, 0 , 1);
    }
}

simulated function Notify_CylinderClose()
{
    SetEjectBullets();
}

//set bullets for partial eject
simulated function SetEjectBullets()
{
    SetVisibleBullets(MagAmmoRemaining);

    if (NumShellsFired == 0) {
        //if there are no shells, hide them all
        SetVisibleShells(0);
    }
}

//copypaste to allow force zoom out
// simulated function bool StartFire(int Mode)
// {
//     local bool RetVal;

//     RetVal = super.StartFire(Mode);

//     if( RetVal )
//     {
//         if( bScopeAttached && (KFScopeDetail == KF_TextureScope) && Mode == 0 && ForceZoomOutOnFireTime > 0 )
//         {
//             ForceZoomOutTime = Level.TimeSeconds + ForceZoomOutOnFireTime;
//         }
//         else if( Mode == 1 && ForceZoomOutOnAltFireTime > 0 )
//         {
//             ForceZoomOutTime = Level.TimeSeconds + ForceZoomOutOnAltFireTime;
//         }

//         NumClicks=0;
//     }

//     return RetVal;
// }

// This function now is triggered by ReloadMeNow() and executed on local side only
simulated function ClientReload()
{
    DoReload();
    if (NumShellsFired == 0)
    {
        PlayAnim(NoBulletEjectAnim, ReloadAnimRate*ReloadMulti, 0.1/ReloadMulti);
    }
    else if (MagAmmoRemaining == 0)
    {
        PlayAnim(FullBulletEjectAnim, ReloadAnimRate*ReloadMulti, 0.1/ReloadMulti);
    }
    else
    {
        PlayAnim(PartialBulletEjectAnim, ReloadAnimRate*ReloadMulti, 0.1/ReloadMulti);
    }
    SetEjectBullets();
}

function ServerInterruptReload()
{
    if ( Role == ROLE_Authority ) {
        ReloadTimer = Level.TimeSeconds + 0.4/ReloadMulti;
        bInterruptedReload = true;
        PlayAnim(CylinderCloseAnim, ReloadAnimRate*ReloadMulti, 0.03/ReloadMulti);
        //SetAnimFrame(144, 0 , 1);  // go to closing drum stage
    }
}

simulated function ClientInterruptReload()
{
    if ( Role < ROLE_Authority ) {
        bInterruptedReload = true;
        PlayAnim(CylinderCloseAnim, ReloadAnimRate*ReloadMulti, 0.03/ReloadMulti);
        SetEjectBullets(); //hide shells if they got ejected already
        //SetAnimFrame(144, 0 , 1);  // go to closing drum stage
    }
}

//frame 144 for cylinder close

// Since vanilla reloading replication is totally fucked, I moved base code into separate,
// replication-free function, which is executed on both server and client side
// -- PooSH
simulated function DoReload()
{
    if ( bHasAimingMode && bAimingRifle ) {
        FireMode[1].bIsFiring = False;
        ZoomOut(false);
        // ZoomOut() just a moment ago was executed on server side - why to force it again?  -- PooSH
        // if( Role < ROLE_Authority)
            // ServerZoomOut(false);
    }

    if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
        ReloadMulti = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetReloadSpeedModifier(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo), self);
    else
        ReloadMulti = 1.0;

    bIsReloading = true;
    bInterruptedReload = false;
    CylinderOpenRate = default.CylinderOpenRate / ReloadMulti;
    BulletUnloadRate = default.BulletUnloadRate / ReloadMulti;
    FirstBulletLoadRate = default.FirstBulletLoadRate / ReloadMulti;
    BulletLoadRate = default.BulletLoadRate / ReloadMulti;
    if (NumShellsFired != 0)
    {
        NextBulletLoadTime = Level.TimeSeconds + BulletUnloadRate + CylinderOpenRate + FirstBulletLoadRate;
    }
    else
    {
        NextBulletLoadTime = Level.TimeSeconds + CylinderOpenRate + FirstBulletLoadRate;
    }
    // more bullets left = less time to reload
    ReloadRate = default.ReloadRate / ReloadMulti;
    ReloadRate -= MagAmmoRemaining * BulletLoadRate;
    ReloadTimer = Level.TimeSeconds + ReloadRate;

    Instigator.SetAnimAction(WeaponReloadAnim);
}

defaultproperties
{
    MeshRef="ScrnWeaponPack_A.500Magnum_T.500Magnum_1st"
    SkinRefs(1)="ScrnWeaponPack_T.500Magnum_T.500magnum_cmb" //Combiner'500magnum_T.500magnum_cmb'
    SkinRefs(2)="ScrnWeaponPack_T.500Magnum_T.500magnum_bullet_cmb" //Combiner'500magnum_T.500magnum_bullet_cmb'
    SkinRefs(3)="ScrnWeaponPack_T.500Magnum_T.500magnum_shell_cmb" //Combiner'500magnum_T.500magnum_shell_cmb'
    SkinRefs(4)="ScrnWeaponPack_T.500Magnum_T.500magnum_scope_cmb" //Combiner'500magnum_T.500magnum_scope_cmb'
    SkinRefs(5)="KF_Weapons_Trip_T.Rifles.CBLens_cmb" //Combiner'KF_Weapons_Trip_T.Rifles.CBLens_cmb'

    //scope stuff
    CrosshairTexRef="ScrnWeaponPack_T.500Magnum_T.500magnum_crosshair" //3d scope
    ZoomMatRef="ScrnWeaponPack_T.500Magnum_T.500magnum_texturescope_finalblend" //texture scope
    ScriptedTextureFallbackRef="KF_Weapons_Trip_T.CBLens_cmb"//Material'Weapons1st_tex.Zoomscope.LensShader'

    lenseMaterialID=5

    bHasScope=True //allows switching scope mode via menu ingame
    bShouldAttachScope=True
    scopePortalFOVHigh=5
    scopePortalFOV=5
    ZoomedDisplayFOVHigh=45  // when scoped
    ZoomedDisplayFOV=65
    ScopedSightFOV=25
    PlayerIronSightFOV=75 //default for pistols, set to 30 if texture scope
    DisplayFOV=70.000000
    ZoomedViewOffset=(X=5.0,Y=0.0,Z=0.0)
    ScopedViewOffset=(X=20.00,Y=0.0,Z=-2.7)

    HudImageRef="ScrnWeaponPack_T.500Magnum_T.500magnum_unselected"
    PickupClass=Class'SW500MagnumPickup'
    SelectedHudImageRef="ScrnWeaponPack_T.500Magnum_T.500magnum_selected"
    Description=".500 S&W Magnum is a .50 caliber revolver with increased armor-piercing capability. Press altfire to attach/detach scope."

    FireModeClass(0)=Class'SW500MagnumFire'
    FireModeClass(1)=Class'KFMod.NoFire'
    ForceZoomOutOnFireTime=0.01
    PlayerViewOffset=(X=10.000000,Y=25.000000,Z=-10.000000)
    ItemName=".500 S&W Magnum"

    FirstPersonFlashlightOffset=(X=-20.000000,Y=-22.000000,Z=8.000000)
    MagCapacity=5
    ReloadRate=5.16
    ReloadAnim="Reload"
    FullBulletEjectAnim="eject_all"
    PartialBulletEjectAnim="eject_partial"
    NoBulletEjectAnim="eject_none"
    CylinderCloseAnim="cylinderclose"
    bHoldToReload=True
    FirstBulletLoadRate=0.5 //~8 frames but iono
    BulletLoadRate=0.667 // 20 frames
    CylinderOpenRate=0.8 // around 29 frames
    BulletUnloadRate=0 //eject partial 28
    ReloadAnimRate=1.000000
    WeaponReloadAnim="Reload_Revolver"
    Weight=5 // 3
    bHasAimingMode=True
    IdleAimAnim="idle_iron"
    ScopedAimAnim="idle_scoped"
    StandardDisplayFOV=70.000000
    bModeZeroCanDryFire=True
    SleeveNum=0
    TraderInfoTexture=Texture'ScrnWeaponPack_T.500Magnum_T.500magnum_trader'


    PutDownAnim="PutDown"
    SelectSound=Sound'KF_9MMSnd.9mm_Select'
    AIRating=0.250000
    CurrentRating=0.250000
    bShowChargingBar=True
    Priority=110 // 5
    InventoryGroup=2
    GroupOffset=1
    BobDamping=6.000000
    AttachmentClass=Class'SW500MagnumAttachment'
    IconCoords=(X1=434,Y1=253,X2=506,Y2=292)

    PutDownAnimRate=2.0
    SelectAnimRate=2.0
    BringUpTime=0.33
    PutDownTime=0.33
}
