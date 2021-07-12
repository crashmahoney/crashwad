//===========================================================================
//
// Player
//
//===========================================================================

class CrashPlayer : PlayerPawn
{
	const DASH_VEL			= 50;
	const DASH_TIME			= 1;
	const DASH_COOLDOWN		= 40;
	const SLIDE_TIME		= 20;
	const DASH_BACK_JUMP	= 8;
    int maxdash;
	int cooldash;
	bool sounddash;
	int slidetime;
	FLineTraceData useable;

    Override void Tick()
    {
//		CVar weapbobspeed = CVar.GetCVar('wbobspeed',self);
//		CVar firebobspeed = CVar.GetCVar('wbobfire ',self);
//		firebobspeed.SetFloat(weapbobspeed.GetFloat());
	

    	// check for useable stuff in front of player
    	
            LineTrace(
               angle,
               UseRange,
               pitch,
               flags: TRF_SOLIDACTORS, 
               offsetz: AttackZOffset,
               data: useable
            );

        Super.Tick();
        If(health>0){DoDash();}
    }

	Default
	{
		Speed 1;
		Health 100;
		Radius 16;
		Height 56;
		Mass 100;
		PainChance 255;
		Player.DisplayName "Marine";
		Player.CrouchSprite "PLYC";
//		Player.StartItem "TaserPistol";
//		Player.StartItem "Fist";
//		Player.StartItem "Clip", 50;
//		Player.StartItem "Cash", 23;		
		Player.WeaponSlot 1, "Fist", "Chainsaw";
		Player.WeaponSlot 2, "TaserPistol";
		Player.WeaponSlot 3, "Shotgun3";
		Player.WeaponSlot 4, "Chaingun";
		Player.WeaponSlot 5, "RocketLauncher";
		Player.WeaponSlot 6, "PlasmaRifle";
		Player.WeaponSlot 7, "BFG9000";
		
		Player.AttackZOffset 32;
		Player.JumpZ 12;
		Player.GruntSpeed 12;
		Player.FallingScreamSpeed 35, 40;
		Player.ViewHeight 60;
		Player.UseRange 64;
		Player.ForwardMove 2,1;
		Player.SideMove 2,1;
		
		Player.ColorRange 112, 127;
		Player.Colorset 0, "$TXT_COLOR_GREEN",		0x70, 0x7F,  0x72;
		Player.Colorset 1, "$TXT_COLOR_GRAY",		0x60, 0x6F,  0x62;
		Player.Colorset 2, "$TXT_COLOR_BROWN",		0x40, 0x4F,  0x42;
		Player.Colorset 3, "$TXT_COLOR_RED",		0x20, 0x2F,  0x22;
		// Doom Legacy additions
		Player.Colorset 4, "$TXT_COLOR_LIGHTGRAY",	0x58, 0x67,  0x5A;
		Player.Colorset 5, "$TXT_COLOR_LIGHTBROWN",	0x38, 0x47,  0x3A;
		Player.Colorset 6, "$TXT_COLOR_LIGHTRED",	0xB0, 0xBF,  0xB2;
		Player.Colorset 7, "$TXT_COLOR_LIGHTBLUE",	0xC0, 0xCF,  0xC2;
	}

	States
	{
	Spawn:
		PLAY A -1;
		Loop;
	See:
		PLAY ABCD 4;
		Loop;
	Missile:
		PLAY E 12;
		Goto Spawn;
	Melee:
		PLAY F 6 BRIGHT;
		Goto Missile;
	Pain:
		PLAY G 4;
		PLAY G 4 A_Pain;
		Goto Spawn;
	Death:
		PLAY H 0 A_PlayerSkinCheck("AltSkinDeath");
	Death1:
		PLAY H 10;
		PLAY I 10 A_PlayerScream;
		PLAY J 10 A_NoBlocking;
		PLAY KLM 10;
		PLAY N -1;
		Stop;
	XDeath:
		PLAY O 0 A_PlayerSkinCheck("AltSkinXDeath");
	XDeath1:
		PLAY O 5;
		PLAY P 5 A_XScream;
		PLAY Q 5 A_NoBlocking;
		PLAY RSTUV 5;
		PLAY W -1;
		Stop;
	AltSkinDeath:
		PLAY H 6;
		PLAY I 6 A_PlayerScream;
		PLAY JK 6;
		PLAY L 6 A_NoBlocking;
		PLAY MNO 6;
		PLAY P -1;
		Stop;
	AltSkinXDeath:
		PLAY Q 5 A_PlayerScream;
		PLAY R 0 A_NoBlocking;
		PLAY R 5 A_SkullPop;
		PLAY STUVWX 5;
		PLAY Y -1;
		Stop;
	}
	
	
// Dash
// https://forum.zdoom.org/viewtopic.php?f=122&t=70570

	void DoDash()
    {
	
		int xvel;
		int yvel;
		int zvel;
		
	//	A_log(String.Format("%i %i, %i %i", xvel, yvel, GetPlayerInput(MODINPUT_FORWARDMOVE), GetPlayerInput(MODINPUT_SIDEMOVE)));
	
        If(GetPlayerInput(MODINPUT_BUTTONS)&BT_SPEED && maxdash<DASH_TIME) //If player is holding BT_SPEED, aka [Run]
        {
			// set dash properties according to which direction the player is pressing
			if (GetPlayerInput(MODINPUT_FORWARDMOVE) > 0 )
			{
				xvel = DASH_VEL;
				if (IsPlayerStanding())
				{
					slidetime = SLIDE_TIME;
					A_StartSound("player/slide",CHAN_AUTO);				
				}
			}
			
			if (GetPlayerInput(MODINPUT_FORWARDMOVE) < 0 )
			{
				xvel = -DASH_VEL * 0.5;
				if (IsPlayerStanding())
				{
					zvel = DASH_BACK_JUMP;
					A_StartSound("*jump",CHAN_AUTO);
				}
			}
			
			if (GetPlayerInput(MODINPUT_SIDEMOVE) < 0 )
			{
				yvel = DASH_VEL;
			}
			
			if (GetPlayerInput(MODINPUT_SIDEMOVE) > 0 )	
			{
				yvel = -DASH_VEL;
			}

			// if player is moving forward and strafing at the same time, reduce speeds a bit
			if (xvel != 0 && yvel != 0) { xvel = xvel * 0.707; yvel = yvel * 0.707; }
		
			// if no directions pressed, dash forwards
			if (xvel == 0 && yvel == 0) { xvel = DASH_VEL; }	
		
		If(sounddash)
			{
				A_StartSound("skeleton/swing",CHAN_AUTO);
				sounddash=0;
			} //To play a sound when dashing
            A_ChangeVelocity(xvel,yvel,zvel,CVF_RELATIVE|CVF_REPLACE); //Replace third zero with vel.z to make the player subject to gravity
            maxdash++;
			cooldash=0;
			
		
		
      //      bTHRUACTORS=1;
      /*      If(FindInventory("PowerStrength")) //Berserk effects
            {
                A_Explode(10,64,XF_NOTMISSILE);
                A_SpawnItemEx("ArchvileFire");
            }*/
        }
        Else
        {
            If(cooldash>=DASH_COOLDOWN) //Cooldown on dash recharge
            {
                If(!sounddash){A_StartSound("misc/i_pkup"); sounddash=1;} //Sound when recharging
                maxdash=0;
            }
            Else{cooldash++; maxdash=DASH_TIME;}
       //     bTHRUACTORS=0;
        }
		
			
		if (slidetime > 0)
		{
			slidetime --;
			ViewHeight = Default.ViewHeight * 0.5 ;
			Height = default.height * 0.5;
			attackzoffset = 16;
			if (slidetime & 7 == 0) { A_Punch(); }
		}
		else
		{
			ViewHeight = Default.ViewHeight;
			Height = default.height;
		}
		
    }

// returns true if actor is either standing on the ground or on top of another actor
	bool IsPlayerStanding()
	{
		bool ok; Actor below;
		[ok, below] = TestMobjZ(true);
		if (below || abs(pos.z - GetZAt()) <= 1)
		{
			return (true);
		}
		
		return (null);
	}
	
}

