class HopMineFunc extends ScrnExplosiveFunc abstract;

static function ScaleHumanDamage(Projectile Proj, KFPawn Human, vector HitLocation, out float DamScale)
{
    DamScale *= 0.3;
}