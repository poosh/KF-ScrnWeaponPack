class AKC74Pickup extends KFWeaponPickup;

defaultproperties
{
     Weight=4
     cost=600
     AmmoCost=15
     BuyClipSize=30
     PowerValue=44
     SpeedValue=90
     RangeValue=50
     Description="A variant of the AK-74 equipped with a side-folding metal shoulder stock."
     ItemName="AKS-74 SE"
     ItemShortName="AKS-74 SE"
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
