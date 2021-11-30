Class HopMineProj extends Projectile;

#exec obj load file="KF_GrenadeSnd.uax"
#exec OBJ LOAD FILE=ScrnWeaponPack_T.utx
#exec OBJ LOAD FILE=ScrnWeaponPack_SND.uax
#exec OBJ LOAD FILE=ScrnWeaponPack_A.ukx

var PanzerfaustTrail SmokeTrail;
var vector RepAttachPos,RepAttachDir,RepLaunchPos;
var HopMineLight DotLight;
var HopMineLchr WeaponOwner;

var     bool    bDisintegrated; // This nade has been disintegrated by a siren scream.
var()   sound   DisintegrateSound;// The sound of this projectile disintegrating


var bool bWarningTarget,bCriticalTarget,bPreLaunched,bNeedsDetonate;

var float MinSpread; // min distance between placed mines. If placed closer, they will trigger each other

var     int     PlacedTeam;     // TeamIndex of the team that placed this projectile


replication
{
    // Variables the server should send to the client.
    reliable if( Role==ROLE_Authority )
        RepAttachPos,RepAttachDir,bWarningTarget,bCriticalTarget,RepLaunchPos;
}

simulated function AddSmoke()
{
    if( SmokeTrail==None )
        SmokeTrail = Spawn(class'PanzerfaustTrail',self);
    SmokeTrail.SetBase(self);
    SmokeTrail.SetRelativeRotation(rot(32768,0,0));
}

simulated function PreBeginPlay()
{
    super.PreBeginPlay();
    SetCollisionSize(0, 0);  // prevents blocking by bBlockNonZeroExtentTraces (e.g., BlockingVolume)
}

simulated function PostBeginPlay()
{
    Velocity = speed * vector(Rotation);
    Super.PostBeginPlay();
}

simulated function Destroyed()
{
    if( WeaponOwner!=None )
        WeaponOwner.RemoveMine(Self);
    if ( SmokeTrail != None )
        SmokeTrail.HandleOwnerDestroyed();
    if( DotLight!=None )
        DotLight.Destroy();
    if( Level.NetMode==NM_Client )
        BlowUp(Location);
    Super.Destroyed();
}

simulated function PostNetBeginPlay()
{
    bNetNotify = true;
    if( Physics==PHYS_None )
        GoToState('OnWall');
    else if( Physics==PHYS_Projectile || RepLaunchPos!=vect(0,0,0) )
        GoToState('LaunchMine');
    else if ( Level.NetMode!=NM_DedicatedServer )
    {
        AddSmoke();
        TweenAnim('Up',0.01f);
        PlaySound(Sound'ScrnWeaponPack_SND.mine.blade_in');
        RandSpin(65000.f);
    }
}

simulated function PostNetReceive()
{
    if( RepAttachPos!=vect(0,0,0) )
    {
        ClientAttachProj();
        RepAttachPos = vect(0,0,0);
    }
    if( bHidden && !bDisintegrated )
    {
        Disintegrate(Location, vect(0,0,1));
    }
}

simulated function AttachTo( vector Pos, vector Dir, Actor Wall )
{
    SetPhysics(PHYS_None);
    SetLocation(Pos + Dir*2);
    SetRotation(rotator(Dir)-rot(16384,0,0));
    RepAttachPos = Location;
    RepAttachDir = Dir*1000.f;
    if( Wall!=None && !Wall.bStatic )
        SetBase(Wall);
    GoToState('OnWall');
}

simulated function ClientAttachProj()
{
    local vector HL,HN,D;
    local Actor A;

    D = Normal(RepAttachDir);
    A = Trace(HL,HN,RepAttachPos-D*10.f,RepAttachPos+D,false);
    if( A==None )
    {
        HN = D;
        HL = RepAttachPos;
    }
    AttachTo(HL,HN,A);
}

// Make the projectile distintegrate, instead of explode
simulated function Disintegrate(vector HitLocation, vector HitNormal)
{
    bDisintegrated = true;
    bHidden = true;

    if( Role == ROLE_Authority ) {
       GotoState('Destroying');
       NetUpdateTime = Level.TimeSeconds - 1;
    }

    PlaySound(DisintegrateSound,,2.0);

    if ( EffectIsRelevant(Location,false) )
    {
        Spawn(Class'KFMod.SirenNadeDeflect',,, HitLocation, rotator(vect(0,0,1)));
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    BlowUp(HitLocation);
}

simulated function BlowUp(vector HitLocation)
{
    if( Level.NetMode!=NM_DedicatedServer )
    {
        PlaySound(ImpactSound,,2.0);
        if ( EffectIsRelevant(Location,false) )
            Spawn(class'KFNadeLExplosion',,,HitLocation, rot(16384,0,0));
    }

    HurtRadius(Damage,DamageRadius, MyDamageType, MomentumTransfer, HitLocation );

    if ( Role == ROLE_Authority ) {
        MakeNoise(1.0);
        GoToState('Destroying');
        NetUpdateTime = Level.TimeSeconds - 1;
    }
}

simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
    local actor Victims;
    local float damageScale, dist;
    local vector dir;

    if ( bHurtEntry )
        return;

    bHurtEntry = true;
    foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
    {
        // don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
        if( (Victims != self) && (Hurtwall != Victims) && (Victims.Role == ROLE_Authority)
                && !Victims.IsA('FluidSurfaceInfo') && ExtendedZCollision(Victims)==None )
        {
            if( Pawn(Victims)!=None && Monster(Victims)==None && Pawn(Victims).Controller!=InstigatorController )
                continue;
            dir = Victims.Location - HitLocation;
            dist = FMax(1,VSize(dir));
            dir = dir/dist;
            damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
            if ( Instigator == None || Instigator.Controller == None )
                Victims.SetDelayedDamageInstigatorController( InstigatorController );
            if( Monster(Victims)==None )
                damageScale*=0.30; // Make it a lot less lethal to player self inflicted damage.
            Victims.TakeDamage
            (
                damageScale * DamageAmount,
                Instigator,
                Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
                (damageScale * Momentum * dir),
                DamageType
            );
            if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
                Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
        }
    }
    bHurtEntry = false;
}

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
    local Class<KFWeaponDamageType> KFDamType;

    if ( InstigatedBy == none )
        return;

    if ( damageType == class'SirenScreamDamage' ) {
        Disintegrate(HitLocation, vect(0,0,1));
        return;
    }
    else if ( Monster(InstigatedBy) != none ) {
        if ( Damage >= 5 )
            Explode(HitLocation, vect(0,0,1));
        return;
    }

    if ( Damage < 30 )
        return;

    KFDamType = Class<KFWeaponDamageType>(damageType);
    if ( KFDamType != none && (KFDamType.default.bIsExplosive || KFDamType.default.bIsMeleeDamage
            || KFDamType.default.bDealBurningDamage) )
        return;

    // check same team
    if ( InstigatorController != InstigatedBy.Controller && InstigatedBy.PlayerReplicationInfo != none
            && InstigatedBy.PlayerReplicationInfo.Team != none
            && InstigatedBy.PlayerReplicationInfo.Team.TeamIndex == PlacedTeam )
    {
        return;
    }

    Explode(HitLocation, vect(0,0,1));
}

auto state Arming
{
    ignores Touch, ClientSideTouch, ProcessTouch;

    simulated function Landed( vector HitNormal )
    {
        HitWall(HitNormal,Base);
    }

    simulated function HitWall(vector HitNormal, actor Wall)
    {
        if( Level.NetMode==NM_Client )
        {
            SetPhysics(PHYS_None);
            return;
        }
        AttachTo(Location,HitNormal,Wall);
    }
}

state OnWall
{
    ignores Touch, ClientSideTouch, ProcessTouch;

    simulated function BeginState()
    {
        local HopMineProj Other;

        if ( SmokeTrail != None )
        {
            SmokeTrail.HandleOwnerDestroyed();
            SmokeTrail = None;
        }
        bCollideWorld = False;
        SetCollisionSize(default.CollisionRadius, default.CollisionHeight);
        bFixedRotationDir = false;
        RotationRate = rot(0,0,0);
        if( Level.NetMode!=NM_DedicatedServer )
        {
            TweenAnim('Down',0.05f);
            PlaySound(Sound'ScrnWeaponPack_SND.mine.blade_cut');
            DotLight = Spawn(Class'HopMineLight',,,Location + (vect(0,0,5) << Rotation));
            if( DotLight!=None )
            {
                DotLight.SetBase(Self);
                DotLight.SetRelativeLocation(vect(0,0,5));
            }
        }
        if( Level.NetMode!=NM_Client )
        {
            NetUpdateFrequency = 1.f;
            SetTimer(0.25+FRand()*0.25,true);
        }

        // destroy other mines around  -- PooSH
        foreach VisibleCollidingActors( class'HopMineProj', Other, MinSpread, Location ) {
            if ( Other != self && !Other.bDeleteMe && Other.IsInState('OnWall') ) {
                Other.RepLaunchPos = Location;
                Other.bCriticalTarget = true;
                Other.GoToState('LaunchMine');
                Other.NetUpdateTime = Level.TimeSeconds-1;
            }
        }
    }

    simulated function EndState()
    {
        SetCollisionSize(0, 0);
        if( Level.NetMode!=NM_Client )
        {
            SetTimer(0,false);
            NetUpdateFrequency = Default.NetUpdateFrequency;
            NetUpdateTime = Level.TimeSeconds-1;
        }
    }

    function Timer()
    {
        local Controller C;
        local vector X,Y,Z;
        local float DotP;
        local int ThreatLevel;
        local bool bA,bB;

        GetAxes(Rotation,X,Y,Z);
        for( C=Level.ControllerList; C!=None; C=C.nextController )
            if( C.Pawn!=None && C.Pawn.Health>0 && VSizeSquared(C.Pawn.Location-Location)<1000000.f )
            {
                X = C.Pawn.Location-Location;
                DotP = (X Dot Z);
                if( DotP<0 )
                    continue;
                DotP = VSizeSquared(X - (Z * DotP));
                if( DotP>90000.f || !FastTrace(C.Pawn.Location,Location) )
                    continue;
                if( Monster(C.Pawn)!=None )
                {
                    bB = true;
                    if( DotP<35500.f )
                    {
                        Y = C.Pawn.Location;
                        ThreatLevel+=C.Pawn.HealthMax;
                    }
                }
                else bA = true;
            }
        if( bA!=bWarningTarget || bB!=bCriticalTarget )
        {
            bWarningTarget = bA;
            bCriticalTarget = bB;
            if( DotLight!=None )
                DotLight.SetMode(bA,bB);
            NetUpdateTime = Level.TimeSeconds-1;
        }
        if( bB && ThreatLevel>400 )
        {
            bWarningTarget = false;
            bCriticalTarget = false;
            RepLaunchPos = Y;
            GoToState('LaunchMine');
        }
        else if( InstigatorController==None || bNeedsDetonate || (WeaponOwner!=None && WeaponOwner.NumMinesOut>WeaponOwner.MaximumMines) )
        {
            bWarningTarget = false;
            bCriticalTarget = false;
            RepLaunchPos = Location + Z*(150.f+FRand()*250.f);
            GoToState('LaunchMine');
        }
    }

    simulated function PostNetReceive()
    {
        if( RepLaunchPos!=vect(0,0,0) )
            GoToState('LaunchMine');
        else if( DotLight!=None )
            DotLight.SetMode(bWarningTarget,bCriticalTarget);
    }
}

state LaunchMine
{
    simulated function BeginState()
    {
        if( WeaponOwner!=None )
            WeaponOwner.RemoveMine(Self);
        bNeedsDetonate = true;
        if( DotLight!=None )
            DotLight.SetMode(true,true);
        if( Physics!=PHYS_Projectile )
        {
            bFixedRotationDir = false;
            RotationRate = rot(0,0,0);
            if( Level.NetMode!=NM_DedicatedServer )
            {
                TweenAnim('Up',0.1f);
                PlaySound(Sound'ScrnWeaponPack_SND.mine.blade_in');
                PlaySound(Sound'ScrnWeaponPack_SND.mine.combine_mine_deploy1',SLOT_Talk);
            }
            SetTimer(0.6,false);
        }
        bNetNotify = false;
    }

    function HitWall(vector HitNormal, actor Wall)
    {
        BlowUp(Location);
    }

    function ProcessTouch(Actor Other, Vector HitLocation)
    {
        if ( Other != Instigator && Pawn(Other) != none )
            Explode(HitLocation ,Normal(HitLocation-Other.Location));
    }

    simulated function Timer()
    {
        if( !bPreLaunched )
        {
            bPreLaunched = true;
            if( Level.NetMode!=NM_DedicatedServer )
                PlaySound(Sound'ScrnWeaponPack_SND.mine.rmine_blip3',SLOT_Misc);
            SetTimer(0.2,false);
        }
        else if( Level.NetMode!=NM_Client && Physics==PHYS_Projectile )
        {
            BlowUp(Location);
        }
        else
        {
            if( DotLight!=None )
                DotLight.Destroy();
            if ( Level.NetMode != NM_DedicatedServer)
            {
                AddSmoke();
                bFixedRotationDir = true;
                RandSpin(45000.f);
            }
            bCollideWorld = true;
            SetPhysics(PHYS_Projectile);
            Velocity = (RepLaunchPos-Location)*2.f;
            if( Level.NetMode!=NM_Client )
                SetTimer(0.5,false);
        }
    }
}

state Destroying
{
    ignores BlowUp, Disintegrate, Touch, ClientSideTouch, ProcessTouch;

    function BeginState()
    {
        SetTimer(0.1, true);
    }

    simulated function Timer()
    {
        Destroy();
    }
}


defaultproperties
{
     Speed=5000.000000
     MaxSpeed=8000.000000
     Damage=500
     DamageRadius=400 // 500
     MomentumTransfer=75000.000000
     MyDamageType=Class'KFMod.DamTypePipeBomb'
     ImpactSound=SoundGroup'KF_GrenadeSnd.Nade_Explode_1'
     DisintegrateSound=Sound'Inf_Weapons.panzerfaust60.faust_explode_distant02'
     bNetTemporary=False
     bAlwaysRelevant=True
     bSkipActorPropertyReplication=True
     Physics=PHYS_Falling
     LifeSpan=0.000000
     Mesh=SkeletalMesh'ScrnWeaponPack_A.HopMineM'
     DrawScale=0.6
     AmbientGlow=25
     bUnlit=False
     TransientSoundVolume=2.000000
     TransientSoundRadius=350.000000
     bBounce=True
     bFixedRotationDir=True
     MinSpread=150
     CollisionRadius=8.000000
     CollisionHeight=3.000000
     bProjTarget=True
}
