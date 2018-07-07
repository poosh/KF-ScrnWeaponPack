class ProtectaFlare extends ScrnFlareProjectile;

defaultproperties
{
    Speed=4500
    MaxSpeed=5000
    HeadShotDamageMult=3.0  // applied only on burn damage. Impact's headshot mult. is set in damage type
    ImpactDamage=115
    bTrueBallistics=false
    bInitialAcceleration=false
    ImpactDamageType=Class'ScrnWeaponPack.ScrnDamTypeProtectaImpact'
    MyDamageType=Class'ScrnWeaponPack.ScrnDamTypeProtectaFlare'
}
