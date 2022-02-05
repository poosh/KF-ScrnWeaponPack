//=============================================================================
// Shotgun Pickup.
//=============================================================================
class SpasPickup extends KFWeaponPickup;

defaultproperties
{
     Weight=9
     cost=1500
     AmmoCost=
     BuyClipSize=10
     PowerValue=55
     SpeedValue=40
     RangeValue=17
     Description="The Franchi SPAS12 is a combat shotgun manufactured by Italian firearms company Franchi from 1979 to 2000. The SPAS12 is a dual-mode shotgun, adjustable for semi-automatic or pump-action operation."
     ItemName="SPAS-12 SE"
     ItemShortName="SPAS-12 SE"
     AmmoItemName="12-gauge shells"
     AmmoMesh=none
     InventoryType=class'Spas'
     PickupMessage="You got the spas-12."
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'ScrnWeaponPack_SM.spas12_pickup'
     DrawType=DT_StaticMesh
     CollisionRadius=35.000000
     CollisionHeight=5.000000
     PickupSound=Sound'KF_PumpSGSnd.SG_Pickup'
     EquipmentCategoryID=2
     CorrespondingPerkIndex=1
}
