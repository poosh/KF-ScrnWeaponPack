class RPG extends ScrnLAW;
//Scrn RPG has a more powerful warhead with enhanced ballistic behaviour, a scope is attached by default and altfire toggles attaching and detaching the scope.

//altfire plays an anim and changes the bScopeAttached bool value, a notify in the anim performs the changeover when the launcher is offscreen
//this bool is also read in BringUp

var bool bScopeAttached;
var vector ZoomedViewOffset; //for handling different zoom positions depending on scope attach status
var byte ZoomedFOVWithScope;
var rotator SightFlipRotation;

var() Material ZoomMat;
var() Sound ZoomSound;

var() int lenseMaterialID;  // used since material id's seem to change alot

var() float scopePortalFOVHigh;  // The FOV to zoom the scope portal by.
var() float scopePortalFOV;  // The FOV to zoom the scope portal by.

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

//illuminated reticle
var texture IllumTex;
var string IllumTexRef;

var float ScopeOffsetY;

var transient Actor AimTarget;
var transient float AimTargetDistance;
var transient float AimTargetNextCheckTime;
var int AimTargetCounter;

replication
{
    reliable if(Role < ROLE_Authority)
        ServerAttachScope;
}

static function PreloadAssets(Inventory Inv, optional bool bSkipRefCount)
{
    local RPG W;

    super.PreloadAssets(Inv, bSkipRefCount);

    default.ZoomMat = FinalBlend(DynamicLoadObject(default.ZoomMatRef, class'FinalBlend', true));
    default.ScriptedTextureFallback = texture(DynamicLoadObject(default.ScriptedTextureFallbackRef, class'texture', true));
    default.CrosshairTex = texture(DynamicLoadObject(default.CrosshairTexRef, class'texture', true));
    default.IllumTex = texture(DynamicLoadObject(default.IllumTexRef, class'texture', true)); //illuminated reticle texture

    W = RPG(Inv);
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

//sets faked fire times so this anim doesn't get interrupted
simulated function AltFire(float F)
{
    local PlayerController PC;

    if( Level.TimeSeconds < FireMode[0].NextFireTime || ClientState != WS_ReadyToFire )
    {
        return;
    }
    FireMode[0].NextFireTime = Level.TimeSeconds + 0.70;
    FireMode[1].NextFireTime = Level.TimeSeconds + 0.70;

    bScopeAttached = !bScopeAttached;
    RPGAttachment(ThirdPersonActor).bScopeAttached = bScopeAttached;
    ServerAttachScope(bScopeAttached);

    if (bAimingRifle)
    {
        ZoomOut(false);
        if( Role < ROLE_Authority)
        {
            ServerZoomOut(false);
        }
    }
    if ( Level.NetMode != NM_DedicatedServer )
    {
        PlayAnim('ScopeAttach',1.0,0.2);
    }

    PC = PlayerController(Instigator.Controller);
    if ( PC != none )
    {
        PC.ReceiveLocalizedMessage(class'RPGSwitchMessage',int(bScopeAttached));
    }
}

function ServerAttachScope(bool bAttach)
{
    bScopeAttached = bAttach;
    RPGAttachment(ThirdPersonActor).bScopeAttached = bScopeAttached;
}

//anim notify in 'ScopeAttach'
simulated function Notify_UpdateScope()
{
    ApplyScopeStatus();
}


simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);
    ApplyScopeStatus();
    if (AmmoAmount(0) <= 0)
    {
        HideRocket();
    }
    else
    {
        Notify_ShowRocket(); //reload doesn't work
    }
}

simulated function ApplyScopeStatus()
{
    if ( Level.NetMode != NM_DedicatedServer )
    {
        if (bScopeAttached)
        {
            SetBoneScale(2, 1.0, 'PGO7_optimized'); //show scope
            ZoomedViewOffset.Y = 0;
            ZoomedViewOffset.Z = 0.05;
            PlayerViewOffset.Y = default.PlayerViewOffset.Y - 8.72;
            PlayerViewOffset.Z = default.PlayerViewOffset.Z - 0.5;
            PlayerIronSightFOV = default.ZoomedFOVWithScope;
            ZoomedDisplayFOV = default.ZoomedDisplayFOV;
            SetBoneRotation( 'frontsight', SightFlipRotation, , 100 ); //flip down sights
            SetBoneRotation( 'rearsight', -1*SightFlipRotation, , 100 ); //flip down sights


        }
        else
        {
            bScopeAttached = false;
            SetBoneScale(2, 0.0, 'PGO7_optimized'); //hide scope
            //ZoomedViewOffset=(X=0.000000,Y=-8.5500000,Z=-0.50000) //new sight alignment fix
            ZoomedViewOffset.Y = -8.72;
            ZoomedViewOffset.Z = -0.5;
            PlayerViewOffset.Y = default.PlayerViewOffset.Y;
            PlayerViewOffset.Z = default.PlayerViewOffset.Z;
            ZoomedDisplayFOV = default.ZoomedDisplayFOV;
            PlayerIronSightFOV = default.PlayerIronSightFOV;
            SetBoneRotation( 'frontsight', SightFlipRotation, , 0); //flip up sights
            SetBoneRotation( 'rearsight', SightFlipRotation, , 0); //flip up sights
        }
    }
    UpdateScopeMode();
}

simulated function bool ShouldDrawPortal()
{
    //    if(bUsingSights && (IsInState('Idle') || IsInState('PostFiring')) && thisAnim != 'scope_shoot_last')
    if( bScopeAttached && bAimingRifle )
        return true;
    else
        return false;
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    // Get new scope detail value from KFWeapon
    KFScopeDetail = class'KFMod.KFWeapon'.default.KFScopeDetail;
    bScopeAttached = true;
    if (bScopeAttached)
    {
        UpdateScopeMode();
    }
}

// Handles initializing and swithing between different scope modes
simulated function UpdateScopeMode()
{
    if (!bScopeAttached)
    {
        ZoomedDisplayFOV = default.ZoomedDisplayFOV;
        return;
    }
    if (Level.NetMode != NM_DedicatedServer && Instigator != none && Instigator.IsLocallyControlled() &&
        Instigator.IsHumanControlled() )
    {
        if( KFScopeDetail == KF_ModelScope)
        {
            scopePortalFOV = default.scopePortalFOV;
            ZoomedDisplayFOV = default.ZoomedFOVWithScope;

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
            //ZoomedDisplayFOV = default.ZoomedDisplayFOVHigh;
            ZoomedDisplayFOV = default.ZoomedFOVWithScope;

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
    local KFPlayerController KFPC;

    if( Level.TimeSeconds < FireMode[0].NextFireTime )
        return;

    super(BaseKFWeapon).ZoomIn(bAnimateTransition);
    bAimingRifle = True;

    if( KFHumanPawn(Instigator)!=None )
        KFHumanPawn(Instigator).SetAiming(True);

    if (Level.NetMode != NM_DedicatedServer) {
        KFPC = KFPlayerController(Instigator.Controller);
        if (KFPC != none) {
            if( AimInSound != none ) {
                PlayOwnedSound(AimInSound, SLOT_Interact,,,,, false);
            }
            if (!bScopeAttached) {
                KFPC.TransitionFOV(PlayerIronSightFOV + (KFPC.DefaultFOV-PlayerIronSightFOV)*0.5, ZoomTime);
            }
        }
    }

    if( bAnimateTransition ) {
        PlayAnim(ZoomAnimName, ZoomAnimRate, 0.1);
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
    local KFPlayerController KFPC;

    super(BaseKFWeapon).ZoomOut(bAnimateTransition);
    bZoomingIn = false;
    bAimingRifle = false;

    if( KFHumanPawn(Instigator)!=None )
        KFHumanPawn(Instigator).SetAiming(False);

    if (Level.NetMode != NM_DedicatedServer && Instigator != none) {
        KFPC = KFPlayerController(Instigator.Controller);
        if (KFPC != none) {
            if (AimOutSound != none) {
                PlayOwnedSound(AimOutSound, SLOT_Misc,,,,, false);
            }
        }

        if (bScopeAttached && KFScopeDetail == KF_TextureScope) {
            KFPC.TransitionFOV(KFPC.DefaultFOV, 0.0);
        }
        else {
            KFPC.TransitionFOV(KFPC.DefaultFOV, ZoomTime);
        }
    }

    if (bAnimateTransition) {
        TweenAnim(IdleAnim,FastZoomOutTime);
    }
}

/**
 * Called by the native code when the interpolation of the first person weapon from the zoomed position finishes
 */
simulated event OnZoomOutFinished()
{
    local name anim;
    local float frame, rate;


    if ( ClientState == WS_ReadyToFire && !bIsReloading )
    {
        GetAnimParams(0, anim, frame, rate);
        // Play the regular idle anim when we're finished zooming out
        if (anim == IdleAimAnim)
        {
           PlayIdle();
        }
    }
    //maybe there should be some fov transition here?
}

simulated function WeaponTick(float dt)
{
    super(KFWeaponShotgun).WeaponTick(dt);

    if( !bIsReloading && bAimingRifle && ForceZoomOutTime > 0 && Level.TimeSeconds - ForceZoomOutTime > 0 )
    {
        ForceZoomOutTime = 0;

        ZoomOut(false);

        if( Role < ROLE_Authority)
            ServerZoomOut(false);
    }

    if ( bAimingRifle && Instigator != none && Instigator.IsLocallyControlled()
            && Level.TimeSeconds > AimTargetNextCheckTime)
    {
        CheckTarget();
        AimTargetNextCheckTime = Level.TimeSeconds + 0.1;
    }
    else if ( !bAimingRifle ) {
        AimTarget = none;
    }
}

simulated function CheckTarget()
{
    local Vector X, Y, Z, Start, End, HitLocation, HitNormal;
    local int i;
    local Actor A;
    local array<Actor> IgnoreActors;

    GetViewAxes(X, Y, Z);
    Start = Instigator.Location + Instigator.EyePosition();
    End = Start + 99 * 50 * X;

    while ( ++i < 100 ) {
        A = Trace(HitLocation, HitNormal, End, Start, true);
        if ( A == none || A.bWorldGeometry || A == Level ) {
            if ( AimTarget != none && --AimTargetCounter <= 0 ) {
                AimTarget = none;
            }
            return;
        }

        if ( ROCollisionAttachment(A) != none ) {
            IgnoreActors[IgnoreActors.length] = A;
            A.SetCollision(false);
        }
        else if ( ExtendedZCollision(A) != none ) {
            AimTarget = A.Owner;
        }
        else {
            AimTarget = A;
        }

        if ( AimTarget != none ) {
            if ( Pawn(AimTarget) != none )
                AimTargetCounter = default.AimTargetCounter;
            else
                AimTargetCounter = 1;  // do not remember other objects
            AimTargetDistance = VSize(HitLocation - Instigator.Location);
            break;
        }

        Start = HitLocation + X;
    }

    for ( i = 0; i < IgnoreActors.Length; i++ ) {
        if ( IgnoreActors[i] != none ) {
            IgnoreActors[i].SetCollision(true);
        }
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

    if( bScopeAttached && Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none &&
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
    local vector DrawOffset;
    local vector ScopedDrawOffset;
    local int m;
    local PlayerController PC;
    local String s;
    local float TextWidth, TextHeight, ScopeLeft;

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
        //applies to 3d scope
        ScopedDrawOffset = (0.9/DisplayFOV * 100 * -ZoomedViewOffset);
        Canvas.DrawBoundActor(self, false, false,DisplayFOV,PC.Rotation,rot(0,0,0),Instigator.CalcZoomedDrawOffset(self)+ScopedDrawOffset);
        bDrawingFirstPerson = false;
    }
    else if( bAimingRifle && bScopeAttached && (KFScopeDetail == KF_TextureScope) && PC.DesiredFOV == PlayerIronSightFOV )
    {
        Skins[LenseMaterialID] = ScriptedTextureFallback;

        ScopeLeft = 0.5 * (Canvas.SizeX - Canvas.SizeY);

        SetZoomBlendColor(Canvas);
        Canvas.Style = ERenderStyle.STY_Normal;
        //left bar
        Canvas.SetPos(0, 0);
        Canvas.DrawTile(ZoomMat, ScopeLeft + (0.15*Canvas.SizeY), Canvas.SizeY, 0.0, 0.0, 8, 8);
        //right bar
        Canvas.SetPos(Canvas.SizeX, 0);
        Canvas.DrawTile(ZoomMat, -ScopeLeft - (0.15*Canvas.SizeY), Canvas.SizeY, 0.0, 0.0, 8, 8);

        //top bar
        Canvas.SetPos(0, 0);
        Canvas.DrawTile(ZoomMat, Canvas.SizeX, (0.15 + ScopeOffsetY) * Canvas.SizeY, 0.0, 0.0, 8, 8);
        //bottom bar
        Canvas.SetPos(0, (0.85 + ScopeOffsetY) * Canvas.SizeY);
        Canvas.DrawTile(ZoomMat, Canvas.SizeX, Canvas.SizeY, 0.0, 0.0, 8, 8);

        Canvas.Style = 255;
        Canvas.SetPos(ScopeLeft + 0.15 * Canvas.SizeY, (0.15 + ScopeOffsetY) * Canvas.SizeY);
        Canvas.DrawTile(ZoomMat, Canvas.SizeY * 0.7, Canvas.SizeY * 0.7, 0.0, 0.0, 512, 512);

        if ( AimTarget != none ) {
            Canvas.Font =class'ScrnHUD'.static.LoadSmallFontStatic(5);
            Canvas.SetDrawColor(200, 64, 0);
            if ( Pawn(AimTarget) != none ) {
                s = Pawn(AimTarget).GetHumanReadableName();
                Canvas.StrLen(s, TextWidth, TextHeight);
                Canvas.SetPos(Canvas.SizeX - ScopeLeft, Canvas.SizeY/2 + ScopeOffsetY - TextHeight);
                Canvas.DrawText(s);
            }
            s = int(AimTargetDistance/50) $ " m";
            Canvas.StrLen(s, TextWidth, TextHeight);
            Canvas.SetPos(Canvas.SizeX - ScopeLeft, Canvas.SizeY/2 + ScopeOffsetY);
            Canvas.DrawText(s);
        }
    }
    else
    {
        Skins[LenseMaterialID] = ScriptedTextureFallback;
        bDrawingFirstPerson = true;
        Canvas.DrawActor(self, false, false, DisplayFOV);
        bDrawingFirstPerson = false;
    }
}

simulated function AdjustIngameScope()
{
    local PlayerController PC;

    if ( Instigator == none || !bHasScope )
        return;
    // Lets avoid having to do multiple casts every tick - Ramm
    PC = PlayerController(Instigator.Controller);
    if( PC == none )
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

simulated function ClientWeaponSet(bool bPossiblySwitch)
{
    super.ClientWeaponSet(bPossiblySwitch);
    UpdateRocket();
}

simulated function UpdateRocket()
{
    if ( MagAmmoRemaining >= 1)
        SetBoneScale (1, 1.0, 'Rocket');
    else
        SetBoneScale (1, 0.0, 'Rocket');
}

//copypaste from RPG to set magammoremaining after last round fired or something
function ServerStopFire(byte Mode)
{
    super(BaseKFWeapon).ServerStopFire(Mode);
    if( AmmoAmount(0) <= 0 ) {
        MagAmmoRemaining = 0;
    }
    else {
        MagAmmoRemaining = 1;
    }
}

simulated function AddReloadedAmmo()
{
    super(KFWeapon).AddReloadedAmmo();
}

simulated function ClientReload()
{
    super.ClientReload();
    ShowRocket();
}

//called by fire function, hides rocket so it doesn't tween to outside of screen for reload anim
simulated function HideRocket()
{
    if ( Level.NetMode != NM_DedicatedServer )
    {
        SetBoneScale(1, 0.0, 'Rocket');
    }
}

simulated function ShowRocket()
{
    if ( Level.NetMode != NM_DedicatedServer )
    {
        SetBoneScale(1, 1.0, 'Rocket');
    }
}

simulated function Notify_ShowRocket()
{
    ShowRocket();
}


// DEBUG STUFF. COMMENT BEFORE RELEASE!
// exec function pfov(int thisFOV)
// {
//     scopePortalFOV = thisFOV;
//     scopePortalFOVHigh = thisFOV;
// }

// exec function zfov(int thisFOV)
// {
//     default.ZoomedDisplayFOV = thisFOV;
//     default.ZoomedDisplayFOVHigh = thisFOV;
// }

// exec function TexSize(int i, int j)
// {
//     ScopeScriptedTexture.SetSize(i, j);
// }


defaultproperties
{
     SleeveNum=0
     //SkinRefs(0)=" " //sleeves
     SkinRefs(1)="ScrnWeaponPack_T.ScrnRPG7.ScrnRPG7_Launcher_cmb" //Texture'ScrnRPG7_Tex.ScrnRPG7_T.ScrnRPG7_Launcher_D'
     SkinRefs(2)="ScrnWeaponPack_T.ScrnRPG7.ScrnRPG7_Rocket_cmb" //Texture'ScrnRPG7_Tex.ScrnRPG7_T.ScrnRPG7_Rocket_D'
     SkinRefs(3)="ScrnWeaponPack_T.ScrnRPG7.ScrnRPG7_PGO7_cmb" //Texture'ScrnRPG7_Tex.ScrnRPG7_T.ScrnRPG7_PGO7_D'
     SkinRefs(4)="ScrnWeaponPack_T.ScrnRPG7.ScrnRPG7_PGO7Eyecup" //"ScrnWeaponPack_T.ScrnRPG7.ScrnRPG7_PGO7Eyecup_D"
     SkinRefs(5)="KF_Weapons_Trip_T.Rifles.CBLens_cmb" //Combiner'KF_Weapons_Trip_T.Rifles.CBLens_cmb'

     //scope stuff
     IllumTexRef="ScrnWeaponPack_T.ScrnRPG7.ScrnRPG7_ReticleIlluminated"
     CrosshairTexRef="ScrnWeaponPack_T.ScrnRPG7.ScrnRPG7_Reticle" //3d scope
     ZoomMatRef="ScrnWeaponPack_T.ScrnRPG7.ScrnRPG7_reticle_finalblend" //texture scope
     ScriptedTextureFallbackRef="KF_Weapons_Trip_T.CBLens_cmb"//Material'Weapons1st_tex.Zoomscope.LensShader'

     TraderInfoTexture=Texture'ScrnWeaponPack_T.ScrnRPG7.ScrnRPG7_trader'
     SelectSoundRef="KF_LAWSnd.LAW_Select"
     HudImageRef="ScrnWeaponPack_T.ScrnRPG7.ScrnRPG7_unselected"
     SelectedHudImageRef="ScrnWeaponPack_T.ScrnRPG7.ScrnRPG7_selected"

     AttachmentClass=class'RPGAttachment'

     //ScriptedTextureFallbackRef="ScrnWeaponPack_T.ScrnRPG7.ScrnRPG7_Rocket_D"//Material'Weapons1st_tex.Zoomscope.LensShader' //"KF_Weapons_Trip_T.CBLens_cmb"

     lenseMaterialID=5

     scopePortalFOVHigh=15.000000
     scopePortalFOV=15.000000

     bHasScope=True //allows switching scope mode via menu ingame
     ZoomedFOVWithScope=45 //50

     ZoomedDisplayFOVHigh=45.000000
     ZoomedDisplayFOV=65 //64
     PlayerIronSightFOV=65 //default for pistols, set to 30 if texture scope

     PlayerViewOffset=(X=10.000000,Y=15.000000,Z=-3.000000)
     MeshRef="ScrnWeaponPack_A.ScrnRPG_1st"
     FastZoomOutTime=0.2
     ForceZoomOutOnFireTime=0.3
     //ForceZoomOutOnFireTime=0.1
     Weight=11
     FireModeClass(0)=class'RPGFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     IdleAimAnim="AimIdle"
     bHoldToReload=false // to show correct ammo amount on classic hud
     ReloadAnim="Reload"
     ReloadRate=2.75
     ReloadAnimRate=1.0
     StandardDisplayFOV=65
     //ZoomedDisplayFOV=50
     //PlayerIronSightFOV=65 //give some zoom when aiming
     ZoomAnimRate=3.0
     ZoomTime=0.3
     Description="RPG-7 Rocket Launcher. Very high damage, but narrow blast radius and rockets drop over distance. Use Altfire to toggle scope."
     PickupClass=class'RPGPickup'
     ItemName="RPG-7 SE"
     SightFlipRotation=(Pitch=-160,Yaw=0,Roll=0)

     ScopeOffsetY = 0.047
     AimTargetCounter=50 // remember target for 5 seconds
}
