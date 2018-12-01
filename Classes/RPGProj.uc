// subclassing ROBallisticProjectile so we can do the ambient volume scaling
class RPGProj extends ScrnLAWProj;

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

simulated function Destroyed()
{
    if (Tracer != none && !Tracer.bDeleteMe)
    {
        Tracer.Destroy();
    }
	Super.Destroyed();
}


function float ScaleMonsterDamage(KFMonster Victim)
{
    if ( ZombieBoss(Victim) != none )
        return 0.8; // add 20% resistance to Pat
    return 1.0;
}

defaultproperties
{
     SmokeTrailClass=Class'ROEffects.PanzerfaustTrail'
     ExplosionClass=Class'ScrnWeaponPack.RpgExplosion'
     TracerClass=Class'ScrnWeaponPack.ScrnRPGTracer'
     ShakeRotMag=(X=512.000000,Y=400.000000)
     ShakeRotRate=(X=3000.000000,Y=3000.000000)
     ShakeOffsetMag=(X=20.000000,Y=30.000000,Z=30.000000)
     ArmDistSquared=90000.000000
     ImpactDamage=400
     StaticMeshRef="ScrnWeaponPack_A.RPG.Rocket"
     ExplosionSoundRef="ScrnWeaponPack_SND.RPG.RPGExplode"
     AmbientSoundRef="ScrnWeaponPack_SND.RPG.RPGFly"
     DisintegrateSoundRef="Inf_Weapons.panzerfaust60.faust_explode_distant02"
     Speed=3000.000000
     MaxSpeed=4000.000000
     Damage=1500.000000
     DamageRadius=300.000000
     MomentumTransfer=2000.000000
     MyDamageType=Class'KFMod.DamTypeLAW'
     LightBrightness=200.000000
     LightRadius=15.000000
     SoundVolume=192
     SoundRadius=128.000000
}
