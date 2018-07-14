class ProtectaFire extends ShotgunFire;

simulated function bool AllowFire()
{
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

	if( KFWeapon(Weapon).MagAmmoRemaining<1 )
    	return false;

	return super(WeaponFire).AllowFire();
}

// overrode to remove FireAimedAnim
function PlayFiring()
{
    local float RandPitch;

	if ( Weapon.Mesh != None )
	{
		if ( FireCount > 0 )
		{
			if( KFWeap.bAimingRifle )
			{
                if ( Weapon.HasAnim(FireLoopAimedAnim) )
    			{
    				Weapon.PlayAnim(FireLoopAimedAnim, FireLoopAnimRate, 0.0);
    			}
    			else if( Weapon.HasAnim(FireAimedAnim) )
    			{
    				Weapon.PlayAnim(FireAimedAnim, FireAnimRate, TweenTime);
    			}
    			else
    			{
                    //Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
    			}
			}
			else
			{
                if ( Weapon.HasAnim(FireLoopAnim) )
    			{
    				Weapon.PlayAnim(FireLoopAnim, FireLoopAnimRate, 0.0);
    			}
    			else
    			{
    				Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
    			}
			}
		}
		else
		{
            if( KFWeap.bAimingRifle )
			{
                if( Weapon.HasAnim(FireAimedAnim) )
    			{
                    Weapon.PlayAnim(FireAimedAnim, FireAnimRate, TweenTime);
    			}
    			else
    			{
                    //Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
    			}
			}
			else
			{
                Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
			}
		}
	}
	if( Weapon.Instigator != none && Weapon.Instigator.IsLocallyControlled() &&
	   Weapon.Instigator.IsFirstPerson() && StereoFireSound != none )
	{
        if( bRandomPitchFireSound )
        {
            RandPitch = FRand() * RandomPitchAdjustAmt;

            if( FRand() < 0.5 )
            {
                RandPitch *= -1.0;
            }
        }

        Weapon.PlayOwnedSound(StereoFireSound,SLOT_Interact,TransientSoundVolume * 0.85,,TransientSoundRadius,(1.0 + RandPitch),false);
    }
    else
    {
        if( bRandomPitchFireSound )
        {
            RandPitch = FRand() * RandomPitchAdjustAmt;

            if( FRand() < 0.5 )
            {
                RandPitch *= -1.0;
            }
        }

        Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,(1.0 + RandPitch),false);
    }
    ClientPlayForceFeedback(FireForce);  // jdf

    FireCount++;
}



defaultproperties
{
     // FireSoundRef="KF_IJC_HalloweenSnd.FlarePistol_Fire_M"
     // StereoFireSoundRef="KF_IJC_HalloweenSnd.FlarePistol_Fire_S"

     FireSoundRef="ScrnWeaponPack_SND.Protecta.striker_shot_stereo"
     StereoFireSoundRef="ScrnWeaponPack_SND.Protecta.striker_shot_stereo"
     NoAmmoSoundRef="ScrnWeaponPack_SND.Protecta.striker_empty"

     maxVerticalRecoilAngle=350
     maxHorizontalRecoilAngle=100
     FireAimedAnim= //"Fire_Iron"
     FireLoopAimedAnim=
     bRandomPitchFireSound=False
     bWaitForRelease=False
     bModeExclusive=False
     ProjPerFire=1
     bAttachSmokeEmitter=True
     TransientSoundVolume=2.000000
     TransientSoundRadius=500.000000
     FireRate=0.300000
     FireAnimRate=2.26 //synced to firerate
     AmmoClass=Class'ScrnWeaponPack.ProtectaAmmo'
     KickMomentum=(X=0,Y=0,Z=0)
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=400.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     ShakeRotTime=5.000000
     ShakeOffsetMag=(X=6.000000,Y=2.000000,Z=10.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=3.000000
     ProjectileClass=Class'ScrnWeaponPack.ProtectaFlare'
     BotRefireRate=0.250000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stKar'
     aimerror=2.000000
     Spread=0.000
     SpreadStyle=SS_None
}
