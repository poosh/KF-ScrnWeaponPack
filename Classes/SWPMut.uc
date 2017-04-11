class SWPMut extends Mutator;

function PostBeginPlay()
{
    class'ScrnAchievements'.static.RegisterAchievements(class'SWPAch');
    Level.Game.Spawn(class'SWPAchHandler');
    Destroy();
}

defaultproperties
{
    bAddToServerPackages=True
    GroupName="KF-SWPAch"
    FriendlyName="ScrN Weapon Pack"
    Description="Adds weapon-specific achievements for ScrN Weapon Pack"
}