//===============================================================
//	Dynamic Difficulty
//===============================================================
struct DifficultyData
{
	int playergrade;
	int playerlasthealth;
	int monsterlastcount;
	int spawnlevel;
	float babyarmour;
}



class DynamicDifficulty : EventHandler
{
//----------------------------------------------------------------
	PlayerPawn pawn;
	DifficultyData diff;


//----------------------------------------------------------------
	const GRADE_DELAY			= 1;			// number of tics between running this script
	const GRADE_HPLOSS_MULT		= 200;			// health lost * this amount is subtracted from grade
	const GRADE_KILLS_MULT		= 1000;		// each monster killed adds this much to grade

	const SPAWN_GRADE_DIV		= 7000;		// how much grade effects spawn level

	const BBARMOUR_HP_MULT		= 200.0;			// how much current health affects damagefactor
	const BBARMOUR_GRADE_DIV	= 16.0;			// how much grade affects damagefactor
	const BBARMOUR_MAX			= 0.5;			// maximum percentage of damagefactor allowed
//----------------------------------------------------------------

	override void WorldTick()
	{

		CVar deaths = CVAR.FindCvar('crash_deaths');
		CVar spawn = CVAR.FindCvar('spawn_level');
		CVar grade = CVAR.FindCvar('player_grade');

		// Iterate through all of the possible players in the game
		for (int i = 0; i < MAXPLAYERS; i++)
        {
			// If a player is in the game and has spawned...
            if (playeringame[i] && players[i].mo)
            {
				// set to the first player found
				if (!pawn) { pawn = players[i].mo; }
         // 	else { pawn = null; break; }
            }
        }


		if (pawn.health <= 0 && diff.playerlasthealth >= 0)						// if player dead
		{
			deaths.SetInt(deaths.GetInt() + 1);									// add 1 to death count
		}
		else
		{
			int healthloss = diff.playerlasthealth - pawn.health;								// get health lost since last tic
				if (healthloss < 0) { healthloss = 0; }  									// ignore if health increases
			int monsterdeaths = level.killed_monsters - diff.monsterlastcount;				// get number of monsters killed since last tic
			diff.babyarmour = 1.0 - ((100.0 - pawn.health) / BBARMOUR_HP_MULT ) ;				// modify player damage taken (damagefactor) according to health

			// adjust grade according to performance
				diff.playergrade = diff.playergrade - (healthloss * GRADE_HPLOSS_MULT) + (monsterdeaths * GRADE_KILLS_MULT);


					if (diff.playergrade < 0)
						{
							diff.playergrade = diff.playergrade + ((pawn.health / 6) * GRADE_DELAY);	// drift grade back towards 0 (faster if you have more health)
							diff.babyarmour = diff.babyarmour + (diff.playergrade / BBARMOUR_GRADE_DIV);		// modify player damage taken (damagefactor) according to grade
						}

					if (diff.playergrade > 0)
						{
							diff.playergrade = diff.playergrade - GRADE_DELAY ;							// drift grade back towards 0
						}


			// apply damage reduction
					if (diff.babyarmour < BBARMOUR_MAX) { diff.babyarmour = BBARMOUR_MAX; }				// stop damagefactor getting too low
					pawn.DamageFactor = diff.babyarmour;

			}

	// save values for next tic
		diff.playerlasthealth = pawn.health;
		diff.monsterlastcount = level.killed_monsters;

	// calculate spawn level
		diff.spawnlevel = (diff.playergrade / SPAWN_GRADE_DIV) - deaths.GetInt();					// set spawn level
			if (diff.spawnlevel > 4) { diff.spawnlevel = 4; }										// clamp value
			if (diff.spawnlevel < 0) { diff.spawnlevel = 0; }										// clamp value


		spawn.SetInt(diff.spawnlevel);									// set cvar so zscript spawner objects can read it
		grade.SetInt(diff.playergrade);									// set cvar so zscript spawner objects can read it



//		console.printf("%d %d %f",diff.spawnlevel, diff.playergrade, diff.babyarmour);


	}



}





class Crash_Spawner : Actor
{
	int spawnquality;
	int spawnlistsize;
	string spawns[20];
	PlayerPawn pawn;

	Default
	{
		//$Arg0 "spawnlist index offset"
		Radius 16;
		Height 8;
		Scale 0.25;
		-SOLID
		+NOGRAVITY
	}


    override void PostBeginPlay()
    {
		// Iterate through all of the possible players in the game
		for (int i = 0; i < MAXPLAYERS; i++)
        {
			// If a player is in the game and has spawned...
            if (playeringame[i] && players[i].mo)
            {
				// set to the first player found
				if (!pawn) { pawn = players[i].mo; }
         // 	else { pawn = null; break; }
            }

		}

	Super.PostBeginPlay();
    }

//function that returns the ClassName of an item to spawn
	void GetItemToSpawn ()
	{
		CVar deaths = CVAR.FindCvar('crash_deaths');
		CVar grade = CVAR.FindCvar('player_grade');

		spawnquality =	1
							+ self.Args[0]
							+ deaths.GetInt()
							+ random(-1,1)
							- spawn_level
							- (grade.GetInt() / 1000)
							+ ((100 - pawn.health)/30);

		if (spawnquality > spawnlistsize) spawnquality = spawnlistsize;	// clamp index value to list size
		if (spawnquality < 0) spawnquality = 0;								// clamp index value to positive numbers

		A_SpawnItemEx(spawns[spawnquality],	// class
						0,0,0,				// x,y,z offset
						0,0,0,				// x,x,z velocity
						0,					// angle offset
						0);					// flags

	}
}




class Crash_HealthSpawner : Crash_Spawner
{

//	const SPAWN_LIST_SIZE = 8; // number of items in the spawnlist -1
	static const string spawnlist[] = {
	"HealthBonus",
	"HealthBonus",
	"HealthBonus",
	"Stimpack",
	"Stimpack",
	"Stimpack",
	"Medikit",
	"Medikit",
	"Berserk",
	"None"
	};

	override void PostBeginPlay()
	{

		for (int i = 0; i < 20; i++)
		{
			if (spawnlist[i] != "None")
			{
				spawns[i] = spawnlist[i];		// copy list into array
				spawnlistsize = i;			//
		//		console.printf("%d %s",spawnlistsize, spawns[i]);

			}

			else break;
		}

		Super.PostBeginPlay();
    }

	States
	{
	Spawn:
		SPWN A 0 BRIGHT;
		TNT1 A 1 ;
		"####" "#" 0 BRIGHT A_CheckProximity("InRange", "PlayerPawn", 512, 1, CPXF_ANCESTOR);
		"####" "#" 0 BRIGHT A_CheckProximity("InRange", "PlayerPawn", 2048, 1, CPXF_ANCESTOR | CPXF_CHECKSIGHT);
		Loop;
	InRange:
		"####" "#" 1  { GetItemToSpawn(); console.printf("Spawned %s(%d)", spawns[spawnquality], spawnquality); }
		stop;

	}

}


