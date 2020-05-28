class RPGAttachment extends KFWeaponAttachment;

var bool bScopeAttached;
var name mMuzFlashBone;

replication
{
    reliable if( Role == ROLE_Authority )
        bScopeAttached;
}

simulated function PostNetReceive()
{
    Super.PostNetReceive();

    if (bScopeAttached ) {
        SetBoneScale(1, 1.0, 'PGO7_optimized'); //show scope
    }
    else {
        SetBoneScale(1, 0.0, 'PGO7_optimized'); //hide scope
    }
}

simulated function DoFlashEmitter()
{
    if (mMuzFlash3rd == None)
    {
        mMuzFlash3rd = Spawn(mMuzFlashClass);
        AttachToBone(mMuzFlash3rd, mMuzFlashBone);
    }
    if(mMuzFlash3rd != None)
        mMuzFlash3rd.SpawnParticle(1);
}

defaultproperties
{
    MeshRef="ScrnWeaponPack_A.ScrnRPG_3rd"
    mMuzFlashBone="Reartip"
    mMuzFlashClass=Class'ScrnWeaponPack.RPGBackblast'
    bNetNotify=true
    bScopeAttached=true
    MovementAnims(0)="JogF_LAW"
    MovementAnims(1)="JogB_LAW"
    MovementAnims(2)="JogL_LAW"
    MovementAnims(3)="JogR_LAW"
    TurnLeftAnim="TurnL_LAW"
    TurnRightAnim="TurnR_LAW"
    CrouchAnims(0)="CHwalkF_LAW"
    CrouchAnims(1)="CHwalkB_LAW"
    CrouchAnims(2)="CHwalkL_LAW"
    CrouchAnims(3)="CHwalkR_LAW"
    WalkAnims(0)="WalkF_LAW"
    WalkAnims(1)="WalkB_LAW"
    WalkAnims(2)="WalkL_LAW"
    WalkAnims(3)="WalkR_LAW"
    CrouchTurnRightAnim="CH_TurnR_LAW"
    CrouchTurnLeftAnim="CH_TurnL_LAW"
    IdleCrouchAnim="CHIdle_LAW"
    IdleWeaponAnim="Idle_LAW"
    IdleRestAnim="Idle_LAW"
    IdleChatAnim="Idle_LAW"
    IdleHeavyAnim="Idle_LAW"
    IdleRifleAnim="Idle_LAW"
    FireAnims(0)="Fire_Crossbow"
    FireAnims(1)="Fire_Crossbow"
    FireAnims(2)="Fire_Crossbow"
    FireAnims(3)="Fire_Crossbow"
    FireAltAnims(0)="Fire_Crossbow"
    FireAltAnims(1)="Fire_Crossbow"
    FireAltAnims(2)="Fire_Crossbow"
    FireAltAnims(3)="Fire_Crossbow"
    FireCrouchAnims(0)="CHFire_Crossbow"
    FireCrouchAnims(1)="CHFire_Crossbow"
    FireCrouchAnims(2)="CHFire_Crossbow"
    FireCrouchAnims(3)="CHFire_Crossbow"
    FireCrouchAltAnims(0)="CHFire_Crossbow"
    FireCrouchAltAnims(1)="CHFire_Crossbow"
    FireCrouchAltAnims(2)="CHFire_Crossbow"
    FireCrouchAltAnims(3)="CHFire_Crossbow"
    HitAnims(0)="HitF_LAW"
    HitAnims(1)="HitB_LAW"
    HitAnims(2)="HitL_LAW"
    HitAnims(3)="HitR_LAW"
    PostFireBlendStandAnim="Blend_LAW"
    PostFireBlendCrouchAnim="CHBlend_LAW"
    bHeavy=True
}
