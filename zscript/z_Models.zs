Class SolidModelBase : Actor {
	Default {
		Radius 32;
		Height 96;
		
		-NOINTERACTION
		+NOTARGET
		+SOLID
		+NOGRAVITY
		+INVULNERABLE
		+NODAMAGETHRUST
		+NOTAUTOAIMED
	}

	States {
		Spawn:
			PLAY A -1;
			Stop;
	}
}
//=======================================================

Class BedH1 : SolidModelBase {
	Default
	{
		Radius 33;
		Height 37;
		-NODAMAGETHRUST
	}
	
	override void PostBeginPlay()
	{
		Actor.Spawn("InvisibleBridge32", Vec3Angle( 32, self.Angle, 24, false ), NO_REPLACE);
		Actor.Spawn("InvisibleBridge32", Vec3Angle( -32, self.Angle, 24, false ), NO_REPLACE);
		Super.PostBeginPlay();
	}
	
	States
	{
	Spawn:
		PLAY A -1;
		Stop;
	}
}
//=======================================================

Class Chair1 : SolidModelBase {
	Default
	{
		Radius 34;
		Height 24;
	}
	
	override void PostBeginPlay()
	{
		Actor.Spawn("InvisibleBridge32", Vec3Angle( 64, self.Angle - 90.0, 16, false ), NO_REPLACE);
		Actor.Spawn("InvisibleBridge32", Vec3Angle( -64, self.Angle - 90.0, 16, false ), NO_REPLACE);
		
		actor chairback = Actor.Spawn("Chairback1", Vec3Angle( -24, self.Angle, 24, false ), NO_REPLACE);
		chairback.Angle = self.Angle;
		Super.PostBeginPlay();
	}
	
	States
	{
	Spawn:
		PLAY A -1;
		Stop;
	}
}

Class Chairback1 : InvisibleBridge8
{
	override void PostBeginPlay()
	{
		for ( int i = -80; i <80; i += 16 )
		{
			Actor.Spawn("InvisibleBridge8", Vec3Angle( i, self.Angle - 90.0, 16, false ), NO_REPLACE);
		}
		Super.PostBeginPlay();
	}
	Default
	{
		Height 24;
	}
}
//-------------------------------------------------------

Class Chair2 : SolidModelBase {
	Default
	{
		Radius 34;
		Height 24;
	}
	
	override void PostBeginPlay()
	{		
		actor chairback = Actor.Spawn("Chairback2", Vec3Angle( -24, self.Angle, 24, false ), NO_REPLACE);
		chairback.Angle = self.Angle;
		Super.PostBeginPlay();
	}
	
	States
	{
	Spawn:
		PLAY A -1;
		Stop;
	}
}

Class Chairback2 : InvisibleBridge8
{
	override void PostBeginPlay()
	{
		for ( int i = -32; i <32; i += 16 )
		{
			Actor.Spawn("InvisibleBridge8", Vec3Angle( i, self.Angle - 90.0, 16, false ), NO_REPLACE);
		}
		Super.PostBeginPlay();
	}
	Default
	{
		Height 24;
	}
}
//=======================================================


Class IVStand : SolidModelBase {
	Default
	{
		Radius 8;
		Height 64;
		RenderStyle "Translucent";
		Mass 25;
		PushFactor 0.75;
		+PUSHABLE;
		+SLIDESONWALLS
	}

	States
	{
	Spawn:
		PLAY A -1;
		Stop;
	}
}
//=======================================================

Class Toilet : SolidModelBase {
	Default
	{
		Radius 16;
		Height 25;
	}
	
	override void PostBeginPlay()
	{
		Actor.Spawn("InvisibleBridge16", Vec3Angle( -24, self.Angle, 46, false ), NO_REPLACE);
		Super.PostBeginPlay();
	}

	States
	{
	Spawn:
		PLAY A -1;
		stop;
	}
}
//=======================================================

Class VendingMachine1 : SolidModelBase {
	Default {
		Radius 32;
		Height 96;
	}

	States {
		Spawn:
			PLAY A -1;
			Stop;
	}
}

//=======================================================
