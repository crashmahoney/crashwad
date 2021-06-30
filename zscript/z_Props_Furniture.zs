//=======================================================
class BedH1 : SolidModelBase {
	Default
	{
		Radius 33;
		Height 37;
		+FLOORCLIP
		+SOLID
		+PUSHABLE
		+SLIDESONWALLS
		+WINDTHRUST
		+SHOOTABLE
		+NOTARGET
		+NOTAUTOAIMED
		+NOBLOOD
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
 			goto Super::Active; 
		Inactive:
 			goto Super::Inactive; 			
	}
}

//=======================================================
class Chair1 : SolidModelBase {
	Default
	{
		Radius 34;
		Height 24;
		+FLOORCLIP
		+SOLID
		+PUSHABLE
		+SLIDESONWALLS
		+WINDTHRUST
		+SHOOTABLE
		+NOTARGET
		+NOTAUTOAIMED
		+NOBLOOD
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
class Chair3 : LiftableActor {
	Default
	{
		Radius 13;
		Height 24;
		Mass 25;
		PushFactor 0.75;

		-NOINTERACTION
		+NOTARGET
		+SHOOTABLE
		+SOLID
		+NOTAUTOAIMED
		+PUSHABLE
		+SLIDESONWALLS
		+WINDTHRUST
		+NOTAUTOAIMED
		+NOBLOOD
        Tag "Chair";		
	}
	
	override void Tick()
	{		
		if (InStateSequence(CurState, ResolveState("Spawn")))
		{
			actor mo = Actor.Spawn("ChairbackMain", Vec3Angle( -16, self.Angle, 24, false ), NO_REPLACE);
			if (mo)
			{
				mo.Angle = self.Angle;
			}
		}

		Super.Tick();
	}

	override bool CanCollideWith(actor other,bool passive)
	{
        if (other.GetClassName() == "ChairbackMain" || other.GetClassName() == "ChairbackChild")
        {
        	return false;
        }
			return true;
	}

	States
	{
		Spawn:
			PLAY A -1;
			stop;
		Pain:
			#### # 0 A_FaceTarget;
			#### # 0 A_Recoil(50);
			Goto Spawn;
		Active:
 			goto Super::Active; 
		Inactive:
 			goto Super::Inactive; 			
	}

}

class ChairbackMain : InvisibleBridge8
{
	override void PostBeginPlay()
	{
		for ( int i = -14; i <14; i += 7 )
		{
			actor mo = Actor.Spawn("ChairbackChild", Vec3Angle( i, self.Angle - 90.0, 0, false ), NO_REPLACE);
		}
		Super.PostBeginPlay();
	}

	Default
	{
		Radius 4;
		Height 24;
	}

	States
	{
		Spawn:
			TNT1 A 2;
			Stop;
	}
}

class ChairbackChild : InvisibleBridge8
{
	Default
	{
		Radius 4;
		Height 24;
	}

	States
	{
		Spawn:
			TNT1 A 2;
			Stop;
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
 			goto Super::Active; 
		Inactive:
 			goto Super::Inactive; 		
	}
}

//=======================================================
Class Table1 : SolidModelBase {
	Default
	{
		Radius 4;
		Height 36;
		+FLOORCLIP
		+SOLID
		+PUSHABLE
		+SLIDESONWALLS
		+WINDTHRUST
		+SHOOTABLE
		+NOTARGET
		+NOTAUTOAIMED
		+NOBLOOD		
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