class AK545Ammo extends KFAmmunition;

#EXEC OBJ LOAD FILE=KillingFloorHUD.utx

defaultproperties
{
     AmmoPickupAmount=30
     MaxAmmo=300
     InitialAmount=120
     IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
     IconCoords=(X1=336,Y1=82,X2=382,Y2=125)
     ItemName="5.45x39mm"
     PickupClass=Class'ScrnWeaponPack.AK545AmmoPickup'
}
