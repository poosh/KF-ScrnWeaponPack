class Saiga12cBullet extends ShotgunBullet;

var() float BigZedPenDmgReduction;      // Additional penetration  damage reduction after hitting big zeds. 0.5 = 50% dmg. red.
var() int   BigZedMinHealth;            // If zed's base Health >= this value, zed counts as Big
var() float MediumZedPenDmgReduction;   // Additional penetration  damage reduction after hitting medium-size zeds. 0.5 = 50% dmg. red.
var() int   MediumZedMinHealth;         // If zed's base Health >= this value, zed counts as Medium-size

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    local vector X;
	local Vector TempHitLocation, HitNormal;
	local array<int>	HitPoints;
    local KFPlayerReplicationInfo KFPRI;
    local KFPawn HitPawn;
    local Pawn Victim;
    local KFMonster KFM;

	if ( Other == none || Other == Instigator || Other.Base == Instigator || !Other.bBlockHitPointTraces  )
		return;
    
    X = Vector(Rotation);

 	if( ROBulletWhipAttachment(Other) != none ) {
        // we touched player's auxilary collision cylinder, not let's trace to the player himself
        // Other.Base = KFPawn
        if( Other.Base == none || Other.Base.bDeleteMe ) 
            return;
	    
        Other = Instigator.HitPointTrace(TempHitLocation, HitNormal, HitLocation + (200 * X), HitPoints, HitLocation,, 1);

        if( Other == none || HitPoints.Length == 0 )
            return; // bullet didn't hit a pawn

		HitPawn = KFPawn(Other);

        if (Role == ROLE_Authority) {
            if ( HitPawn != none && !HitPawn.bDeleteMe ) {
                HitPawn.ProcessLocationalDamage(Damage, Instigator, TempHitLocation, MomentumTransfer * Normal(Velocity), MyDamageType,HitPoints);
            }
        }
	}
    else {
        if ( ExtendedZCollision(Other) != none) 
            Victim = Pawn(Other.Owner); // ExtendedZCollision is attached to KFMonster    
        else if ( Pawn(Other) != none )
            Victim = Pawn(Other);

        KFM = KFMonster(Victim);
    
        if ( Victim != none && Victim.IsHeadShot(HitLocation, X, 1.0))
            Victim.TakeDamage(Damage * HeadShotDamageMult, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType);
        else
            Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType);
    }

    KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);    
	if ( KFPRI != none && KFPRI.ClientVeteranSkill != none )
   		PenDamageReduction = KFPRI.ClientVeteranSkill.static.GetShotgunPenetrationDamageMulti(KFPRI,default.PenDamageReduction);
	else
   		PenDamageReduction = default.PenDamageReduction;
    // loose penetrational damage after hitting specific zeds -- PooSH
    if ( KFM != none)
        PenDamageReduction *= ZedPenDamageReduction(KFM);    

   	Damage *= PenDamageReduction; // Keep going, but lose effectiveness each time.
    
    // if we've struck through more than the max number of foes, destroy.
    // MaxPenetrations now really means number of max penetration off-perk -- PooSH
    if ( Damage / default.Damage < (default.PenDamageReduction ** MaxPenetrations) + 0.0001 )
    {
        Destroy();
    }

    speed = VSize(Velocity);

    if( Speed < (default.Speed * 0.25) )
    {
        Destroy();
    }
}

/**
 * Further damage reduction after hitting a specific zed
 * @param   Monster                         Zed that took damage
 * @return  Further penetration  damage reduction. Doesn't affect current Monster!
 *          1.0  - no additional penetration  damage reduction
 *          0.75 - 25% additional penetration  damage reduction
 */
simulated function float ZedPenDamageReduction(KFMonster Monster)
{
    if ( Monster == none ) 
        return 1.0;
    
    if ( Monster.default.Health >= BigZedMinHealth )
        return BigZedPenDmgReduction;
    else if ( Monster.default.Health >= MediumZedMinHealth )
        return MediumZedPenDmgReduction;
    
    return 1.0;
}



defaultproperties
{
     BigZedPenDmgReduction=0.500000
     BigZedMinHealth=1000
     MediumZedPenDmgReduction=0.750000
     MediumZedMinHealth=500
     MaxPenetrations=3
     PenDamageReduction=0.700000
     HeadShotDamageMult=1.000000
     Damage=66 // 60
     MomentumTransfer=60000.000000
     MyDamageType=Class'ScrnWeaponPack.DamTypeSaiga12c'
     DrawScale=1.500000
}
