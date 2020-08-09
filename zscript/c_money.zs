

class Cash : Inventory
{
	Default
	{
		Radius 8;
		Height 20;
		Inventory.Amount 1;
		Inventory.MaxAmount 20000;
		Inventory.InterHubAmount 20000;
		+INVENTORY.INVBAR
		Inventory.Icon "COINA0";
		Inventory.PickupMessage "Picked up 1 dollar";
		BounceType "Grenade";
		BounceFactor 0.6;

	}
	
	int cointoss;
	int groundtime;
    bool bSloped;
	PlayerPawn target;

	override void PostBeginPlay()
		{
	//	angle = random(0,359);
		cointoss = random(0,1);		
		
	// Iterate through all of the possible players in the game
        for (int i = 0; i < MAXPLAYERS; i++)
        {
            // If a player is in the game and has spawned...
            if (playeringame[i] && players[i].mo)
            {
                if (!target) { target = players[i].mo; } 	// Set the skybox to follow the first player who is in the game
                else { target = null; break; } 			// If there are multiple players, don't move the skybox
            }
        }
		
		
		
		Super.PostBeginPlay();
		
	
		}


    override void Tick()
    {
        if (!bSloped)
        {
         
		 if ( Pos.z - FloorZ == 0 )
		 {
			Physics.AlignToSlope(self, self.Angle, 0.f);
			groundtime ++;
			
			if (groundtime > 10 )
			{
				bSloped = true;
			}
/*			
			if ( cointoss == 1 )
			{
				self.roll += 180.0;
			}
*/
		}
		else
		{
			self.roll += 15.0;
		}


        }
        
		
		if ( Distance3d(target) < 128 )
		{
			Vector3 thrust = Vec3To(target);
			self.Vel += (thrust.Unit() * 2.0);// * 255.0 * 1 / max(target.Mass, 1));
		}
		
		Super.Tick();
    }

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

	States
	{
	Spawn:
		COIN A -1;
		stop;
	}
}


class NoteBundle : Cash
{
	Default
	{
		Inventory.Amount 100;
		Inventory.PickupMessage "Picked up a fat stack";
	}

	States
	{
	Spawn:
		PIPE A -1;
		stop;
	}
}