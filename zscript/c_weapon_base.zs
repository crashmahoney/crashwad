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
				// drop if use button pressed
				if (target && GetPlayerInput(INPUT_BUTTONS)&BT_USE ) target.SetStateLabel("Inactive"); 
				// if no object held, remove this weapon
				if (!target)	A_TakeInventory("HoldingObjectWeapon");
				else A_WeaponReady();
			}
			Loop;
		Deselect:
			TNT1 A 1 A_Lower(5);
			Wait;
		Select:
			TNT1 A 1 A_Raise(20);
			Wait;
		Fire:
			TNT1 A 15
			{
				if (target != null)
				{
					A_StartSound("Fist/Swing", CHAN_WEAPON, 0, 0.7, ATTN_NORM, frandom(0.9,1.1));
					target.Vel3DFromAngle(30-(target.mass*0.1), angle, pitch-5.0);
					target.SetDamage(target.mass * target.vel.length() * 0.015 + random(0,10));
				//	A_Logfloat(target.damage);
					target.bMISSILE = TRUE;
					target.bACTIVATEIMPACT = TRUE;
					target.bACTIVATEPCROSS = TRUE;
					target.bNOGRAVITY = FALSE;			
					if ( target.Species != "Explosive" ) 
					{
						target.bUSEBOUNCESTATE = TRUE;
						target.bBOUNCEONFLOORS = TRUE;
						target.bBOUNCEONCEILINGS = TRUE;
						target.bBOUNCEONWALLS = TRUE;
						target.bALLOWBOUNCEONACTORS = TRUE;
						target.bBOUNCEONACTORS = TRUE;						
					}
					target.SetStateLabel("Inactive");
				}
			}
			TNT1 A 4 A_TakeInventory("HoldingObjectWeapon");
			Goto Ready;			
	}

}