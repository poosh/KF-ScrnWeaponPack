class RPGPickup extends KFWeaponPickup;

#exec OBJ LOAD FILE=KillingFloorWeapons.utx


defaultproperties
{
     Weight=11.000000
     cost=4000
     AmmoCost=40
     BuyClipSize=1
     PowerValue=100
     SpeedValue=20
     RangeValue=64
     Description="RPG-7 Rocket Launcher. Very high damage, but narrow blast radius."
     ItemName="RPG-7 SE"
     ItemShortName="RPG-7 SE"
     AmmoItemName="RPG Rockets"
     //showMesh=SkeletalMesh'ScrnWeaponPack_A.RPG7_3rd'
     AmmoMesh=StaticMesh'ScrnWeaponPack_SM.Rocket'
     CorrespondingPerkIndex=6
     EquipmentCategoryID=3
     SellValue=300
     MaxDesireability=0.790000
     InventoryType=Class'ScrnWeaponPack.RPG'
     RespawnTime=60.000000
     PickupMessage="You got the RPG-7"
     PickupSound=Sound'KF_LAWSnd.LAW_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'ScrnWeaponPack_SM.RPG7'
     CollisionRadius=35.000000
     CollisionHeight=6.000000
}
