//=============================================================================
// Shotgun Fire
//=============================================================================
class SpasAltFire extends SpasFire;

//copypaste for recoil to apply to firemode 1
simulated function HandleRecoil(float Rec)
{
    local rotator NewRecoilRotation;
    local KFPlayerController KFPC;
    local KFPawn KFPwn;
    local vector AdjustedVelocity;
    local float AdjustedSpeed;

    if( Instigator != none )
    {
        KFPC = KFPlayerController(Instigator.Controller);
        KFPwn = KFPawn(Instigator);
    }

    if( KFPC == none || KFPwn == none )
        return;

    if( !KFPC.bFreeCamera )
    {
        if( Weapon.GetFireMode(1).bIsFiring )
        {
              NewRecoilRotation.Pitch = RandRange( maxVerticalRecoilAngle * 0.5, maxVerticalRecoilAngle );
             NewRecoilRotation.Yaw = RandRange( maxHorizontalRecoilAngle * 0.5, maxHorizontalRecoilAngle );

              if( Rand( 2 ) == 1 )
                 NewRecoilRotation.Yaw *= -1;

            if( Weapon.Owner != none && Weapon.Owner.Physics == PHYS_Falling &&
                Weapon.Owner.PhysicsVolume.Gravity.Z > class'PhysicsVolume'.default.Gravity.Z )
            {
                AdjustedVelocity = Weapon.Owner.Velocity;
                // Ignore Z velocity in low grav so we don't get massive recoil
                AdjustedVelocity.Z = 0;
                AdjustedSpeed = VSize(AdjustedVelocity);
                //log("AdjustedSpeed = "$AdjustedSpeed$" scale = "$(AdjustedSpeed* RecoilVelocityScale * 0.5));

                // Reduce the falling recoil in low grav
                NewRecoilRotation.Pitch += (AdjustedSpeed* 3 * 0.5);
                NewRecoilRotation.Yaw += (AdjustedSpeed* 3 * 0.5);
            }
            else
            {
                //log("Velocity = "$VSize(Weapon.Owner.Velocity)$" scale = "$(VSize(Weapon.Owner.Velocity)* RecoilVelocityScale));
                NewRecoilRotation.Pitch += (VSize(Weapon.Owner.Velocity)* 3);
                NewRecoilRotation.Yaw += (VSize(Weapon.Owner.Velocity)* 3);
            }

            NewRecoilRotation.Pitch += (Instigator.HealthMax / Instigator.Health * 5);
            NewRecoilRotation.Yaw += (Instigator.HealthMax / Instigator.Health * 5);
            NewRecoilRotation *= Rec;

             KFPC.SetRecoil(NewRecoilRotation,RecoilRate * (default.FireRate/FireRate));
        }
     }
}


defaultproperties
{
    KickMomentum=(X=-45.000000,Z=10.000000) //Pump action is (X=-85.000000,Z=15.000000)
    maxVerticalRecoilAngle=750
    maxHorizontalRecoilAngle=500
    FireRate=0.25
    FireAnim="Fire_Secondary"
    FireAimedAnim="Fire_Secondary_Iron"
    //FireEndAnim="Idle"
    FireAnimRate=0.95
    bWaitForRelease=False
    Spread=1500.000000
}
