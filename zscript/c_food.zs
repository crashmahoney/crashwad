
class Can1 : Health
{

	override void PostBeginPlay()
	{
		self.angle = self.angle + frandom(-20.0, 20.0);
		Physics.AlignToSlope(self, self.Angle, self.Pitch);	// align
		Super.PostBeginPlay();
	}


	Default
	{
		+COUNTITEM
		+INVENTORY.ALWAYSPICKUP
		Inventory.Amount 1;
		Inventory.MaxAmount 200;
		Inventory.PickupMessage "$GOTHTHBONUS";
	}
	States
	{
	Spawn:
		STIM A -1;
		Stop;
	}
}

class Soy : Health
{

	override void PostBeginPlay()
	{
		self.angle = self.angle + frandom(-20.0, 20.0);
		if (!random(0,4)) self.pitch = 180.0; 
		Physics.AlignToSlope(self, self.Angle, self.Pitch);	// align
		Super.PostBeginPlay();
	}


	Default
	{
		Inventory.Amount 10;
		Inventory.PickupMessage "$GOTSTIM";
	}
	States
	{
	Spawn:
		STIM A -1;
		Stop;
	}
}
