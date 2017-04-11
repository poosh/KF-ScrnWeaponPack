Class FakedHopMine extends Actor;

defaultproperties
{
	LifeSpan=0.000000
	Mesh=SkeletalMesh'ScrnWeaponPack_A.HopMineM'
	DrawType=DT_Mesh

	RemoteRole=ROLE_None
    bSkipActorPropertyReplication=true
    bReplicateMovement=false
    bUpdateSimulatedPosition=false
    bNetNotify=false
    bAlwaysRelevant=true
	
	Physics=PHYS_None
	bCollideActors=false
	bCollideWorld=false
	bBlockActors=false
	bBlockProjectiles=false
	bBlockHitPointTraces=false
	DrawScale=0.6	
}