//=======================================================
class BedH1 : LiftableActor {
	Default
	{
		Radius 33;
		Height 37;
		Mass 200;
		PushFactor 0.2;
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

		CollisionChild.SpawnChild(self, -32, 0, 0, 1, 0, 33, 37); // bottom
		CollisionChild.SpawnChild(self, 32, 0, 0, 1, 0, 33, 37); // bottom
		Super.PostBeginPlay();
	}

	States
	{
        Spawn:
            PLAY # -1;
            Stop;
    }
}

class Bed2 : BedH1
{
	override void PostBeginPlay()
	{
		frame = random(0,2);
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
class Chair1 : LiftableActor {
	Default
	{
		Radius 32;
		Height 24;
		Mass 250;
		PushFactor .2;
		FloatSpeed -16; // z height offset when held
		+FLOORCLIP
		+SOLID
		+PUSHABLE
		+SLIDESONWALLS
		+WINDTHRUST
		+SHOOTABLE
		+NOTARGET
		+NOTAUTOAIMED
		+NOBLOOD
        Tag "Couch";		
	}
	
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		CollisionChild.SpawnChild(self, 0, -64, 64, 128, 0, 32, 24); // bottom
		CollisionChild.SpawnChild(self, -24, -96, 96, 32, 25, 8, 23); // back
	}
	
	States
	{
	Spawn:
		PLAY A -1;
		Stop;
	}
}

//=======================================================
class Chair2 : LiftableActor {
	Default
	{
		Radius 30;
		Height 24;
		Mass 150;
		FloatSpeed -16; // z offset when held
		+SOLID
		+PUSHABLE
		+SLIDESONWALLS
		+WINDTHRUST
		+SHOOTABLE
		+NOTARGET
		+NOTAUTOAIMED
		+NOBLOOD
        Tag "Armchair";		
	}

	override void PostBeginPlay()
	{		
		Super.PostBeginPlay();
		CollisionChild.SpawnChild(self, -20, -24, 24, 24, 25, 8, 24);
	}

	States
	{
		Spawn:
			PLAY A -1;
			stop;			
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
        Tag "Wooden Chair";		
	}
	
	override void PostBeginPlay()
	{		
		Super.PostBeginPlay();
		CollisionChild.SpawnChild(self, -16, -8, 8, 16, 32, 4, 16);
	}

	States
	{
		Spawn:
			PLAY A -1;
			stop;			
	}

}

//=======================================================
class Stool1 : LiftableActor {
	Default
	{
		Radius 10;
		Height 32;
		Mass 35;
		PushFactor 0.5;	
		
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
class Table1 : LiftableActor {
	Default
	{
		Radius 4;
		Height 31;
		PushFactor 0.2;
		Mass 100;
		DefThreshold 32;
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
		Super.PostBeginPlay();
		CollisionChild.SpawnChild(self, 0, 0, 2, 1, 32, 40, 8);
		if (pos.z + height > ceilingz) self.destroy();
	}

	States
	{
		Spawn:
			PLAY A -1;
			stop;			
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