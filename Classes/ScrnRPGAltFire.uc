class ScrnRPGAltFire extends NoFire;

function DrawMuzzleFlash(Canvas Canvas)
{
}

function FlashMuzzleFlash()
{
}

function StartMuzzleSmoke()
{
}

event ModeDoFire()
{
	if (!AllowFire())
		return;

	if( Instigator==None || Instigator.Controller==none )
		return;

    //do nothing
}

event ModeHoldFire()
{
}

simulated function bool AllowFire()
{
    //if( Level.TimeSeconds - LastClickTime>FireRate )
    //{
    	//LastClickTime = Level.TimeSeconds;
        return true;
    //}
    //else
    //{
        return false;
    //}
}

function ServerPlayFiring()
{
    KFWeapon(Weapon).ZoomOut(false);
}

function PlayPreFire()
{
}

function PlayFiring()
{
    KFWeapon(Weapon).ZoomOut(false);
    if ( Weapon.Mesh != none )
    {
        Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
    }
}

function PlayFireEnd()
{
}

function float MaxRange()
{
	return 0;
}


defaultproperties
{    
    FireAnim="ScopeAttach"
    FireRate=1.0
    bModeExclusive = true
}
