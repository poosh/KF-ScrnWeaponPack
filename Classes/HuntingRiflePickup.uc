//=============================================================================
// HuntingRifle Pickup.
//=============================================================================
class HuntingRiflePickup extends KFWeaponPickup;

/*
function ShowDeagleInfo(Canvas C)
{
  C.SetPos((C.SizeX - C.SizeY) / 2,0);
  C.DrawTile( Texture'KillingfloorHUD.ClassMenu.Deagle', C.SizeY, C.SizeY, 0.0, 0.0, 256, 256);
}
*/

defaultproperties
{
    Weight=7.000000
    cost=650
    BuyClipSize=10
    PowerValue=55
    SpeedValue=42
    RangeValue=95
    Description="A recreational hunting weapon, featuring a firing trigger and a powerful integrated scope. Chambered with Armor-Piercing rounds."
    ItemName="Hunting Rifle AP"
    ItemShortName="Hunting Rifle AP"
    AmmoItemName=".308 AP"
    CorrespondingPerkIndex=2
    EquipmentCategoryID=2
    InventoryType=class'HuntingRifle'
    PickupMessage="You got the Hunting Rifle"
    PickupSound=Sound'KF_RifleSnd.RifleBase.Rifle_Pickup'
    PickupForce="AssaultRiflePickup"
    StaticMesh=StaticMesh'ScrnWeaponPack_SM.HR_Pickup'
    CollisionRadius=30.000000
    CollisionHeight=5.000000
}
