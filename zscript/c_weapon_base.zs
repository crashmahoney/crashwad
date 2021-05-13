/*
Weapon Base
*/


class CrashWeapon : Weapon
{


	Default
	{
		Weapon.Kickback 100;
	}
	
	
	States
	{
		Ready:
			TNT1 A 1;
			Wait;
		Deselect:
			TNT1 A 1 A_Lower(10);
			Wait;
		Select:
			TNT1 A 1 A_Raise(10);
			Wait;
		Fire:
			Goto Ready;

	}
	
}


class HoldingObjectWeapon : CrashWeapon
{

	States
	{
		Ready:
			TNT1 A 1
			{
				if (target == null)
				{
					A_TakeInventory("HoldingObjectWeapon");
				}
				else
				{
					A_WeaponReady();
				//	A_FaceTarget();
				}
			}
			Loop;
		Deselect:
			TNT1 A 1 A_Lower(10);
			Wait;
		Select:
			TNT1 A 1 A_Raise(10);
			Wait;
		Fire:
			TNT1 A 4
			{
				A_Log("pressed fire");
				if (target)
				{
					target.Vel3DFromAngle(30, angle, pitch-5.0);
					target.bMISSILE = TRUE;
					target.bNOGRAVITY = FALSE;					
					target.SetStateLabel("Inactive");
					A_TakeInventory("HoldingObjectWeapon");
				}
			}
			Goto Ready;			
	}

}