class ScrnRPGProj extends LAWProj;

var class<Emitter> ExplosionClass;
var class<PanzerfaustTrail> SmokeTrailClass;
var class<Emitter> TracerClass;

var Emitter Tracer; //some corona

//overrided to change smoke emiter
simulated function PostBeginPlay()
{
    local rotator SmokeRotation;

    BCInverse = 1 / BallisticCoefficient;

    if ( Level.NetMode != NM_DedicatedServer)
    {
        SmokeTrail = Spawn(SmokeTrailClass,self);
        SmokeTrail.SetBase(self);
        SmokeRotation.Pitch = 32768;
        SmokeTrail.SetRelativeRotation(SmokeRotation);
        Tracer = Spawn(TracerClass,self);
        
    }

    OrigLoc = Location;

    if( !bDud )
    {
        Dir = vector(Rotation);
        Velocity = speed * Dir;
        Velocity.Z += TossZ;
    }

    if (PhysicsVolume.bWaterVolume)
    {
        bHitWater = True;
        Velocity=0.6*Velocity;
    }
    super(Projectile).PostBeginPlay();
}

//don't blow up on minor damage
function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
    if( damageType == class'SirenScreamDamage')
    {
        // disable disintegration by dead Siren scream
        if ( InstigatedBy != none && InstigatedBy.Health > 0 )
            Disintegrate(HitLocation, vect(0,0,1));
    }
    else if ( !bDud && Damage >= 200 ) {
        if ( (VSizeSquared(Location - OrigLoc) < ArmDistSquared) || OrigLoc == vect(0,0,0))
            Disintegrate(HitLocation, vect(0,0,1));
        else
            Explode(HitLocation, vect(0,0,0));
    }
}

// overrided to add ExplosionClass
simulated function Explode(vector HitLocation, vector HitNormal)
{
    local Controller C;
    local PlayerController  LocalPlayer;

    bHasExploded = True;

    // Don't explode if this is a dud
    if( bDud )
    {
        Velocity = vect(0,0,0);
        LifeSpan=1.0;
        SetPhysics(PHYS_Falling);
    }


    PlaySound(ExplosionSound,,2.0);
    if ( EffectIsRelevant(Location,false) )
    {
        Spawn(ExplosionClass,,,HitLocation + HitNormal*20,rotator(HitNormal));
        Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
    }

    BlowUp(HitLocation);
    Destroy();

    // Shake nearby players screens
    LocalPlayer = Level.GetLocalPlayerController();
    if ( (LocalPlayer != None) && (VSize(Location - LocalPlayer.ViewTarget.Location) < DamageRadius) )
        LocalPlayer.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);

    for ( C=Level.ControllerList; C!=None; C=C.NextController )
        if ( (PlayerController(C) != None) && (C != LocalPlayer)
            && (VSize(Location - PlayerController(C).ViewTarget.Location) < DamageRadius) )
            C.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
    // Don't let it hit this player, or blow up on another player
    if ( Other == none || Other == Instigator || Other.Base == Instigator || !Other.bBlockHitPointTraces )
        return;

    // Don't collide with bullet whip attachments
    if( KFBulletWhipAttachment(Other) != none )
    {
        return;
    }

    // Don't allow hits on people on the same team - except hardcore mode
    if( !class'ScrnBalance'.default.Mut.bHardcore && KFPawn(Other) != none && Instigator != none
            && KFPawn(Other).GetTeamNum() == Instigator.GetTeamNum() )
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

simulated function Destroyed()
{
    if (Tracer != none && !Tracer.bDeleteMe)
    {
        Tracer.Destroy();
    }
	Super.Destroyed();
}

defaultproperties
{   
     SmokeTrailClass=Class'ROEffects.PanzerfaustTrail'
     ExplosionClass=Class'ScrnWeaponPack.ScrnRPGExplosion'
     TracerClass=Class'ScrnWeaponPack.ScrnRPGTracer'
     StaticMeshRef="ScrnWeaponPack_SM.ScrnRPGProj"
     ExplosionSoundRef="ScrnWeaponPack_SND.RPG.RPGExplode"
     AmbientSoundRef="KF_LAWSnd.Rocket_Propel" 
     Damage=1500.000000
     ImpactDamage=400
     DamageRadius=300.000000 //300
     MomentumTransfer=2000.000000
     
     BallisticCoefficient=0.9 //0.3
	 Speed=3700.000000 //2600
	 MaxSpeed=3700.000000 //3000
     bTrueBallistics=true //add ballistic drop
     bInitialAcceleration=true //projectile accelerates after launch
     InitialAccelerationTime=0.5 //0.5 second acceleration
     MinFudgeScale=0.35 //start with reduced velocity
     LifeSpan=4.000000 //10
     //adds light to projectile
     LightType=LT_Steady
     LightBrightness=160.0 //128
     LightRadius=8.000000 //4.0
     LightHue=25 //25
     LightSaturation=100
     LightCone=16
     bDynamicLight=True
}
