class ScrnDamTypeProtectaImpact extends ScrnDamTypeFlareProjectileImpact;

// No XP Bonus to Gunslinger
static function AwardKill(KFSteamStatsAndAchievements KFStatsAndAchievements, KFPlayerController Killer,
        KFMonster Killed )
{
}

static function ScoredHeadshot(KFSteamStatsAndAchievements KFStatsAndAchievements, class<KFMonster> MonsterClass,
        bool bLSM14Kill)
{
}

defaultproperties
{
    WeaponClass=class'Protecta'
    HeadShotDamageMult=2.0
}
