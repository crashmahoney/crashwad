class SolidModelBase : Actor {
	Default {
		Radius 32;
		Height 96;
		
		-NOINTERACTION
		+NOTARGET
		+SOLID
		+NOGRAVITY
		+INVULNERABLE
		+NODAMAGETHRUST
		+NOTAUTOAIMED
	}

	States {
		Spawn:
			PLAY A -1;
			Stop;
	}
}
//=======================================================

class ATM : Actor {
	Default {
		Radius 28;
		Height 120;
		+NOGRAVITY
		+SOLID
		  
		//Activation THINGSPEC_Switch|THINGSPEC_Deactivate
		+USESPECIAL
	}

	States {
		Spawn:
			PLAY A -1;
			Stop;
	}
}

//=======================================================
class Barrier1 : Actor {
	Default {
		Radius 32;
		Height 64;
		
		
		+SOLID
		+INVULNERABLE
		+NODAMAGE
		+SHOOTABLE
		+NOTAUTOAIMED
		+NEVERTARGET
		+DONTTHRUST
	}

	override void PostBeginPlay()
	{
		Physics.AlignToSlope(self, self.Angle, self.Pitch);	// align
		Actor.Spawn("InvisibleBridgeBarrier1", Vec3Angle( 32, self.Angle - 90.f, 24, false ), NO_REPLACE);
		Actor.Spawn("InvisibleBridgeBarrier1", Vec3Angle( -32, self.Angle - 90.f, 24, false ), NO_REPLACE);
		Super.PostBeginPlay();
	}

	States {
		Spawn:
			PLAY A -1;
			Stop;
	}
}

class InvisibleBridgeBarrier1 : InvisibleBridge
{
	Default
	{
		Radius 32;
		Height 64;
	}
}



//=======================================================
class Crane3 : SolidModelBase {
	Default
	{
		Radius 78;
		Height 64;
	}
}
//=======================================================
class Grate128 : SolidModelBase {
	Default
	{
		Radius 64;
		Height 3;
	}
}

//=======================================================
class Monkey : SolidModelBase {
	Default
	{
		Radius 32;
		Height 56;
	}
}
//=======================================================
class Orb : SolidModelBase {
	Default
	{
		Radius 72;
		Height 128;
	}
}

class Orb2 : Orb {

}

//=======================================================
class Rail_B : SolidModelBase {
	Default {
		Radius 2;
		Height 3;
		+NOGRAVITY
		
		-SOLID

	}

	States {
		Spawn:
			PLAY A -1;
			Stop;
	}
}


//=======================================================

class Toilet : SolidModelBase {
	Default
	{
		Radius 16;
		Height 25;
	}
	
	override void PostBeginPlay()
	{
		Actor.Spawn("InvisibleBridge16", Vec3Angle( -24, self.Angle, 46, false ), NO_REPLACE);
		Super.PostBeginPlay();
	}
}
//=======================================================

class VendingMachine1 : SolidModelBase {
	Default
	{
		Radius 32;
		Height 96;
	}
}

//=======================================================
