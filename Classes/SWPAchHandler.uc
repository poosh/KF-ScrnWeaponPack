class SWPAchHandler extends ScrnAchHandlerBase;

var transient bool       bAnyDamageThisWave;
var transient float      LastHopMineHitTime;
var transient bool       bBossFlareOnly;

struct SHitInfo {
    var KFMonster Victim;
    var int Hits, Damage;
};
var array<SHitInfo> HopMineTargets;

struct SDamageInstigators {
    var KFMonster Victim;
    var array<ScrnPlayerInfo> Instigators;
};
var array<SDamageInstigators> ScrakeHealers;


function ApplyGameRules()
{
    local int i;

    super.ApplyGameRules();

    i = GameRules.SovietDamageTypes.length;
    GameRules.SovietDamageTypes[i++] = class'ScrnWeaponPack.DamTypeAK12AssaultRifle';
    GameRules.SovietDamageTypes[i++] = class'ScrnWeaponPack.DamTypeAK74AssaultRifle';
    GameRules.SovietDamageTypes[i++] = class'ScrnWeaponPack.DamTypeSaiga12c';
    GameRules.SovietDamageTypes[i++] = class'ScrnWeaponPack.DamTypeSVD';
    GameRules.SovietDamageTypes[i++] = class'ScrnWeaponPack.DamTypeSVDm';
    GameRules.SovietDamageTypes[i++] = class'ScrnWeaponPack.DamTypeVALDT';
    GameRules.SovietDamageTypes[i++] = class'ScrnWeaponPack.DamTypeVSSDT';
}

function WaveStarted(byte WaveNum)
{
    bAnyDamageThisWave = false;
}

function WaveEnded(byte WaveNum)
{
    local ScrnPlayerInfo SPI;
    local class<KFWeaponDamageType> DamType;
    local int i, j;
    local int AK47Kills, AK74Kills, CZ805M_Damage, ProtectaDamage;
    local bool bSovietOnly;

    for ( SPI=GameRules.PlayerInfo; SPI!=none; SPI=SPI.NextPlayerInfo ) {
        if ( SPI.bDied )
            continue;

        bSovietOnly = true;
        AK47Kills = 0;
        AK74Kills = 0;
        CZ805M_Damage = 0;
        ProtectaDamage = 0;

        if ( SPI.GetCustomValue(self, 'HRL_Kills') >= 500
                && SWPAch(SPI.GetAchievementsByClass(class'SWPAch')).KillWhoreCounter >= 2 )
        {
            SPI.ProgressAchievement('HRL_KillWhore', 1);
            SPI.SetCustomValue(self, 'HRL_Kills', 0, false);
        }

        for ( i=0; i<SPI.WeapInfos.length; ++i ) {
            DamType = SPI.WeapInfos[i].DamType;
            if ( ClassIsChildOf(DamType, Class'DamTypeAK47AssaultRifle') )
                AK47Kills += SPI.WeapInfos[i].TotalKills;
            else if ( ClassIsChildOf(DamType, Class'DamTypeAK74AssaultRifle') )
                AK74Kills += SPI.WeapInfos[i].TotalKills;
            else if ( ClassIsChildOf(DamType, Class'DamTypeCZ805M') )
                CZ805M_Damage += SPI.WeapInfos[i].DamagePerWave;
            else if ( ClassIsChildOf(SPI.WeapInfos[i].WeaponClass, Class'Protecta') )
                ProtectaDamage += SPI.WeapInfos[i].DamagePerWave;
            else if ( SPI.WeapInfos[i].KillsPerWave >= 30 && RPG(SPI.WeapInfos[i].Weapon) != none
                    && SPI.WeapInfos[i].Weapon.AmmoAmount(0) > 0 )
                SPI.ProgressAchievement('RPG_Ammo', 1);

            if ( SPI.WeapInfos[i].DamagePerWave > 0 ) {
                // RPG and MTS use KFMod. damage types to keep damage bonus on FP
                if ( bSovietOnly && RPG(SPI.WeapInfos[i].Weapon) == none && MTS255Shotgun(SPI.WeapInfos[i].Weapon) == none ) {
                    for ( j=0; j<GameRules.SovietDamageTypes.Length; ++j )
                        if ( GameRules.SovietDamageTypes[j] == DamType )
                            break;
                    if ( j == GameRules.SovietDamageTypes.Length )
                        bSovietOnly = false;
                }
            }
        }

        if ( AK47Kills >= 47 && AK74Kills >= 74 )
            SPI.ProgressAchievement('AK47_74', 1);
        if ( CZ805M_Damage >= 10000 && SPI.GetCustomValue(self, 'CZ805M_HP') >= 100 )
            SPI.ProgressAchievement('CZ805M', 1);
        if ( ProtectaDamage >= 10000 && SPI.DamageReceivedPerWave == 0 )
            SPI.ProgressAchievement('Protecta_DMG', 1);
        if ( SPI.KillsPerWave > 0 && bSovietOnly )
            SPI.ProgressAchievement('USSR', 1);
    }
}


function GameWon(string MapName)
{
    local ScrnPlayerInfo SPI;
    local ScrnPlayerInfo TopKillsSPI;
    local class<KFWeaponDamageType> DamType;
    local bool bAKOnly;
    local int i, PlayerCount;

    if (bBossFlareOnly)
        Ach2All('FlarryMen', 1);

    for ( SPI=GameRules.PlayerInfo; SPI!=none; SPI=SPI.NextPlayerInfo ) {
        if ( SPI.PlayerOwner != none && SPI.PlayerOwner.PlayerReplicationInfo != none ) {
            PlayerCount++;
            if ( TopKillsSPI == none || SPI.PlayerOwner.PlayerReplicationInfo.Kills > TopKillsSPI.PlayerOwner.PlayerReplicationInfo.Kills )
                TopKillsSPI = SPI;
        }
    }

    bAKOnly = true;
    for ( i=0; i<TopKillsSPI.WeapInfos.length; ++i ) {
        DamType = TopKillsSPI.WeapInfos[i].DamType;
        if ( TopKillsSPI.WeapInfos[i].TotalKills > 0
                && !ClassIsChildOf(DamType, Class'DamTypeAK47AssaultRifle')
                && !ClassIsChildOf(DamType, Class'DamTypeAK74AssaultRifle')
                && !ClassIsChildOf(DamType, Class'DamTypeAK12AssaultRifle') )
        {
            bAKOnly = false;
            break;
        }
    }
    if ( bAKOnly && PlayerCount >= 3 )
        TopKillsSPI.ProgressAchievement('AKFan', 1);
}

function BossSpawned(KFMonster EndGameBoss)
{
    bBossFlareOnly = true; // avaliable for other bosses as well, e.g. Doom3 bosses
}

function int WInstantHeadhots(ScrnPlayerInfo SPI, KFWeapon Weapon, class<KFWeaponDamageType> DamType, int Count)
{
    if ( ClassIsChildOf(DamType, class'DamTypeVSSDT') ) {
        if ( Count == 5 )
            SPI.ProgressAchievement('VSS_FA', 1);
        return 5;
    }
    else if ( ClassIsChildOf(DamType, class'DamTypeVALDT') ) {
        if ( Count >= 5 )
            SPI.ProgressAchievement('VAL_FA', 1);
        return 5;
    }
    return IGNORE_STAT;
}


function int WKillsPerShot(ScrnPlayerInfo SPI, KFWeapon Weapon, class<KFWeaponDamageType> DamType, int Count, float DeltaTime)
{
    if ( ClassIsChildOf(DamType, class'DamTypeHuntingRifle') ) {
        if ( Count == 4 && !SPI.ProgressAchievement('Hunting4Kills', 1) )
            return IGNORE_STAT; // if achievement already earned, then ProgressAchievement() returns false, meaning no need to track it anymore
        return 4;
    }
    else if ( ClassIsChildOf(DamType, class'DamTypeCZ805M') ) {
        if ( Count == 5 && SPI.PlayerOwner.Pawn.Health < 25 ) {
            SPI.ProgressAchievement('CZ805M_Crazy', 1);
            return IGNORE_STAT; // once achieved, no need to track it anymore
        }
        return 5;
    }
    return IGNORE_STAT;
}

function int WHeadshotsPerMagazine(ScrnPlayerInfo SPI, KFWeapon Weapon, class<KFWeaponDamageType> DamType, int Count)
{
    if ( ClassIsChildOf(DamType, class'DamTypeVALDT') ) {
        if ( Count == 20 && !SPI.ProgressAchievement('VAL', 1) )
            return IGNORE_STAT; // if achievement already earned, then ProgressAchievement() returns false, meaning no need to track it anymore
        return 20;
    }
    return IGNORE_STAT;
}


function int WKillsPerMagazine(ScrnPlayerInfo SPI, KFWeapon Weapon, class<KFWeaponDamageType> DamType, int Count)
{
    if ( ClassIsChildOf(DamType, class'DamTypeHK417AR') ) {
        if ( Count == 17 && !SPI.ProgressAchievement('HK417', 1) )
            return IGNORE_STAT; // if achievement already earned, then ProgressAchievement() returns false, meaning no need to track it anymore
        return 17;
    }
    return IGNORE_STAT;
}


function int WDamagePerShot(ScrnPlayerInfo SPI, KFWeapon Weapon, class<KFWeaponDamageType> DamType, int Damage, float DeltaTime)
{
    if ( HopMineLchr(Weapon) != none ) {
        if ( !bAnyDamageThisWave && Damage >= 5000 ) {
            SPI.ProgressAchievement('HopMines5k', 1);
            return IGNORE_STAT; // once achieved, no need to track it anymore
        }
        return 5000;
    }
    else if ( Spas(Weapon) != none ) {
        if ( Damage >= 5000 ) {
            SPI.ProgressAchievement('SPAS_Auto', 1);
            return IGNORE_STAT; // once achieved, no need to track it anymore
        }
        return 5000;
    }
    return IGNORE_STAT;
}

function int WDamagePerMagazine(ScrnPlayerInfo SPI, KFWeapon Weapon, class<KFWeaponDamageType> DamType, int Damage)
{
    if ( Saiga12c(Weapon) != none ) {
        if ( Damage >= 9000 ) {
            SPI.ProgressAchievement('Saiga_9k', 1);
            return IGNORE_STAT; // once achieved, no need to track it anymore
        }
        return 9000;
    }
    return IGNORE_STAT;
}

function WeaponReloaded(ScrnPlayerInfo SPI, KFWeapon W)
{
    SPI.SetCustomValue(self, 'SVD_HuskKills', 0, true);
    SPI.SetCustomValue(self, 'SVD_SCKills', 0, true);
}

function MonsterDamaged(int Damage, KFMonster Victim, ScrnPlayerInfo SPI,
    class<KFWeaponDamageType> DamType, bool bIsHeadshot, bool bWasDecapitated)
{
    local int index, WeapIdx;
    local int i, count;
    local KFPlayerReplicationInfo KFPRI;
    local class<KFVeterancyTypes> Perk;

    if ( GameRules.BossClass == Victim.class ) {
        bBossFlareOnly = bBossFlareOnly && ( ClassIsChildOf(DamType, class'DamTypeFlareRevolver')
            || ClassIsChildOf(DamType, class'DamTypeFlareProjectileImpact') );
    }

    index = GameRules.GetMonsterIndex(Victim);
    WeapIdx = SPI.FindWeaponInfoByDamType(DamType);
    if ( index == -1 || WeapIdx == -1 )
        return; // wtf?

    KFPRI = KFPlayerReplicationInfo(SPI.PlayerOwner.PlayerReplicationInfo);
    if ( KFPRI != none )
        Perk = KFPRI.ClientVeteranSkill;

    if ( HopMineLchr(SPI.WeapInfos[WeapIdx].Weapon) != none ) {
        if ( Level.TimeSeconds - LastHopMineHitTime < 2 ) {
            for ( i=0; i<HopMineTargets.length; ++i ) {
                if ( HopMineTargets[i].Victim == Victim && ++HopMineTargets[i].Hits == 5) {
                    SPI.ProgressAchievement('HopMines5', 1);
                    HopMineTargets[i].Hits = 0;
                    break;
                }
            }
            if ( i == HopMineTargets.length ) {
                HopMineTargets.insert(i, 1);
                HopMineTargets[i].Victim = Victim;
                HopMineTargets[i].Hits = 1;
            }
        }
        else {
            LastHopMineHitTime = Level.TimeSeconds;
            HopMineTargets.length = 1;
                HopMineTargets[0].Victim = Victim;
                HopMineTargets[0].Hits = 1;
        }
    }
    else {
        bAnyDamageThisWave = true;

        if ( Protecta(SPI.WeapInfos[WeapIdx].Weapon) != none && Victim.bDecapitated && !bWasDecapitated )
            SPI.ProgressAchievement('Protecta_DECAP', 1);
    }


    if ( ZombieCrawler(Victim) != none ) {
        if ( Victim.Physics == PHYS_Falling && MTS255Shotgun(SPI.WeapInfos[WeapIdx].Weapon) != none ) {
            count = class'MTS255Rocket'.default.Damage;
            if ( Perk != none )
                count = Perk.Static.AddDamage(KFPRI, Victim, KFPawn(SPI.PlayerOwner.Pawn), count, DamType);
            if ( Damage > count*0.93 )
                SPI.ProgressAchievement('MTS255_CR', 1);
        }
    }
    else if ( ZombieScrake(Victim) != none ) {
        if ( bIsHeadshot && ClassIsChildOf(DamType, class'DamTypeSVD') && Damage >= Victim.default.Health/1.5 ) {
            count = 1;
            for ( i=0; i<GameRules.MonsterInfos.Length; ++i ) {
                if ( ZombieScrake(GameRules.MonsterInfos[i].Monster) != none
                        && GameRules.MonsterInfos[i].Monster != Victim
                        && GameRules.MonsterInfos[i].Monster.Health > 0
                        && KFMonsterController(GameRules.MonsterInfos[i].Monster.Controller).bUseFreezeHack
                        && ((GameRules.MonsterInfos[i].DamType1 == DamType && GameRules.MonsterInfos[i].KillAss1 == SPI)
                            || GameRules.MonsterInfos[i].DamType2 == DamType && GameRules.MonsterInfos[i].KillAss2 == SPI) )
                {
                    if ( ++count == 3 ) {
                        SPI.ProgressAchievement('SVD_ScrakeStun', 1);
                        break;
                    }
                }
            }
            if ( GameRules.MonsterInfos[index].KillAss1 == SPI
                    && GameRules.MonsterInfos[index].DamType1 == DamType
                    && Level.TimeSeconds - GameRules.MonsterInfos[index].DamTime1 < 1.0 )
            {
                if ( Victim.bDecapitated )
                    SPI.ProgressAchievement('SVD_ScrakeFast', 1);
                else
                    GameRules.MonsterInfos[index].DamTime1 = Level.TimeSeconds; // 2 clicks not enough - wait for 3rd one
            }
          }
        else if ( bIsHeadshot && Colt(SPI.WeapInfos[WeapIdx].Weapon) != none ) {
            if ( KFMonsterController(Victim.Controller).bUseFreezeHack )
                SPI.ProgressAchievement('Colt_SC', 1);
        }
        else if ( bIsHeadshot && Victim.bDecapitated && !bWasDecapitated && Victim.Health >= 0.75 * Victim.HealthMax
                    /*&& !Victim.IsInState('RunningState') */ )
            TW_ScrakeHealers(Victim, SPI);
        else if ( !Victim.bDecapitated && !bIsHeadshot && ClassIsChildOf(DamType, class'DamTypeMedicPistol') )
            AddDamageInstigator(ScrakeHealers, Victim, SPI);
    }
}

function AddDamageInstigator(out array<SDamageInstigators> Table, KFMonster Victim, ScrnPlayerInfo InstigatorSPI)
{
    local int i, j;

    for ( i=0; i< Table.length; ++i )
        if ( Table[i].Victim == Victim )
            break;
    // Victim not found, let's find first empty record
    if ( i == Table.length ) {
        for ( i=0; i< Table.length; ++i ) {
            if ( Table[i].Victim == none ) {
                Table[i].Instigators.length = 0;
                break;
            }
        }
    }
    // if no empty records found - make a new entry
    if ( i == Table.length )
        Table.insert(i, 1);

    Table[i].Victim = Victim;
    // search if already added
    for ( j=0; j < Table[i].Instigators.length; ++j )
        if ( Table[i].Instigators[j] == InstigatorSPI )
            return;
    // if reached here - InstigatorSPI is not found in table
    Table[i].Instigators[j] = InstigatorSPI;
}

// Scrake was decapitated without raging thanks to healing from Medic Pistol.
// Reward decapitator and all healers
function TW_ScrakeHealers(KFMonster Victim, ScrnPlayerInfo DecapitatorSPI)
{
    local int i, j;
    local ScrnPlayerInfo SPI;

    for ( i=0; i< ScrakeHealers.length; ++i )
        if ( ScrakeHealers[i].Victim == Victim )
            break;
    if ( i == ScrakeHealers.length )
        return; // nobody healed our victim. Maybe it got health for differenc source (custom map, mutator etc.)

    for ( j=0; j < ScrakeHealers[i].Instigators.length; ++j ) {
        SPI = ScrakeHealers[i].Instigators[j];
        if ( SPI != none && SPI != DecapitatorSPI )
            SPI.ProgressAchievement('TW_HealingSC', 1);
    }
    DecapitatorSPI.ProgressAchievement('TW_HealingSC', 1);
}

function MonsterKilled(KFMonster Victim, ScrnPlayerInfo KillerInfo, class<KFWeaponDamageType> DamType)
{
    local int index, WeapIdx;

    // FindWeaponInfoByDamType() won't find DamTypeMedicOvercharge, because it isn't a primiry weapon damage (DamTypeMedicPistol)
    if ( ClassIsChildOf(DamType, class'DamTypeMedicOvercharge') ) {
        if ( Victim.IsA('ZombieCrawler') )
            KillerInfo.ProgressAchievement('MedicPistol_Crawler', 1);
        else if ( Victim.IsA('ZombieBloat') )
            KillerInfo.ProgressAchievement('MedicPistol_Bloat', 1);
    }

    index = GameRules.GetMonsterIndex(Victim);
    WeapIdx = KillerInfo.FindWeaponInfoByDamType(DamType);
    if ( index == -1 || WeapIdx == -1 )
        return; // wtf?

    if ( DamType.default.bSniperWeapon ) {
        if ( ClassIsChildOf(DamType, class'DamTypeSVD')
                && (Victim.default.Health >= 1000 || Victim.IsA('ZombieHusk')) )
        {
            if ( Level.TimeSeconds - KillerInfo.GetCustomFloat(self, 'SVD_LastKill') < 5.0 ) {
                if ( KillerInfo.IncCustomValue(self, 'SVD_HuskKills', 1, true) >= 3 )
                    KillerInfo.ProgressAchievement('SVD_Husk', 1);
            }
            else
                KillerInfo.SetCustomValue(self, 'SVD_HuskKills', 1, true);
            KillerInfo.SetCustomFloat(self, 'SVD_LastKill', Level.TimeSeconds);
        }
        else if ( ClassIsChildOf(DamType, class'DamTypeHuntingRifle') ) {
            if ( Victim.IsA('ZombieFleshpound') || Victim.IsA('FemaleFP') )
                KillerInfo.ProgressAchievement('HuntingFP', 1);
        }
        else if ( ClassIsChildOf(DamType, class'DamTypeRocketImpact') ) {
            if ( RPG(KillerInfo.WeapInfos[WeapIdx].Weapon) != none && Victim.IsA('ZombieStalker') )
                KillerInfo.ProgressAchievement('RPG_Stalker', 1);
        }
        else if ( ClassIsChildOf(DamType, class'DamTypeColt') ) {
            if ( Victim.IsA('ZombieHusk') || Victim.IsA('ZombieSiren') )
                KillerInfo.ProgressAchievement('Colt', 1);
        }
    }
    else if ( DamType.default.bIsExplosive ) {
        if ( HRL(KillerInfo.WeapInfos[WeapIdx].Weapon) != none ) {
            if ( KillerInfo.IncCustomValue(self, 'HRL_Kills', 1, false) >= 500
                    && SWPAch(KillerInfo.GetAchievementsByClass(class'SWPAch')).KillWhoreCounter >= 2 )
            {
                KillerInfo.ProgressAchievement('HRL_KillWhore', 1);
                KillerInfo.SetCustomValue(self, 'HRL_Kills', 0, false);
            }
        }
        else if ( RPG(KillerInfo.WeapInfos[WeapIdx].Weapon) != none ) {
            if ( Victim.default.Health >= 1000 && KillerInfo.IncCustomValue(self, 'RPG_BigKills', 1, true) >= 10 )
            {
                KillerInfo.ProgressAchievement('RPG_Kill10', 1);
                KillerInfo.SetCustomValue(self, 'RPG_BigKills', 0);
            }
        }
        else if ( MTS255Shotgun(KillerInfo.WeapInfos[WeapIdx].Weapon) != none ) {
            KillerInfo.ProgressAchievement('MTS255', 1);
            if ( Victim.IsA('ZombieFleshpound') || Victim.IsA('FemaleFP') )
                KillerInfo.ProgressAchievement('MTS255_FP', 1);
            else if ( Victim.IsA('ZombieCrawler') && Victim.Physics == PHYS_Falling )
        }
    }
    else if ( DamType.default.bIsPowerWeapon ) {
        if ( ClassIsChildOf(DamType, class'DamTypeSaiga12c') ) {
            if ( Victim.IsA('ZombieGorefast') )
                KillerInfo.ProgressAchievement('Saiga_GF', 1);
        }
        else if ( ClassIsChildOf(DamType, class'DamTypeSpas') ) {
            if ( Victim.bDecapitated || Victim.bCrispified )
                KillerInfo.ProgressAchievement('SPAS_Finish', 1);
        }
    }
    else {
        if ( ClassIsChildOf(DamType, class'DamTypeAK12AssaultRifle') ) {
            if ( !Victim.bDamagedAPlayer && Victim.IsA('Brute') )
                KillerInfo.ProgressAchievement('BruteSCAR', 1);
            KillerInfo.ProgressAchievement('AK2012', 1);
        }
        else if ( ClassIsChildOf(DamType, class'DamTypeCZ805M') ) {
            if ( Level.TimeSeconds - GameRules.MonsterInfos[index].PlayerKillTime < 15 )
                KillerInfo.ProgressAchievement('CZ805M_Kill', 1);
        }
    }
}

function HealingMade(int HealAmount, ScrnHumanPawn Patient, ScrnPlayerInfo InstigatorSPI, KFWeapon MedicGun)
{
    if ( CZ805M(MedicGun) != none ) {
        InstigatorSPI.IncCustomValue(self, 'CZ805M_HP', HealAmount, true);
        if ( MedicGun.MagAmmoRemaining <= 0 )
            InstigatorSPI.ProgressAchievement('CZ805M_Heal', 1);
    }
}


defaultproperties
{
}
