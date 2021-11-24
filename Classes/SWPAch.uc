Class SWPAch extends ScrnAchievements;

#exec OBJ LOAD FILE=ScrnAch_T.utx

var int KillWhoreCounter;

function AchievementEarned(ScrnAchievements A, int Index, bool bFirstTimeEarned)
{
    if ( A.AchDefs[Index].ID == 'KillWhore' )
        KillWhoreCounter++;
}

defaultproperties
{
    ProgressName="ScrN Weapon Achievements"
    DefaultAchGroup="WEAP"

    GroupInfo(1)=(Group="WEAP",Caption="Custom Weapons")

    AchDefs(0)=(id="USSR",DisplayName="Back in the USSR",Description="Survive 10 waves using Soviet/Russian guns only.",Icon=Texture'ScrnAch_T.Achievements.USSR',MaxProgress=10,DataSize=4)
    AchDefs(1)=(id="CZ805M",DisplayName="Commando Medic",Description="Deal 10000 damage and heal 100hp with CZ805M in a single wave (x%c)",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=5,DataSize=3)
    AchDefs(2)=(id="CZ805M_Crazy",DisplayName="When Medic Goes Crazy",Description="Kill 5 zeds with CZ805M without releasing a trigger, when your health is below 25%",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=1,DataSize=1,bForceShow=True)
    AchDefs(3)=(id="CZ805M_Heal",DisplayName="HEAL First, Shoot Later",Description="Make %c healings with empty CZ805M",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=15,DataSize=4)
    AchDefs(4)=(id="CZ805M_Kill",DisplayName="KILL First, Heal... oh sorry, my bad :(",Description="Kill a zed with CZ805M who just killed your teammate",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=1,DataSize=1)
    AchDefs(5)=(id="VSS_FA",DisplayName="Full-Auto Sniper",Description="Score 5 headshots with VSS Vintorez without releasing the trigger (x%c)",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=10,DataSize=6)
    AchDefs(6)=(id="SVD_Husk",DisplayName="Ultimate Russian Sniper",Description="Use SVD to kill 3 Husks or any other big zeds within 5 seconds.",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=15,DataSize=4)
    AchDefs(7)=(id="SVD_ScrakeStun",DisplayName="SVD Stun Control",Description="Get 3 Scrakes stunned at the same time with SVD.",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=1,DataSize=1)
    AchDefs(8)=(id="SVD_ScrakeFast",DisplayName="SVD DoubleClick",Description="Kill a Scrake in 1 second with SVD (x%c)",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=15,DataSize=4)
    AchDefs(9)=(id="Hunting4Kills",DisplayName="Line up and shoot",Description="Kill 4 zeds with a single shot of Hunting rifle (x%c)",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=10,DataSize=4)
    AchDefs(10)=(id="HuntingFP",DisplayName="Hunting Flesh",Description="Kill %c Fleshpounds with Hunting Rifle",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=30,DataSize=5)
    AchDefs(11)=(id="Saiga_9k",DisplayName="SAIGA 9000",Description="Deal 9000 damage with Saiga-12 without reloading",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=1,DataSize=1)
    AchDefs(12)=(id="Saiga_GF",DisplayName="GoreFast = DieEasy",Description="Kill %c Gorefasts with Saiga-12",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=120,DataSize=7)
    AchDefs(13)=(id="SPAS_Auto",DisplayName="Pump Action, AA12 Behavior",Description="Deal 5000 damage with SPAS-12 without releasing the trigger",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=1,DataSize=1)
    AchDefs(14)=(id="SPAS_Finish",DisplayName="SPASing 'em down",Description="Finish off %c crispified or decapitated zeds with SPAS-12",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=120,DataSize=7)
    AchDefs(15)=(id="AK47_74",DisplayName="47 or 74?",Description="Kill 47 zeds with AK47 and 74 zeds with AK74 in a single game.",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=1,DataSize=1)
    AchDefs(16)=(id="AK2012",DisplayName="Modern Classic 2012",Description="Kill 2012 zeds with AK-12",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=2012,DataSize=11)
    AchDefs(17)=(id="AKFan",DisplayName="AK Fanboy(-girl)",Description="Survive and score top kills in 3p+ game by using mostly Kalashnikovs (80%+ kills)",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=1,DataSize=1)
    AchDefs(18)=(id="VAL",DisplayName="Little brother of Vintorez",Description="Score 20 headshots with VAL without reloading.",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=5,DataSize=3)
    AchDefs(19)=(id="VAL_FA",DisplayName="Full-Auto Commando Sniper",Description="Score 5 headshots with VAL without releasing the trigger (x%c)",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=15,DataSize=4)
    AchDefs(20)=(id="HK417",DisplayName="HK417 Last Hope",Description="Kill %c Fleshpounds with HK417",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=7,DataSize=3)
    AchDefs(21)=(id="Protecta_DMG",DisplayName="Protect Your Balls",Description="Use Protecta to deal 10000 damage and stay unhurt for entire wave (x%c)",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=10,DataSize=4)
    AchDefs(22)=(id="Protecta_DECAP",DisplayName="Flaming Sniper",Description="Decapitate %c zeds with Protecta ",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=120,DataSize=7)
    AchDefs(23)=(id="FlarryMen",DisplayName="Flarry Men",Description="Kill the Patriarch with flares only",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=1,DataSize=1)
    AchDefs(24)=(id="HopMines5",DisplayName="Explosive Pentagram",Description="Simultaneously hit a zed with 5 hopmines",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=5,DataSize=3,bForceShow=True)
    AchDefs(25)=(id="HopMines5k",DisplayName="Minefields",Description="At the start of a wave deal 5000 damage with hopmines before anybody shoots anything",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=1,DataSize=1)
    AchDefs(26)=(id="HRL_KillWhore",DisplayName="Spam2Win",Description="Score at least 500 kills with HRL-1 along with 2 KillWhore titles in a single game",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=1,DataSize=1)
    AchDefs(27)=(id="RPG_Kill10",DisplayName="Big Game Hunter",Description="Kill 10 big zeds with RPG7 in a single wave (x%c)",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=7,DataSize=3)
    AchDefs(28)=(id="RPG_Ammo",DisplayName="Rocket Saver",Description="Finish %c waves without running out of RPG7 ammo. 30 RPG kills required.",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=10,DataSize=4)
    AchDefs(29)=(id="RPG_Stalker",DisplayName="Oops, didn't seeya",Description="Kill a Stalker with undetonated RPG7 rocket",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=1,DataSize=1)
    AchDefs(30)=(id="MTS255",DisplayName="Shotgun that SHOOTS ROCKETS!",Description="Kill 255 zeds with MTs-255",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=255,DataSize=8)
    AchDefs(31)=(id="MTS255_FP",DisplayName="A New Toy For a Big Boy",Description="Kill %c Fleshpouds with MTs-255",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=50,DataSize=6)
    AchDefs(32)=(id="MTS255_CR",DisplayName="Taste a rocket, arachnoid baby!",Description="Hit and blow up a Crawler in midair with MTs-255 rocket",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=1,DataSize=1)
    AchDefs(33)=(id="Colt",DisplayName="Elephant Pistol",Description="Kill %c Sirens or Husks with Colt Python",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=60,DataSize=6)
    AchDefs(34)=(id="Colt_SC",DisplayName="Sniper's Assist",Description="Headshot %c stuned Scrakes with Colt Python",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=30,DataSize=5)

    AchDefs(35)=(id="MedicPistol_250",DisplayName="Overcharge",Description="Overcharge teammate's health up to 250hp",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=1,DataSize=1)
    AchDefs(36)=(id="MedicPistol_Crawler",DisplayName="Overkill vol.X: Overheal",Description="Overheal %c crawlers to make them explode",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=15,DataSize=4)
    AchDefs(37)=(id="MedicPistol_Bloat",DisplayName="Overcharged Fat",Description="Overheal Bloat to make him to explode",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=1,DataSize=1)
    AchDefs(38)=(id="TW_HealingSC",DisplayName="Teamwork: Calm Drugs",Description="Use Medic Pistol to prevent Scrake from raging until teammate decapitates him.",Icon=Texture'ScrnAch_T.Teamwork.TW_HealingSC',MaxProgress=15,DataSize=4,Group="TW")
}
