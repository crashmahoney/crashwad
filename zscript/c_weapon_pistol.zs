// --------------------------------------------------------------------------
//
// Pistol 
//
// --------------------------------------------------------------------------

class TaserPistol : CrashWeapon
{
	float bobeaseamount;

	const BOB_RANGE_X_DEFAULT = 0.6;
	const BOB_RANGE_Y_DEFAULT = 0.4;
	

	Default
	{
		Weapon.SelectionOrder 1900;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 20;
		Weapon.AmmoType "Clip";
		Weapon.BobRangeX BOB_RANGE_X_DEFAULT;
		Weapon.BobRangeY BOB_RANGE_Y_DEFAULT;
		Weapon.BobSpeed 1.2;
		Weapon.BobStyle "Smooth";
		Obituary "$OB_MPPISTOL";
		+WEAPON.WIMPY_WEAPON
		Inventory.Pickupmessage "$GOTTASER";
		Tag "$TAG_PISTOL";
	}
	States
	{
	Ready:
		Ready:
		TNT1 ABAB 80 A_WeaponReady;
		TNT1 FGHGF 5 A_WeaponReady;
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
		TNT1 A 1;
		TNT1 C 1
			{
				A_GunFlash();
				A_FireProjectile("TaserProjectile", 0, true, 8.0, 0);
				A_StartSound("taser/tasshot", CHAN_WEAPON, 0, 0.7, ATTN_NORM, frandom(0.9,1.1));
				// we're gonna avoid the weird snap back to the bob position when firing has finished
				invoker.BobRangeX = 0.0;
				invoker.BobRangeY = 0.0;				
			}
		TNT1 D 3;
		TNT1 E 4;
		TNT1 F 6;
		TNT1 AAAAAAAA 1
			{
				A_WeaponReady();	
				// slowly let the bob come back
				if ( invoker.BobRangeX < BOB_RANGE_X_DEFAULT ) invoker.BobRangeX += 0.1;
				if ( invoker.BobRangeY < BOB_RANGE_Y_DEFAULT ) invoker.BobRangeY += 0.1;
/*				return (invoker.BobRangeX < BOB_RANGE_X_DEFAULT
						&& invoker.BobRangeY < BOB_RANGE_Y_DEFAULT)
								? invoker.resolveState("Ready") : null;*/
			}
		Goto Ready;
		
		
		
/*		old version of bob snap removal
		TNT1 F 1
			{
				invoker.bobeaseamount = 0.001;
				player.bob = 0.0;
				A_WeaponReady(WRF_NOBOB|WRF_NOFIRE|WRF_NOSWITCH);
			}
	FireBobEase:		
		TNT1 A 1 
				{
				let player = self.player;
				player.bob = player.bob * invoker.bobeaseamount;
				invoker.bobeaseamount = invoker.bobeaseamount + invoker.bobeaseamount;
				A_WeaponReady(WRF_NOFIRE|WRF_NOSWITCH);
				return (invoker.bobeaseamount > 1.0) ? invoker.resolveState("Ready") : null;
				}
		//wait;
		Goto FireBobEase;
*/
	Flash:
		PISF A 1 Bright
		{
			let psp = player.GetPSprite(PSP_FLASH);
			psp.frame = random(0,6);  // 65 = A, 90 = Z
			A_OverlayFlags(PSP_FLASH,PSPF_RENDERSTYLE|PSPF_FORCESTYLE|PSPF_ALPHA,true);
			A_OverlayRenderStyle(PSP_FLASH,STYLE_Add);
			A_OverlayAlpha(PSP_FLASH,0.5); 
			A_ZoomFactor(0.98,ZOOM_INSTANT);
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
}



class TaserProjectile : FastProjectile
{
	Default
	{
		Alpha 0.90;
		RenderStyle "Add";
		Radius 2;
		Height 2;
		DamageFunction ( random( 1, 3 ) * 4);
		Speed 90;
		PROJECTILE;
		+BLOODSPLATTER;
		+NOEXTREMEDEATH;
		+ADDITIVEPOISONDAMAGE;
		PoisonDamage 1, 30, 7;
		PoisonDamageType "Electric";
		Scale 0.3;
		//MissileType "PistolTracerTrail";
		MissileHeight 8;
		//Decal "BulletChip";
		Obituary "$OB_METAPISTOL";
	}
/*	
override void PostBeginPlay()
	{
		Actor.Spawn("PistolFlash", Vec3Angle( 0,0,0 ), NO_REPLACE);
		Super.PostBeginPlay();
	}
*/	
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

class PistolTracerSpark : Actor
{
	Default
	{
		Health 4;
		radius 3;
		height 6;
		speed .1;
		RenderStyle "Add";
		Alpha 1;
		Scale 0.5;
		Mass 0;
		+missile
		+doombounce
		+FLOORCLIP
		+DONTSPLASH
		+NOTELEPORT
	}
	States
	{
		TELE A 1;
		TELE AAAAA 1  Bright A_SetTranslucent(.8,1);
		TELE AAAAAA 1  Bright A_SetTranslucent(.6,1);
		TELE AAAAAAAA 1  Bright A_SetTranslucent(.4,1);
		TELE AAAAAAAAAA 1 Bright A_SetTranslucent(.2,1);
		Stop;
	}
	
	override bool CanCollideWith(Actor other, bool passive)
	{
		return false;
	}
}

class MetaZappy : Actor
{
	Default
	{
		Radius 8;
		Height 8;
		Speed 16;
		DamageFunction (random( 0, 2 ));
		DamageType "Electric";
		Projectile;
		+RANDOMIZE
		//+NOCLIP
		+BLOODSPLATTER;
		+CLIENTSIDEONLY
		+FORCEXYBILLBOARD
		+ROLLSPRITE
		+ROLLCENTER
		RenderStyle "Add";
		scale 0.5;
		Alpha 1;
	}
	States
	{
	Spawn:
		ZAPP A 0;
		ZAPP A 0 A_Stop;
		ZAPP A 0 A_SetRoll(random(0,360));
		ZAPP ABCD 0 A_Jump(256, "Death");
	Death:
		ZAPP A 1 bright
		{
			A_FadeOut(0.1);
			A_SetRoll(random(0,360));
		}
		loop;
	}
}

class ZappySmall :MetaZappy
{
	Default
	{
		Scale 0.1;
		Damage 0;
		Health 4;
		Radius 3;
		Height 6;
		Mass 0;
		-NOGRAVITY
		+doombounce
		+FLOORCLIP
		+DONTSPLASH
	}

}


class PistolFlash : TaserProjectile
{
	Default
	{
	
		Speed 1;

	//	RenderStyle "Add";
		+NOGRAVITY;
		+NOINTERACTION;
		+NOBLOCKMAP;
		+NOTELEPORT;
		+ForceXYBillboard;
		+CLIENTSIDEONLY;
		
	}

	States
	{
	
	    WFLR A 1 Bright;
		loop;
	//	BAL2 BCDE 5 Bright;
	//	loop;
	
	}
}



