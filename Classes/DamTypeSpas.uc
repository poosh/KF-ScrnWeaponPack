class DamTypeSpas extends KFProjectileWeaponDamageType
    abstract;

defaultproperties
{
     WeaponClass=Class'ScrnWeaponPack.Spas'
     DeathString="%k killed %o (SPAS-12)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     bRagdollBullet=True
     bBulletHit=True
     FlashFog=(X=600.000000)
     VehicleDamageScaling=0.700000

     KDamageImpulse=10000.000000
     KDeathVel=300.000000
     KDeathUpKick=100.000000

     bIsPowerWeapon=True
}
