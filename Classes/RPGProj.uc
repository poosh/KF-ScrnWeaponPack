// subclassing ROBallisticProjectile so we can do the ambient volume scaling
class RPGProj extends LAWProj;

var class<Emitter> ExplosionClass;

//don't blow up on minor damage
//destoy 
function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
    if( damageType == class'SirenScreamDamage')
    {
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
    if ( Other == none || Other == Instigator || Other.Base == Instigator )
        return;

    // Don't collide with bullet whip attachments
    if( KFBulletWhipAttachment(Other) != none )
    {
        return;
    }

    // Don't allow hits on people on the same team - except hardcore mode
    if( !class'ScrnBalance'.default.Mut.bHardcore && KFHumanPawn(Other) != none && Instigator != none
            && KFHumanPawn(Other).GetTeamNum() == Instigator.GetTeamNum() )   
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
     ExplosionClass=Class'ScrnWeaponPack.RpgExplosion'
     ShakeRotMag=(X=512.000000,Y=400.000000)
     ShakeRotRate=(X=3000.000000,Y=3000.000000)
     ShakeOffsetMag=(X=20.000000,Y=30.000000,Z=30.000000)
     ArmDistSquared=90000.000000
     ImpactDamage=500
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
