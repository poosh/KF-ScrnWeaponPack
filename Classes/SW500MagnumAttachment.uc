class SW500MagnumAttachment extends Magnum44Attachment;

var bool bScopeAttached;

replication
{
    reliable if ((bNetInitial || bNetDirty) && Role == ROLE_Authority)
        bScopeAttached;
}

function InitFor(Inventory Inv)
{
    super.InitFor(Inv);
    bScopeAttached = SW500Magnum(Inv).bScopeAttached;
}

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();
    UpdateScope();
}

simulated function PostNetReceive()
{
    super.PostNetReceive();
    UpdateScope();
}

simulated function UpdateScope()
{
    if (Level.NetMode == NM_DedicatedServer)
        return;
    SetBoneScale(1, float(bScopeAttached), 'Scope');
}

defaultproperties
{
    mMuzFlashClass=Class'ROEffects.MuzzleFlash3rdSTG'
    mTracerClass=Class'KFMod.KFLargeTracer'
    MeshRef="ScrnWeaponPack_A.500magnum_3rd"
    bScopeAttached=true
}
