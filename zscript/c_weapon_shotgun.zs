// --------------------------------------------------------------------------
//
// Shotgun
//
// --------------------------------------------------------------------------
class ShellLoaded : Ammo
{
    Default
    {
        +INVENTORY.IGNORESKILL 
        Inventory.MaxAmount 3;
        Inventory.Icon "TNT1A0";
    }
}

class Shotgun3 : CrashWeapon replaces Shotgun
{
	float bobeaseamount;

	const BOB_RANGE_X_DEFAULT = 0.6;
	const BOB_RANGE_Y_DEFAULT = 0.4;
	

	Default
	{
		Weapon.SelectionOrder 1900;
		Weapon.AmmoUse1 3;
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive 20;
		Weapon.AmmoType1 "Shell";
		Weapon.AmmoType2 "ShellLoaded";
		Weapon.BobRangeX BOB_RANGE_X_DEFAULT;
		Weapon.BobRangeY BOB_RANGE_Y_DEFAULT;
		Weapon.BobSpeed 1.2;
		Weapon.BobStyle "Smooth";
		Obituary "$OB_MPPISTOL";
		Inventory.Pickupmessage "$GOTTASER";
		Tag "$TAG_PISTOL";
	}
	States
	{
		Ready:
			TNT1 ABAB 80 A_WeaponReady(WRF_ALLOWRELOAD);
			TNT1 FGHGF 5 A_WeaponReady(WRF_ALLOWRELOAD);
			Loop;

		Deselect:
			TNT1 A 1 A_Lower(24);
			Loop;

		Select:
			TNT1 H 1;	
			TNT1 HGF 1 A_Raise(24);
			TNT1 AAAAAAAAAAAAA 1 A_Raise(24);
			Wait;

		Fire:
			TNT1 A 0
			{
				if (CountInv("ShellLoaded") <= 0) return ResolveState("Reload");
				if (CountInv("ShellLoaded") == 1) return ResolveState("Fire1");
				if (CountInv("ShellLoaded") == 2) return ResolveState("Fire2");
				if (CountInv("ShellLoaded") >= 3) return ResolveState("Fire3");
				return ResolveState(null);
			}

		AltFire:
			TNT1 A 0
			{
				if (CountInv("ShellLoaded") <= 0) return ResolveState("Reload");
				if (CountInv("ShellLoaded") >= 1) return ResolveState("Fire1");	
				return ResolveState(null);
			}

		Fire1:
			TNT1 A 1;
			TNT1 C 1
			{
				A_FireShotgun(7);
				A_TakeInventory("ShellLoaded",1);
			}
			Goto FireFinish;

		Fire2:
			TNT1 A 1;
			TNT1 C 1
			{
				A_FireShotgun(20);
				A_TakeInventory("ShellLoaded",2);
			}
			Goto FireFinish;

		Fire3:
			TNT1 A 1;
			TNT1 C 1
			{
				A_FireShotgun(30);
				A_TakeInventory("ShellLoaded",3);
			}

		FireFinish:		
			TNT1 DEF 1;
			TNT1 AAAAAAAA 1
			{
				A_WeaponReady(WRF_ALLOWRELOAD);	
				// slowly let the bob come back
				if ( invoker.BobRangeX < BOB_RANGE_X_DEFAULT ) invoker.BobRangeX += 0.1;
				if ( invoker.BobRangeY < BOB_RANGE_Y_DEFAULT ) invoker.BobRangeY += 0.1;
			}
			TNT1 AAAAAAAA 1
			{
				if (CountInv("ShellLoaded") < 1) return ResolveState("Reload");
				return ResolveState(null);
			}			
			Goto Ready;

		Reload:
			TNT1 A 20
			{
				if (CountInv("ShellLoaded") >=3) return ResolveState("Ready");
				return ResolveState(null);				
			}

			TNT1 A 10 A_TakeInventory("Shell", 3 - CountInv("ShellLoaded"));
			TNT1 A 30 A_GiveInventory("ShellLoaded",3);
			TNT1 A 5 A_WeaponReady();
			Goto Ready;		



	Flash:
		PISF A 1 Bright
		{
			let psp = player.GetPSprite(PSP_FLASH);
			psp.frame = random(0,6);  // 65 = A, 90 = Z
			A_OverlayFlags(PSP_FLASH,PSPF_RENDERSTYLE|PSPF_FORCESTYLE|PSPF_ALPHA,true);
			A_OverlayRenderStyle(PSP_FLASH,STYLE_Add);
			A_OverlayAlpha(PSP_FLASH,0.5); 
			A_ZoomFactor(0.94,ZOOM_INSTANT);
			A_ZoomFactor(1.0);
			A_Light0();
		}
		"####" "#" 1 Bright
		{
			A_OverlayAlpha(PSP_FLASH,0.3); 
			A_Light1();
		}
		"####" "#" 1 Bright
		{
			A_OverlayAlpha(PSP_FLASH,0.1); 
			A_Light2();
		}
		Goto LightDone;
 	Spawn:
		TASR A -1;
		Stop;
	}


	action void A_FireShotgun(int shots)
	{
		A_GunFlash();
		A_StartSound("taser/tasshot", CHAN_WEAPON, 0, 0.7, ATTN_NORM, frandom(0.9,1.1));
		double spread = shots * 0.001;
		for (int i = 0; i < shots; ++i)
			{
				let mo = A_FireProjectile("ShotgunProjectile", 0, false, 2.0, 0, 0, 0);
				if (mo)
				{
					mo.A_FaceMovementDirection();

					// add spread
					mo.angle += random2[Shotgun]() * spread;
					mo.pitch += random2[Shotgun]() * spread;
					mo.speed += random2[Shotgun]() * spread;
					mo.Vel3DFromAngle(mo.speed, mo.angle, mo.pitch);

					// add player velocity to starting position
					mo.SetOrigin(mo.pos + vel, false);
				}
			}

		// we're gonna avoid the weird snap back to the bob position when firing has finished
		invoker.BobRangeX = 0.0;
		invoker.BobRangeY = 0.0;					
	}


}




class Trail : Actor
{
	vector3 lastpos;
	vector3 spawnvel;
	Default
	{
		RenderStyle "Add";
		+NOGRAVITY
	}

	override void PostBeginPlay()
		{
			scale.y = (lastpos- pos).Length() * 0.5;	
			pitch = pitch - 90;

			Super.PostBeginPlay();
		}

	States
	{
		Spawn:
			PLAY A 1
			{
				scale.x = scale.x * 0.6;
				if  (scale.x < 0.05) self.destroy();
			}
			Loop;
	}
}




class ShotgunProjectile : FastProjectile
{
	vector3 lastpos;
	float lastangle, lastpitch;

	Default
	{
		Radius 2;
		Height 2;
		Scale 0.001;
		Speed 110;
		DamageFunction (5 * random[Shotgun]( 1, 3 ));
		ProjectileKickBack 300;

		PROJECTILE;
		+BLOODSPLATTER;
		//+NOEXTREMEDEATH;
/*		MissileType "Trail";
		MissileHeight 8;*/
		//Decal "BulletChip";
		Obituary "$OB_METAPISTOL";
	}

	override void BeginPlay()
	{
		lastpos = pos;
		Super.BeginPlay();
	}

	override void Tick()
	{
			A_FaceMovementDirection();
			lastpos = pos;
			lastangle = angle;
			lastpitch = pitch;

			Super.Tick();

		if (!IsFrozen())
		{
			//actor.Spawn("BulletPuff",pos);
			actor mo = actor.Spawn("Trail",pos);
			if(mo)
			{
				let mo = Trail(mo);
				mo.pitch = lastpitch;
				mo.angle = angle;
				mo.lastpos = lastpos;
				mo.spawnvel = vel;
			}


		}

	}

	States
	{
	Spawn:
		PLSE A 1 BRIGHT;
		Loop;
	Death:
	Crash:
		PUFF A 0 
		{
			A_StartSound("taser/zapsmall", CHAN_BODY, frandom(0.5,1.0));
			
			// GROSS hack to activate hitscan impact triggers
			A_CustomBulletAttack (0, 0, 1, 0, "Actor", 4, CBAF_AIMFACING|CBAF_NOPITCH|CBAF_NORANDOM, AAPTR_TARGET, null, 0, 0);
			A_SprayDecal("BulletChip",4);
		}
		PUFF A 2 BRIGHT A_SpawnDebris("ZappySmall");
		PUFF B 2 BRIGHT A_SetTranslucent(0.9,0);
		PUFF CD 2 BRIGHT;
		Stop;
	XDeath:
		TNT1 A 3 A_StartSound("taser/zapsmall");
		Stop;
	}
}
