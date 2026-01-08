class RPGFire extends ScrnLAWFire;

var bool bFiringLastRound;
var name FireLastAnim;

function DoFireEffect()
{
    local Vector StartProj, HitLocation, HitNormal, StartTrace, X,Y,Z;
    local Rotator R, Aim;
    local Actor Other;
    local int p, SpawnCount;

    Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(X,Y,Z);

    StartTrace = Instigator.Location + Instigator.EyePosition();
    StartProj = StartTrace + X*ProjSpawnOffset.X;
    if ( !Weapon.WeaponCentered() && !KFWeap.bAimingRifle )
        StartProj = StartProj + Weapon.Hand * Y*ProjSpawnOffset.Y + Z*ProjSpawnOffset.Z;
    Other = Weapon.Trace(HitLocation, HitNormal, StartProj, StartTrace, false);

    if (Other != None)
    {
        StartProj = HitLocation;
    }

    Aim = AdjustAim(StartProj, AimError);

    Aim.Pitch += 250;

    SpawnCount = Max(1, ProjPerFire * int(Load));

    switch (SpreadStyle)
    {
    case SS_Random:
        X = Vector(Aim);
        for (p = 0; p < SpawnCount; p++)
        {
            R.Yaw = Spread * (FRand()-0.5);
            R.Pitch = Spread * (FRand()-0.5);
            R.Roll = Spread * (FRand()-0.5);
            SpawnProjectile(StartProj, Rotator(X >> R));
        }
        break;
    }

    if (Instigator != none )
    {
        if( Instigator.Physics != PHYS_Falling  )
        {
            Instigator.AddVelocity(KickMomentum >> Instigator.GetViewRotation());
        }
        else if( Instigator.Physics == PHYS_Falling
            && Instigator.PhysicsVolume.Gravity.Z > class'PhysicsVolume'.default.Gravity.Z)
        {
            Instigator.AddVelocity((KickMomentum * LowGravKickMomentumScale) >> Instigator.GetViewRotation());
        }
    }
}

function ModeDoFire()
{
    bFiringLastRound = Weapon.AmmoAmount(0) <= AmmoPerFire;
    super.ModeDoFire();
}

function ServerPlayFiring()
{
    Super.ServerPlayFiring();
    if (bFiringLastRound) {
        Weapon.PlayAnim(FireLastAnim, FireAnimRate, TweenTime);
    }
}

function PlayFiring()
{
    Super.PlayFiring();
    if (bFiringLastRound) {
        Weapon.PlayAnim(FireLastAnim, FireAnimRate, TweenTime);
    }
    if (RPG(Weapon) != none) {
        RPG(Weapon).HideRocket();
    }
}


defaultproperties
{
    AmmoClass=class'RPGAmmo'
    ProjectileClass=class'RPGProj'

    KickMomentum=(X=-45.000000,Z=25.000000)
    ProjSpawnOffset=(X=50.000000,Z=0) //doesn't seem to do anything, since it should be 0 when fired while aimed
    TransientSoundVolume=2.5
    FireAnim="AimFire"
    FireLastAnim="Fire"
    FireAnimRate=0.94
    ReloadAnimRate=0.94 //
    //PreFireAnim ="FireShort"
    FireSoundRef="ScrnWeaponPack_SND.ScrnRPG7.fire_m"
    StereoFireSoundRef="ScrnWeaponPack_SND.ScrnRPG7.fire_s"
    NoAmmoSoundRef="KF_LAWSnd.LAW_DryFire"
    FireRate=3.250000
    AmmoPerFire=1
    //** View shake **//
    ShakeOffsetMag=(X=0.0,Y=0.0,Z=0.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=3.0
    ShakeRotMag=(X=50.0,Y=50.0,Z=400.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
    ShakeRotTime=1.0
    BotRefireRate=3.250000
    FlashEmitterClass=class'RPGMuzzleFlash'
    Spread=0.1
    SpreadStyle=SS_Random
    ProjPerFire=1

    // Lets not make poeple wait to shoot, it feels broken - Ramm
    PreFireTime=0.0

    CrouchedAccuracyBonus = 0.1

    maxVerticalRecoilAngle=200
    maxHorizontalRecoilAngle=200
    bWaitForRelease=true
    bRandomPitchFireSound=false
}