class MuzzleFlash1stSVDS extends ROMuzzleFlash1st;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
	Emitters[0].SpawnParticle(1);
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         RespawnDeadParticles=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Opacity=0.100000
         MaxParticles=1
         StartSizeRange=(X=(Min=50.000000,Max=50.000000))
         DrawStyle=PTDS_Brighten
         Texture=Texture'Effects_Tex.Smoke.MuzzleCorona1stP'
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(0)=SpriteEmitter'ScrnWeaponPack.MuzzleFlash1stSVDS.SpriteEmitter0'

}
