class DamTypeSVDm extends KFWeaponDamageType
	abstract;

defaultproperties
{
     HeadShotDamageMult=1.0
     bIsMeleeDamage=True
     WeaponClass=class'SVD'
     DeathString="%k killed %o (SVD)."
     PawnDamageSounds(0)=Sound'KFPawnDamageSound.MeleeDamageSounds.axehitflesh'
     KDamageImpulse=1500.000000
     KDeathVel=110.000000
     KDeathUpKick=1.000000
     VehicleDamageScaling=0.700000
}
