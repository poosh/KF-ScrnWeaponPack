class HK417Fire extends KFFire;

var vector ScopedShakeOffsetMag; //Shake offset mag used for 3d scopes
var vector ScopedShakeOffsetRate; //Shake offset rate used for 3d scopes

//adds faked recoil to 3d scope zoom
event ModeDoFire()
{
    if( KFWeapon(Weapon).bAimingRifle )
    {
        if ( KFWeapon(Weapon).KFScopeDetail != KF_TextureScope)
        {
            ShakeOffsetMag=default.ScopedShakeOffsetMag;
            ShakeOffsetRate=default.ScopedShakeOffsetRate;
        }
    }
    else 
    {
        ShakeOffsetMag=default.ShakeOffsetMag;
        ShakeOffsetRate=default.ShakeOffsetRate;
    }
    Super.ModeDoFire();
}

defaultproperties
{
     StereoFireSoundRef="ScrnWeaponPack_SND.HK417AR.HK417_shot"
     FireSoundRef="ScrnWeaponPack_SND.HK417AR.HK417_shot"
     NoAmmoSoundRef="ScrnWeaponPack_SND.HK417AR.HK417_empty"

     FireAimedAnim="Iron_Idle"
     RecoilRate=0.07 // 0.10
     maxVerticalRecoilAngle=500
     maxHorizontalRecoilAngle=250
     ShellEjectClass=Class'ROEffects.KFShellEjectAK'
     ShellEjectBoneName="Shell_eject"
     DamageType=Class'ScrnWeaponPack.DamTypeHK417AR'
     DamageMin=75
     DamageMax=85
     Momentum=20000.000000
     bPawnRapidFireAnim=True
     bWaitForRelease=True
     TransientSoundVolume=1.800000
     FireLoopAnim="Fire"
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.230000
     AmmoClass=Class'ScrnWeaponPack.HK417Ammo'
     AmmoPerFire=1
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=300.000000)
     ShakeRotRate=(X=9500.000000,Y=9500.000000,Z=9500.000000)
     ShakeRotTime=0.650000
     ShakeOffsetMag=(X=3.000000,Y=3.000000,Z=3.000000)
     ScopedShakeOffsetMag=(X=3.000000,Y=0.000000,Z=0.000000) //faked recoil for 3d scope
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ScopedShakeOffsetRate=(X=50.000000,Y=50.000000,Z=50.000000) //faked recoil for 3d scope
     ShakeOffsetTime=1.250000
     BotRefireRate=0.990000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stSTG'
     aimerror=60.000000
     Spread=0.002000
     SpreadStyle=SS_Random
}
