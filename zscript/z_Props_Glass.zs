// --------------------------------------------------------------------------
class Bottle1 : LiftableActor
{
	Default
	{
		Radius 4;
		Height 16;
		Health 1;
		Scale 0.7;
		Mass 5;

		+SOLID
		+SHOOTABLE
		+NOBLOOD
		+NOTARGET
		+NOTAUTOAIMED
		+DONTGIB
		+NOICEDEATH

		Species "Explosive";
		DeathSound "break/glass";
	}

	States
	{
		Spawn:
			DRNK A -1;
			stop;
		Death:
			#### # 0 A_SpawnDebris("GlassShrapnel",FALSE,2,2);
			#### # 1 A_Scream;
			Stop;

 	}
}

Class Bottle2 : Bottle1
{
	States
	{
	Spawn:
		DRNK B -1;
		stop;
	}
}

Class Bottle3 : Bottle1
{
	States
	{
	Spawn:
		DRNK D -1;
		stop;
	}
}

// --------------------------------------------------------------------------
Class CoffeeMug : Bottle1
{
	Default
	{
		Radius 4;
		Height 16;
		Scale 0.4;
	}


	States
	{
		Spawn:
			COFF A -1;
			stop;
	}
}

// --------------------------------------------------------------------------
Class Glass1 : Bottle1
{
	States
	{
	Spawn:
		DRNK C -1;
		stop;
	}
}

Class Glass2 : Bottle1
{
	Default
	{
		Scale 1;
	}

	States
	{
	Spawn:
		DRNK E -1;
		stop;
	}
}

Class Glass3 : Bottle1
{
	Default
	{
		Scale 1;
	}
	
	States
	{
	Spawn:
		DRNK F -1;
		stop;
	}
}

Class Glass4 : Bottle1
{
	Default
	{
		Scale 1;
	}
	
	States
	{
	Spawn:
		DRNK G -1;
		stop;
	}
}

// --------------------------------------------------------------------------
Class GlassFlat : ManholeCover
{
	Default
	{
		Health 1;
		Alpha 0.2;

		+NOGRAVITY

		DeathSound "break/glass";
	}
	States
	{
		Spawn:
			GLAS A -1;
			Stop;
		Death:
            GLAS B 3
            {
            	A_Scream();		
				A_SpawnDebris("GlassShrapnel",FALSE,2,2);
			}
			Stop;		
	}
}

