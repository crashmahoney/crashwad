//===========================================================================
//
// Generic Monster Stuff
//
//===========================================================================

mixin class CrashMonsterBase
{
	int zap_timer;

	//---------------------------------------------------------------------------
	// Do things that should happen every single gametic.
	override void Tick()
	{

	// Taser zap effects	
		if ( PoisonDamageReceived > 0 && PoisonDamageTypeReceived == "Electric" )
		{
			zap_timer --;
			self.PainChance = 200;
			
			if ( zap_timer <= 0 )
			{
				A_SpawnProjectile( "MetaZappy", frandom( 16.0, self.height ), frandom( -5.0, 5.0 ), 0, 0, 0 );		
				A_StartSound( "taser/zap1", CHAN_BODY, 0, frandom( 0.5, 0.7 ), ATTN_NORM, frandom( 0.7, 1.3 ), 0.0 );
				zap_timer = clamp( 40 - ( PoisonDamageReceived * 5 ), 2, 40 );
				
				if ( health <= 0 )
				{
					zap_timer = 45 + random(0,6);
				}
			}
			
			if ( health > 0 )
			{
				A_SpawnParticle( "LightGray", SPF_RELATIVE | SPF_FULLBRIGHT, random(20, 35), random(4, 12), random(0, 360), random(0, 8) * Scale.X, 0, random(28, 42), frandom(-3.0,3.0), frandom(-3.0,3.0), frandom(3.0, 6.0),0,0,-0.9);
			}
			else if ( ( gametic & 7 ) == 0 ) // every seventh gametic
			{
				A_SpawnItemEx( "Smoulder",
								frandom( -3.0, 3.0 ),
								frandom( -3.0, 3.0 ),
								4.0,
								frandom( -0.4, 0.4 ),
								frandom( -0.4, 0.4 ),
								frandom( 0.6, 0.8 ),
								0,SXF_NOCHECKPOSITION,0,0);
			}
		}

		Super.Tick();
	}
	
	//---------------------------------------------------------------------------
	// do stuff when dying
	//---------------------------------------------------------------------------
	override void Die(Actor source, Actor inflictor, int dmgflags)
	{

		switch (random(0,19))
		{
		case 0:
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		case 6:
			Crash.SpawnCash(self, "Cash");
			break;
		case 10:
		case 11:
		case 12:
			Crash.SpawnCash(self, "Cash");
			Crash.SpawnCash(self, "Cash");
			break;
		case 19:
			Crash.SpawnCash(self, "NoteBundle");
			break;
		default:
			break;		
		}

		Super.Die(source, inflictor, dmgflags);

	}
	
}

class C_Arachnotron : Arachnotron replaces Arachnotron { mixin CrashMonsterBase; }

class C_Archvile : Archvile replaces Archvile { mixin CrashMonsterBase; }

class C_BaronOfHell : BaronOfHell replaces BaronOfHell { mixin CrashMonsterBase; }

class C_HellKnight : HellKnight replaces HellKnight { mixin CrashMonsterBase; }

class C_Cacodemon : Cacodemon replaces Cacodemon { mixin CrashMonsterBase; }

class C_Cyberdemon : Cyberdemon replaces Cyberdemon { mixin CrashMonsterBase; }

class C_Demon : Demon replaces Demon { mixin CrashMonsterBase; }

class C_Imp : DoomImp replaces DoomImp { mixin CrashMonsterBase; }

class C_Fatso : Fatso replaces Fatso { mixin CrashMonsterBase; }

class C_LostSoul : LostSoul replaces LostSoul { mixin CrashMonsterBase; }

class C_PainElemental : PainElemental replaces PainElemental { mixin CrashMonsterBase; }

class C_ZombieMan : ZombieMan replaces ZombieMan { mixin CrashMonsterBase; }

class C_ShotgunGuy : ShotgunGuy replaces ShotgunGuy { mixin CrashMonsterBase; }

class C_ChaingunGuy : ChaingunGuy replaces ChaingunGuy { mixin CrashMonsterBase; }

class C_WolfensteinSS : WolfensteinSS replaces WolfensteinSS { mixin CrashMonsterBase; }

class C_Revenant : Revenant replaces Revenant { mixin CrashMonsterBase; }

class C_SpiderMastermind : SpiderMastermind replaces SpiderMastermind { mixin CrashMonsterBase; }

