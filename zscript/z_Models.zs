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

Class ATM : Actor {
	Default {
		Radius 28;
		Height 120;
		+NOGRAVITY
		+SOLID
		  
		//Activation THINGSPEC_Switch|THINGSPEC_Deactivate
		+USESPECIAL
	}

	States {
		Spawn:
			PLAY A -1;
			Stop;
	}
}

//=======================================================
Class Barrier1 : Actor {
	Default {
		Radius 32;
		Height 64;
		
		
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
		Physics.AlignToSlope(self, self.Angle, self.Pitch);	// align
		Actor.Spawn("InvisibleBridgeBarrier1", Vec3Angle( 32, self.Angle - 90.f, 24, false ), NO_REPLACE);
		Actor.Spawn("InvisibleBridgeBarrier1", Vec3Angle( -32, self.Angle - 90.f, 24, false ), NO_REPLACE);
		Super.PostBeginPlay();
	}

	States {
		Spawn:
			PLAY A -1;
			Stop;
	}
}

class InvisibleBridgeBarrier1 : InvisibleBridge
{
	Default
	{
		Radius 32;
		Height 64;
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
Class Chair3 : SolidModelBase {
	Default
	{
		Radius 13;
		Height 24;
	}
	
	override void PostBeginPlay()
	{		
		actor mo = Actor.Spawn("Chairback3", Vec3Angle( -16, self.Angle, 24, false ), NO_REPLACE);
		if (mo)
		{
			mo.Angle = self.Angle;
		}
		
		Super.PostBeginPlay();
	}
}

Class Chairback3 : InvisibleBridge8
{
	override void PostBeginPlay()
	{
		for ( int i = -14; i <14; i += 7 )
		{
			actor mo = Actor.Spawn("InvisibleBridge8", Vec3Angle( i, self.Angle - 90.0, 0, false ), NO_REPLACE);
		}
		Super.PostBeginPlay();
	}
	Default
	{
		Radius 4;
		Height 24;
	}
}
//=======================================================
Class Crane3 : SolidModelBase {
	Default
	{
		Radius 78;
		Height 64;
	}
}
//=======================================================
Class Grate128 : SolidModelBase {
	Default
	{
		Radius 64;
		Height 3;
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
	Default
	{
		Radius 12;
		Height 3;
	}
}
//=======================================================
Class LiteF : SolidModelBase {
	Default
	{
		Radius 1;
		Height 1;
		+NOGRAVITY
		+NOCLIP
		-SOLID
	}
}
//=======================================================
Class LiteR : Actor {
	Default {
		Radius 18;
		Height 2;
		+NOGRAVITY
		+SPAWNCEILING
		
	}

	override void PostBeginPlay()
	{		

		actor mo = Actor.Spawn("LampPostGlow", Vec3Angle( 0, self.Angle, -80, false ), NO_REPLACE);
		if (mo)
		{
			mo.Scale.x = 0.5;
			mo.Scale.y = 0.5;
			mo.Alpha = 0.1;
		}
		mo = Actor.Spawn("LiteRSpotlight", Vec3Angle( 0, self.Angle, -8, false ), NO_REPLACE);
		if (mo)
		{
			mo.Angle = self.Angle;
			mo.Pitch = 90.0;
		}
		
		Super.PostBeginPlay();
	}

	States {
		Spawn:
			PLAY A -1;
			Stop;
	}
}


Class LiteRSpotlight : SpotLightAttenuated
{
	override void PostBeginPlay()
   {
      args[LIGHT_RED] = 100;
      args[LIGHT_GREEN] = 100;
      args[LIGHT_BLUE] = 100;
      args[LIGHT_INTENSITY] = 192;
      SpotInnerAngle = 30;
      SpotOuterAngle = 60;
      Super.PostBeginPlay();
   }
}

//=======================================================
Class Monkey : SolidModelBase {
	Default
	{
		Radius 32;
		Height 56;
	}
}
//=======================================================
Class Orb : SolidModelBase {
	Default
	{
		Radius 72;
		Height 128;
	}
}

Class Orb2 : Orb {

}

//=======================================================
Class Rail_B : SolidModelBase {
	Default {
		Radius 2;
		Height 3;
		+NOGRAVITY
		
		-SOLID

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
	Default
	{
		Radius 4;
		Height 36;
	}
	
	override void PostBeginPlay()
	{
		actor mo = Actor.Spawn("InvisibleBridgeTable1", Vec3Angle( 0, 0, 32, false ), NO_REPLACE);
		Super.PostBeginPlay();
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
}
//=======================================================

Class VendingMachine1 : SolidModelBase {
	Default
	{
		Radius 32;
		Height 96;
	}
}

//=======================================================
