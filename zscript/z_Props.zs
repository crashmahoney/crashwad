// --------------------------------------------------------------------------
class DeskLamp : SwitchableDecoration
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
		+PUSHABLE
		+SLIDESONWALLS		
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
class DingBell : SwitchableDecoration
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
		+PUSHABLE
		+SLIDESONWALLS		
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
//=======================================================
class IVStand : LiftableActor {
	Default
	{
		Radius 8;
		Height 64;
		RenderStyle "Translucent";
		Mass 25;
		PushFactor 0.75;

		+FLOORCLIP
		+SOLID
		+PUSHABLE
		+SLIDESONWALLS
		+WINDTHRUST
		+SHOOTABLE
		+NOTARGET
		+NOTAUTOAIMED
		+NOBLOOD
		Tag "IV Stand";

	}

	States
	{
		Spawn:
			PLAY A -1;
			Stop;
		Active:
 			goto Super::Active; 
		Inactive:
 			goto Super::Inactive; 
	}
}
//=======================================================

class Keyboard : LiftableActor {
	Default
	{
		Radius 12;
		Height 3;
		+FLOORCLIP
		+SOLID
		+PUSHABLE
		+SLIDESONWALLS
		+WINDTHRUST
		+SHOOTABLE
		+NOTARGET
		+NOTAUTOAIMED
		+NOBLOOD		
	}

	States
	{
		Spawn:
			PLAY A -1;
			Stop;
		Active:
 			PLAY A 0 A_PickUp;
			PLAY A 1 A_WarpToCarrier;
			Wait;   
		Inactive:
 			PLAY A 0 A_PutDown;		
			Goto Spawn; 
	}	
}

// --------------------------------------------------------------------------
class ManholeCover : Actor
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
class PotPlant : LiftableActor
{
	Default
	{
		Radius 16;
		Height 48;
		Scale 0.75;

		+FLOORCLIP
		+SOLID
		+PUSHABLE
		+SLIDESONWALLS
		+WINDTHRUST
		+SHOOTABLE
		+NOTARGET
		+NOTAUTOAIMED
		+NOBLOOD	
	}


	States
	{
		Spawn:
			POTP A -1;
			stop;
		Active:
 			goto Super::Active; 
		Inactive:
 			goto Super::Inactive; 
 	}
}

// --------------------------------------------------------------------------
class Stapler : LiftableActor
{
	Default
	{
		Radius 4;
		Height 4;
		Scale 0.25;

		+FLOORCLIP
		+SOLID
		+PUSHABLE
		+SLIDESONWALLS
		+WINDTHRUST
		+SHOOTABLE
		+NOTARGET
		+NOTAUTOAIMED
		+NOBLOOD

	}
	
	States
	{
		Spawn:
			STAP A -1;
			stop;
		Active:
 			goto Super::Active; 
		Inactive:
 			goto Super::Inactive; 		
	}
}
