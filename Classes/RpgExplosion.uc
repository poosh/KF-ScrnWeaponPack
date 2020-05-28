class RPGExplosion extends ScrnLAWExplosion;

defaultproperties
{   
Begin Object Class=SpriteEmitter Name=SpriteEmitter0
    FadeOut=True
    FadeIn=True
    RespawnDeadParticles=False
    SpinParticles=True
    UseSizeScale=True
    UseRegularSizeScale=False
    UniformSize=True
    AutomaticInitialSpawning=False
    BlendBetweenSubdivisions=True
    TriggerDisabled=False
    ResetOnTrigger=True
    ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
    ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
    FadeOutStartTime=0.500000
    FadeInEndTime=0.200000
    MaxParticles=3
    Name="SpriteEmitter0"
    StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
    UseRotationFrom=PTRS_Actor
    SpinCCWorCW=(X=1.000000)
    SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
    StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
    SizeScale(0)=(RelativeSize=1.000000)
    SizeScale(1)=(RelativeTime=0.140000,RelativeSize=3.000000)
    SizeScale(2)=(RelativeTime=1.000000,RelativeSize=7.000000)
    StartSizeRange=(X=(Min=20.000000,Max=30.000000),Y=(Min=20.000000,Max=30.000000),Z=(Min=45.000000,Max=50.000000))
    InitialParticlesPerSecond=500.000000
    DrawStyle=PTDS_AlphaBlend
    Texture=Texture'kf_fx_trip_t.Misc.smoke_animated'
    TextureUSubdivisions=8
    TextureVSubdivisions=8
    SecondsBeforeInactive=0.000000
    LifetimeRange=(Min=2.000000)
    StartVelocityRange=(X=(Max=300.000000))
    VelocityLossRange=(X=(Min=3.000000,Max=3.000000),Y=(Min=3.000000,Max=3.000000),Z=(Min=3.000000,Max=3.000000))
End Object
Emitters(0)=SpriteEmitter'SpriteEmitter0'


Begin Object Class=SpriteEmitter Name=SpriteEmitter1
    UseColorScale=True
    FadeOut=True
    FadeIn=True
    RespawnDeadParticles=False
    SpinParticles=True
    UseSizeScale=True
    UseRegularSizeScale=False
    UniformSize=True
    AutomaticInitialSpawning=False
    BlendBetweenSubdivisions=True
    TriggerDisabled=False
    ResetOnTrigger=True
    Acceleration=(X=50.000000,Y=50.000000,Z=50.000000)
    ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
    ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128,A=255))
    Name="SpriteEmitter1"
    StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
    UseRotationFrom=PTRS_Actor
    SpinCCWorCW=(X=1.000000)
    SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
    StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
    SizeScale(0)=(RelativeSize=1.000000)
    SizeScale(1)=(RelativeTime=0.500000,RelativeSize=3.000000)
    SizeScale(2)=(RelativeTime=1.000000,RelativeSize=5.000000)
    StartSizeRange=(X=(Min=30.000000,Max=50.000000),Y=(Min=30.000000,Max=50.000000),Z=(Min=45.000000,Max=50.000000))
    InitialParticlesPerSecond=500.000000
    DrawStyle=PTDS_AlphaBlend
    Texture=Texture'kf_fx_trip_t.Misc.smoke_animated'
    TextureUSubdivisions=8
    TextureVSubdivisions=8
    SecondsBeforeInactive=0.000000
    LifetimeRange=(Min=2.000000)
    StartVelocityRange=(X=(Min=175.000000,Max=550.000000),Y=(Min=-550.000000,Max=550.000000),Z=(Min=-550.000000,Max=550.000000))
    VelocityLossRange=(X=(Min=5.000000,Max=5.000000),Y=(Min=5.000000,Max=5.000000),Z=(Min=5.000000,Max=5.000000))
End Object
Emitters(1)=SpriteEmitter'SpriteEmitter1'

Begin Object Class=SpriteEmitter Name=SpriteEmitter2
    UseColorScale=True
    FadeOut=True
    FadeIn=True
    RespawnDeadParticles=False
    UseSizeScale=True
    UseRegularSizeScale=False
    UniformSize=True
    AutomaticInitialSpawning=False
    ColorScale(0)=(Color=(B=174,G=228,R=255,A=255))
    ColorScale(1)=(RelativeTime=0.200000,Color=(B=255,G=255,R=255,A=255))
    ColorScale(2)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
    ColorScale(3)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
    ColorScale(4)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
    FadeOutStartTime=0.102500
    FadeInEndTime=0.050000
    MaxParticles=2
    Name="SpriteEmitter2"
    SizeScale(1)=(RelativeTime=0.250000,RelativeSize=1.000000)
    SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.000000)
    StartSizeRange=(X=(Min=50.000000,Max=50.000000),Y=(Min=50.000000,Max=50.000000),Z=(Min=50.000000,Max=50.000000))
    InitialParticlesPerSecond=30.000000
    DrawStyle=PTDS_AlphaBlend
    Texture=Texture'Effects_Tex.explosions.radialexplosion_1frame'
    LifetimeRange=(Min=0.250000,Max=0.250000)
End Object
Emitters(2)=SpriteEmitter'SpriteEmitter2' 

Begin Object Class=SpriteEmitter Name=SpriteEmitter3
    UseColorScale=True
    FadeOut=True
    RespawnDeadParticles=False
    SpinParticles=True
    UseSizeScale=True
    UseRegularSizeScale=False
    UniformSize=True
    AutomaticInitialSpawning=False
    BlendBetweenSubdivisions=True
    Acceleration=(X=50.000000,Y=50.000000,Z=0.500000)
    ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
    ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128,A=255))
    FadeOutStartTime=0.990000
    MaxParticles=8
    Name="SpriteEmitter3"
    StartLocationRange=(X=(Min=-25.000000,Max=25.000000),Y=(Min=-25.000000,Max=25.000000))
    StartLocationShape=PTLS_Sphere
    SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
    StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
    SizeScale(0)=(RelativeTime=1.000000,RelativeSize=5.000000)
    StartSizeRange=(X=(Min=10.000000,Max=50.000000),Y=(Min=10.000000,Max=50.000000),Z=(Min=20.000000,Max=20.000000))
    InitialParticlesPerSecond=500.000000
    DrawStyle=PTDS_AlphaBlend
    Texture=Texture'kf_fx_trip_t.Misc.smoke_animated'
    TextureUSubdivisions=8
    TextureVSubdivisions=8
    SecondsBeforeInactive=0.000000
    LifetimeRange=(Min=1.000000,Max=3.000000)
    StartVelocityRange=(X=(Min=-300.000000,Max=300.000000),Y=(Min=-300.000000,Max=300.000000))
    VelocityLossRange=(X=(Min=3.000000,Max=3.000000),Y=(Min=3.000000,Max=3.000000),Z=(Min=3.000000,Max=3.000000))
End Object
Emitters(3)=SpriteEmitter'SpriteEmitter3'

Begin Object Class=SpriteEmitter Name=SpriteEmitter4
    FadeOut=True
    FadeIn=True
    RespawnDeadParticles=False
    UseSizeScale=True
    UseRegularSizeScale=False
    UniformSize=True
    AutomaticInitialSpawning=False
    BlendBetweenSubdivisions=True
    Acceleration=(Z=50.000000)
    ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
    ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
    FadeOutStartTime=0.102500
    FadeInEndTime=0.050000
    MaxParticles=2
    Name="SpriteEmitter4"
    SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.000000)
    SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.500000)
    StartSizeRange=(X=(Min=60.000000,Max=60.000000),Y=(Min=60.000000,Max=60.000000),Z=(Min=60.000000,Max=60.000000))
    InitialParticlesPerSecond=30.000000
    DrawStyle=PTDS_Brighten
    Texture=Texture'Effects_Tex.explosions.impact_2frame'
    TextureUSubdivisions=2
    TextureVSubdivisions=1
    LifetimeRange=(Min=0.200000,Max=0.200000)
    StartVelocityRange=(Z=(Min=10.000000,Max=10.000000))
End Object
Emitters(4)=SpriteEmitter'SpriteEmitter4'

Begin Object Class=SpriteEmitter Name=SpriteEmitter5
    FadeOut=True
    RespawnDeadParticles=False
    UseRevolution=True
    SpinParticles=True
    UseSizeScale=True
    UseRegularSizeScale=False
    UniformSize=True
    AutomaticInitialSpawning=False
    UseRandomSubdivision=True
    Acceleration=(Z=-1200.000000)
    DampingFactorRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
    ColorScale(0)=(Color=(B=25,G=25,R=25,A=255))
    ColorScale(1)=(RelativeTime=1.000000,Color=(B=82,G=84,R=95,A=255))
    FadeOutStartTime=1.400000
    MaxParticles=20
    Name="SpriteEmitter5"
    UseRotationFrom=PTRS_Actor
    SpinsPerSecondRange=(X=(Min=-0.200000,Max=0.200000))
    StartSpinRange=(X=(Min=0.500000,Max=0.500000))
    SizeScale(0)=(RelativeTime=1.000000,RelativeSize=5.000000)
    StartSizeRange=(X=(Min=1.000000,Max=3.000000),Y=(Min=1.000000,Max=3.000000),Z=(Min=3.000000,Max=5.000000))
    InitialParticlesPerSecond=500.000000
    DrawStyle=PTDS_AlphaBlend
    Texture=Texture'Effects_Tex.BulletHits.concrete_chunks'
    TextureUSubdivisions=2
    TextureVSubdivisions=2
    LifetimeRange=(Min=2.000000,Max=2.000000)
    StartVelocityRange=(X=(Min=800.000000,Max=1000.000000),Y=(Min=-500.000000,Max=500.000000),Z=(Min=-500.000000,Max=500.000000))
End Object
Emitters(5)=SpriteEmitter'SpriteEmitter5'

    //added lights
    LightType=LT_Steady
    LightBrightness=128.0 //128
    LightRadius=6.000000 //4.0
    LightHue=20 //made it a little bit more orange (old 25)
    LightSaturation=100
    LightCone=16
    bDynamicLight=false
}
