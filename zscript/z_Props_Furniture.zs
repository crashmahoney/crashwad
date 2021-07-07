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
		CollisionChild.SpawnChild(self, -28, -96, 96, 16, 25, 8, 23); // back
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
		CollisionChild.SpawnChild(self, -20, -24, 24, 12, 25, 8, 24);
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
		CollisionChild.SpawnChild(self, -16, -14, 14, 14, 32, 2, 16);
	}

	States
	{
		Spawn:
			PLAY A -1;
			stop;			
	}

}

// --------------------------------------------------------
class CollisionChild : SwitchableDecoration
{

	double xoff, yoff, zoff;

	Default
	{
		+SOLID
		+NOGRAVITY
		+NOLIFTDROP
		+ACTLIKEBRIDGE

		+NOTARGET
		+SHOOTABLE
		+NOTAUTOAIMED
		+PUSHABLE
		+NOTAUTOAIMED
		+NOBLOOD
		+THRUSPECIES
		+USESPECIAL
		Activation THINGSPEC_Activate | THINGSPEC_ThingTargets;
	}

	override void Tick()
	{	
		// match size of debug model to radius and height
		scale.x = radius / 32;
		scale.y = height / 64;

	//	if (pos.z + height > ceilingz) self.destroy();


		if (master)
		{
			if (!master.target) // if parent not picked up
			{
				/*if (bNOINTERACTION = true)*/ A_ChangeLinkFlags(false); // restore collision
				A_Warp(AAPTR_MASTER, xoff, yoff, zoff, 0, WARPF_NOCHECKPOSITION);
				angle = 0 ;//AngleTo(master, true);

		 		// if velocity is greater than the parent object, transfer velocity to it
				if (vel != (0,0,0) && master.vel == (0,0,0))
				{
/*					// get angle from master to self, like when spawned
					double getangle = master.AngleTo(self, true);

					// if it has changed
					if ( getangle != self.angle )
					{	
						// add the difference to master
						master.angle = deltaangle(master.angle, master.AngleTo(self, false));
						//self.angle = getangle;
					}*/

					master.vel.x = vel.x * PushFactor;
					master.vel.y = vel.y * PushFactor;

				}
			}
			else
			{
				A_ChangeLinkFlags(true); // nointeraction true
			}
		}
		else
		{
			self.Destroy();
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
			//PLAY A -1;
			TNT1 A -1;
			Stop;
		Active:
			#### # 1
				{
					if (master && target)
					{
						A_Log("active");
						target.target = master; 		// set player target to parent
						master.target = target; 		// set parent target to player
						master.SetStateLabel("Active");	// set parent active

						self.activationtype |= THINGSPEC_Activate;	// set flag
						self.A_ClearTarget();
					}
					else { a_log("child didn't have either target or master"); }
				}
			Goto Spawn;	
	}



	//---------------------------------------------------------------------------
	// function to spawn a row of collision objects along the y axis + angle of given actor
	//---------------------------------------------------------------------------	
	static void SpawnChild(Actor parent, double xoffset, double ystart, double yend, double yspacing, double zoffset, int radius, int height)
	{
		for ( int i = ystart; i <= yend; i += yspacing )
		{			
			Actor mo = actor.Spawn("CollisionChild", parent.pos, NO_REPLACE);
			if (mo)
			{
				let mo = CollisionChild(mo);
				mo.A_SetSize(radius, height, false);
				mo.master = parent;
				mo.mass = parent.mass;
				mo.pushfactor = parent.pushfactor;
				mo.angle = mo.AngleTo(parent, true);
				mo.xoff = xoffset;
				mo.yoff = i;
				mo.zoff = zoffset;
			}
		}
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
Class Table1 : LiftableActor {
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