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
     Weight=8 // 6
     cost=3000
     AmmoCost=25
     BuyClipSize=16
     PowerValue=60
     SpeedValue=30
     RangeValue=95
     Description="The Heckler&Koch HK417 is a gas-operated, selective fire rifle with a rotating bolt and is essentially an enlarged HK416 assault rifle. Chambered for the full power 7.62x51mm AP NATO round, instead of a less powerful intermediate cartridge, the HK417 is intended for use as a designated marksman rifle, and in other roles where the greater penetrative power and range of the 7.62x51mm NATO round are required."
     ItemName="HK417 SE"
     ItemShortName="HK417 SE"
     AmmoItemName="7.62x51mm NATO AP"
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=Class'ScrnWeaponPack.HK417AR'
     PickupMessage="You've got a HK417"
     PickupSound=Sound'ScrnWeaponPack_SND.HK417AR.HK417_pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'ScrnWeaponPack_SM.HK417_st'
     DrawScale=0.800000
     CollisionRadius=30.000000
     CollisionHeight=5.000000
}
