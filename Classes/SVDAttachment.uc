class SVDAttachment extends KFWeaponAttachment;

simulated function vector GetTracerStart()
{
    local Pawn p;

    p = Pawn(Owner);

    if ( (p != None) && p.IsFirstPerson() && p.Weapon != None )
        return p.Weapon.GetEffectStart();

    if( Instigator!=None && (Level.TimeSeconds-LastRenderTime)>2 )
        Return Instigator.Location;
    // 3rd person
    if ( mMuzFlash3rd != None )
        return mMuzFlash3rd.Location;
    else return Location;
}

simulated function DoFlashEmitter()
{
    if (mMuzFlash3rd == None)
    {
        mMuzFlash3rd = Spawn(mMuzFlashClass);
        AttachToBone(mMuzFlash3rd, 'tip');
    }
    if(mMuzFlash3rd != None)
        mMuzFlash3rd.SpawnParticle(1);
}
simulated event ThirdPersonEffects()
{
    local PlayerController PC;

    if ( (Level.NetMode == NM_DedicatedServer) || (Instigator == None) )
        return;

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

    if( FiringMode==1 )
    {
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
        }
        else
        {
            GotoState('');
            if( KFPawn(Instigator)!=None )
                KFPawn(Instigator).StopFiring();
        }
    }
    else
    {
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

                WeaponLight();

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
}

defaultproperties
{
     mMuzFlashClass=Class'ScrnWeaponPack.MuzzleFlash3rdSVD'
     mTracerClass=Class'KFMod.KFNewTracer'
     mShellCaseEmitterClass=Class'ScrnWeaponPack.KFShellSpewerSVD'
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
     FireAltAnims(0)="FastAttack2_Knife"
     FireAltAnims(1)="FastAttack2_Knife"
     FireAltAnims(2)="FastAttack2_Knife"
     FireAltAnims(3)="FastAttack2_Knife"
     FireCrouchAnims(0)="CHFire_AK47"
     FireCrouchAnims(1)="CHFire_AK47"
     FireCrouchAnims(2)="CHFire_AK47"
     FireCrouchAnims(3)="CHFire_AK47"
     FireCrouchAltAnims(0)="CHFastAttack2_Knife"
     FireCrouchAltAnims(1)="CHFastAttack2_Knife"
     FireCrouchAltAnims(2)="CHFastAttack2_Knife"
     FireCrouchAltAnims(3)="CHFastAttack2_Knife"
     HitAnims(0)="HitF_AK47"
     HitAnims(1)="HitB_AK47"
     HitAnims(2)="HitL_AK47"
     HitAnims(3)="HitR_AK47"
     PostFireBlendStandAnim="Blend_AK47"
     PostFireBlendCrouchAnim="CHBlend_AK47"
     WeaponAmbientScale=2.000000
     bRapidFire=True
     bAltRapidFire=True
     SplashEffect=Class'ROEffects.BulletSplashEmitter'
     LightBrightness=0.000000
     MeshRef="ScrnWeaponPack_A.SVD_3rd"
}
