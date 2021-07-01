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
	const NO_COLL_TIMER = 20;
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
		+NOCLIP;
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

    	if (GetAge() == NO_COLL_TIMER) bNOCLIP = FALSE;

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
		Health 9999999;
		PainChance 100;
        +SOLID
        +SHOOTABLE
        +NOBLOOD
        +NOTARGET
        +ACTIVATEPCROSS
        +DONTGIB
        +NOICEDEATH
        +DROPOFF
		+PUSHABLE
		+SLIDESONWALLS        
		BounceSound "break/vent";
		Tag "Cash Register";
	}

	States
	{
		Spawn:
			PLAY # -1;
			Stop;
		Active:
 			goto Super::Active;  
		Inactive:
 			goto Super::Inactive;
		Bounce:
			#### # 4 A_BounceThrown();
		Pain:
			#### B 1
			{
				if (!alreadypaidout)
				{	
					alreadypaidout = 1;
					switch (random(0,8))
					{
						case 0: 
							Crash.SpawnCash(self, "NoteBundle");
						case 1:	
							Crash.SpawnCash(self, "Cash");
						case 2:
							Crash.SpawnCash(self, "NoteBundle");
						case 3:						
							Crash.SpawnCash(self, "Cash");
						case 4:						
							Crash.SpawnCash(self, "Cash");
						case 5:						
							Crash.SpawnCash(self, "Cash");
						case 6:						
							Crash.SpawnCash(self, "Cash");
						case 7:						
							Crash.SpawnCash(self, "Cash");
						case 8:						
							Crash.SpawnCash(self, "NoteBundle");
						default:
							break;		
					}
				}
			}
			Goto Inactive;			
	}
}



