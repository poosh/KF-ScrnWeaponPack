class MTS255Rocket extends SPGrenadeProjectile;

var() 		float 		StraightFlightTime;          // How long the projectile and flies straight
var 		bool 		bOutOfPropellant;            // Projectile is out of propellant
var     bool                bDud;

replication
{
	reliable if(Role == ROLE_Authority)
		bDud;
}

simulated function Tick( float DeltaTime )
{
    SetRotation(Rotator(Normal(Velocity)));

    if( !bOutOfPropellant ){
        if ( StraightFlightTime > 0 )
            StraightFlightTime -= DeltaTime;
        else
            bOutOfPropellant = true;
    }

    if(  bOutOfPropellant && Physics != PHYS_Falling )
         SetPhysics(PHYS_Falling);
}

simulated function HitWall( vector HitNormal, actor Wall )
{
    if( Instigator != none )
    {
        OrigLoc = Instigator.Location;
    }
    if( !bDud && ((VSizeSquared(Location - OrigLoc) < ArmDistSquared) || OrigLoc == vect(0,0,0)) )
    {
        bDud = true;
        LifeSpan=1.0;
        Velocity = vect(0,0,0);
        SetPhysics(PHYS_Falling);
    }

    if( !bDud )
    {
        super(Projectile).HitWall(HitNormal,Wall);
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    bHasExploded = True;

    // Don't explode if this is a dud
    if( bDud )
    {
        Velocity = vect(0,0,0);
        LifeSpan=1.0;
        SetPhysics(PHYS_Falling);
        return;
    }
    
    super.Explode(HitLocation, HitNormal);
}  

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	// Don't let it hit this player, or blow up on another player
    if ( Other == none || Other == Instigator || Other.Base == Instigator )
		return;

    // Don't collide with bullet whip attachments
    if( KFBulletWhipAttachment(Other) != none )
    {
        return;
    }

    // Don't allow hits on poeple on the same team
    if( KFHumanPawn(Other) != none && Instigator != none
        && KFHumanPawn(Other).PlayerReplicationInfo.Team.TeamIndex == Instigator.PlayerReplicationInfo.Team.TeamIndex )
    {
        return;
    }

    // Use the instigator's location if it exists. This fixes issues with
    // the original location of the projectile being really far away from
    // the real Origloc due to it taking a couple of milliseconds to
    // replicate the location to the client and the first replicated location has
    // already moved quite a bit.
    if( Instigator != none )
    {
        OrigLoc = Instigator.Location;
    }

    if( !bDud && ((VSizeSquared(Location - OrigLoc) < ArmDistSquared) || OrigLoc == vect(0,0,0)) )
    {
        if( Role == ROLE_Authority )
        {
            AmbientSound=none;
            PlaySound(Sound'ProjectileSounds.PTRD_deflect04',,2.0);
            Other.TakeDamage( ImpactDamage, Instigator, HitLocation, Normal(Velocity), ImpactDamageType );
        }
        bDud = true;
        Velocity = vect(0,0,0);
        LifeSpan=1.0;
        SetPhysics(PHYS_Falling);
    }

    if( !bDud )
    {
	   Explode(HitLocation,Normal(HitLocation-Other.Location));
	}
}  

defaultproperties
{
    Speed=5000
    MaxSpeed=7500
    StraightFlightTime=0.5

    DrawScale=0.5
    
    ArmDistSquared=62500
    Damage=260
    DamageRadius=300
    
    bBounce=False
    Physics=PHYS_Projectile
    TossZ=0 //no initial Z velocity
}
