//=============================================================================
// ColtAmmo
//=============================================================================
class ColtAmmo extends KFAmmunition;

#EXEC OBJ LOAD FILE=InterfaceContent.utx

defaultproperties
{
    AmmoPickupAmount=12
    MaxAmmo=60
    InitialAmount=30
    PickupClass=Class'ColtAmmoPickup'
    IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
    IconCoords=(X1=413,Y1=82,X2=457,Y2=125)
    ItemName=".50 xAP"
}
