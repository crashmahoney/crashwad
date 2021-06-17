
//===========================================================================
class Cash : Inventory
{
	int groundtime;
	bool bHoming;
    bool bSloped;
	PlayerPawn player;
	
	//---------------------------------------------------------------------------
	const HOMING_RANGE = 128;
	const HOMING_MAX_TURN = 20;
	const HOMING_MAX_PITCH = 20;
	const HOMING_SPEED = 1.0;
	//---------------------------------------------------------------------------
	
	Default
	{
		Radius 12;
		Height 20;
		Inventory.Amount 1;
		Inventory.MaxAmount 20000;
		Inventory.InterHubAmount 20000;
		+INVENTORY.INVBAR
		+INVENTORY.KEEPDEPLETED;
		Inventory.Icon "COINA0";
		Inventory.PickupMessage "$GOTCASH";
		BounceType "Grenade";
		BounceFactor 0.6;

	}
	//---------------------------------------------------------------------------
	
	override void PostBeginPlay()
	{		
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
		
		Super.PostBeginPlay();
		
	
	}
	//---------------------------------------------------------------------------

    override void Tick()
    {
		//----------------------------------------------------------------------
        // set actor angle / pitch / roll when not homing
		//----------------------------------------------------------------------
        if (!bSloped && !bHoming)				// if not already matched to floor slope or homing towards player
        {
			if ( Pos.z - FloorZ < 2 )			// if close to floor
			{
				Physics.AlignToSlope(self, self.Angle, 0.f);	// align
				groundtime ++;					// add to timer
			
				if (groundtime > 10 )			// if timer expired
				{
					bSloped = true;				// flag as already matched to the floor
				}
			}
			
			else								// else if in the air
			{
				self.roll += 15.0;				// speeeen
			}
		}
		
		//----------------------------------------------------------------------
        // if under max amount of cash, home in on player
		//----------------------------------------------------------------------
		if ( player.CountInv("Cash") < self.MaxAmount - self.Amount )
		{
			if (!bHoming && Distance3d(player) < HOMING_RANGE )	// if within range of player
			{
			
				if ( CheckSight(player) )
				{
					bHoming = true;									// set homing flag
					A_Face( player, 360, 30, 0, 0, 0, 16);			// face player
					self.bNoclip = true;							// set noclip
				}
				
			}
			//----------------------------------------------------------------------
			if ( bHoming )										// if homing flag set
			{
				self.speed += HOMING_SPEED;
				A_Face( player, HOMING_MAX_TURN, HOMING_MAX_PITCH, 0, 0, 0, 16);	// face player
				Vel3DFromAngle( self.speed, self.angle, self.pitch );	//thrust towards player			
			}
		}
		else
		{
			self.bNoclip = false;
			self.bHoming = false;
		}
		//----------------------------------------------------------------------
		
		Super.Tick();
    }
	
	
	//---------------------------------------------------------------------------

	override bool HandlePickup (Inventory item)
	{
		if (item is "Cash")
		{
			if (Amount < MaxAmount)
			{
				if (MaxAmount - Amount < item.Amount)
				{
					Amount = MaxAmount;
				}
				else
				{
					Amount += item.Amount;
				}
				item.bPickupGood = true;
			}
			return true;
		}
		return false;
	}
	//---------------------------------------------------------------------------

	override Inventory CreateCopy (Actor other)
	{
		if (GetClass() == "Cash")
		{
			return Super.CreateCopy (other);
		}
		Inventory copy = Inventory(Spawn("Cash"));
		copy.Amount = Amount;
		copy.BecomeItem ();
		GoAwayAndDie ();
		return copy;
	}
	//---------------------------------------------------------------------------

	States
	{
	Spawn:
		COIN A -1;
		stop;
	}
}


//===========================================================================

class NoteBundle : Cash
{
	Default
	{
		Inventory.Amount 50;
		Inventory.PickupMessage "$GOTNOTEBUNDLE";
	}
	
	//---------------------------------------------------------------------------
	States
	{
	Spawn:
		PIPE A -1;
		stop;
	}
}

//===========================================================================

class CashRegister : LiftableActor
{

	int alreadypaidout;

	Default
	{
		Radius 12;
		Height 13;
		Health 10;

        +SOLID
        +SHOOTABLE
        +NOBLOOD
        +NOTARGET
        +ACTIVATEPCROSS
        +DONTGIB
        +NOICEDEATH
        +DROPOFF
		Species "Explosive";
		DeathSound "break/vent";
		Tag "Cash Register";
	}

		const CASH_THROW_MAX_DIST = 3.0;
		const CASH_THROW_MIN_HEIGHT = 8.0;
		const CASH_THROW_MAX_HEIGHT = 15.0;
		const CASH_SPAWN_OFFSET = 24.0;	

	//---------------------------------------------------------------------------
	// function to spawn and throw cash actor
	//---------------------------------------------------------------------------	
	static void SpawnCash(Actor self, string spawnclass)
	{


		let mo = actor.Spawn( spawnclass, (self.pos.x, self.pos.y, self.pos.z + CASH_SPAWN_OFFSET), NO_REPLACE );
		if (mo)
		{
			mo.Angle = self.angle;
			mo.vel.x = frandom( - CASH_THROW_MAX_DIST, CASH_THROW_MAX_DIST );
			mo.vel.y = frandom( - CASH_THROW_MAX_DIST, CASH_THROW_MAX_DIST );
			mo.vel.z = frandom( CASH_THROW_MIN_HEIGHT, CASH_THROW_MAX_HEIGHT );
		}
	}


	States
	{
		Spawn:
			PLAY # -1;
			Stop;
		Active:
 			PLAY # 0 A_PickUp;
			PLAY # 1 A_WarpToCarrier;
			Wait;   
		Inactive:
 			PLAY # 0 A_PutDown;		
			Goto Spawn; 
		Death:
			PLAY A 10;
			PLAY B 5
			{
				if (!alreadypaidout)
				{	
					alreadypaidout = 1;
					switch (random(0,8))
					{
						case 0: 
							SpawnCash(self, "NoteBundle");
						case 1:	
							SpawnCash(self, "Cash");
						case 2:
							SpawnCash(self, "NoteBundle");
						case 3:						
							SpawnCash(self, "Cash");
						case 4:						
							SpawnCash(self, "Cash");
						case 5:						
							SpawnCash(self, "Cash");
						case 6:						
							SpawnCash(self, "Cash");
						case 7:						
							SpawnCash(self, "Cash");
						case 8:						
							SpawnCash(self, "NoteBundle");
						default:
							break;		
					}
				}
			}
			PLAY B 5;
			Wait;			
	}
}



