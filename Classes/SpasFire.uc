//=============================================================================
// Shotgun Fire
//=============================================================================
class SpasFire extends ShotgunFire;

var()           class<Emitter>  ShellEjectClass;            // class of the shell eject emitter
var()           Emitter         ShellEjectEmitter;          // The shell eject emitter
var()           name            ShellEjectBoneName;         // name of the shell eject bone

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

//disabling automatic shell eject
function FlashMuzzleFlash()
{
    super(InstantFire).FlashMuzzleFlash();
    /*
    if (ShellEjectEmitter != None)
    {
        ShellEjectEmitter.Trigger(Weapon, Instigator);
    }
    */
}

simulated function DestroyEffects()
{
    super.DestroyEffects();

    if (ShellEjectEmitter != None)
        ShellEjectEmitter.Destroy();
}

simulated function bool AllowFire()
{
                                                                             //changed to 1 -- PooSH
    if( KFWeapon(Weapon).bIsReloading && KFWeapon(Weapon).MagAmmoRemaining < 1)
        return false;

    if(KFPawn(Instigator).SecondaryItem!=none)
        return false;
    if( KFPawn(Instigator).bThrowingNade )
        return false;

    if( Level.TimeSeconds - LastClickTime>FireRate )
    {
        LastClickTime = Level.TimeSeconds;
    }

    if( KFWeaponShotgun(Weapon).MagAmmoRemaining<1 )
    {
            return false;
    }

    return super(WeaponFire).AllowFire();
}

defaultproperties
{
     FireSoundRef="KF_PumpSGSnd.SG_Fire"
     StereoFireSoundRef="KF_PumpSGSnd.SG_FireST"
     NoAmmoSoundRef="KF_PumpSGSnd.SG_DryFire"
     
     KickMomentum=(X=-85.000000,Z=15.000000)
     ProjPerFire=7//10
     bAttachSmokeEmitter=True
     TransientSoundVolume=2.000000
     TransientSoundRadius=500.000000
     FireRate=0.965
     FireAnimRate=0.95
     AmmoClass=Class'ScrnWeaponPack.SpasAmmo'
     ProjectileClass=Class'ScrnWeaponPack.SpasBullet'
     BotRefireRate=1.500000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stKar'
     aimerror=1.000000
     Spread=900.000000 //1025
     maxVerticalRecoilAngle=1500
     maxHorizontalRecoilAngle=900
     FireAimedAnim="Fire_Iron"
     
     ShellEjectClass=class'ROEffects.KFShellEjectShotty'
     ShellEjectBoneName=Shell_eject

     //** View shake **//
     ShakeOffsetMag=(X=6.0,Y=2.0,Z=10.0)
     ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
     ShakeOffsetTime=3.0
     ShakeRotMag=(X=50.0,Y=50.0,Z=400.0)
     ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
     ShakeRotTime=5.0
     bWaitForRelease=true
     bRandomPitchFireSound=false
}
