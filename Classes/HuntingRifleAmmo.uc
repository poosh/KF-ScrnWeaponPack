//=============================================================================
// HuntingRifle Rifle Ammo.
//=============================================================================
class HuntingRifleAmmo extends KFAmmunition;

#EXEC OBJ LOAD FILE=InterfaceContent.utx

defaultproperties
{
     AmmoPickupAmount=10
     MaxAmmo=70
     InitialAmount=25
     PickupClass=class'HuntingRifleAmmoPickup'
     IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
     IconCoords=(X1=338,Y1=40,X2=393,Y2=79)
     ItemName=".308 AP"
}
