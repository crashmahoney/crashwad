class SteamSpawner : Actor
{
	Default
	{
	//$arg0 spawn area mult /10
	//$arg0default 10
	//$arg1 speed mult /10
	//$arg1default 10
	//$arg2 tics between spawns
	//$arg2default 8	
	
	Radius 8;
	Height 16;
	}
	
	States
	{
		Spawn:
			TNT1 A 8
			{
				if (LookForPlayers(true) == true)
				{
					A_ClearTarget(); // checking for player gives a target, so we clear it
					A_SetTics(Args[2]);		
					A_SpawnItemEx("Fog",
									frandom(-3.0,3.0) * (Args[0] / 10.0),
									frandom(-3.0,3.0) * (Args[0] / 10.0),
									0,
									frandom(-0.2,1.0) * (Args[1] / 10.0),
									frandom(-0.2,1.0) * (Args[1] / 10.0),
									frandom(1.0,3.0) * (Args[1] / 10.0),
									0,SXF_NOCHECKPOSITION|SXF_TRANSFERSCALE|SXF_TRANSFERALPHA,0,0);
				}
			}
		Loop;
	}


}


class Fog : Actor
{
Default
	{
	Radius 32;
	Height 64;
	RenderStyle "Add";
	Alpha 0.4;
	+NOINTERACTION;
	+FORCEXYBILLBOARD;
	+ROLLSPRITE;
	+ROLLCENTER;
	}
	
	States
	{
		Spawn:
			FOGW A 0 NoDelay {	self.roll = random(0,359);
								A_SetScale(frandom(0.1,0.2));
								A_FadeOut(frandom(0.0,0.2));

							}

		Roll:
			FOGW A 1 {	A_SetRoll(self.roll + 1,SPF_INTERPOLATE);
						A_SetScale(scale.x + 0.005);
						A_FadeOut(0.005);
					}
			Loop;
	}

}

class Smoulder : Fog
{
Default
	{
	Alpha 0.5;
	Scale 0.001;	
	}
	

}

