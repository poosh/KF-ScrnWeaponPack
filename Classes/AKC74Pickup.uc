class AKC74Pickup extends KFWeaponPickup;

defaultproperties
{
     Weight=5.000000
     cost=1150
     AmmoCost=10
     BuyClipSize=30
     PowerValue=44
     SpeedValue=90
     RangeValue=50
     Description="The AK-74 is an assault rifle developed in the early 1970s in the Soviet Union as the replacement for the earlier AKM (itself a refined version of the AK-47). It uses a smaller intermediate cartridge, the 5.45x39mm, replacing the 7.62x39mm chambering of earlier Kalashnikov-pattern weapons. Smaller ammunition lowers damage, but makes weapon lighter."
     ItemName="AK-74 SE"
     ItemShortName="AK-74 SE"
     AmmoItemName="5.45x39mm"
     //showMesh=SkeletalMesh'ScrnWeaponPack_A.AKC74_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=Class'ScrnWeaponPack.AKC74AssaultRifle'
     PickupMessage="You've got a AK-74"
     PickupSound=Sound'ScrnWeaponPack_SND.AK74.akc74_holster'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'ScrnWeaponPack_SM.AKC74_ST'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
