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