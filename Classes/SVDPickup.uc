class SVDPickup extends KFWeaponPickup;

#exec OBJ LOAD FILE=ScrnWeaponPack_T.utx
#exec OBJ LOAD FILE=ScrnWeaponPack_A.ukx

defaultproperties
{
     Weight=10.000000
     cost=4500
     AmmoCost=45
     BuyClipSize=10
     PowerValue=90
     SpeedValue=40
     RangeValue=100
     Description="The Dragunov sniper rifle (formally Russian: Snayperskaya Vintovka Dragunova, SVD) is a semi-automatic sniper rifle/designated marksman rifle chambered in 7H1 sniper rounds and developed in the Soviet Union."
     ItemName="SVD (Dragunov) SE"
     ItemShortName="SVD SE"
     AmmoItemName="7H1 Sniper Rounds"
     CorrespondingPerkIndex=2
     EquipmentCategoryID=2
     InventoryType=class'SVD'
     PickupMessage="You've got the Dragunov Sniper Rifle (SVD)"
     PickupSound=Sound'ScrnWeaponPack_SND.SVD.SVD_pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'ScrnWeaponPack_SM.SVD_st'
     CollisionRadius=30.000000
     CollisionHeight=5.000000
}
