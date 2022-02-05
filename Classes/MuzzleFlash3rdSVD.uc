class MuzzleFlash3rdSVD extends ROMuzzleFlash3rd;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    Emitters[0].SpawnParticle(10);
    Emitters[1].SpawnParticle(10);
}

defaultproperties
{
     Emitters(0)=SpriteEmitter'roeffects.ROMuzzleFlash3rd.SpriteEmitter4'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter5
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         UseVelocityScale=True
         Acceleration=(X=200.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.600000
         MaxParticles=50
         StartLocationOffset=(X=5.000000)
         StartLocationRange=(X=(Max=10.000000))
         UseRotationFrom=PTRS_Actor
         SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=25.000000,Max=50.000000))
         DrawStyle=PTDS_Brighten
         Texture=Texture'Effects_Tex.Weapons.MP3rdPmuzzle_smoke1frame'
         LifetimeRange=(Min=1.500000,Max=3.000000)
         StartVelocityRange=(X=(Min=50.000000,Max=175.000000),Y=(Min=-30.000000,Max=30.000000),Z=(Min=20.000000,Max=50.000000))
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=0.500000,RelativeVelocity=(X=0.200000,Y=0.200000,Z=0.200000))
         VelocityScale(2)=(RelativeTime=1.000000)
     End Object
     Emitters(1)=SpriteEmitter5

}
