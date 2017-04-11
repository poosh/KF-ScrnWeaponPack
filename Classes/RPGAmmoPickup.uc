//=============================================================================
// L.A.W Ammo Pickup.
//=============================================================================
class RPGAmmoPickup extends KFAmmoPickup;

defaultproperties
{
     AmmoAmount=4
     InventoryType=Class'ScrnWeaponPack.RPGAmmo'
     PickupMessage="You picked up an RPG-7 Rocket"
     StaticMesh=StaticMesh'KillingFloorStatics.LAWAmmo'
     DrawScale=0.500000
     CollisionRadius=40.000000
}
