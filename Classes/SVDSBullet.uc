class SVDSBullet extends ScrnM99Bullet;

simulated function int AdjustZedDamage( int Damage, KFMonster Victim, bool bHeadshot )
{
    return Damage;
}

defaultproperties
{
    DamageTypeHeadShot=class'DamTypeSVD'
    MyDamageType=class'DamTypeSVD'
    HeadShotDamageMult=4.000000
    Speed=14000.000000
    MaxSpeed=14000.000000
    //bSwitchToZeroCollision=True
    Damage=125.000000
    DamageRadius=0.000000
    MomentumTransfer=50000.000000
    DrawType=DT_StaticMesh
    LifeSpan=3.0
    HitVelocityReduction=0.85     
    HitDamageReduction=0.70
}
