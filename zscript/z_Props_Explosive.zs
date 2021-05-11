Class GasCan : Actor
{
    Default
    {
        //$Arg0 "don't thrust"
        Health 20;
        Radius 10;
        Height 48;
        Scale 0.8;

        +SOLID
        +SHOOTABLE
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
            XCAN A 4 { if ( Args[0] == 0 ) bDONTTHRUST= TRUE;}		// if arg1 is set in doombuilder don't allow it to be pushed by explosions
			XCAN A 4;
            Wait;
        Death:
            XCAN B 5 Bright A_Scream;
            XCAN C 5 Bright;
            FEXT C 4 Bright A_SpawnDebris("ShrapnelCrash", 5,5);
            FEXT C 2 Bright A_Explode;      //(128,192)
            FEXT C 5 Bright A_SetScale(1.2);
            FEXT D 5 Bright;
            FEXT D 5 Bright A_SetScale(1.4);
			TNT1 A 1050 BRIGHT A_BarrelDestroy;
			TNT1 A 5 A_Respawn;
            Wait;
     }
}

// --------------------------------------------------------------------------
Class FireExtinguisher : Actor
{
    Default
    {
        Health 1;
        Radius 6;
        Height 24;
        Gravity 0;
        Scale 0.5;

        +SOLID
        +SHOOTABLE
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
            FEXT A -1;
            Stop;
        Death:
            FEXT B 8 Bright
            {
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
Class WallBreaker : Actor
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
                A_Explode(64,64);
                A_SpawnDebris("ShrapnelCrash",3,3);
                A_Scream();
            }
            FEXT C 6 Bright;
            FEXT D 4 Bright;
            Stop;
    }
}