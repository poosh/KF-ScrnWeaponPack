class DamTypeCZ805M extends ScrnDamTypeMedic
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
     HeadShotDamageMult=1.5
     WeaponClass=Class'ScrnWeaponPack.CZ805M'
     DeathString="%k killed %o (CZ 805)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     bRagdollBullet=True
     KDamageImpulse=5500.000000
     KDeathVel=175.000000
     KDeathUpKick=20.000000
}
