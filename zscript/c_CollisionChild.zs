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
		+USESPECIAL
		Activation THINGSPEC_Activate | THINGSPEC_ThingTargets;
	}


	override void PostBeginPlay()
	{		
		// match size of debug model to radius and height
		scale.x = radius / 32;
		scale.y = height / 64;

		// set initial position
		A_Warp(AAPTR_MASTER, xoff, yoff, zoff, 0, WARPF_NOCHECKPOSITION);

		// destroy if above ceiling
		if (pos.z + height > ceilingz) self.destroy();

		Super.PostBeginPlay();
	}


	override void Tick()
	{	
		if (master)
		{
			if (!master.target) // if parent not picked up
			{
				// enable collision
				A_ChangeLinkFlags(false);

		 		// if velocity is greater than the parent object, transfer velocity to it
				if (vel != (0,0,0))
				{
					if (vel.x > master.vel.x) master.vel.x = vel.x;
					if (vel.y > master.vel.y) master.vel.y = vel.y;
					//master.A_ChangeVelocity(vel.x, vel.y, master.vel.z, CVF_REPLACE);
				}

				if (master.vel != (0,0,0))// if parent is moving
				{
					// reposition relative to parent object
					A_Warp(AAPTR_MASTER, xoff, yoff, zoff, 0, WARPF_NOCHECKPOSITION);
					angle = 0 ;//AngleTo(master, true);					
				}

				vel = vel * PushFactor;


/*					// get angle from master to self, like when spawned
					double getangle = master.AngleTo(self, true);

					// if it has changed
					if ( getangle != self.angle )
					{	
						// add the difference to master
						master.angle = deltaangle(master.angle, master.AngleTo(self, false));
						//self.angle = getangle;
					}*/
			}
			else
			{
				// disable collision if parent is being held
				A_ChangeLinkFlags(true);
			}
		}
		else
		{
			// parent is gone
			self.Destroy();
		}

		Super.Tick();
	}


	override bool CanCollideWith(actor other,bool passive)
	{
        if (other && passive)
        {
        	if (other == master || other.master == master)
        	{
	        	return false;        		
        	}
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
			// pass pick up attempt on to parent object
			#### # 1
				{
					if (master && target)
					{
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
				if (yspacing == 0) return;
			}
		}
	}


}

