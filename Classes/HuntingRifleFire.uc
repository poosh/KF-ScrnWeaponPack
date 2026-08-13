//=============================================================================
// HuntingRifleFire
//=============================================================================
class HuntingRifleFire extends ScrnFire;

var vector ScopedShakeOffsetMag; //Shake offset mag used for 3d scopes
var vector ScopedShakeOffsetRate; //Shake offset rate used for 3d scopes


//adds faked recoil to 3d scope zoom
event ModeDoFire()
{
    if (KFWeap.bAimingRifle) {
        if (KFWeap.KFScopeDetail != KF_TextureScope) {
            ShakeOffsetMag=default.ScopedShakeOffsetMag;
            ShakeOffsetRate=default.ScopedShakeOffsetRate;
        }
    }
    else {
        ShakeOffsetMag=default.ShakeOffsetMag;
        ShakeOffsetRate=default.ShakeOffsetRate;
    }
    Super.ModeDoFire();
}

defaultproperties
{
    StereoFireSoundRef="ScrnWeaponPack_SND.BDHR.awp1_stereo"
    FireSoundRef="ScrnWeaponPack_SND.BDHR.awp1_mono"
    NoAmmoSoundRef="KF_RifleSnd.Rifle_DryFire"

    FireAimedAnim="Fire_Iron"
    RecoilRate=0.100000
    maxVerticalRecoilAngle=800
    maxHorizontalRecoilAngle=250
    DamageType=class'DamTypeHuntingRifle'
    DamageMax=220
    Momentum=18000.000000
    bWaitForRelease=True
    bModeExclusive=False
    bAttachSmokeEmitter=True
    TransientSoundVolume=2.800000
    FireLoopAnim=
    FireEndAnim=
    FireForce="ShockRifleFire"
    FireRate=1.900000
    AmmoClass=class'HuntingRifleAmmo'
    AmmoPerFire=1
    ShakeRotMag=(X=100.000000,Y=100.000000,Z=500.000000)
    ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
    ShakeRotTime=2.000000
    ShakeOffsetMag=(X=0.000000,Y=0.000000,Z=0.000000)
    ScopedShakeOffsetMag=(X=3.000000,Y=0.000000,Z=0.000000) //faked recoil for 3d scope
    ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
    ScopedShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000) //faked recoil for 3d scope
    ShakeOffsetTime=2.000000
    BotRefireRate=0.650000
    FlashEmitterClass=Class'ROEffects.MuzzleFlash1stKar'
    aimerror=0.000000
    Spread=0.007000

    MaxPenetrations=10
    PenDmgReduction=0.80
    PenDmgReductionByHealth=0
}
