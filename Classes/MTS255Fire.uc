class MTS255Fire extends KFShotgunFire;

var()           class<Emitter>  ShellEjectClass;
var()           Emitter         ShellEjectEmitter;
var()           name            ShellEjectBoneName;

simulated function InitEffects()
{
    super.InitEffects();

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

// Overridden to support interrupting the reload
simulated function bool AllowFire()
{
	if( KFWeapon(Weapon).bIsReloading )
		return false;

	if(KFPawn(Instigator).SecondaryItem!=none)
		return false;
	if( KFPawn(Instigator).bThrowingNade )
		return false;

	if( Level.TimeSeconds - LastClickTime>FireRate )
	{
		LastClickTime = Level.TimeSeconds;
	}

	if( KFWeapon(Weapon).MagAmmoRemaining<1 )
	{
    		return false;
	}

	return super(WeaponFire).AllowFire();
}

defaultproperties
{
     ShellEjectClass=None
     KickMomentum=(X=-45.000000,Z=10.000000)
     maxVerticalRecoilAngle=1500
     maxHorizontalRecoilAngle=900
     FireAimedAnim="Fire_Iron"
     bRandomPitchFireSound=False
     FireSoundRef="KF_PumpSGSnd.SG_Fire"
     StereoFireSoundRef="KF_PumpSGSnd.SG_FireST"
     NoAmmoSoundRef="KF_PumpSGSnd.SG_DryFire"
     ProjPerFire=1
     bWaitForRelease=True
     bAttachSmokeEmitter=True
     TransientSoundVolume=2.000000
     TransientSoundRadius=500.000000
     FireRate=0.400000
     AmmoClass=Class'ScrnWeaponPack.MTS255Ammo'
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=400.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     ShakeRotTime=5.000000
     ShakeOffsetMag=(X=6.000000,Y=2.000000,Z=10.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=3.000000
     ProjectileClass=Class'ScrnWeaponPack.MTS255Rocket'
     BotRefireRate=0.200000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stKar'
     aimerror=1.000000
     Spread=0.01
}
