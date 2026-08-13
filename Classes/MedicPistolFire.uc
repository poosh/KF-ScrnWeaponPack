class MedicPistolFire extends ScrnFire;

var int HealAmount, HealBoost;

simulated event ModeDoFire()
{
    if (MedicPistol(Weapon) != none) {
        if (MedicPistol(Weapon).bFiringLastRound) {
            FireAnim = 'FireLast';
            FireAimedAnim = 'FireLast_Iron';
        }
        else {
            FireAnim = default.FireAnim;
            FireAimedAnim = default.FireAimedAnim;
        }
    }
    Super.ModeDoFire();
}

function WeaponHitHealTarget(vector HitLocation, vector HitMomentum)
{
    if (ScrnCustomMedicGun(Instigator.Weapon) != none) {
        ScrnCustomMedicGun(Instigator.Weapon).HitHealTarget(HitLocation, Rotator(-HitMomentum));
    }

}

function DamagePlayer(KFPawn Victim, int Damage, vector HitLocation, vector HitMomentum, out array<int> HitPoints)
{
    // HEAL
    if (Victim.Health > 0) {
        WeaponHitHealTarget(HitLocation, HitMomentum);
        HealPawn(Victim);
    }
}

function DamageZed(KFMonster Victim, int Damage, vector HitLocation, vector HitMomentum)
{
    // DAMAGE & HEAL
    Victim.TakeDamage(Damage, Instigator, HitLocation, HitMomentum, DamageType);
    if (!Victim.bDecapitated && Victim.Health > 0) {
        WeaponHitHealTarget(HitLocation, HitMomentum);
        Victim.Health += int(Damage * class<KFWeaponDamageType>(DamageType).default.HeadShotDamageMult);
        if (Victim.Health > 2 * Victim.HealthMax) {
            Victim.TakeDamage(Victim.Health * 10, Instigator, Victim.Location, vect(0,0,1), class'DamTypeMedicOvercharge' );
        }
    }
}

function HealPawn(KFPawn Healed)
{
    local KFPlayerReplicationInfo PRI;
    local float HealPotency;

    if ( Healed.Health <= 0 )
        return;

    HealPotency = 1.0;
    PRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
    if ( PRI != none && PRI.ClientVeteranSkill != none )
        HealPotency = PRI.ClientVeteranSkill.Static.GetHealPotency(PRI);

    if ( Healed.Controller != none )
        Healed.Controller.ShakeView(ShakeRotMag, ShakeRotRate, ShakeRotTime, ShakeOffsetMag, ShakeOffsetRate, ShakeOffsetTime);

    if ( ScrnHumanPawn(Healed) != none )
        ScrnHumanPawn(Healed).TakeHealingEx(ScrnHumanPawn(Instigator), 0, HealAmount, KFWeapon(Instigator.Weapon), true);
    else
        class'ScrnHumanPawn'.static.HealLegacyPawn(Healed, Instigator, HealAmount);

    // instantly raise player health
    Healed.Health += int(HealBoost * HealPotency);
    if (Healed.Health > 250) {
        class'ScrnAchCtrl'.static.Ach2Pawn(Instigator, 'MedicPistol_250', 1);
    }
}


defaultproperties
{
    HealAmount=20
    HealBoost=3
    DamageMax=23
    DamageType=class'DamTypeMedicPistol'
    AmmoClass=class'MedicPistolAmmo'
    PenDmgReduction=0.50
    MaxPenetrations=0
    bWaitForRelease=True

    maxVerticalRecoilAngle=250
    maxHorizontalRecoilAngle=50
    FireAimedAnim="Fire_Iron"
    FireSoundRef="KF_MP7Snd.Medicgun_Fire"
    StereoFireSoundRef="KF_MP7Snd.Medicgun_FireST"
    NoAmmoSoundRef="KF_PumpSGSnd.SG_DryFire"
    bAttachSmokeEmitter=False
    TransientSoundVolume=2.000000
    TransientSoundRadius=500.000000
    FireRate=0.25
    AmmoPerFire=1
    ShakeRotMag=(X=75.000000,Y=75.000000,Z=290.000000)
    ShakeRotRate=(X=10080.000000,Y=10080.000000,Z=10000.000000)
    ShakeRotTime=3.500000
    ShakeOffsetMag=(X=6.000000,Y=1.000000,Z=8.000000)
    ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
    ShakeOffsetTime=2.500000
    BotRefireRate=0.40
    FlashEmitterClass=Class'ROEffects.MuzzleFlash1stKar'
    aimerror=1.000000
    Spread=0.010000
    SpreadStyle=SS_Random
}
