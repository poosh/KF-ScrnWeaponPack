//=============================================================================
// Colt Fire
//=============================================================================
class ColtFire extends ScrnFire;

var float DamMultFP;

function AdjustZedDamage(KFMonster Zed, out float Damage)
{
    // FP must have only 25% damage resistance against AP rounds.
    // However, FP does the AP check via "HeadShotDamageMult >= 1.5", which is not our case.
    // Boost the damage to 150%, so it remains at 75% after halving in the FP code.
    // Adjusted to 160% to make 6 headhots decapitate 6p HoE FP
    if (Zed.IsA('ZombieFleshpound') || Zed.IsA('FemaleFP')) {
        Damage *= DamMultFP;
    }
}


defaultproperties
{
    StereoFireSoundRef="ScrnWeaponPack_SND.Colt.357_fire3_ST"
    FireSoundRef="ScrnWeaponPack_SND.Colt.357_fire3"
    NoAmmoSoundRef="KF_HandcannonSnd.50AE_DryFire"

    PenDmgReduction=0.75
    MaxPenetrations=5
    PenDmgReductionByHealth=1.0  // Zed that survived the shot stops penetrations

    RecoilRate=0.400000 //0.85
    maxVerticalRecoilAngle=3000 //300
    maxHorizontalRecoilAngle=500 //50
    DamageType=class'DamTypeColt'
    DamageMax=350
    DamMultFP=1.6
    Momentum=10000.000000
    bWaitForRelease=True
    bAttachSmokeEmitter=True
    TransientSoundVolume=2.25 // 2.5
    TransientSoundRadius=150 // 400
    FireAnimRate=1.50000 //synced better with fire animation
    TweenTime=0.025000
    FireForce="AssaultRifleFire"
    FireRate=0.900000
    AmmoClass=class'ColtAmmo'
    AmmoPerFire=1
    ShakeRotMag=(X=75.000000,Y=75.000000,Z=400.000000)
    ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=10000.000000)
    ShakeRotTime=3.500000
    ShakeOffsetMag=(X=6.000000,Y=1.000000,Z=8.000000)
    ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
    ShakeOffsetTime=2.500000
    BotRefireRate=0.350000
    FlashEmitterClass=Class'ROEffects.MuzzleFlash1stKar'
    aimerror=30.000000
    Spread=0.015000
    SpreadStyle=SS_Random
    ShellEjectClass=None
}
