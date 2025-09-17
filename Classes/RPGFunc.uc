class RPGFunc extends ScrnExplosiveFunc abstract;

static function ScaleZedDamage(Projectile Proj, KFMonster Zed, vector HitLocation, out float DamScale)
{
    if (Zed.IsA('ZombieBoss'))
        DamScale *= 0.8;
}
