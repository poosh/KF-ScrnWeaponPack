class RPGFire extends KFShotgunFire;

function bool AllowFire()
{
    if( Instigator != none && Instigator.IsHumanControlled() )
    {
        if( !KFWeapon(Weapon).bAimingRifle || KFWeapon(Weapon).bZoomingIn )
        {
            return false;
        }
    }
	return ( Weapon.AmmoAmount(ThisModeNum) >= AmmoPerFire);
}
function ServerPlayFiring()
{
	Super.ServerPlayFiring();
    KFWeapon(Weapon).ZoomOut(false);
}
function PlayFiring()
{
	Super.PlayFiring();
    KFWeapon(Weapon).ZoomOut(false);
}

defaultproperties
{
     CrouchedAccuracyBonus=0.100000
     KickMomentum=(X=-45.000000,Z=25.000000)
     maxVerticalRecoilAngle=1000
     maxHorizontalRecoilAngle=250
     bRandomPitchFireSound=False
     FireSoundRef="ScrnWeaponPack_SND.RPG.Fire"
     StereoFireSoundRef="ScrnWeaponPack_SND.RPG.Fire"
     NoAmmoSoundRef="KF_LAWSnd.LAW_DryFire"
     ProjPerFire=1
     ProjSpawnOffset=(X=50.000000,Z=0.000000)
     bSplashDamage=True
     bRecommendSplashDamage=True
     bWaitForRelease=True
     TransientSoundVolume=1.800000
     FireAnim="FireReload"
     FireForce="redeemer_shoot"
     FireRate=3.250000
     AmmoClass=Class'ScrnWeaponPack.RPGAmmo'
     ShakeRotMag=(X=128.000000,Y=64.000000,Z=16.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=2.500000
     ShakeOffsetMag=(X=-20.000000)
     ShakeOffsetRate=(X=-1000.000000)
     ShakeOffsetTime=2.500000
     ProjectileClass=Class'ScrnWeaponPack.RPGProj'
     BotRefireRate=3.250000
     Spread=0.100000
}
