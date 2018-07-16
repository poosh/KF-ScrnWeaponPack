//=============================================================================
// HopMineLchr
//=============================================================================
class HopMineLchr extends Crossbuzzsaw;

var byte NumMinesOut;
var() byte MaximumMines;
var() localized string MinesText;

var FakedHopMine FakedHopMine;
var vector FakedHopMineOffset;

replication
{
    // Variables the server should send to the client.
    reliable if( Role==ROLE_Authority && bNetOwner )
        NumMinesOut;
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer ) {
        FakedHopMine = spawn(class'FakedHopMine',self);
        if ( FakedHopMine != none ) {
            SetBoneLocation('Blade', FakedHopMineOffset );
            // bone must have a size to properly adjust rotation
            SetBoneScale (55, 0.0001, 'Blade');
            AttachToBone(FakedHopMine, 'Blade');
        }
    }
}

simulated function Destroyed()
{
    local HopMineProj P;

    if ( FakedHopMine != None )
        FakedHopMine.Destroy();
        
    // blow up all mines on weapon destroy (drop)  -- PooSH
    foreach DynamicActors(Class'HopMineProj',P)
    {
        if( !P.bDeleteMe && P.WeaponOwner==self && !P.bNeedsDetonate )
        {
            if ( P.IsInState('OnWall') ) {
                P.RepLaunchPos = P.Location;
                P.bCriticalTarget = true;
                P.GoToState('LaunchMine');
                P.NetUpdateTime = Level.TimeSeconds-1;
            }
            else {
                P.Disintegrate(P.Location, vect(0,0,1));
            }
        }
    }        
        
    super.Destroyed();
}

// simulated function AltFire(float F)
// {
    // FakedHopMineOffset.Z += 0.1;
    // SetBoneLocation('Blade', FakedHopMineOffset );
    // PlayerController(Instigator.Controller).ClientMessage("FakedHopMineOffset = "$ FakedHopMineOffset);
// }


final function AddMine( HopMineProj M )
{
    ++NumMinesOut;
    M.WeaponOwner = Self;
    if ( Instigator != none && Instigator.PlayerReplicationInfo != none 
            && Instigator.PlayerReplicationInfo.Team != none )
    {
        M.PlacedTeam = Instigator.PlayerReplicationInfo.Team.TeamIndex;
    }
    NetUpdateTime = Level.TimeSeconds-1;
}
final function RemoveMine( HopMineProj M )
{
    --NumMinesOut;
    M.WeaponOwner = None;
    NetUpdateTime = Level.TimeSeconds-1;
}

// simulated function RenderOverlays( Canvas Canvas )
// {
    // Super.RenderOverlays(Canvas);
    // Canvas.SetDrawColor(255,255,255,255);
    // Canvas.Font = Canvas.MedFont;
    // Canvas.SetPos(25,Canvas.ClipY*0.5);
    // Canvas.DrawText(MinesText$NumMinesOut$"/"$MaximumMines,false);
// }

/*
function GiveTo(Pawn Other, optional Pickup Pickup)
{
    local HopMineProj P;

    Super.GiveTo(Other,Pickup);
    NumMinesOut = 0;
    foreach DynamicActors(Class'HopMineProj',P)
    {
        if( P.InstigatorController==Other.Controller && !P.bNeedsDetonate )
        {
            P.Instigator = Other;
            P.WeaponOwner = Self;
            ++NumMinesOut;
        }
        else if( P.WeaponOwner==Self )
            P.WeaponOwner = None;
    }
}
*/

defaultproperties
{
    RotateRate=500
    FakedHopMineOffset=(X=0,Y=0,Z=0.32)
    Weight=6
    MaximumMines=254
    MinesText="Mines: "
    FireModeClass(0)=Class'ScrnWeaponPack.HopMineFire'
     Description="The prototype of Hopmine launcher. Alpha version. Have some serious bugs like mines are detonated by each other. But still can be very useful."
    PickupClass=Class'ScrnWeaponPack.HopMineLPickup'
    ItemName="HopMine Launcher SE"
    AppID=0
}
