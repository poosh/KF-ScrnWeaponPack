class SVDFireB extends KFMeleeFire;


simulated function bool AllowFire()
{
	if(KFWeapon(Weapon).bIsReloading)
		return false;
	if(KFPawn(Instigator).SecondaryItem!=none)
		return false;
	if(KFPawn(Instigator).bThrowingNade)
		return false;
	if ( KFWeapon(Weapon).bAimingRifle )
		return false;

	return Super.AllowFire();
}


defaultproperties
{
     MeleeDamage=65
     WideDamageMinHitAngle=0
     ProxySize=0.150000
     weaponRange=70
     DamagedelayMin=0.16
     DamagedelayMax=0.16
     hitDamageClass=Class'ScrnWeaponPack.DamTypeSVDm'
     MeleeHitSounds(0)=Sound'KF_AxeSnd.AxeImpactBase.Axe_HitFlesh4'
     HitEffectClass=Class'ScrnWeaponPack.SVDHitEffect'
     bWaitForRelease=True
     FireAnim="MeleeAttack"
     FireRate=1.100000
     BotRefireRate=1.100000
}
