class DamTypeMedicPistol extends ScrnDamTypeMedicBase
    abstract;

defaultproperties
{
     HeadShotDamageMult=4.0
     bSniperWeapon=True
     WeaponClass=class'MedicPistol'
     DeathString="%k killed %o (healing darts)."
     FemaleSuicide="%o overdosed healing injections."
     MaleSuicide="%o overdosed healing injections."
     bRagdollBullet=True
     bBulletHit=True
     FlashFog=(X=600.000000)
     KDamageImpulse=750.000000
     KDeathVel=100.000000
     VehicleDamageScaling=0.700000
}
