

// --------------------------------------------------------------------------
Class Bush1 : Actor
{
	Default
	{
		Radius 12;
		Height 24;
		+SOLID
	}

	States
	{
		Spawn:
			BUS1 A -1;
			Stop;
	}
}

Class Bush2 : Bush1
{
	States
	{
		Spawn:
			BUS1 B -1;
			Stop;
	}
}

Class Bush3 : Bush1
{
	States
	{
		Spawn:
			BUS1 C -1;
			Stop;
	}
}

Class BushTall1 : Actor
{
	Default
	{
		Radius 12;
		Height 46;
		+SOLID
	}

	States
	{
		Spawn:
			BUS1 D -1;
			Stop;
	}
}

Class BushTall2 : Bush1
{
	States
	{
		Spawn:
			BUS1 E -1;
			Stop;
	}
}

Class BushTall3 : BushTall1
{
	States
	{
		Spawn:
			BUS1 F -1;
			Stop;
	}
}

// --------------------------------------------------------------------------
Class GrassSpawn : Actor
{
	Default
	{
		//$arg0 spawn area size X
		//$arg1 spawn area size Y
		//$arg2 density of tufts
		Radius 8;
		Scale 0.3;
	}

    override void PostBeginPlay()
    {
    	frame = random(0,4); 		// set this object to a random frame
    	Args[2] = Args[0] * Args[1] * Args[2] * 0.0001;
    	while ( Args[2] > 0 )
    	{
    		A_SpawnItemEx("GrassTuft1", Random(0,Args[1]), Random(0,Args[0])-Args[0], 0, 0, 0, 0, 0, SXF_CLIENTSIDE, 0);
    		Args[2]--;
    	}

		Super.PostBeginPlay();
    }


	States
	{
		Spawn:
			GRAS # -1;
			Stop;
      }
}

Class GrassSpawnDead : GrassSpawn
{
	Default
	{
		//$arg0 spawn area size X
		//$arg1 spawn area size Y
		//$arg2 density of tufts
		Radius 8;
		Scale 0.3;
	}

    override void PostBeginPlay()
    {
    	frame = random(0,4); 		// set this object to a random frame
    	Args[2] = Args[0] * Args[1] * Args[2] * 0.0001;
    	while ( Args[2] > 0 )
    	{
    		A_SpawnItemEx("GrassTuft2", Random(0,Args[1]), Random(0,Args[0])-Args[0], 0, 0, 0, 0, 0, SXF_CLIENTSIDE, 0);
    		Args[2]--;
    	}

		Super.PostBeginPlay();
    }

	States
	{
		Spawn:
			GRAB # -1;
			Stop;
      }
}

Class GrassTuft1 : Actor // green grass
{
	Default
	{
		Radius 8;
		Scale 0.5;

		+NOTARGET
		+NOBLOCKMAP
		+NOINTERACTION
		+CLIENTSIDEONLY

	}

    override void PostBeginPlay()
    {
		frame = random(0,4); // pick between 5 available frames
		scale.x = random(5,10) * 0.05;
		scale.y = scale.x;
		if ( !random(0,1) ) scale.x = -scale.x; // randomly mirror on x axis
		Super.PostBeginPlay();
    }

	States
	{
		Spawn:
			GRAS "#" -1;
			stop;
	}	
}

Class GrassTuft2 : GrassTuft1 // brown grass
{
	States
	{
		Spawn:
			GRAB "#" -1;
			stop;
	}		
}

// --------------------------------------------------------------------------
Class SeaWeed : Actor
{
	States
	{
		Spawn:
			CWED AB 12;
			Loop;
	}
}

// --------------------------------------------------------------------------

Class Tree1 : Actor
{
	Default
	{
		Radius 8;
		Height 46;

		+SOLID
		+NOGRAVITY
	}	

	States
	{
		Spawn:
			TREE A -1;
			Stop;
	}
}

Class Tree2 : Tree1
{
	Default
	{
		Height 56;
	}

	States
	{
		Spawn:
			TREE C -1;
			Stop;
	}
}

Class Tree3 : Tree1
{
	Default
	{
		Height 72;
	}

	States
	{
		Spawn:
			TREE B -1;
			Stop;
	}
}

Class Tree4 : Tree1
{
	Default
	{
		Height 72;
	}

	States
	{
		Spawn:
			TREE D -1;
			Stop;
	}
}

Class Tree5 : Tree1
{
	Default
	{
		Height 72;
	}

	States
	{
		Spawn:
			TREE E -1;
			Stop;
	}
}

Class Tree6 : Tree1
{
	Default
	{
		Height 72;
	}

	States
	{
		Spawn:
			TREE F -1;
			Stop;
	}
}

Class Tree7 : Tree1
{
	Default
	{
		Height 72;
	}

	States
	{
		Spawn:
			TREE G -1;
			Stop;
	}
}

// --------------------------------------------------------------------------
Class Waterlily : Actor
{
	Default
	{
		Radius 16;
		Height 16;
		Scale 0.5;

		+NOGRAVITY
		+FORCEXYBILLBOARD
	}	

	States
	{
		Spawn:
			LILY A -1;
			Stop;
	}
}