Class SolidModelBase : Actor {
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

Class Chair1 : SolidModelBase {
	Default {
		Radius 34;
		Height 24;
		
	}

	States {
		Spawn:
			PLAY A -1;
			Stop;
	}
}

//-------------------------------------------------------

Class Chair2 : Chair1 {
	Default {
		Radius 34;
		Height 24;
		
	}

	States {
		Spawn:
			PLAY A -1;
			Stop;
	}
}
//=======================================================

Class Toilet : SolidModelBase {
	Default {
		Radius 16;
		Height 24;
		
	}

	States {
		Spawn:
			PLAY A 8 {
						A_SpawnItem("ShotgunGuy",-16,32,0);
						A_Log("spawned!");
					}
			PLAY A 1;
			wait;
	}
}
//=======================================================

Class VendingMachine1 : SolidModelBase {
	Default {
		Radius 32;
		Height 96;
		
	}

	States {
		Spawn:
			PLAY A -1;
			Stop;
	}
}

//=======================================================
