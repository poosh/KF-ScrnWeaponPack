class VALDTPickup extends KFWeaponPickup;

defaultproperties
{
     Weight=7 //5
     cost=2500
     AmmoCost=23
     BuyClipSize=20
     PowerValue=50
     SpeedValue=95
     RangeValue=50
     Description="The AS VAL (Avtomat Specialnyj Val or Special Assault Rifle) is a Soviet designed assault rifle featuring an integrated suppressor. It was developed during the late 1980s by TsNIITochMash (Central Institute for Precision Machine Building) and is used by Russian Spetsnaz special forces and select units of the Russian Army. Loaded with a lower-cost version of 9x39mm rounds: PAB-9."
     ItemName="AS VAL SE"
     ItemShortName="VAL SE"
     AmmoItemName="9x39mm PAB-9"
     //showMesh=SkeletalMesh'ScrnWeaponPack_T.VAL.ValDT3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=class'VALDTAssaultRifle'
     PickupMessage="You've got a AS 'VAL'"
     PickupSound=Sound'KF_AK47Snd.AK47_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'ScrnWeaponPack_SM.ValDT_sm'
     DrawScale=1.300000
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
