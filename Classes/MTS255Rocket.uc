class MTS255Rocket extends ScrnRocketProjectile;


defaultproperties
{
    ImpactDamageType=Class'KFMod.DamTypeSPGrenadeImpact'
    ImpactDamage=200

    // DamTypeSPGrenade is used to deal x1.25 damage to FP
    MyDamageType=Class'KFMod.DamTypeSPGrenade'
    Damage=260
    DamageRadius=300
    ArmDistSquared=62500

    Speed=5000
    MaxSpeed=7500

    LightType=LT_Steady
    LightHue=21
    LightSaturation=64
    LightBrightness=128.000000
    LightRadius=4.000000
    LightCone=16
    bDynamicLight=True

    DrawType=DT_StaticMesh
    StaticMeshRef="KF_IJC_Summer_Weps.SPGrenade_proj"
    DrawScale=0.5

    SmokeTrailClass=Class'ReducedGrenadeTrail'
    ExplosionClass=Class'KFMod.SPGrenadeExplosion'
    ExplosionDecal=Class'KFMod.KFScorchMark'
    ExplosionSoundRef="KF_GrenadeSnd.Nade_Explode_1"
    AmbientSoundRef="KF_IJC_HalloweenSnd.KF_FlarePistol_Projectile_Loop"
    DisintegrateSoundRef="Inf_Weapons.faust_explode_distant02"
    ImpactSoundRef="KF_GrenadeSnd.Nade_HitSurf"
}
