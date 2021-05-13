// --------------------------------------------------------------------------
Class GlassShrapnel : Actor
{
	Default
	{
		Radius 1;
		Height 1;
		Health 4; //number of pieces to spawn when created with A_SpawnDebris
		Gravity 2;
		Scale 0.5;
		RenderStyle "Add";
		Alpha 0.7;
		BounceType "Grenade";
		BounceFactor 0.5;

		+CLIENTSIDEONLY
		+ROLLSPRITE
		+FORCEXYBILLBOARD
		+NOBLOCKMAP
		+NOCLIP
	}

	States
	{
		Spawn:
			GLsS A 0 NoDelay
			{
				A_SetRoll(random(0,359));
				A_Jump(256,"Frame1","Frame2","Frame3");
			}
		Frame1:
			GLsS ABCABCABCABC 3;
			GLsS A -1;
			Stop;
	//		Goto Death;
		Frame2:
			GLsS BCABCABCABCA 3;
			GLsS B -1;
			Stop;
	//		Goto Death;
		Frame3:
			GLsS CABCABCABCAB 3;
			GLsS C -1;
			Stop;
	//		Goto Death;
	//	Death:
	//    	"----" A 1 A_FadeOut(0.06);
 	//   			Wait
	}
}

// --------------------------------------------------------------------------
Class ShrapnelCrash : Actor
{
	int pick_sprite;
	int frames_left;
	static const string sprite_names[] = { "SHRP","SHRB","SHRC","SHRG","SHRE","SHRF" } ;
	static const int frame_counts[] = { 3, 	   3,      3,     3,     2,     8 };

	Default
	{
		Health 20;
		Radius 1;
		Height 1;
		Gravity 1;

		+CLIENTSIDEONLY
		//+TOUCHY
		//+NOCLIP
		//+NOBLOCKMAP
	}

    override void PostBeginPlay()
    {
		pick_sprite = random(0,5);	// pick a sprite sequence
		sprite = GetSpriteIndex(sprite_names[pick_sprite]);
		frame = random(0,frame_counts[pick_sprite]); // pick a random starting frame
		frames_left = 12; // animate for 12 frames

		Super.PostBeginPlay();
    }


	States
	{
		Spawn:
			#### # 2
			{
				if ( frame < frame_counts[pick_sprite])	frame++; 
				else frame = 0;

				frames_left--;
				if (frames_left == 0) SetStateLabel("Death");
			}
			Loop;
		Death:
			TNT1 A 0; //remove object
			Stop;
		XDeath: // this just initialises all the sprites, and is never called
			SHRP A 0;
			SHRB A 0;
			SHRC A 0;
			SHRG A 0;
			SHRE A 0;
			SHRF A 0;
	}
}

// --------------------------------------------------------------------------
Class TeleSparkGenerator : SwitchableDecoration 
{
	Default
	{
		+NOBLOCKMAP 
		+NOGRAVITY
		+DONTSPLASH
		+MOVEWITHSECTOR
		+NOTELEPORT
	}

	States
	{
		Spawn:
			TNT1 A 8;
			Loop;
		Active:
			TNT1 A 0 A_Jump(256,1,2,3);
			TNT1 A 16;
			TNT1 A 16;
			TNT1 A 0 A_SpawnItemEx("TeleSpark", random(0,64)-32, random(0,64)-32, 20,0,0,1.5);
			TNT1 A 16;
			Loop;
		Inactive:
			TNT1 A 8;
			Loop;
	}
}

Class TeleSpark : Actor
{
	Default
	{
		Height 8;
		Radius 8;
		Speed 1;
		Scale 0.25;
		RenderStyle "ADD";
		Alpha 0.8;
		PROJECTILE;

		+NOBLOCKMAP 
		+NOGRAVITY
		+DONTSPLASH
		+NOTELEPORT
	}

	States
	{
		Spawn:
			TELE A 10 A_ScaleVelocity(1.25);
			Loop;
		Death:
			Stop;
	}
}

// --------------------------------------------------------------------------
