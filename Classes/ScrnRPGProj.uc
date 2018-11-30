class ScrnRPGProj extends RPGProj;

defaultproperties
{
     SmokeTrailClass=Class'ROEffects.PanzerfaustTrail'
     ExplosionClass=Class'ScrnWeaponPack.ScrnRPGExplosion'
     TracerClass=Class'ScrnWeaponPack.ScrnRPGTracer'
     StaticMeshRef="ScrnWeaponPack_SM.ScrnRPGProj"
     ExplosionSoundRef="ScrnWeaponPack_SND.RPG.RPGExplode"
     AmbientSoundRef="KF_LAWSnd.Rocket_Propel"
     Damage=1500.000000
     ImpactDamage=400
     DamageRadius=300.000000 //300
     MomentumTransfer=2000.000000

     BallisticCoefficient=0.9 //0.3
	 Speed=3700.000000 //2600
	 MaxSpeed=3700.000000 //3000
     bTrueBallistics=true //add ballistic drop
     bInitialAcceleration=true //projectile accelerates after launch
     InitialAccelerationTime=0.5 //0.5 second acceleration
     MinFudgeScale=0.35 //start with reduced velocity
     LifeSpan=4.000000 //10
     //adds light to projectile
     LightType=LT_Steady
     LightBrightness=160.0 //128
     LightRadius=8.000000 //4.0
     LightHue=25 //25
     LightSaturation=100
     LightCone=16
     bDynamicLight=True
}
