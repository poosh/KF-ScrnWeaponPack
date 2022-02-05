//=============================================================================
// 9mm Ammo.
//=============================================================================
class MedicPistolAmmo extends KFAmmunition;

#EXEC OBJ LOAD FILE=InterfaceContent.utx

defaultproperties
{
     AmmoPickupAmount=14
     MaxAmmo=98
     InitialAmount=21
     PickupClass=class'MedicPistolAmmoPickup'
     IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
     IconCoords=(X1=413,Y1=82,X2=457,Y2=125)
     ItemName="Healing Darts"
}
