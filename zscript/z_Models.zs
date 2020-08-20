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
		
		actor mo = Actor.Spawn("Chairback1", Vec3Angle( -24, self.Angle, 24, false ), NO_REPLACE);
		if (mo)
		{
			mo.Angle = self.Angle;
		}
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
		actor mo = Actor.Spawn("Chairback2", Vec3Angle( -24, self.Angle, 24, false ), NO_REPLACE);
		if (mo)
		{
			mo.Angle = self.Angle;
		}
		
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

Class Keyboard : SolidModelBase {
	Default {
		Radius 12;
		Height 3;
	}

	States {
		Spawn:
			PLAY A -1;
			Stop;
	}
}
//=======================================================
Class Stool1 : SolidModelBase {
	Default
	{
		Radius 10;
		Height 32;
		Mass 25;
		PushFactor 0.75;	
		
		+PUSHABLE;
		+SLIDESONWALLS;
		+WINDTHRUST;
		+Shootable;
		+NOTARGET;
		+NOTAUTOAIMED;
		+NOBLOOD;
		+NODROPOFF;
		-NOGRAVITY;
		-NODAMAGETHRUST

		MaxDropOffHeight 999999;
	}

	States
	{
	Spawn:
		PLAY A -1;
		Stop;
		
	Pain:
		PLAY A 0 A_FaceTarget;
		PLAY A 0 A_Recoil(20); 
		Goto Spawn;
	}
}
//=======================================================


Class Table1 : SolidModelBase {
	Default {
		Radius 4;
		Height 36;
		
		
		+SOLID
		+INVULNERABLE
		+NODAMAGE
		+SHOOTABLE
		+NOTAUTOAIMED
		+NEVERTARGET
		+DONTTHRUST
	}
	
	override void PostBeginPlay()
	{
		actor mo = Actor.Spawn("InvisibleBridgeTable1", Vec3Angle( 0, 0, 32, false ), NO_REPLACE);
		Super.PostBeginPlay();
	}
	
	States {
		Spawn:
			PLAY A -1;
			Stop;
	}
}

class InvisibleBridgeTable1 : InvisibleBridge
{
	Default
	{
		Radius 48;
		Height 8;
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
