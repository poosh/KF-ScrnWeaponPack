class VSSDTAttachment extends KFWeaponAttachment;


simulated event ThirdPersonEffects()
{
    local PlayerController PC;

    if ( (Level.NetMode == NM_DedicatedServer) || (Instigator == None) )
        return;

    // new Trace FX - Ramm
    if (FiringMode == 0)
    {
        if ( OldSpawnHitCount != SpawnHitCount )
        {
            OldSpawnHitCount = SpawnHitCount;
            GetHitInfo();
            PC = Level.GetLocalPlayerController();
            if ( ((Instigator != None) && (Instigator.Controller == PC)) || (VSize(PC.ViewTarget.Location - mHitLocation) < 4000) )
            {
                if( mHitActor!=None )
                    Spawn(class'ROBulletHitEffect',,, mHitLocation, Rotator(-mHitNormal));
                CheckForSplash();
                SpawnTracer();
            }
        }
    }

      if ( FlashCount>0 )
    {
        if( KFPawn(Instigator)!=None )
        {
            if (FiringMode == 0)
            {
                KFPawn(Instigator).StartFiringX(false,bRapidFire);
            }
            else
            {
                KFPawn(Instigator).StartFiringX(true,bRapidFire);
            }
        }

        if( bDoFiringEffects )
        {
            PC = Level.GetLocalPlayerController();

            if ( (Level.TimeSeconds - LastRenderTime > 0.2) && (Instigator.Controller != PC) )
                return;

            // WeaponLight();

            DoFlashEmitter();

            if ( (mShellCaseEmitter == None) && (Level.DetailMode != DM_Low) && !Level.bDropDetail )
            {
                mShellCaseEmitter = Spawn(mShellCaseEmitterClass);
                if ( mShellCaseEmitter != None )
                    AttachToBone(mShellCaseEmitter, ShellEjectBoneName);
            }
            if (mShellCaseEmitter != None)
                mShellCaseEmitter.mStartParticles++;
        }
    }
    else
    {
        GotoState('');
        if( KFPawn(Instigator)!=None )
            KFPawn(Instigator).StopFiring();
    }
}
/*
simulated function WeaponLight()
{

    if ( (FlashCount > 0) && !Level.bDropDetail && (Instigator != None)
        && ((Level.TimeSeconds - LastRenderTime < 0.2) || (PlayerController(Instigator.Controller) != None)) )
    {
        if ( Instigator.IsFirstPerson() )
        {
            LitWeapon = Instigator.Weapon;
            LitWeapon.bDynamicLight = true;
        }
        else
            bDynamicLight = true;
        SetTimer(0.15, false);
    }
    else
        Timer();
        
}
*/

defaultproperties
{
     mMuzFlashClass=class'MuzzleFlash3rdVSSDT'
     mTracerClass=Class'KFMod.KFNewTracer'
     mShellCaseEmitterClass=Class'KFMod.KFShellSpewer'
     ShellEjectBoneName="Shell_eject"
     MovementAnims(0)="JogF_AK47"
     MovementAnims(1)="JogB_AK47"
     MovementAnims(2)="JogL_AK47"
     MovementAnims(3)="JogR_AK47"
     TurnLeftAnim="TurnL_AK47"
     TurnRightAnim="TurnR_AK47"
     CrouchAnims(0)="CHWalkF_AK47"
     CrouchAnims(1)="CHWalkB_AK47"
     CrouchAnims(2)="CHWalkL_AK47"
     CrouchAnims(3)="CHWalkR_AK47"
     WalkAnims(0)="WalkF_AK47"
     WalkAnims(1)="WalkB_AK47"
     WalkAnims(2)="WalkL_AK47"
     WalkAnims(3)="WalkR_AK47"
     CrouchTurnRightAnim="CH_TurnR_AK47"
     CrouchTurnLeftAnim="CH_TurnL_AK47"
     IdleCrouchAnim="CHIdle_AK47"
     IdleWeaponAnim="Idle_AK47"
     IdleRestAnim="Idle_AK47"
     IdleChatAnim="Idle_AK47"
     IdleHeavyAnim="Idle_AK47"
     IdleRifleAnim="Idle_AK47"
     FireAnims(0)="Fire_AK47"
     FireAnims(1)="Fire_AK47"
     FireAnims(2)="Fire_AK47"
     FireAnims(3)="Fire_AK47"
     FireAltAnims(0)="IS_Fire_AK47"
     FireAltAnims(1)="IS_Fire_AK47"
     FireAltAnims(2)="IS_Fire_AK47"
     FireAltAnims(3)="IS_Fire_AK47"
     FireCrouchAnims(0)="CHFire_AK47"
     FireCrouchAnims(1)="CHFire_AK47"
     FireCrouchAnims(2)="CHFire_AK47"
     FireCrouchAnims(3)="CHFire_AK47"
     FireCrouchAltAnims(0)="CHFire_AK47"
     FireCrouchAltAnims(1)="CHFire_AK47"
     FireCrouchAltAnims(2)="CHFire_AK47"
     FireCrouchAltAnims(3)="CHFire_AK47"
     HitAnims(0)="HitF_AK47"
     HitAnims(1)="HitB_AK47"
     HitAnims(2)="HitL_AK47"
     HitAnims(3)="HitR_AK47"
     PostFireBlendStandAnim="Blend_AK47"
     PostFireBlendCrouchAnim="CHBlend_AK47"
     MeshRef="ScrnWeaponPack_A.vintorezDT3rd"
     bHeavy=True
     SplashEffect=Class'ROEffects.BulletSplashEmitter'
     CullDistance=5000.000000
     DrawScale=0.550000
}
