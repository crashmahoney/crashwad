class ExplosionCrash : Actor //Spawnable Explosion
{
	Default
	{
		//SpawnID 200;
		Radius 0;
		Height 0;
		floatspeed 0;
		DeathSound "world/barrelx";

		+NOGRAVITY
		+FLOAT
		+SPAWNFLOAT
	}

	States
	{
		Spawn:
			MISL B 1 bright A_QuakeEx( 9, 9, 9, 15, 0, 1024, "", QF_SCALEDOWN, 1,1,1, 256, 0, 2 );
			MISL B 4 bright A_Scream;
			MISL CD 5 bright;
		Stop;
   }
}

class GasCan : LiftableActor
{

    Default
    {
        //$Arg0 "don't thrust"
        Health 20;
        Radius 10;
        Height 48;
        Scale 0.8;
        Mass 50;

        +SOLID
        +SHOOTABLE
        +NOBLOOD
        +ACTIVATEPCROSS
        +DONTGIB
        +NOICEDEATH
        +DROPOFF
        +PUSHABLE
        +SLIDESONWALLS
		Species "Explosive";
        DeathSound "world/barrelx";
        Obituary "$OB_BARREL"; // "%o went boom.";
        Tag "Gas Cylinder";
    }

    States
    {
        Spawn:
            XCAN A 4 { if ( Args[0] == 0 ) bDONTTHRUST= TRUE;}		// if arg1 is set in doombuilder don't allow it to be pushed by explosions
			XCAN A 4;
            Wait;
        Active:
            goto Super::Active; 
        Inactive:
            goto Super::Inactive;       
        Death:
            XCAN B 5 Bright A_Scream;
            XCAN C 5 Bright;
            #### # 0 A_QuakeEx( 9, 9, 9, 15, 0, 1024, "", QF_SCALEDOWN, 1,1,1, 256, 0, 2 );
            FEXT C 4 Bright A_SpawnDebris("ShrapnelCrash", 5,5);
            FEXT C 2 Bright A_Explode(128,192);
            FEXT C 5 Bright A_SetScale(1.2);
            FEXT D 5 Bright;
            FEXT D 5 Bright A_SetScale(1.4);
			TNT1 A 1050 BRIGHT A_BarrelDestroy;
			TNT1 A 5 A_Respawn;
            Wait;
     }
}

// --------------------------------------------------------------------------
class FireExtinguisher : LiftableActor
{
    Default
    {
        Health 1;
        Radius 6;
        Height 24;
        Gravity 0;
        Scale 0.5;
        Mass 25;

        +SOLID
        +SHOOTABLE
        +NOBLOOD
        +ACTIVATEMCROSS
        +DONTGIB
        +NOICEDEATH

		Species "Explosive";
        DeathSound "world/barrelx";
        Obituary "$OB_BARREL"; // "%o went boom."
        Tag "Fire Extinguisher";
    }

    States
    {
        Spawn:
            FEXT A -1;
            Stop;
        Active:
            goto Super::Active; 
        Inactive:
            goto Super::Inactive; 
	    Death:
            FEXT B 8 Bright
            {
            	A_QuakeEx( 9, 9, 9, 15, 0, 1024, "", QF_SCALEDOWN, 1,1,1, 256, 0, 2 );
                A_Explode(64,64);
                A_SpawnDebris("ShrapnelCrash",3,3);
                A_Scream();
            }
            FEXT C 6 Bright;
            FEXT D 4 Bright;
            Stop;
     }
}

// --------------------------------------------------------------------------
class LiftableActor : SwitchableDecoration
{

	int clangdelay; // timeout for sound when hitting wall while held
	int pickupangle; // angle when picked up
    int oldangle;

    Default
    {
    	Damage 1000;

    	BounceType "None";
        BounceSound "KnifeHit";
    	BounceFactor 0.4;
    	WallBounceFactor 0.4;
        ProjectileKickBack 300;
		+INTERPOLATEANGLES 
    	+CANPASS
		+USESPECIAL
		Activation THINGSPEC_Switch | THINGSPEC_ThingTargets | THINGSPEC_TriggerTargets;
	}


	override bool CanCollideWith(actor other,bool passive)
	{
        if (other && passive && other == target)
        {
            if (!TestMobjLocation()) 	return false;
        }
			return true;
	}

	States
	{
        Spawn:
            #### # -1;
            Stop;
		Bounce:
			#### # 1 A_BounceThrown();
			wait;
		Active:
 			#### # 0 A_PickUp;
			#### # 1 A_WarpToCarrier;
			Wait;
		Inactive:
 			#### # 0 A_PutDown;		
			Goto Spawn;

	}

	void A_BounceThrown()
	{
		SetDamage(mass * vel.length() * 0.015 + random(0,10));
        angle = oldangle;
		if (vel.x < 5 && vel.y < 5 && vel.z < 5)
		{
			bMISSILE = FALSE;
			bUSEBOUNCESTATE = FALSE;
			bBOUNCEONFLOORS = FALSE;
			bBOUNCEONCEILINGS = FALSE;
			bBOUNCEONWALLS = FALSE;
			bALLOWBOUNCEONACTORS = FALSE;
			bBOUNCEONACTORS = FALSE;	
			SetStateLabel("Inactive");
		}
	}

	void A_PickUp()
	{
		//A_FadeOut(0.3);
		A_GiveToTarget("HoldingObjectWeapon", 1);
		target.A_SelectWeapon("HoldingObjectWeapon");
		bNOTARGETSWITCH = TRUE;
		bACTIVATEIMPACT = FALSE;
		bACTIVATEPCROSS = FALSE;
        bNOGRAVITY = TRUE;
        pickupangle = angle - target.angle; // save original angle
	}

	void A_WarpToCarrier()
	{
		// remember old position in case the new one is invalid
		vector3 oldpos = pos;
		oldangle = angle;
		int floordif = floorz - target.floorz;

		// calculate offsets
		vector3 offset;
		offset.x = (target.radius + radius + 8.) * 2. - (abs(target.pitch) * 0.7) + Threshold;
		offset.z = clamp((target.height*0.8)-(height*0.5) - target.pitch, 1. + floordif , 80.);

		A_Warp(AAPTR_TARGET, offset.x, offset.y, offset.z, 0, WARPF_INTERPOLATE | WARPF_COPYVELOCITY);
		angle = pickupangle + target.angle;

		// use line of sight check to see if it's in a valid location (maybe not the best way)
		if (!CheckSight(target))
		{
			// restore position
			A_Warp(AAPTR_TARGET, oldpos.x, oldpos.y, oldpos.z, 0, WARPF_ABSOLUTEPOSITION );
			angle = oldangle;

			// things get too noisy if we do this every frame
			clangdelay --;

			if (clangdelay < 0)
			{
				A_StartSound(BounceSound, CHAN_WEAPON, 0, 0.7, ATTN_NORM, frandom(0.9,1.1));
				clangdelay = 3;
			}
		}

		// drop object if the player is somehow holding another, or if player is too far away
		if (target.target != self || !target ||
            Distance2d(target) > radius * 2 + 80 ||
            Distance3d(target) > radius * 2 + 120) SetStateLabel("Inactive");
/*
		bool ok; Actor below;
		[ok, below] = TestMobjZ(true);
		if (below) A_PutDown();
*/
/*
	// 2d overlap
	double blockdist = radius + target.radius;
	if (abs(target.pos.x - pos.x) < blockdist && abs(target.pos.y - pos.y) < blockdist)
				A_StartSound(BounceSound, CHAN_WEAPON, 0, 0.7, ATTN_NORM, frandom(0.9,1.1));
*/
	}



	void A_PutDown()
	{
		//A_SetRenderStyle(1.0, STYLE_Normal);
		A_TakeInventory("HoldingObjectWeapon", 0, AAPTR_TARGET );
		bNOTARGETSWITCH = FALSE;
        bNOGRAVITY = FALSE;
		activationtype &= ~THINGSPEC_Deactivate; // clear flag
		activationtype |= THINGSPEC_Activate;	// set flag
		if (target) 
		{
			target.A_ClearTarget();
			A_ClearTarget();
		}
	}

}


// --------------------------------------------------------------------------
class WallBreaker : Actor
{
    Default
    {
        Health 1;
        Radius 16;
        Height 128;
        Gravity 0;

        +VULNERABLE
        +NOTAUTOAIMED
        +NOBLOOD
        +ACTIVATEMCROSS
        +DONTGIB
        +NOICEDEATH

        DeathSound "world/barrelx";
        Obituary "$OB_BARREL"; // "%o went boom."
    }

    States
    {
        Spawn:
            TNT1 A -1;
            Stop;
        Death:
            FEXT B 8 Bright
            {
            	A_QuakeEx( 9, 9, 9, 15, 0, 1024, "", QF_SCALEDOWN, 1,1,1, 256, 0, 2 );
                A_Explode(64,64);
                A_SpawnDebris("ShrapnelCrash",3,3);
                A_Scream();
            }
            FEXT C 6 Bright;
            FEXT D 4 Bright;
            Stop;
    }
}