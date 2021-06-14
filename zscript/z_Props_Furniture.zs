//=======================================================
class BedH1 : SolidModelBase {
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

// --------------------------------------------------------------------------
class Chair : LiftableActor
{
	Default
	{
		Height 30;
		Radius 15;
		Scale 1.4;
		Mass 25;
		PushFactor 0.75;

		+FLOORCLIP
		+SOLID
		+PUSHABLE
		+SLIDESONWALLS
		+WINDTHRUST
		+SHOOTABLE
		+NOTARGET
		+NOTAUTOAIMED
		+NOBLOOD
        Tag "Swivel Chair";
	}

	States
	{
		Spawn:
			CHAI A -1;
			stop;
		Pain:
			CHAI A 0 A_FaceTarget;
			TNT1 A 0 A_Recoil(50);
			Goto Spawn;
		Active:
 			CHAI A 0 A_PickUp;
			CHAI A 1 A_WarpToCarrier;
			Wait;   
		Inactive:
 			CHAI A 0 A_PutDown;		
			Goto Spawn; 			
	}
}

//=======================================================
class Chair1 : SolidModelBase {
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

//=======================================================
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
class Stool1 : LiftableActor {
	Default
	{
		Radius 10;
		Height 32;
		Mass 25;
		PushFactor 0.25;	
		
		+SOLID
		+PUSHABLE
		+SLIDESONWALLS
		+WINDTHRUST
		+Shootable
		+NOTARGET
		+NOTAUTOAIMED
		+NOBLOOD
    	+CANPASS
        Tag "Stool";
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
		Active:
 			PLAY A 0 A_PickUp;
			PLAY A 1 A_WarpToCarrier;
			Wait;   
		Inactive:
 			PLAY A 0 A_PutDown;		
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