

class Cash : Inventory
{
	Default
	{
		Radius 8;
		Height 8;
		Inventory.Amount 1;
		Inventory.MaxAmount 20000;
		+INVENTORY.INVBAR
		Inventory.Icon "COINA0";
		Inventory.PickupMessage "Picked up 1 dollar";
		BounceType "Grenade";
		BounceFactor 0.6;

	}
	
	int cointoss;
	int groundtime;
    bool bSloped;


	override void PostBeginPlay()
		{
	//	angle = random(0,359);
		cointoss = random(0,1);		
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