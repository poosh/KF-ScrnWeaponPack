class SVDSFire extends KFShotgunFire;

var()           class<Emitter>  ShellEjectClass;            // class of the shell eject emitter
var()           Emitter         ShellEjectEmitter;          // The shell eject emitter
var()           name            ShellEjectBoneName;         // name of the shell eject bone

var vector ScopedShakeOffsetMag; //Shake offset mag used for 3d scopes
var vector ScopedShakeOffsetRate; //Shake offset rate used for 3d scopes


simulated function InitEffects()
{
    super.InitEffects();

    // don't even spawn on server
    if ( (Level.NetMode == NM_DedicatedServer) || (AIController(Instigator.Controller) != None) )
        return;
    if ( (ShellEjectClass != None) && ((ShellEjectEmitter == None) || ShellEjectEmitter.bDeleteMe) )
    {
        ShellEjectEmitter = Weapon.Spawn(ShellEjectClass);
        Weapon.AttachToBone(ShellEjectEmitter, ShellEjectBoneName);
    }
}

function DrawMuzzleFlash(Canvas Canvas)
{
    super.DrawMuzzleFlash(Canvas);
    // Draw shell ejects
    if (ShellEjectEmitter != None )
    {
        Canvas.DrawActor( ShellEjectEmitter, false, false, Weapon.DisplayFOV );
    }
}

function FlashMuzzleFlash()
{
    super.FlashMuzzleFlash();

    if (ShellEjectEmitter != None)
    {
        ShellEjectEmitter.Trigger(Weapon, Instigator);
    }
}

simulated function DestroyEffects()
{
    super.DestroyEffects();

    if (ShellEjectEmitter != None)
        ShellEjectEmitter.Destroy();
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


function float MaxRange()
{
    return 25000;
}


defaultproperties
{
     StereoFireSoundRef="ScrnWeaponPack_SND.SVD.SVD_shot"
     FireSoundRef="ScrnWeaponPack_SND.SVD.SVD_shot"
     NoAmmoSoundRef="ScrnWeaponPack_SND.SVD.SVD_empty"
     TransientSoundVolume=3.800000

     ShellEjectClass=class'KFShellEjectSVD'
     ShellEjectBoneName="Shell_eject"

     RecoilRate=0.200000
     maxVerticalRecoilAngle=1500
     maxHorizontalRecoilAngle=300
     FireAimedAnim="Fire"
     ProjPerFire=1
     ProjSpawnOffset=(X=0,Y=0,Z=0)
     bWaitForRelease=True
     bModeExclusive=False
     FireLoopAnim="Fire"
     FireForce="ShockRifleFire"
     FireRate=0.750000
     AmmoClass=class'SVDSAmmo'
     ShakeRotMag=(X=100.000000,Y=100.000000,Z=500.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=10.000000,Y=3.000000,Z=12.000000)
     ScopedShakeOffsetMag=(X=0.000000,Y=0.000000,Z=0.000000) //recoil shake disabled for 3d scopes
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ScopedShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000) //recoil shake disabled for 3d scopes
     ShakeOffsetTime=2.000000
     ProjectileClass=class'SVDSBullet'
     BotRefireRate=0.550000
     FlashEmitterClass=class'MuzzleFlash1rdSVD'
     aimerror=0.000000
     Spread=0.000000
}
