class SW500MagnumPickup extends ScrnRevolverPickup;

defaultproperties
{
    Weight=5
    cost=1750
    AmmoCost=30
    BuyClipSize=5
    PowerValue=85
    SpeedValue=20
    RangeValue=35
    CorrespondingPerkIndex=8
    EquipmentCategoryID=1
    Description=".500 S&W Magnum is a .50 caliber revolver with increased armor-piercing capability. Press altfire to attach/detach scope."
    ItemName=".500 S&W Magnum Revolver"
    ItemShortName=".500 Magnum"
    AmmoItemName=".50"
    InventoryType=Class'SW500Magnum'
    PickupMessage="You got the .500 S&W Magnum Revolver"
    PickupSound=Sound'KF_HandcannonSnd.50AE_Pickup'
    PickupForce="AssaultRiflePickup"
    StaticMesh=StaticMesh'ScrnWeaponPack_SM.500Magnum_SM.500magnum_pickup'
    CollisionHeight=5.000000
}
