
class LevelTransVars : Thinker
{
	bool Transitioning;
	vector3 Offset;
	double Angle;
	double Pitch;
	double Roll;
	vector3 Vel;


	LevelTransVars Init()
	{
		Transitioning = false;
		ChangeStatNum(STAT_STATIC); // persist between maps
		return self;
	}

	/*
	LevelTransVars Add(int i)
	{
		testVar += i;
		return self;
	}
	*/

	static LevelTransVars Get()
	{
		ThinkerIterator it = ThinkerIterator.Create("LevelTransVars", STAT_STATIC);
		let p = LevelTransVars(it.Next());
		if (p == null)
		{
			p = new("LevelTransVars").Init();
		}
		return p;
	}
}


class LevelTrans_Save play
{
	static void SaveVars (Actor activator, int tid)
	{
		let g = LevelTransVars.Get();
		
		// find map spot to get position offset from
		ActorIterator it = Level.CreateActorIterator(tid, "MapSpot");
		let spot = it.Next();
		
		if (spot == null)
		{
			Console.Printf(String.Format("No Map Spot with tid %d", tid));
		}

        // Only players
        if(activator && activator.player)
        {
		
			g.Transitioning = true;
		
			g.Offset.x = spot.pos.x - activator.pos.x;
			g.Offset.y = spot.pos.y - activator.pos.y;
			g.Offset.z = spot.pos.z - activator.pos.z;
			
			g.Vel = activator.Vel;
            g.Angle = activator.Angle;
            g.Pitch = activator.Pitch;
            g.Roll = activator.Roll;
			

			
        } else	{	Console.Printf(String.Format("No Activator??? whut"));	}

	}
}



class LevelTrans_Load : EventHandler
{
    override void PlayerEntered(PlayerEvent e)
    {
		let g = LevelTransVars.Get();
		
		if (g.Transitioning)
		{
			PlayerPawn player;
			
			// Iterate through all of the possible players in the game
			for (int i = 0; i < MAXPLAYERS; i++)
			{
				// If a player is in the game and has spawned...
				if (playeringame[i] && players[i].mo)
				{
					if (!player) { player = players[i].mo; } 	// Set the skybox to follow the first player who is in the game
					else { player = null; break; } 			// If there are multiple players, don't move the skybox
				}
			}
			
			Console.Printf(String.Format("Level Transition:"));
			Console.Printf(String.Format("%f %f %f", player.pos.x, player.pos.y, player.pos.z));

			player.A_Warp(AAPTR_DEFAULT, -g.offset.x, -g.offset.y, -g.offset.z, 0, WARPF_ABSOLUTEOFFSET);
			player.Vel = g.Vel;
			player.Pitch = g.Pitch;
			player.Angle = g.Angle;
			player.Roll = g.Roll;
			
			Console.Printf(String.Format("%f %f %f", player.pos.x, player.pos.y, player.pos.z));
			Console.Printf(String.Format("%f %f %f", g.offset.x, g.offset.y, g.offset.z));

			Console.Printf(String.Format("%f %f %f %f %f", g.vel.x, g.vel.y, g.vel.z, g.pitch, g.angle));
			Console.Printf(String.Format("%f %f %f %f %f", player.vel.x, player.vel.y, player.vel.z, player.pitch, player.angle));
		}
		
		g.Transitioning = false;

													
	}
	
}
