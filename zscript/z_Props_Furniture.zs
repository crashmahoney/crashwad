//=======================================================
class BedH1 : LiftableActor {
	Default
	{
		Radius 33;
		Height 37;
		Mass 200;
		PushFactor 0.2;
		-NOGRAVITY
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
	
	override void Tick()
	{
		if (!target && LookForPlayers(true) == true)
		{
			A_ClearTarget(); // checking for player gives a target, so we clear it		
			for (int i = -32; i <= 32; i += 64)
			{
				actor mo = Actor.Spawn("CollisionChild", Vec3Angle( i, self.Angle, 0, false ), NO_REPLACE);
				if (mo)
				{
					mo.A_SetSize(33, 37, false);
					mo.Angle = self.Angle;
					mo.master = self;
					mo.mass = mass;
					mo.pushfactor = pushfactor;
				}
			}
		}
		Super.Tick();
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
class Chair2 : LiftableActor {
	Default
	{
		Radius 34;
		Height 24;
		+SOLID
		+PUSHABLE
		+SLIDESONWALLS
		+WINDTHRUST
		+SHOOTABLE
		+NOTARGET
		+NOTAUTOAIMED
		+NOBLOOD
	}

	override void Tick()
	{		
		Super.Tick();
		Crash.SpawnCollisionChild(self, -24, -32, 32, 16, 16, 8, 24);
		if (pos.z + height > ceilingz) self.destroy();
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
	
	override void Tick()
	{		
		Super.Tick();

		Crash.SpawnCollisionChild(self, -16, -14, 14, 14, 32, 4, 16);
		if (pos.z + height > ceilingz) self.destroy();
	}

	States
	{
		Spawn:
			PLAY A -1;
			stop;			
	}

}

// --------------------------------------------------------
class CollisionChild : InvisibleBridge8
{
	Default
	{
		+NOTARGET
		+SHOOTABLE
		+SOLID
		+NOTAUTOAIMED
		+PUSHABLE
		+NOTAUTOAIMED
		+NOBLOOD
		+THRUSPECIES
	}

	override void Tick()
	{	
	// if velocity is greater than the parent object, transfer velocity to it
		if (vel != (0,0,0) && master && master.vel == (0,0,0))
		{
			master.vel.x = vel.x * PushFactor;
			master.vel.y = vel.y * PushFactor;
			self.destroy();
		}
		Super.Tick();
	}

	override bool CanCollideWith(actor other,bool passive)
	{
        if (other && passive && other == master)
        {
        //	if (master is "Chair3") a_log("self collision chair3");
        	return false;
        }
			return true;
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
Class Table1 : LiftableActor {
	Default
	{
		Radius 4;
		Height 31;
		PushFactor 0.2;
		Mass 70;
		Threshold 32;
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
	
	override void Tick()
	{		
		Super.Tick();
		Crash.SpawnCollisionChild(self, 0, 0, 2, 1, 32, 40, 8);
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