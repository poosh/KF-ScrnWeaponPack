class AK12Pickup extends KFWeaponPickup;

defaultproperties
{
    Weight=6
    cost=2750
    AmmoCost=15
    BuyClipSize=30
    PowerValue=55
    SpeedValue=80
    RangeValue=30
    Description="The Kalashnikov AK-12 (formerly AK-400) is the newest derivative of the Soviet/Russian AK-74 series of assault rifles and was proposed for possible general issue to the Russian Army. This version uses the 5.45x39mm ammo (the same as AK-74)"
    ItemName="AK-12 SE"
    ItemShortName="AK-12 SE"
    AmmoItemName="5.45x39mm"
    AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
    CorrespondingPerkIndex=3
    EquipmentCategoryID=2
    InventoryType=class'AK12AssaultRifle'
    PickupMessage="You got the AK-12"
    PickupSound=Sound'ScrnWeaponPack_SND.AK12.AK12_select'
    PickupForce="AssaultRiflePickup"
    StaticMesh=StaticMesh'ScrnWeaponPack_SM.AK12_st'
    DrawScale=1.1
    CollisionRadius=25.000000
    CollisionHeight=5.000000
}
