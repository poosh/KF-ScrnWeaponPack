class AK12Fire extends KFFire;

var int BurstSize;
var transient int BurstShotCount; //how many bullets were fired in the current burst?
var transient float FireBurstEndTime; //this is just to be sure we don't stuck inside FireBurst state, if shit happens


state WaitingForFireButtonRelease
{
    ignores PlayFiring, ServerPlayFiring, PlayFireEnd, ModeDoFire;
}

state FireBurst
{
    function BeginState()
    {
        NumShotsInBurst = 0;
        BurstShotCount = 0;
        // NextFireTime = Level.TimeSeconds - 0.0001; //fire now!
        FireBurstEndTime = Level.TimeSeconds + ( FireRate * BurstSize ) + 0.1; // if shit happens - get us out of this state when this time hits
    }

    function EndState()
    {
        PlayFireEnd();
    }

    function StopFiring()
    {
        GotoState('');
    }

    function ModeTick(float dt)
    {
        Super.ModeTick(dt);

        if ( !bIsFiring ||  !AllowFire() )  // stopped firing, magazine empty
            GotoState('');
        else if ( Level.TimeSeconds > FireBurstEndTime )
        {
            GotoState('');
            log("stuck inside FireBurst state after making "$BurstShotCount$" shots! Getting us out of it.", class.name);
        }
    }

    // Calculate modifications to spread
    simulated function float GetSpread()
    {
        local float NewSpread;
        local float AccuracyMod;

        AccuracyMod = 1.0;

        // Spread bonus for firing aiming
        if( KFWeap.bAimingRifle )
        {
            AccuracyMod *= 0.5;
        }

        // Small spread bonus for firing crouched
        if( Instigator != none && Instigator.bIsCrouched )
        {
            AccuracyMod *= 0.85;
        }

        NumShotsInBurst++;

        // Small spread bonus for firing in semi auto mode
        // make spread bonus for first 2 shots -- PooSH
        if( NumShotsInBurst < 2 || (bAccuracyBonusForSemiAuto && bWaitForRelease) )
        {
            AccuracyMod *= 0.5;
        }


        if ( Level.TimeSeconds - LastFireTime > 0.5 ) {
            NewSpread = Default.Spread;
            NumShotsInBurst=0;
        }
        else if (BurstSize <= 2) {
            //2-nd shot doesn't get spread penalty
            NewSpread = Default.Spread;
        }
        else {
            // Decrease accuracy up to MaxSpread by the number of recent shots up to a max of six
            NewSpread = FMin(Default.Spread + (NumShotsInBurst * (MaxSpread/6.0)),MaxSpread);
        }

        NewSpread *= AccuracyMod;

        return NewSpread;
    }

    function ModeDoFire()
    {
        local float Rec;
        local KFPlayerReplicationInfo KFPRI;

        if (!AllowFire())
            return;

        if( Instigator==None || Instigator.Controller==none )
            return;

        KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);

        Spread = GetSpread();

        Rec = GetFireSpeed();
        FireRate = default.FireRate/Rec;
        FireAnimRate = default.FireAnimRate*Rec;
        ReloadAnimRate = default.ReloadAnimRate*Rec;
        Rec = 1;

        if ( KFPRI != none && KFPRI.ClientVeteranSkill != none )
        {
            Spread *= KFPRI.ClientVeteranSkill.Static.ModifyRecoilSpread(KFPRI, self, Rec);
        }

        LastFireTime = Level.TimeSeconds;

        if (Weapon.Owner != none && AllowFire() && !bFiringDoesntAffectMovement)
        {
            if (FireRate > 0.25)
            {
                Weapon.Owner.Velocity.x *= 0.1;
                Weapon.Owner.Velocity.y *= 0.1;
            }
            else
            {
                Weapon.Owner.Velocity.x *= 0.5;
                Weapon.Owner.Velocity.y *= 0.5;
            }
        }

        Super(WeaponFire).ModeDoFire();

        // client
        if (Instigator.IsLocallyControlled())
        {
            if( bDoClientRagdollShotFX && Weapon.Level.NetMode == NM_Client )
            {
                DoClientOnlyFireEffect();
            }
            //reduce recoil for first 2 bullets
            if (NumShotsInBurst <= 1) {
                maxVerticalRecoilAngle = default.maxVerticalRecoilAngle *  0.1;
                maxHorizontalRecoilAngle = default.maxHorizontalRecoilAngle *  0.1;
            }
            HandleRecoil(Rec);
            //restore defaults
            maxVerticalRecoilAngle = default.maxVerticalRecoilAngle;
            maxHorizontalRecoilAngle = default.maxHorizontalRecoilAngle;
        }

        if ( ++BurstShotCount >= BurstSize ) {
            GotoState('WaitingForFireButtonRelease');
            return;
        }
    }
}


defaultproperties
{
    FireSoundRef="ScrnWeaponPack_SND.AK12.AK12_shot"
    StereoFireSoundRef="ScrnWeaponPack_SND.AK12.AK12_shot"
    NoAmmoSoundRef="ScrnWeaponPack_SND.AK12.AK12_empty"

    FireAimedAnim="Fire_Iron"
    RecoilRate=0.040000
    maxVerticalRecoilAngle=250
    maxHorizontalRecoilAngle=150
    bRecoilRightOnly=True
    ShellEjectClass=class'KFShellEjectAK12AR'
    ShellEjectBoneName="Shell_eject"
    bAccuracyBonusForSemiAuto=True
    bRandomPitchFireSound=False
    DamageType=class'DamTypeAK12AssaultRifle'
    DamageMax=50
    Momentum=18500.000000
    bPawnRapidFireAnim=True
    TransientSoundVolume=3.800000
    FireLoopAnim="Fire"
    TweenTime=0.025000
    FireForce="AssaultRifleFire"
    FireRate=0.095
    AmmoClass=class'AK545Ammo'
    AmmoPerFire=1
    ShakeRotMag=(X=50.000000,Y=50.000000,Z=350.000000)
    ShakeRotRate=(X=5000.000000,Y=5000.000000,Z=5000.000000)
    ShakeRotTime=0.750000
    ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=7.500000)
    ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
    ShakeOffsetTime=1.250000
    BotRefireRate=0.990000
    FlashEmitterClass=class'MuzzleFlashAK12AR'
    aimerror=42.0
    Spread=0.0075
    SpreadStyle=SS_Random

    BurstSize=2
}
