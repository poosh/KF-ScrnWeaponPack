class MedicPistolPickup extends KFWeaponPickup;

defaultproperties
{
     Weight=2.000000
     cost=900
     AmmoCost=42
     BuyClipSize=7
     PowerValue=20
     SpeedValue=50
     RangeValue=35
     Description="Primary fire shoots healing darts. Darts heal zeds too, but it doesn't help them much, if titanium needle breaks their skulls first. Shooting multiple dart into the same zed may cause overdose. Alternate fire switch between laser and flashlight."
     ItemName="KF2 Medic Pistol SE"
     ItemShortName="KF2 Medic Pistol SE"
     AmmoItemName="Healing Darts"
     AmmoMesh=StaticMesh'KillingFloorStatics.DualiesAmmo'
     CorrespondingPerkIndex=0
     EquipmentCategoryID=1
     InventoryType=class'MedicPistol'
     PickupMessage="You got the Medic Pistol"
     PickupSound=Sound'KF_9MMSnd.9mm_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'ScrnWeaponPack_SM.MedicPistol_Pickup'
     DrawScale=0.100000
     CollisionHeight=5.000000
}
