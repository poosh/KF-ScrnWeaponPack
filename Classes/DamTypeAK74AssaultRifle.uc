class DamTypeAK74AssaultRifle extends KFProjectileWeaponDamageType
    abstract;


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
     WeaponClass=Class'ScrnWeaponPack.AKC74AssaultRifle'
     DeathString="%k killed %o (AK-74)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     bRagdollBullet=True
     KDamageImpulse=6500.000000
     KDeathVel=250.000000
     KDeathUpKick=80.000000
}
