//=============================================================================
// LAW Ammo.
//=============================================================================
class RPGAmmo extends KFAmmunition;

#EXEC OBJ LOAD FILE=KillingFloorHUD.utx
#EXEC OBJ LOAD FILE=ScrnWeaponPack_T.utx

defaultproperties
{
     AmmoPickupAmount=2
     MaxAmmo=10
     InitialAmount=6
     IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
     IconCoords=(X1=458,Y1=34,X2=511,Y2=78)
     ItemName="RPG Rockets"
}
