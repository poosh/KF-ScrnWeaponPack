class RPGProj extends ScrnRocketProjectile;

defaultproperties
{
    Func=class'RPGFunc'
    SmokeTrailClass=Class'ROEffects.PanzerfaustTrail'
    ExplosionClass=class'RpgExplosion'
    TracerClass=class'RPGTracer'
    ShakeRotMag=(X=512.000000,Y=400.000000)
    ShakeRotRate=(X=3000.000000,Y=3000.000000)
    ShakeOffsetMag=(X=20.000000,Y=30.000000,Z=30.000000)
    ArmDistSquared=90000.000000
    StaticMeshRef="ScrnWeaponPack_SM.ScrnRPGProj"

    ExplosionSoundRef="ScrnWeaponPack_SND.RPG.RPGExplode"
    //  AmbientSoundRef="KF_LAWSnd.Rocket_Propel"
    AmbientSoundRef="ScrnWeaponPack_SND.RPG.RPGFly"
    DisintegrateSoundRef="Inf_Weapons.panzerfaust60.faust_explode_distant02"
    SoundVolume=192
    SoundRadius=128.000000

    Speed=3700
    MaxSpeed=3700
    BallisticCoefficient=0.9 //0.3
    bTrueBallistics=true //add ballistic drop
    bInitialAcceleration=true //projectile accelerates after launch
    InitialAccelerationTime=0.5 //0.5 second acceleration
    MinFudgeScale=0.35 //start with reduced velocity
    LifeSpan=10.000000 //10

    ImpactDamage=500
    Damage=1500.000000
    DamageRadius=300.000000
    MomentumTransfer=2000.000000
    MyDamageType=Class'KFMod.DamTypeLAW'

    //adds light to projectile
    LightType=LT_Steady
    LightBrightness=160.0 //128
    LightRadius=8.000000 //4.0
    LightHue=25 //25
    LightSaturation=100
    LightCone=16
    bDynamicLight=True
}
