--
-- Addon helps you notice when someone whispers to say they want Power Infusion.
--

--		I added the "buddy" concept after seeing a "PiBuddy" addon that works for retail wow.
--			See: https://www.curseforge.com/wow/addons/pibuddy
--		Further,  Nyxxis from TW made a similar addon called "EmeraldPowerInfusion" and I liked his "show an icon" functionality, so I added it in. 
--			See: https://github.com/NyxxisTW/EmeraldPowerInfusion


--[[ PiMe.UI.CountdownButton button TODOs 
* when no buddy set
	** it's enabled with the test "/pime help"
	** onclick it runs "/pime help"
* when buddyt set
	** ... and no known cooldown
		** it's by default enabled with "[Priestname] | PI Check?"
		** Onclick it runs "/pime check pi"
			** (which itself should listen for the response whisper and update the cooldown)
	** ... and known cooldown
		** if the cooldown is positive (future) then the button is disabled with "[Priestname] | [time, e.g. 2m 27s]"
		** if the cooldown is negative (past) then the button is enabled with "[Priestname] | !! [time, e.g. 2m 27s] !!" (maybe? the !!'s seem lame but want to differentiate... maybe just enabled is enough)
--]]


-- == == == == == == == == == == == == == == == == == == == == -- 
-- Slash-Command / Event Support Functions
--		From an event, direct the request
-- == == == == == == == == == == == == == == == == == == == == -- 

	local function AddonLoaded()
		PiMe.InitializeCfg()

		-- Set the button location upon reload
		if PiMe_Cfg.countdownTimerRef ~= nil and PiMe_Cfg.countdownTimerX ~= nil and PiMe_Cfg.countdownTimerY ~= nil then 
			PiMe.UI.CountdownButton:SetPoint(PiMe_Cfg.countdownTimerRef, PiMe_Cfg.countdownTimerX, PiMe_Cfg.countdownTimerY) 
		end

		if not PiMe_Cfg.hasEverUnlocked then PiMe.PPrint("Use '/PiMe help' to get started and '/pime unlock' will make this message go away.") end
	end
	
	local function AuraUpdate()
		if "Priest" ~= UnitClass("player") then
			PiMe.DestChar.AuraUpdate()
		end
	end

	local function CooldownCheck(spellName, recipient)
			if "Priest" == UnitClass("player") then
				PiMe.SourceChar.CooldownCheck(spellName, recipient)
			else
				PiMe.DestChar.CooldownCheck(spellName, recipient)
			end
	end

	local function CooldownCast(spellName, recipient)
			if "Priest" == UnitClass("player") then
				PiMe.SourceChar.CooldownCast(spellName, recipient)
			else
				PiMe.DestChar.CooldownCast(spellName, recipient)
			end
	end

	local function ReactToWhisper(eventMessage, eventOriginator)
		if "Priest" == UnitClass("player") then
			PiMe.SourceChar.ReactToWhisper(eventMessage, eventOriginator)
		end
	end

-- == == == == == == == == == == == == == == == == == == == == -- 
-- Slash-Command Support Actions
--		From a user's slash command, these verify and execute the request
-- == == == == == == == == == == == == == == == == == == == == -- 
	
	local function PrintCfg()
			local COLOR = PiMe.START_COLOR..PiMe.EMPHASIS_COLOR
			PiMe.PPrint("PiMe - Current Settings:")
			PiMe.PPrint(COLOR.."    /PiMe banner "..PiMe.END_COLOR.. (PiMe_Cfg.printAnnoyingBanner and " on" or " off"))
			PiMe.PPrint(COLOR.."    /PiMe icon "..PiMe.END_COLOR.. (PiMe_Cfg.showAnnoyingImage and " on" or " off"))
			PiMe.PPrint(COLOR.."    /PiMe sound "..PiMe.END_COLOR.. (PiMe_Cfg.makeAnnoyingNoise and " on" or " off"))
			PiMe.PPrint(COLOR.."    /PiMe buddy "..PiMe.END_COLOR.. (PiMe_Cfg.raidBuddy or "(not set yet)"))
	end

	local function PrintHelp() 
		local COLOR = PiMe.START_COLOR..PiMe.EMPHASIS_COLOR
		local GREEN = PiMe.START_COLOR..PiMe.GREEN_COLOR
		
		PiMe.PPrint(" ")
		PiMe.PPrint(COLOR.."Priests: PiMe communicates PI cooldown time"..PiMe.END_COLOR)
		PiMe.PPrint(COLOR.."Mages/Locks: PiMe notices when PI hits you and lets you know when PI is back up."..PiMe.END_COLOR)
		PiMe.PPrint("Commands:")
		PiMe.PPrint(COLOR.."    /PiMe help"..PiMe.END_COLOR.."  - Show this menu.")
		PiMe.PPrint(GREEN.."    /PiMe buddy [CharacterName]"..PiMe.END_COLOR.."  - Set the name of your 'buddy' that casts or receives the spell")
		PiMe.PPrint(COLOR.."    /PiMe banner [on/off]"..PiMe.END_COLOR.."  - Toggle 'annoying text banner' printing")
		PiMe.PPrint(COLOR.."    /PiMe icon [on/off]"..PiMe.END_COLOR.."  - Toggle 'annoying icon' displaying")
		PiMe.PPrint(COLOR.."    /PiMe sound [on/off]"..PiMe.END_COLOR.."  - Toggle 'annoying sound' playing")
		PiMe.PPrint(GREEN.."    /PiMe settings"..PiMe.END_COLOR.."  - print your current config")
		PiMe.PPrint(COLOR.."    /PiMe cast"..PiMe.END_COLOR.."  - Cast power infusion on your buddy.")
		PiMe.PPrint(COLOR.."    /PiMe check"..PiMe.END_COLOR.."  - Whisper/request spell cooldown to/from your buddy.")
		PiMe.PPrint(GREEN.."    /PiMe unlock"..PiMe.END_COLOR.."  - Allows you to move spell icon and PiMe timer.")
		PiMe.PPrint(GREEN.."    /PiMe lock"..PiMe.END_COLOR.."  - Hide the spell icon and re-enable the PiMe timer")
		PiMe.PPrint(COLOR.."    /PiMe reset"..PiMe.END_COLOR.."  - Set config back to defaults")
		PiMe.PPrint(" ")
	end

	local function CmdHelp(cmd) 
		if string.lower(cmd) == "help" or PiMe.Trim(cmd) == "" then PrintHelp(); PrintCfg();  return true; end
	end

	local function CmdUnlockUI(cmd)
		if string.lower(cmd) == "unlock" then 
			PiMe.UI.Unlock()
			return true
		end
	end

	local function CmdLockUI(cmd)
		if string.lower(cmd) == "lock" then 
			PiMe.UI.Lock()
			PiMe.UI.UpdateCountownButton()
			return true
		end
	end

	local function CmdReset(cmd)
		if string.lower(cmd) == "reset" then 
			PiMe_Cfg = {}
			PiMe.InitializeCfg()
			PiMe.UI.Initialize()
			PiMe.PPrint("Reset!")
			return true
		end
	end

	local function CmdSet(cmd)
		local lcmd = string.lower(cmd)
			if PiMe.Trim(string.sub(lcmd, 1, 6)) == "banner" then
				local value = PiMe.Trim(string.sub(lcmd, 8))
				PiMe_Cfg.printAnnoyingBanner = (value == "on" or value == "true")
				return true
			elseif PiMe.Trim(string.sub(lcmd, 1, 4)) == "icon" then
				local value = PiMe.Trim(string.sub(lcmd, 6))
				PiMe_Cfg.showAnnoyingImage = (value == "on" or value == "true")
				return true
			elseif PiMe.Trim(string.sub(lcmd, 1, 5)) == "sound" then
				local value = PiMe.Trim(string.sub(lcmd, 7))
				PiMe_Cfg.makeAnnoyingNoise = (value == "on" or value == "true")
				return true
			elseif PiMe.Trim(string.sub(lcmd, 1, 5)) == "buddy" then
				if string.len(PiMe.Trim(cmd)) >= 8 then
					PiMe.SetBuddy(PiMe.Trim(string.sub(cmd,7)))
				elseif UnitIsPlayer("target") and UnitFactionGroup("target") == UnitFactionGroup("player") then
					PiMe.SetBuddy(UnitName("target"))
				else
					PiMe.PPrint("No buddy specified.")
				end
				PiMe.UI.UpdateCountownButton()
				return true
		end
	end
	
	local function CmdPrintCfg(cmd)
		local lcmd = string.lower(cmd)
		if string.sub(lcmd,1,8) == "settings" then 
			PrintCfg()
			return true
		end
	end
	
	local function CmdCheck(cmd)
		local lcmd = string.lower(cmd)
		if string.sub(lcmd,1,5) == "check" then
			local spellCmd = PiMe.Trim(string.sub(lcmd, 7))
			local spellRequest = string.len(spellCmd) == 0 and PiMe.PI or PiMe.GetSpellRequest(spellCmd)
			if spellRequest then
				local recipient = PiMe_Cfg.raidBuddy or "player"
				CooldownCheck(spellRequest.name, recipient)
			else
				PiMe.PPrint("Could not find spell")
			end
			return true
		end
	end
	
	local function CmdCast(cmd)
		local lcmd = string.lower(cmd)
		if string.sub(lcmd,1,4) == "cast" then 
			local spellCmd = PiMe.Trim(string.sub(lcmd, 6))
			local spellRequest = string.len(spellCmd) == 0 and PiMe.PI or PiMe.GetSpellRequest(spellCmd)
			if spellRequest and spellRequest.name then
				CooldownCast(spellRequest.name, PiMe_Cfg.raidBuddy)
			else
				PiMe.PPrint("Could not find spell")
			end
			return true
		end
	end

-- == == == == == == == == == == == == == == == == == == == == --
-- Global Actions
--		Publicly accessible action functions that interact with WoW to "do something".
-- 	Other the user could call them with "/script", and other addons could see these.
-- == == == == == == == == == == == == == == == == == == == == --

	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	-- UI Event functions
	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

	function PiMeFrame_OnEvent()
		if event == "ADDON_LOADED" and arg1 == PIME_ADDON_NAME then
			AddonLoaded()
		elseif event == "CHAT_MSG_WHISPER" then
			local eventMessage = arg1
			local eventOriginator = arg2
			ReactToWhisper(eventMessage, eventOriginator)
		elseif event == "PLAYER_AURAS_CHANGED" then
			AuraUpdate()
		end
	end

	function PiMe_IconFrame_OnUpdate(elapsed)
		if not PiMe.UI.locked then return end
		local now = GetTime()
		if PiMe.hideButtonAfter and PiMe.hideButtonAfter < now then
			PiMe.UI.HideAnnoyingImage()
			PiMe.hideButtonAfter = nil
		end
	end

	local function TimerExpired(spell)
		PiMe.PPrint(spell.name.." is available!")
	end

	function PiMeFrame_OnUpdate()
		if not PiMe.nextExpiration then return end
		local now = GetTime()

		if PiMeFrame_NextTic < now then 
			PiMeFrame_NextTic = now + PiMe_Cfg.buttonUpdateTicInSeconds
			if PiMe.nextExpiration < now then
				PiMe.nextExpiration = nil
				for _,cd in PiMe.cooldowns do
					if cd and cd.timerExpiration then
						if cd.timerExpiration > now then
							PiMe.nextExpiration = cd.timerExpiration
						end
						if cd.timerExpiration <= now then
							cd.timerExpiration = nil
							TimerExpired(cd.spell)
						end
					end
				end
			end
			
			PiMe.UI.UpdateCountownButton()
			
		end
	end

	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	-- Slash commands
	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	SLASH_PIME1="/PiMe"
	SlashCmdList[string.upper(PIME_ADDON_NAME)] = function(cmd)
		if CmdHelp(cmd) then return end
		if CmdPrintCfg(cmd) then return end
		if CmdUnlockUI(cmd) then return end
		if CmdLockUI(cmd) then return end
		if CmdReset(cmd) then return end
		if CmdSet(cmd) then return end
		if CmdCheck(cmd) then return end
		if CmdCast(cmd) then return end
		PiMe.PPrint("Unknown command. try /PiMe help")
	end

	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	-- UI Event Registration
	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	PiMe.UI.PiMeFrame:RegisterEvent("ADDON_LOADED")
	PiMe.UI.PiMeFrame:RegisterEvent("CHAT_MSG_WHISPER")
	PiMe.UI.PiMeFrame:RegisterEvent("PLAYER_AURAS_CHANGED")
	PiMe.UI.PiMeFrame:SetScript("OnEvent", PiMeFrame_OnEvent)
	PiMe.UI.PiMeFrame:SetScript('OnUpdate', PiMeFrame_OnUpdate)
