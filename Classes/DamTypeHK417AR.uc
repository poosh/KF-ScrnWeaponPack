class DamTypeHK417AR extends KFProjectileWeaponDamageType;

// Award also Shiver kills with 2x Stalker progress 
// Count only 1 kill from now on, because new version of Shiver.se calls 
// AwardKill() twice: for the decapitator and for the killer
static function AwardKill(KFSteamStatsAndAchievements KFStatsAndAchievements, KFPlayerController Killer, KFMonster Killed )
{
    if( Killed.IsA('ZombieStalker') || Killed.IsA('ZombieShiver') )
        KFStatsAndAchievements.AddStalkerKill();
} 

static function AwardDamage(KFSteamStatsAndAchievements KFStatsAndAchievements, int Amount)
{
    KFStatsAndAchievements.AddBullpupDamage(Amount);
}

defaultproperties
{
     bSniperWeapon=False
     HeadShotDamageMult=1.3 // 1.1
     WeaponClass=Class'ScrnWeaponPack.HK417AR'
     DeathString="%k killed %o (HK-417)."
     bRagdollBullet=True
     bBulletHit=True
     FlashFog=(X=600.000000)
     KDamageImpulse=4500.000000
     KDeathVel=200.000000
     KDeathUpKick=20.000000
     VehicleDamageScaling=0.800000
}
