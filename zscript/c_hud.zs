class CrashStatusBar : BaseStatusBar
{
	HUDFont mHUDFont;
	HUDFont mIndexFont;
	HUDFont mAmountFont;
	HUDFont mSmallFont;
	InventoryBarState diparms;
	

	override void Init()
	{
		Super.Init();
		SetSize(32, 320, 200);

		// Create the font used for the fullscreen HUD
		Font fnt = "HUDFONT_DOOM";
		mHUDFont = HUDFont.Create(fnt, fnt.GetCharWidth("0"), Mono_CellLeft, 1, 1);
		fnt = "INDEXFONT_DOOM";
		mIndexFont = HUDFont.Create(fnt, fnt.GetCharWidth("0"), Mono_CellLeft);
		mAmountFont = HUDFont.Create("INDEXFONT");
		mSmallFont = HUDFont.Create("smallfont");
		diparms = InventoryBarState.Create();
	}

	override void Draw (int state, double TicFrac)
	{
		Super.Draw (state, TicFrac);

		// if (state == HUD_StatusBar)
		// {
		// 	BeginStatusBar();
		// 	DrawMainBar (TicFrac);
		// }
		// else if (state == HUD_Fullscreen)
		// {
			BeginHUD();
			DrawFullScreenStuff ();
		// }
	}

	protected void DrawMainBar (double TicFrac)
	{
		DrawImage("STBAR", (0, 168), DI_ITEM_OFFSETS);
		DrawImage("STTPRCNT", (90, 171), DI_ITEM_OFFSETS);
		DrawImage("STTPRCNT", (221, 171), DI_ITEM_OFFSETS);
		
		Inventory a1 = GetCurrentAmmo();
		if (a1 != null) DrawString(mHUDFont, FormatNumber(a1.Amount, 3), (44, 171), DI_TEXT_ALIGN_RIGHT|DI_NOSHADOW);
		DrawString(mHUDFont, FormatNumber(CPlayer.health, 3), (90, 171), DI_TEXT_ALIGN_RIGHT|DI_NOSHADOW);
		DrawString(mHUDFont, FormatNumber(GetArmorAmount(), 3), (221, 171), DI_TEXT_ALIGN_RIGHT|DI_NOSHADOW);

		DrawBarKeys();
		DrawBarAmmo();
		
		if (deathmatch || teamplay)
		{
			DrawString(mHUDFont, FormatNumber(CPlayer.FragCount, 3), (138, 171), DI_TEXT_ALIGN_RIGHT);
		}
		else
		{
			DrawBarWeapons();
		}
		
		if (multiplayer)
		{
			DrawImage("STFBANY", (143, 168), DI_ITEM_OFFSETS|DI_TRANSLATABLE);
		}
		
		if (CPlayer.mo.InvSel != null && !Level.NoInventoryBar)
		{
			DrawInventoryIcon(CPlayer.mo.InvSel, (160, 198));
			if (CPlayer.mo.InvSel.Amount > 1)
			{
				DrawString(mAmountFont, FormatNumber(CPlayer.mo.InvSel.Amount), (175, 198-mIndexFont.mFont.GetHeight()), DI_TEXT_ALIGN_RIGHT, Font.CR_GOLD);
			}
		}
		else
		{
			DrawTexture(GetMugShot(5), (143, 168), DI_ITEM_OFFSETS);
		}
		if (isInventoryBarVisible())
		{
			DrawInventoryBar(diparms, (48, 169), 7, DI_ITEM_LEFT_TOP);
		}
		
	}
	
	protected virtual void DrawBarKeys()
	{
		bool locks[6];
		String image;
		for(int i = 0; i < 6; i++) locks[i] = CPlayer.mo.CheckKeys(i + 1, false, true);
		// key 1
		if (locks[1] && locks[4]) image = "STKEYS6";
		else if (locks[1]) image = "STKEYS0";
		else if (locks[4]) image = "STKEYS3";
		DrawImage(image, (239, 171), DI_ITEM_OFFSETS);
		// key 2
		if (locks[2] && locks[5]) image = "STKEYS7";
		else if (locks[2]) image = "STKEYS1";
		else if (locks[5]) image = "STKEYS4";
		else image = "";
		DrawImage(image, (239, 181), DI_ITEM_OFFSETS);
		// key 3
		if (locks[0] && locks[3]) image = "STKEYS8";
		else if (locks[0]) image = "STKEYS2";
		else if (locks[3]) image = "STKEYS5";
		else image = "";
		DrawImage(image, (239, 191), DI_ITEM_OFFSETS);
	}
	
	protected virtual void DrawBarAmmo()
	{
		int amt1, maxamt;
		[amt1, maxamt] = GetAmount("Clip");
		DrawString(mIndexFont, FormatNumber(amt1, 3), (288, 173), DI_TEXT_ALIGN_RIGHT);
		DrawString(mIndexFont, FormatNumber(maxamt, 3), (314, 173), DI_TEXT_ALIGN_RIGHT);
		
		[amt1, maxamt] = GetAmount("Shell");
		DrawString(mIndexFont, FormatNumber(amt1, 3), (288, 179), DI_TEXT_ALIGN_RIGHT);
		DrawString(mIndexFont, FormatNumber(maxamt, 3), (314, 179), DI_TEXT_ALIGN_RIGHT);
		
		[amt1, maxamt] = GetAmount("RocketAmmo");
		DrawString(mIndexFont, FormatNumber(amt1, 3), (288, 185), DI_TEXT_ALIGN_RIGHT);
		DrawString(mIndexFont, FormatNumber(maxamt, 3), (314, 185), DI_TEXT_ALIGN_RIGHT);
		
		[amt1, maxamt] = GetAmount("Cell");
		DrawString(mIndexFont, FormatNumber(amt1, 3), (288, 191), DI_TEXT_ALIGN_RIGHT);
		DrawString(mIndexFont, FormatNumber(maxamt, 3), (314, 191), DI_TEXT_ALIGN_RIGHT);
	}
	
	protected virtual void DrawBarWeapons()
	{
		DrawImage("STARMS", (104, 168), DI_ITEM_OFFSETS);
		DrawImage(CPlayer.HasWeaponsInSlot(2)? "STYSNUM2" : "STGNUM2", (111, 172), DI_ITEM_OFFSETS);
		DrawImage(CPlayer.HasWeaponsInSlot(3)? "STYSNUM3" : "STGNUM3", (123, 172), DI_ITEM_OFFSETS);
		DrawImage(CPlayer.HasWeaponsInSlot(4)? "STYSNUM4" : "STGNUM4", (135, 172), DI_ITEM_OFFSETS);
		DrawImage(CPlayer.HasWeaponsInSlot(5)? "STYSNUM5" : "STGNUM5", (111, 182), DI_ITEM_OFFSETS);
		DrawImage(CPlayer.HasWeaponsInSlot(6)? "STYSNUM6" : "STGNUM6", (123, 182), DI_ITEM_OFFSETS);
		DrawImage(CPlayer.HasWeaponsInSlot(7)? "STYSNUM7" : "STGNUM7", (135, 182), DI_ITEM_OFFSETS);
	}

	protected void DrawFullScreenStuff ()
	{

		DrawUsePrompt();

		Vector2 iconbox = (40, 20);
		// Draw health
		let berserk = CPlayer.mo.FindInventory("PowerStrength");
		DrawImage(berserk? "PSTRA0" : "MEDIA0", (20, -2));
		DrawString(mHUDFont, FormatNumber(CPlayer.health, 3), (44, -20));
		
		let armor = CPlayer.mo.FindInventory("BasicArmor");
		if (armor != null && armor.Amount > 0)
		{
			DrawInventoryIcon(armor, (20, -22));
			DrawString(mHUDFont, FormatNumber(armor.Amount, 3), (44, -40));
		}
		Inventory ammotype1, ammotype2;
		[ammotype1, ammotype2] = GetCurrentAmmo();
		int invY = -20;
		if (ammotype1 != null)
		{
			DrawInventoryIcon(ammotype1, (-14, -4));
			DrawString(mHUDFont, FormatNumber(ammotype1.Amount, 3), (-30, -20), DI_TEXT_ALIGN_RIGHT);
			invY -= 20;
		}
		if (ammotype2 != null && ammotype2 != ammotype1)
		{
			DrawInventoryIcon(ammotype2, (-14, invY + 17));
			DrawString(mHUDFont, FormatNumber(ammotype2.Amount, 3), (-30, invY), DI_TEXT_ALIGN_RIGHT);
			invY -= 20;
		}
		if (!isInventoryBarVisible() && !Level.NoInventoryBar && CPlayer.mo.InvSel != null)
		{
			DrawInventoryIcon(CPlayer.mo.InvSel, (-14, invY + 17));
			DrawString(mHUDFont, FormatNumber(CPlayer.mo.InvSel.Amount, 3), (-30, invY), DI_TEXT_ALIGN_RIGHT);
		}
		if (deathmatch)
		{
			DrawString(mHUDFont, FormatNumber(CPlayer.FragCount, 3), (-3, 1), DI_TEXT_ALIGN_RIGHT, Font.CR_GOLD);
		}
		else
		{
			DrawFullscreenKeys();
		}
		
		if (isInventoryBarVisible())
		{
			DrawInventoryBar(diparms, (0, 0), 7, DI_SCREEN_CENTER_BOTTOM, HX_SHADOW);
		}
	}
	
	protected virtual void DrawFullscreenKeys()
	{
		// Draw the keys. This does not use a special draw function like SBARINFO because the specifics will be different for each mod
		// so it's easier to copy or reimplement the following piece of code instead of trying to write a complicated all-encompassing solution.
		Vector2 keypos = (-10, 2);
		int rowc = 0;
		double roww = 0;
		for(let i = CPlayer.mo.Inv; i != null; i = i.Inv)
		{
			if (i is "Key" && i.Icon.IsValid())
			{
				DrawTexture(i.Icon, keypos, DI_SCREEN_RIGHT_TOP|DI_ITEM_LEFT_TOP);
				Vector2 size = TexMan.GetScaledSize(i.Icon);
				keypos.Y += size.Y + 2;
				roww = max(roww, size.X);
				if (++rowc == 3)
				{
					keypos.Y = 2;
					keypos.X -= roww + 2;
					roww = 0;
					rowc = 0;
				}
			}
		}
	}


const FLAGS = DI_SCREEN_LEFT_BOTTOM | DI_ITEM_LEFT | DI_TEXT_ALIGN_LEFT ;
const TRANS = Font.CR_UNTRANSLATED;
const ALPHA = 0.8;

	protected virtual void DrawUsePrompt()
	{
		let plr = CrashPlayer(CPlayer.mo);
		string text;

	// with object picked up		
		if (plr.target && CheckWeaponSelected("HoldingObjectWeapon") == TRUE )
		{
			text =	String.Format("%s - throw %s\n%s - drop %s",
									GetStrKeyBinds("+attack"), plr.target.GetTag(),
									GetStrKeyBinds("+use"),plr.target.GetTag());
		}

	// if looking at actor
		else if (plr.useable.HitType == TRACE_HitActor && plr.useable.HitActor) 
		{
			// looking at activatible object		
	        if (plr.useable.HitActor.bUseSpecial == TRUE) 
	        {
	        	// get object name
				string thingtag = plr.useable.HitActor.GetTag();

				// get parent object name
				if (plr.useable.HitActor is "CollisionChild")
					thingtag = plr.useable.HitActor.master.GetTag();

				// text for looking at liftable object or it's child
		        if (plr.useable.HitActor is "LiftableActor" ||
		        	plr.useable.HitActor is "CollisionChild")					
					text = String.Format("%s - pick up %s", GetStrKeyBinds("+use"), thingtag);

				// text for looking at standard activatable object
				else text = String.Format("%s - use %s", GetStrKeyBinds("+use"), thingtag);

			}
		}
    // if looking at activatible linedef 
        else if (plr.useable.HitType == TRACE_HitWall && plr.useable.HitLine.activation == SPAC_Use)
			text = String.Format("%s - activate ", GetStrKeyBinds("+use"));

		Screen.DrawText(mSmallFont.mfont, TRANS, xPercent(3), yPercent(75), text, DTA_CleanNoMove_1, true, DTA_Alpha, ALPHA );

    //    DrawString(mConFont,FormatNumber(plr.useable.HitType, 0, 100), location);
    //    Screen.Dim(888888,0.5,40,40,40,40);
    }

    private string GetStrKeyBinds(string command)
    {
	//  reference for the key codes
	//	https://github.com/coelckers/gzdoom/blob/4bcea0ab783c667940008a5cab6910b7a826f08c/src/common/console/c_bind.cpp#L54
		int bindingKeys[2];
		[bindingKeys[0], bindingKeys[1]] = Bindings.GetKeysForCommand(command);
		//return KeyBindings.NameKeys(bindingKeys[0], bindingKeys[1]); // text version
		//return FormatNumber(bindingKeys[0],3).." / "..FormatNumber(bindingKeys[1],3);
		if (bindingKeys[0] == 0) return "unassigned";
		if (bindingKeys[0] < 255) bindingKeys[0] += 512; // stop conflicts with normal ascii by adding $200
		if (bindingKeys[1] == 0) return String.Format("%c", bindingKeys[0]);	
		if (bindingKeys[1] < 255) bindingKeys[1] += 512; // same
		return String.Format("%c / %c", bindingKeys[0], bindingKeys[1]);

	}

	private float xPercent (float percent)
	{
		return Screen.Getwidth() * 0.01 * percent;
	}
	private float yPercent (float percent)
	{
		return Screen.GetHeight() * 0.01 * percent;
	}
}
