//==================================================
// Colt Python Pickup.
//==================================================
class ColtPickup extends ScrnRevolverPickup;

defaultproperties
{
     Weight=5
     cost=1750
     AmmoCost=30
     BuyClipSize=6
     PowerValue=85
     SpeedValue=20
     RangeValue=35
     CorrespondingPerkIndex=8
     Description="Horzine modified Colt Python to .50 xAE expansive Action-Express (xAE) rounds. Horzine xAE rounds combine the best of two worlds (AP+HP): they penetrate armor and weak targets but expand inside strong targets, dealing massive damage."
     ItemName="Colt .50 xAE"
     ItemShortName="Colt .50 xAE"
     AmmoItemName=".50 xAE"
     EquipmentCategoryID=1
     InventoryType=class'Colt'
     PickupMessage="You got the Colt .50 AE"
     PickupSound=Sound'KF_9MMSnd.9mm_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'ScrnWeaponPack_SM.WColt_Pickup'
     CollisionHeight=5.000000
}
