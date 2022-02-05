class HK417Ammo extends KFAmmunition;

#EXEC OBJ LOAD FILE=InterfaceContent.utx

defaultproperties
{
    ItemName="7.62x51mm NATO AP"
    MaxAmmo=240
    InitialAmount=80
    AmmoPickupAmount=20
    PickupClass=Class'ScrnWeaponPack.HK417AmmoPickup'
    IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
    IconCoords=(X1=338,Y1=40,X2=393,Y2=79)
}
