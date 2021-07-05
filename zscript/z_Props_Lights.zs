// --------------------------------------------------------------------------
Class Corona : Actor
{
	Default
	{
		RenderStyle "Add";
		Scale 0.65;
		Alpha 0.35;

		+NOGRAVITY
		+NOINTERACTION
		+NOBLOCKMAP
		+NOTELEPORT
		+ForceXYBillboard
		+CLIENTSIDEONLY
	}

	States
	{
		Spawn:
			WFLR A -1 Bright;
			Stop;
	}
}

// --------------------------------------------------------------------------
Class CoronaBlue : Corona
{
	Default
	{	
		Alpha 0.3;
		Scale 1.5;
	}

	States
	{
		Spawn:
			WFLR D -1 Bright;
			Stop;
	}
}

// --------------------------------------------------------------------------
Class CoronaGreen : Corona
{
	Default
	{	
		Alpha 0.3;
		Scale 1.2;
	}

	States
	{
		Spawn:
			WFLR B -1 Bright;
			Stop;
	}
}

Class CoronaGreenFaded : CoronaGreen
{
	Default
	{	
		Alpha 0.3;
		Scale 0.7;

    	+NoClip
		+WallSprite
	}

	States
	{
		Spawn:
			WFLR B 5 Bright;
			Stop;
	}	
}

// --------------------------------------------------------------------------
Class CoronaPink : Corona
{
	Default
	{	
		Alpha 0.5;
		Scale 1.5;
	}

	States
	{
		Spawn:
			WFLR C -1 Bright;
			Stop;
	}
}

// --------------------------------------------------------------------------
Class CoronaRed : Corona
{
	Default
	{	
		Alpha 0.3;
		Scale 1.2;
	}

	States
	{
		Spawn:
			RFLR A -1 Bright;
			Stop;
	}
}

Class CoronaRed2 : Corona
{
	Default
	{	
		Alpha 0.3;
		Scale 1.5;
	}

	States
	{
		Spawn:
			WFLR A -1 Bright;
			Stop;
	}
}

// --------------------------------------------------------------------------
Class CoronaYellow : Corona
{
	Default
	{	
		Alpha 0.3;
		Scale 1.5;
	}

	States
	{
		Spawn:
			WFLR E -1 Bright;
			Stop;
	}
}

//=======================================================
Class LampPost : SolidModelBase
{
	Default
	{
		Radius 8;
		Height 232;
	}

	override void PostBeginPlay()
	{
		Actor.Spawn("InvisibleBridge16", Vec3Angle( 58, self.Angle, 244, false ), NO_REPLACE);
		Actor.Spawn("LampPostGlow", Vec3Angle( 65, self.Angle, 92, false ), NO_REPLACE);
		Super.PostBeginPlay();
	}

	States
	{
		Spawn:
			PIPE A -1;
			Stop;
	}
}

Class LampPostGlow : Actor
{
	Default
	{
		Radius 32;
		Height 200;
		Alpha 0.2;
		RenderStyle "Add";
			
		+NOGRAVITY
		+NOINTERACTION
	}

	States
	{
		Spawn:
		LITE A -1 Bright;
		Stop;
	}
}

//=======================================================
Class LiteF : SolidModelBase
{
	Default
	{
		Radius 1;
		Height 1;
		+NOGRAVITY
		+NOCLIP
		-SOLID
	}
}

//=======================================================
Class Lite2 : Actor {
	Default {
		Radius 16;
		Height 72;
		RenderStyle "Add";
		+NOGRAVITY
		+SPAWNCEILING
		+SOLID
		+INVULNERABLE
		+NODAMAGE
		+SHOOTABLE
		+NOTAUTOAIMED
		+NEVERTARGET
		+DONTTHRUST
	}

	States {
		Spawn:
			PLAY A -1;
			Stop;
	}
}

//=======================================================
Class LiteR : Actor
{
	Default {
		Radius 18;
		Height 2;
		+NOGRAVITY
		+SPAWNCEILING
		
	}

	override void PostBeginPlay()
	{		

		actor mo = Actor.Spawn("LampPostGlow", Vec3Angle( 0, self.Angle, -80, false ), NO_REPLACE);
		if (mo)
		{
			mo.Scale.x = 0.5;
			mo.Scale.y = 0.5;
			mo.Alpha = 0.1;
		}
		mo = Actor.Spawn("LiteRSpotlight", Vec3Angle( 0, self.Angle, -8, false ), NO_REPLACE);
		if (mo)
		{
			mo.Angle = self.Angle;
			mo.Pitch = 90.0;
		}
		
		Super.PostBeginPlay();
	}

	States {
		Spawn:
			PLAY A -1;
			Stop;
	}
}

Class LiteRSpotlight : SpotLightAttenuated
{
	override void PostBeginPlay()
   {
      args[LIGHT_RED] = 100;
      args[LIGHT_GREEN] = 100;
      args[LIGHT_BLUE] = 100;
      args[LIGHT_INTENSITY] = 192;
      SpotInnerAngle = 30;
      SpotOuterAngle = 60;
      Super.PostBeginPlay();
   }
}


// --------------------------------------------------------------------------
Class LightBase : Actor
{
	Default
	{
	Radius 0;
	Height 0;

	+NOGRAVITY
	+FIXMAPTHINGPOS
	}

	States
	{
		Spawn:
			PIPE A -1;
    		Stop;
	}
}


Class LightBlue : LightBase
{
	override void PostBeginPlay()
	{
		Actor.Spawn("CoronaBlue", Vec3Angle(0,0,0), NO_REPLACE);
		Super.PostBeginPlay();
	}
}

Class LightGreen : LightBase
{
	override void PostBeginPlay()
	{
		Actor.Spawn("CoronaGreen", Vec3Angle(0,0,0), NO_REPLACE);
		Super.PostBeginPlay();
	}
}

Class LightPink : LightBase
{
	override void PostBeginPlay()
	{
		Actor.Spawn("CoronaPink", Vec3Angle(0,0,0), NO_REPLACE);
		Super.PostBeginPlay();
	}
}

Class LightRed : LightBase
{
	override void PostBeginPlay()
	{
		Actor.Spawn("CoronaRed2", Vec3Angle(0,0,0), NO_REPLACE);
		Super.PostBeginPlay();
	}
}

Class LightYellow : LightBase
{
	override void PostBeginPlay()
	{
		Actor.Spawn("CoronaYellow", Vec3Angle(0,0,0), NO_REPLACE);
		Super.PostBeginPlay();
	}
}


// --------------------------------------------------------------------------
Class Torch : Actor
{
	Default
	{
		height 32;
		radius 16;

		+SOLID
		+NOGRAVITY
	}

	States
	{
		Spawn:
			TORC A 0 A_PlaySound("DSCHAFIR", CHAN_BODY, 1, 1, 3);
			TORC A 0 A_CheckSight("NoLos");
			//TORC A 0 A_SpawnItemEx("RedCorona", 8,0,32, 0,0,0, 0, 0, 0 );
			TORC A 2 A_SpawnItemEx("FireParticleSmall", Random(0,4)+2, Random(0,4)-2, 22+Random(0, 4), (0.001)*Random(10, 400), (0.001)*Random(10, 400), (0.0004)*Random(1500, 3000), 0, SXF_CLIENTSIDE, 64);
			Goto Spawn;
		NoLOS:
			TORC A 5;
			Goto Spawn;
	}
}