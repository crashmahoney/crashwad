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
        // DefThreshold is added to x offset of held objects,
        // for small objects that need to be held further away
        DefThreshold 0;
        // FloatSpeed is added to z offset of held objects,
        // for objects that need to be held higher or lower
        FloatSpeed 0;
        ProjectileKickBack 300;
		+INTERPOLATEANGLES 
    	+CANPASS
    	+ACTLIKEBRIDGE
		+USESPECIAL
		Activation THINGSPEC_Switch | THINGSPEC_ThingTargets | THINGSPEC_TriggerTargets;
	}

    override void Tick()
    {     
        if (!target)
        {
        	ResolveState("Inactive");
	        if (abs(vel.x) > 2 || abs(vel.y) > 2)
	        {
	            bACTIVATEIMPACT = TRUE;
	            bACTIVATEPCROSS = TRUE;
	        }
	        else
	        {
	            bACTIVATEIMPACT = false;
	            bACTIVATEPCROSS = false;           
	        }
	    }
        Super.Tick();
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
		offset.x = (target.radius + radius + 8.) * 2. - (abs(target.pitch) * 0.7) + DefThreshold;
		offset.z = clamp((target.height*0.8)-(height*0.5) - target.pitch + FloatSpeed, 1. + floordif , 80.);

		// warp to new position
		A_Warp(AAPTR_TARGET, offset.x, offset.y, offset.z, 0, WARPF_INTERPOLATE | WARPF_COPYVELOCITY);

		// look at player and fire a linetrace to check for a clear line of sight
		A_FaceTarget(0,0,0,0, FAF_TOP);
    	FLineTraceData LosToPlayer;
        LineTrace(
           self.AngleTo(target,true), // gets absolute angle from caller to target
           128, // distance
           pitch, // pitch
           flags: TRF_THRUACTORS | TRF_BLOCKSELF, 
           offsetz: 0,
           data: LosToPlayer
            );

        // restore previous angle and pitch
		angle = pickupangle + target.AngleTo(self,true);
        pitch = 0;

		// if linetrace didn't hit the player
		if (LosToPlayer.HitActor != target )
		{
			// restore previous position
			A_Warp(AAPTR_TARGET, oldpos.x, oldpos.y, oldpos.z, angle, WARPF_ABSOLUTEPOSITION | WARPF_ABSOLUTEANGLE );

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

