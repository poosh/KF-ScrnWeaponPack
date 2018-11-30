class ScrnRPGAttachment extends RPGAttachment;

var bool bLocalScopeStatus;
var ScrnRPG ScrnWeap; // avoid typecasting

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    ScrnWeap = ScrnRPG(Instigator.Weapon);
    HideScope();
}

simulated function PostNetReceive()
{
	Super.PostNetReceive();
	if ( bLocalScopeStatus != ScrnWeap.bScopeAttached )
	{
        bLocalScopeStatus = ScrnWeap.bScopeAttached;
        if (bLocalScopeStatus)
        {
            ShowScope();
        }
        else
        {
            HideScope();
        }
	}
}

simulated function ShowScope()
{
    if ( Level.NetMode != NM_DedicatedServer )
    {
        SetBoneScale(1, 1.0, 'PGO7_optimized'); //show scope
    }
}

simulated function HideScope()
{
    if ( Level.NetMode != NM_DedicatedServer )
    {
        SetBoneScale(1, 0.0, 'PGO7_optimized'); //hide scope
    }
}


defaultproperties
{
    mMuzFlashClass=Class'ScrnWeaponPack.ScrnRPGBackblast'
    MeshRef="ScrnWeaponPack_A.ScrnRPG_3rd"
}