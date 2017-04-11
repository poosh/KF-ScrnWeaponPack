//==================================================
// Colt Python Pickup.
//==================================================
class ColtPickup extends KFWeaponPickup;

defaultproperties
{
     Weight=5 // 3
     cost=1250 // 500
     AmmoCost=30
     BuyClipSize=6
     PowerValue=85
     SpeedValue=20
     RangeValue=35
     CorrespondingPerkIndex=8
     Description="The Colt Python is a double action handgun chambered for the .357 Magnum cartridge, built on Colt's large I-frame. Pythons have a reputation for accuracy, smooth trigger pull, and a tight cylinder lock-up."
     ItemName="Colt Python SE"
     ItemShortName="Colt SE"
     AmmoItemName=".357"
     EquipmentCategoryID=1
     InventoryType=Class'ScrnWeaponPack.Colt'
     PickupMessage="You got the Colt Python handgun"
     PickupSound=Sound'KF_9MMSnd.9mm_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'ScrnWeaponPack_SM.WColt_Pickup'
     CollisionHeight=5.000000
}
