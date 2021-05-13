// --------------------------------------------------------------------------
Class DeskLamp : SwitchableDecoration
{
	Default
	{
		Radius 16;
		Height 24;
		Scale 0.75;
		Mass 75;
		PushFactor 0.75;
		Activation THINGSPEC_Switch|THINGSPEC_Deactivate;

		+USESPECIAL
		+SOLID
		+SHOOTABLE
		+NOTARGET
		+NOTAUTOAIMED
		+NOBLOOD
	}

	States
	{
		Spawn:
			DLMP A 1;
			Wait;
		Active:
			DLMP A 1 A_PlaySound("switch/lampon");
			DLMP A 1;
			Wait;
		Inactive:
			DLMP B 1 A_PlaySound("switch/lampon");
			DLMP B 1;
			Wait;	
	}
}

// --------------------------------------------------------------------------
Class DingBell : SwitchableDecoration
{
	Default
	{
		Radius 8;
		Height 8;
		Scale 0.33;
		Mass 75;
		PushFactor 0.75;
		Activation THINGSPEC_Switch|THINGSPEC_MissileTrigger;

		+USESPECIAL
		+BUMPSPECIAL
		+SOLID
		+Shootable
		+NOTARGET
		+NOTAUTOAIMED
		+NOBLOOD
	}


	States
	{
		Spawn:
			DING A 1;
			Wait;
		Active:
		Inactive:	
			DING A 1 A_PlaySound("crash/bell");
			DING A 1;
			Wait;
	}
}

// --------------------------------------------------------------------------
Class ManholeCover : Actor
{
	Default
	{
		Health 100;
		Radius 32;
		Height 2;

		+SOLID
		+FLATSPRITE
		+ROLLCENTER
		//+SHOOTABLE
		+VULNERABLE
		+NOBLOOD	
		+NOTARGET
		+DONTTHRUST
		+NOTAUTOAIMED

		DeathSound "break/vent";
	}

	States
	{
		Spawn:
			MANH A -1;
			Stop;
		Death:
            MANH B 1		
            {
            	A_Scream();		
				A_SpawnDebris("ShrapnelCrash",FALSE,2,2);
			}
			Stop;
	
	}

}

// --------------------------------------------------------------------------
Class PotPlant : Actor
{
	Default
	{
		Radius 16;
		Height 48;
		Scale 0.75;

		+SOLID
	}


	States
	{
		Spawn:
			POTP A -1;
			stop;
	}
}

// --------------------------------------------------------------------------
Class Stapler : Actor
{
	Default
	{
		Radius 4;
		Height 4;
		Scale 0.25;
	}
	
	States
	{
		Spawn:
			STAP A -1;
			stop;
	}
}
