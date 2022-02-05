class HRLFire extends LAWFire;

function bool AllowFire()
{
    //  allow fire without zooming
    return ( Weapon.AmmoAmount(ThisModeNum) >= AmmoPerFire);
}


defaultproperties
{
     FireAnimRate=1.600000
     FireRate=2.031250
     AmmoClass=class'HRLAmmo'
     ProjectileClass=class'HRLProj'
}
