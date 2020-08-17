// --------------------------------------------------------------------------
//
// Pistol 
//
// --------------------------------------------------------------------------

class TaserPistol : DoomWeapon
{
	Default
	{
		Weapon.SelectionOrder 1900;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 20;
		Weapon.AmmoType "Clip";
		Obituary "$OB_MPPISTOL";
		+WEAPON.WIMPY_WEAPON
		Inventory.Pickupmessage "$GOTTASER";
		Tag "$TAG_PISTOL";
	}
	States
	{
	Ready:
		TNT1 AB 120 A_WeaponReady;
		Loop;
	Deselect:
		TNT1 A 1 A_Lower;
		Loop;
	Select:
		TNT1 A 1 A_Raise;
		Loop;
	Fire:
		TNT1 A 1;
		TNT1 C 1
			{
				A_GunFlash();
				A_FireProjectile("TaserProjectile", 0, true, 8.0, 0);
				A_StartSound("taser/tasshot", CHAN_WEAPON, 0, 0.7, ATTN_NORM, frandom(0.9,1.1));
			}
		TNT1 D 3;
		TNT1 E 8;
		TNT1 B 3; 
		TNT1 A 3 A_Refire; 
		Goto Ready;
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



