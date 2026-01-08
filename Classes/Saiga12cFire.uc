//=============================================================================
// Shotgun Fire
//=============================================================================
class Saiga12cFire extends KFShotgunFire;

function InitEffects()
{
    Super.InitEffects();
    if ( FlashEmitter != None )
        Weapon.AttachToBone(FlashEmitter, 'tip');
        //FlashEmitter = Weapon.Spawn(FlashEmitterClass);
}

simulated function bool AllowFire()
{
    if(KFWeapon(Weapon).bIsReloading)
        return false;
    if(KFPawn(Instigator).SecondaryItem!=none)
        return false;
    if(KFPawn(Instigator).bThrowingNade)
        return false;

    if(KFWeapon(Weapon).MagAmmoRemaining < 1)
    {
        if( Level.TimeSeconds - LastClickTime>FireRate )
        {
            LastClickTime = Level.TimeSeconds;
        }

        if( AIController(Instigator.Controller)!=None )
            KFWeapon(Weapon).ReloadMeNow();
        return false;
    }

    return super(WeaponFire).AllowFire();
}

function float MaxRange()
{
    return 25000;
}

defaultproperties
{
    KickMomentum=(X=-95.000000,Z=25.000000)
    maxVerticalRecoilAngle=1300
    maxHorizontalRecoilAngle=700
    //FireAimedAnim="Fire"
    FireAimedAnim="Fire_Iron"
    StereoFireSound=none
    FireSound=none
    FireSoundRef="ScrnWeaponPack_SND.saiga.shot_mono"
    StereoFireSoundRef="ScrnWeaponPack_SND.saiga.shot_stereo"
    NoAmmoSoundRef="ScrnWeaponPack_SND.saiga.Saiga_empty"
    ProjPerFire=6 // 5
    bModeExclusive=False
    bAttachSmokeEmitter=True
    TransientSoundVolume=2.500000
    TransientSoundRadius=500.000000
    FireRate=0.50
    FireAnimRate=1.52  // framerate: 19/25
    AmmoClass=class'Saiga12cAmmo'
    ShakeRotMag=(X=50.000000,Y=50.000000,Z=400.000000)
    ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
    ShakeRotTime=5.000000
    ShakeOffsetMag=(X=6.000000,Y=2.000000,Z=10.000000)
    ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
    ShakeOffsetTime=3.000000
    ProjectileClass=class'Saiga12cBullet'
    BotRefireRate=0.250000
    FlashEmitterClass=Class'ROEffects.MuzzleFlash1stKar'
    aimerror=1.000000
    Spread=825.000000
}
