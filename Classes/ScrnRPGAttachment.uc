class ScrnRPGAttachment extends RPGAttachment;

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
    mMuzFlashBone="Reartip"
    mMuzFlashClass=Class'ScrnWeaponPack.ScrnRPGBackblast'
    MeshRef="ScrnWeaponPack_A.ScrnRPG_3rd"
    bNetNotify=true
    bScopeAttached=true
}
