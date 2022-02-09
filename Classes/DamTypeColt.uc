class DamTypeColt extends KFProjectileWeaponDamageType
    abstract;

static function AwardKill(KFSteamStatsAndAchievements KFStatsAndAchievements, KFPlayerController Killer, KFMonster Killed )
{
    local SRStatsBase stats;
    
    // do not count kills of decapitated specimens - those are counted in ScoredHeadshot()
    if ( Killed != none && Killed.bDecapitated )
        return;

    stats = SRStatsBase(KFStatsAndAchievements);
    if( stats !=None && stats.Rep!=None )
        stats.Rep.ProgressCustomValue(Class'ScrnPistolKillProgress',1);
}

static function ScoredHeadshot(KFSteamStatsAndAchievements KFStatsAndAchievements, class<KFMonster> MonsterClass, bool bLaserSightedM14EBRKill)
{
    local SRStatsBase stats;
    
    if ( KFStatsAndAchievements != none ) {
        if ( Default.bSniperWeapon )
            KFStatsAndAchievements.AddHeadshotKill(bLaserSightedM14EBRKill);
            
        stats = SRStatsBase(KFStatsAndAchievements);
        if( stats !=None && stats.Rep!=None )
            stats.Rep.ProgressCustomValue(Class'ScrnPistolKillProgress',1);
    }
}

static function AwardDamage(KFSteamStatsAndAchievements KFStatsAndAchievements, int Amount)
{
    local SRStatsBase stats;
    
    stats = SRStatsBase(KFStatsAndAchievements);
    if( stats !=None && stats.Rep!=None )
        stats.Rep.ProgressCustomValue(Class'ScrnPistolDamageProgress',Amount);
}
    
defaultproperties
{
    HeadShotDamageMult=1.15
     bSniperWeapon=True
     WeaponClass=class'Colt'
     DeathString="%k 'colted' %o."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     bRagdollBullet=True
     bBulletHit=True
     FlashFog=(X=600.000000)
     KDamageImpulse=1000.000000
     KDeathVel=500.000000
     KDeathUpKick=150.000000
     VehicleDamageScaling=0.700000
}
