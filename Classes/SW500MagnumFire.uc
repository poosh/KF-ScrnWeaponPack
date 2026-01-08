class SW500MagnumFire extends ColtFire;

simulated function bool AllowFire()
{
    local bool result;
    local SW500Magnum W;
    local int OldMagAmmoRemaining;

    W = SW500Magnum(Weapon);
    OldMagAmmoRemaining = W.MagAmmoRemaining;
    if (W.Role < ROLE_Authority &&  W.MagAmmoRemaining != W.LastMagAmmoRemaining + 1) {
        // in case the updated MagAmmoRemaining is already replicated to client
        W.MagAmmoRemaining = W.LastMagAmmoRemaining + 1;
        result = super.AllowFire();
        W.MagAmmoRemaining = OldMagAmmoRemaining;
        return result;
    }

    return super.AllowFire();;
}

function PlayFiring() {
    super.PlayFiring();
    SW500Magnum(Weapon).AddSpentShell();
}

defaultproperties
{
    FlashEmitterClass=Class'ROEffects.MuzzleFlash1stKar'
    AmmoClass=class'SW500MagnumAmmo'
    DamageType=class'SW500MagnumDT'
    FireAnimRate=1.2
    FireAimedAnim=Fire_Iron
    FireRate=0.7
    RecoilRate=0.1
    DamMultFP=2.0
}
