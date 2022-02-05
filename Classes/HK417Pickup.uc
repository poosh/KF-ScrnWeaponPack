class HK417Pickup extends KFWeaponPickup;

/*
function ShowDeagleInfo(Canvas C)
{
  C.SetPos((C.SizeX - C.SizeY) / 2,0);
  C.DrawTile( Texture'KillingfloorHUD.ClassMenu.Deagle', C.SizeY, C.SizeY, 0.0, 0.0, 256, 256);
}
*/

defaultproperties
{
     Weight=7 // 6
     cost=3500
     AmmoCost=35
     BuyClipSize=20
     PowerValue=60
     SpeedValue=30
     RangeValue=95
     Description="The Heckler&Koch HK417 is a designated marksman rifle. Uses 7.62x51mm NATO Armor-Piercing rounds."
     ItemName="HK417 AP"
     ItemShortName="HK417 AP"
     AmmoItemName="7.62x51mm NATO AP"
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=class'HK417AR'
     PickupMessage="You've got a HK417"
     PickupSound=Sound'ScrnWeaponPack_SND.HK417AR.HK417_pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'ScrnWeaponPack_SM.HK417_st'
     DrawScale=0.800000
     CollisionRadius=30.000000
     CollisionHeight=5.000000
}
