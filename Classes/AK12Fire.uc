class AK12Fire extends ScrnFire;

var int BurstSize;
var float BurstRecoilMod;
var float BurstSpreadMod;
var transient int BurstShotCount; //how many bullets were fired in the current burst?
var transient float FireBurstEndTime; //this is just to be sure we don't stuck inside FireBurst state, if shit happens


state WaitingForFireButtonRelease
{
    function PlayFiring() {}
    function ServerPlayFiring() {}
    function PlayFireEnd() {}
    function ModeDoFire() {}
}

state FireBurst
{
    function BeginState()
    {
        BurstShotCount = 0;
        NextFireTime = Level.TimeSeconds - 0.000001; //fire now!
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
        super.ModeTick(dt);

        if (!bIsFiring || !AllowFire())  // stopped firing, magazine empty
            GotoState('');
        else if ( Level.TimeSeconds > FireBurstEndTime )
        {
            GotoState('');
            log("stuck inside FireBurst state after making "$BurstShotCount$" shots! Getting us out of it.", class.name);
        }
    }

    simulated function float GetSpread()
    {
        local float NewSpread;

        NewSpread = global.GetSpread();
        if (NumShotsInBurst < BurstSize) {
            NewSpread *= 0.5;
        }
        return NewSpread;
    }

    simulated function HandleRecoil(float Rec)
    {
        if (NumShotsInBurst == 0) {
            maxVerticalRecoilAngle = default.maxVerticalRecoilAngle * BurstRecoilMod;
            maxHorizontalRecoilAngle = default.maxHorizontalRecoilAngle * BurstRecoilMod;
        }

        global.HandleRecoil(Rec);

        maxVerticalRecoilAngle = default.maxVerticalRecoilAngle;
        maxHorizontalRecoilAngle = default.maxHorizontalRecoilAngle;
    }

    function ModeDoFire()
    {
        if (!AllowFire())
            return;

        super(ScrnFire).ModeDoFire();

        if (++BurstShotCount >= BurstSize) {
            GotoState('WaitingForFireButtonRelease');
            return;
        }
    }
}


defaultproperties
{
    StereoFireSoundRef="ScrnWeaponPack_SND.AK12.AK12_shotST"
    FireSoundRef="ScrnWeaponPack_SND.AK12.AK12_shot"
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
    BurstRecoilMod=0.1
    BurstSpreadMod=0.5
}
