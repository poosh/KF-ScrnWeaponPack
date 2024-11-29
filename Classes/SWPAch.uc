Class SWPAch extends ScrnAchievements;

#exec OBJ LOAD FILE=ScrnAch_T.utx

var int KillWhoreCounter;

// The engine limits the size of a localized string to 4096.
// That's why we need to do the copy-paste crap below to bypass the limitaion.
var localized string DisplayName0, Description0;
var localized string DisplayName1, Description1;
var localized string DisplayName2, Description2;
var localized string DisplayName3, Description3;
var localized string DisplayName4, Description4;
var localized string DisplayName5, Description5;
var localized string DisplayName6, Description6;
var localized string DisplayName7, Description7;
var localized string DisplayName8, Description8;
var localized string DisplayName9, Description9;
var localized string DisplayName10, Description10;
var localized string DisplayName11, Description11;
var localized string DisplayName12, Description12;
var localized string DisplayName13, Description13;
var localized string DisplayName14, Description14;
var localized string DisplayName15, Description15;
var localized string DisplayName16, Description16;
var localized string DisplayName17, Description17;
var localized string DisplayName18, Description18;
var localized string DisplayName19, Description19;
var localized string DisplayName20, Description20;
var localized string DisplayName21, Description21;
var localized string DisplayName22, Description22;
var localized string DisplayName23, Description23;
var localized string DisplayName24, Description24;
var localized string DisplayName25, Description25;
var localized string DisplayName26, Description26;
var localized string DisplayName27, Description27;
var localized string DisplayName28, Description28;
var localized string DisplayName29, Description29;
var localized string DisplayName30, Description30;
var localized string DisplayName31, Description31;
var localized string DisplayName32, Description32;
var localized string DisplayName33, Description33;
var localized string DisplayName34, Description34;
var localized string DisplayName35, Description35;
var localized string DisplayName36, Description36;
var localized string DisplayName37, Description37;
var localized string DisplayName38, Description38;


function AchievementEarned(ScrnAchievements A, int Index, bool bFirstTimeEarned)
{
    if ( A.AchDefs[Index].ID == 'KillWhore' )
        KillWhoreCounter++;
}

simulated function SetDefaultAchievementData()
{
    AchDefs[0].DisplayName = DisplayName0;
    AchDefs[1].DisplayName = DisplayName1;
    AchDefs[2].DisplayName = DisplayName2;
    AchDefs[3].DisplayName = DisplayName3;
    AchDefs[4].DisplayName = DisplayName4;
    AchDefs[5].DisplayName = DisplayName5;
    AchDefs[6].DisplayName = DisplayName6;
    AchDefs[7].DisplayName = DisplayName7;
    AchDefs[8].DisplayName = DisplayName8;
    AchDefs[9].DisplayName = DisplayName9;
    AchDefs[10].DisplayName = DisplayName10;
    AchDefs[11].DisplayName = DisplayName11;
    AchDefs[12].DisplayName = DisplayName12;
    AchDefs[13].DisplayName = DisplayName13;
    AchDefs[14].DisplayName = DisplayName14;
    AchDefs[15].DisplayName = DisplayName15;
    AchDefs[16].DisplayName = DisplayName16;
    AchDefs[17].DisplayName = DisplayName17;
    AchDefs[18].DisplayName = DisplayName18;
    AchDefs[19].DisplayName = DisplayName19;
    AchDefs[20].DisplayName = DisplayName20;
    AchDefs[21].DisplayName = DisplayName21;
    AchDefs[22].DisplayName = DisplayName22;
    AchDefs[23].DisplayName = DisplayName23;
    AchDefs[24].DisplayName = DisplayName24;
    AchDefs[25].DisplayName = DisplayName25;
    AchDefs[26].DisplayName = DisplayName26;
    AchDefs[27].DisplayName = DisplayName27;
    AchDefs[28].DisplayName = DisplayName28;
    AchDefs[29].DisplayName = DisplayName29;
    AchDefs[30].DisplayName = DisplayName30;
    AchDefs[31].DisplayName = DisplayName31;
    AchDefs[32].DisplayName = DisplayName32;
    AchDefs[33].DisplayName = DisplayName33;
    AchDefs[34].DisplayName = DisplayName34;
    AchDefs[35].DisplayName = DisplayName35;
    AchDefs[36].DisplayName = DisplayName36;
    AchDefs[37].DisplayName = DisplayName37;
    AchDefs[38].DisplayName = DisplayName38;

    AchDefs[0].Description = Description0;
    AchDefs[1].Description = Description1;
    AchDefs[2].Description = Description2;
    AchDefs[3].Description = Description3;
    AchDefs[4].Description = Description4;
    AchDefs[5].Description = Description5;
    AchDefs[6].Description = Description6;
    AchDefs[7].Description = Description7;
    AchDefs[8].Description = Description8;
    AchDefs[9].Description = Description9;
    AchDefs[10].Description = Description10;
    AchDefs[11].Description = Description11;
    AchDefs[12].Description = Description12;
    AchDefs[13].Description = Description13;
    AchDefs[14].Description = Description14;
    AchDefs[15].Description = Description15;
    AchDefs[16].Description = Description16;
    AchDefs[17].Description = Description17;
    AchDefs[18].Description = Description18;
    AchDefs[19].Description = Description19;
    AchDefs[20].Description = Description20;
    AchDefs[21].Description = Description21;
    AchDefs[22].Description = Description22;
    AchDefs[23].Description = Description23;
    AchDefs[24].Description = Description24;
    AchDefs[25].Description = Description25;
    AchDefs[26].Description = Description26;
    AchDefs[27].Description = Description27;
    AchDefs[28].Description = Description28;
    AchDefs[29].Description = Description29;
    AchDefs[30].Description = Description30;
    AchDefs[31].Description = Description31;
    AchDefs[32].Description = Description32;
    AchDefs[33].Description = Description33;
    AchDefs[34].Description = Description34;
    AchDefs[35].Description = Description35;
    AchDefs[36].Description = Description36;
    AchDefs[37].Description = Description37;
    AchDefs[38].Description = Description38;

    super.SetDefaultAchievementData();
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
    AchDefs(33)=(id="Colt",DisplayName="Elephant Pistol",Description="Kill %c Sirens or Husks with Colt .50 xAE",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=60,DataSize=6)
    AchDefs(34)=(id="Colt_SC",DisplayName="Sniper's Assist",Description="Headshot %c stuned Scrakes with Colt .50 xAE",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=30,DataSize=5)
    AchDefs(35)=(id="MedicPistol_250",DisplayName="Overcharge",Description="Overcharge teammate's health up to 250hp",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=1,DataSize=1)
    AchDefs(36)=(id="MedicPistol_Crawler",DisplayName="Overkill vol.X: Overheal",Description="Overheal %c crawlers to make them explode",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=15,DataSize=4)
    AchDefs(37)=(id="MedicPistol_Bloat",DisplayName="Overcharged Fat",Description="Overheal Bloat to make him to explode",Icon=Texture'ScrnAch_T.Achievements.Checked',MaxProgress=1,DataSize=1)
    AchDefs(38)=(id="TW_HealingSC",DisplayName="Teamwork: Calm Drugs",Description="Use Medic Pistol to prevent Scrake from raging until teammate decapitates him.",Icon=Texture'ScrnAch_T.Teamwork.TW_HealingSC',MaxProgress=15,DataSize=4,Group="TW")

    DisplayName1="Commando Medic"
    DisplayName0="Back in the USSR"
    DisplayName2="When Medic Goes Crazy"
    DisplayName3="HEAL First, Shoot Later"
    DisplayName4="KILL First, Heal... oh sorry, my bad :("
    DisplayName5="Full-Auto Sniper"
    DisplayName6="Ultimate Russian Sniper"
    DisplayName7="SVD Stun Control"
    DisplayName8="SVD DoubleClick"
    DisplayName9="Line up and shoot"
    DisplayName10="Hunting Flesh"
    DisplayName11="SAIGA 9000"
    DisplayName12="GoreFast = DieEasy"
    DisplayName13="Pump Action, AA12 Behavior"
    DisplayName14="SPASing 'em down"
    DisplayName15="47 or 74?"
    DisplayName16="Modern Classic 2012"
    DisplayName17="AK Fanboy(-girl)"
    DisplayName18="Little brother of Vintorez"
    DisplayName19="Full-Auto Commando Sniper"
    DisplayName20="HK417 Last Hope"
    DisplayName21="Protect Your Balls"
    DisplayName22="Flaming Sniper"
    DisplayName23="Flarry Men"
    DisplayName24="Explosive Pentagram"
    DisplayName25="Minefields"
    DisplayName26="Spam2Win"
    DisplayName27="Big Game Hunter"
    DisplayName28="Rocket Saver"
    DisplayName29="Oops, didn't seeya"
    DisplayName30="Shotgun that SHOOTS ROCKETS!"
    DisplayName31="A New Toy For a Big Boy"
    DisplayName32="Taste a rocket, arachnoid baby!"
    DisplayName33="Elephant Pistol"
    DisplayName34="Sniper's Assist"
    DisplayName35="Overcharge"
    DisplayName36="Overkill vol.X: Overheal"
    DisplayName37="Overcharged Fat"
    DisplayName38="Teamwork: Calm Drugs"

    Description0="Survive 10 waves using Soviet/Russian guns only."
    Description1="Deal 10000 damage and heal 100hp with CZ805M in a single wave (x%c)"
    Description2="Kill 5 zeds with CZ805M without releasing a trigger, when your health is below 25%"
    Description3="Make %c healings with empty CZ805M"
    Description4="Kill a zed with CZ805M who just killed your teammate"
    Description5="Score 5 headshots with VSS Vintorez without releasing the trigger (x%c)"
    Description6="Use SVD to kill 3 Husks or any other big zeds within 5 seconds."
    Description7="Get 3 Scrakes stunned at the same time with SVD."
    Description8="Kill a Scrake in 1 second with SVD (x%c)"
    Description9="Kill 4 zeds with a single shot of Hunting rifle (x%c)"
    Description10="Kill %c Fleshpounds with Hunting Rifle"
    Description11="Deal 9000 damage with Saiga-12 without reloading"
    Description12="Kill %c Gorefasts with Saiga-12"
    Description13="Deal 5000 damage with SPAS-12 without releasing the trigger"
    Description14="Finish off %c crispified or decapitated zeds with SPAS-12"
    Description15="Kill 47 zeds with AK47 and 74 zeds with AK74 in a single game."
    Description16="Kill 2012 zeds with AK-12"
    Description17="Survive and score top kills in 3p+ game by using mostly Kalashnikovs (80%+ kills)"
    Description18="Score 20 headshots with VAL without reloading."
    Description19="Score 5 headshots with VAL without releasing the trigger (x%c)"
    Description20="Kill %c Fleshpounds with HK417"
    Description21="Use Protecta to deal 10000 damage and stay unhurt for entire wave (x%c)"
    Description22="Decapitate %c zeds with Protecta "
    Description23="Kill the Patriarch with flares only"
    Description24="Simultaneously hit a zed with 5 hopmines"
    Description25="At the start of a wave deal 5000 damage with hopmines before anybody shoots anything"
    Description26="Score at least 500 kills with HRL-1 along with 2 KillWhore titles in a single game"
    Description27="Kill 10 big zeds with RPG7 in a single wave (x%c)"
    Description28="Finish %c waves without running out of RPG7 ammo. 30 RPG kills required."
    Description29="Kill a Stalker with undetonated RPG7 rocket"
    Description30="Kill 255 zeds with MTs-255"
    Description31="Kill %c Fleshpouds with MTs-255"
    Description32="Hit and blow up a Crawler in midair with MTs-255 rocket"
    Description33="Kill %c Sirens or Husks with Colt .50 xAE"
    Description34="Headshot %c stuned Scrakes with Colt .50 xAE"
    Description35="Overcharge teammate's health up to 250hp"
    Description36="Overheal %c crawlers to make them explode"
    Description37="Overheal Bloat to make him to explode"
    Description38="Use Medic Pistol to prevent Scrake from raging until teammate decapitates him."
}
