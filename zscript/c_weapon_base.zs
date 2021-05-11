/*
Weapon Base
*/


Class CrashWeapon : Weapon
{


	Default
	{
		Weapon.Kickback 100;
	}
	
	
	States
	{

	Fire:
		Goto Ready;

	}
	
}


