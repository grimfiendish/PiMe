--
-- Setup Functions
--
PIME_ADDON_NAME = "PiMe"
PiMe = { }

-- == == == == == == == == == == == == == == == == == == == == -- 
-- Variable initialization
-- == == == == == == == == == == == == == == == == == == == == -- 

	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	-- CONSTANTS
	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	PiMe.VERSION="0.0.4"
	PiMe.PI={name="Power Infusion", icon="Spell_Holy_PowerInfusion", phrase="PI", cooldownInSeconds=180}
	PiMe.INNERVATE={name="Innervate", icon="Spell_Nature_Lightning", phrase="V8", cooldownInSeconds=180}
	PiMe.ARCANE_POWER={name="Arcane Power", icon="Spell_Nature_Lightning"}

	PiMe.COOLDOWN_SPELLS={ }
	PiMe.COOLDOWN_SPELLS[PiMe.PI.name] = PiMe.PI
	--PiMe.COOLDOWN_SPELLS[PiMe.INNERVATE.name] = PiMe.INNERVATE -- TODO fix innervate... 


			
	PiMe.START_COLOR = "\124CFF"
	PiMe.END_COLOR = "\124r"
	PiMe.EMPHASIS_COLOR = "FFFF99"
	PiMe.GREEN_COLOR = "99FF99"

	PiMe.UNITS = { "mouseover", "player", "pet", "target", "party", "partypet", "raid", "raidpet" }

	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	-- Globals
	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	PiMe_Cfg = { -- TODO - Using "PiMe_Cfg" instead of "PiMe.Cfg" bc I assume the saved variables mechanism will break. vet it and update here.
		printAnnoyingBanner=true,
		showAnnoyingImage=true,
		makeAnnoyingNoise=true,
		
		-- This is a response prefix. Mainly I used it because I kept muting myself.
		msgPrefix = "[PiMe] ",
		
		-- e.g. the " me" of "PI me"
		castRequestSuffix = " me",
		
		-- e.g. the " check" of "PI check"
		checkRequestSuffix = " check",

		-- You can choose which annoying sound to play. Look up your options online.
		annoyingNoise = "PVPTHROUGHQUEUE",

		-- This is mainly useful if I make incompatible config changes down the road.
		configVersion = PiMe.VERSION,

		-- How large/visible/long the spell's icon appears
		iconScale=1.0,
		iconAlpha=0.8,
		iconVisibleTimeInSeconds=5,
		
		-- This controls how often the button updates. For better performance, make this number >= 1.
		buttonUpdateTicInSeconds=5,
		
		-- Once you've manually moved the button, this remembers where it was
		countdownTimerRef=nil,
		countdownTimerX=nil,
		countdownTimerY=nil,
		
		-- For a priest, this is who you'd cast PI on in raid. For a mage/lock this is who you'll whisper.
		raidBuddy=nil
	}

	PiMe.nextExpiration = nil
	PiMeFrame_NextTic = 0
	PiMe.cooldowns = { }
	for _, sp in PiMe.COOLDOWN_SPELLS do
		PiMe.cooldowns[sp.name] = {
			spell = sp,
			timerExpiration = nil
		}
	end

-- == == == == == == == == == == == == == == == == == == == == -- 

-- == == == == == == == == == == == == == == == == == == == == -- 
-- Utility Functions
--		These are neither aware nor modify the environment.
-- == == == == == == == == == == == == == == == == == == == == -- 

	function PiMe.PrintColor(r, g, b, t)
			DEFAULT_CHAT_FRAME:AddMessage(t,r,g,b);
	end

	local function PrefixMessageColor(msg)
		return PiMe.START_COLOR..PiMe.EMPHASIS_COLOR..PiMe_Cfg.msgPrefix..PiMe.END_COLOR..(msg ~= nil and msg or '-nil-')
	end

	local function PrefixMessage(msg)
		return PiMe_Cfg.msgPrefix..(msg ~= nil and msg or '-nil-')
	end

	function PiMe.Print(msg)
		DEFAULT_CHAT_FRAME:AddMessage(msg,1,1,1)
	end

	function PiMe.PPrint(msg)
		PiMe.Print(PrefixMessageColor(msg))
	end

	function PiMe.Trim(str)
		return string.gsub(string.gsub(str, "^%s+",""), "%s+$","")
	end

	function PiMe.IsCountdownResponse(spell, eventMessage)
		return false -- an ADDON message "[PiMe] Power Infusion=123.456"
	end

	function PiMe.IsCheckRequest(spell, eventMessage)
		return spell and eventMessage and (string.find(string.upper(eventMessage), string.upper(spell.name..PiMe_Cfg.checkRequestSuffix)) ~= nil 
				or string.find(string.upper(eventMessage), string.upper(spell.phrase..PiMe_Cfg.checkRequestSuffix)) ~= nil )
	end
	
	function PiMe.IsCastRequest(spell, eventMessage)
		return spell and eventMessage and (string.find(string.upper(eventMessage), string.upper(spell.name..PiMe_Cfg.castRequestSuffix)) ~= nil
				or string.find(string.upper(eventMessage), string.upper(spell.phrase..PiMe_Cfg.castRequestSuffix)) ~= nil)
	end

	function PiMe.GetSpellRequest(eventMessage)
		for i,sp in pairs(PiMe.COOLDOWN_SPELLS) do
			if  string.lower(eventMessage) == string.lower(sp.name) 
					or string.lower(eventMessage) == string.lower(sp.phrase) 
					or string.lower(eventMessage) == string.lower(PiMe_Cfg.msgPrefix..sp.phrase) 
					or PiMe.IsCheckRequest(sp, eventMessage) 
					or PiMe.IsCastRequest(sp, eventMessage) 
					or PiMe.IsCountdownResponse(sp, eventMessage) then
				return sp
			end
		end
	end

	function PiMe.GetPiMeSpell(findspell)
		for i,sp in pairs(PiMe.COOLDOWN_SPELLS) do
			if sp.name == findspell or sp.phrase == findspell then
				return sp
			end
		end
	end

	function PiMe.SpellExists(findspell)
		if not findspell then return end
		for i = 1, MAX_SKILLLINE_TABS do
		   local name, texture, offset, numSpells = GetSpellTabInfo(i);
		   if not name then break end
		   for s = offset + 1, offset + numSpells do
			  local	spell, rank = GetSpellName(s, BOOKTYPE_SPELL);
			  if rank then
				 local spell = spell.." "..rank;
			  end
			  if string.find(string.lower(spell),string.lower(findspell)) then
				 return true
			  end
		   end
		end
	end

	function PiMe.SpellNum(spell)
		local i = 1
		local spellName
		while true do
			spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL)
			if not spellName or spell==spellName then
				do break end
			end
			i = i + 1
		end
		if not spellName then PiMe.Print("Spell " .. (spell or "-nil-").. " does not exist in spellbook! " ) ; return; end
		return i
	end

	function PiMe.GetCooldown(spell) -- TODO - rename this. This is the remaining time until a spell is ready again. (e.g. five seconds after casting PI, this will return 175.)
		if not PiMe.SpellExists(spell) then return end
		
		local cdtime = nil
		local spellNum = PiMe.SpellNum(spell)
		if spellNum then
			local start,duration,enable = GetSpellCooldown(spellNum,BOOKTYPE_SPELL)
			if duration == 0 then cdtime=0 else cdtime=GetTime()-start end
			if duration <= cdtime then return 0 else return duration - cdtime end
		end
	end

	function PiMe.GetDuration(spell) -- This is the total downtime between spellcasts. (e.g. PI always returns 180.)
		if not PiMe.SpellExists(spell) then return end
		
		local cdtime = nil
		local spellNum = PiMe_SpellNum(spell)
		if spellNum then
			local start,duration,enable = GetSpellCooldown(spellNum,BOOKTYPE_SPELL)
			return duration
		end
	end

	function PiMe.BuffCheck(text, target)
		local i = 1
		local buff = UnitBuff(target, i)

		while buff do
			if buff == text then
				return true
			end
			i = i + 1
			buff = UnitBuff(target, i)
		end
		return
	end

	function PiMe.FindCharacterUnitId(characterName)
		foundTarget=nil
		for i=1,GetNumRaidMembers() do
			local name,rank,subgroup,level,class,fileName,zone,online,isdead=GetRaidRosterInfo(i)
			if name == characterName then 
				foundTarget="raid"..i
				break
			end
		end
		
		if not foundTarget then
			for i=1,GetNumPartyMembers()+1 do
				local id
				if i==GetNumPartyMembers()+1 then id="player" else id="party"..i end
				if UnitName(id) == characterName then
					foundTarget = id
					break
				end
			end
		end
		
		if not foundTarget and UnitName("target") == characterName then
			foundTarget = "target"
		end
		
		return foundTarget
	end

	function PiMe.SecondsToString(duration)
		if not duration then return "0" end
		local cdCountdownMsg = nil
		if duration > 60 then 
			local mins = math.floor(duration / 60)
			local secs = math.mod(duration, 60)
			cdCountdownMsg = string.format("%d min %d sec ", mins, secs) 
		else 
			cdCountdownMsg = string.format("%d seconds", duration) 
		end
		return cdCountdownMsg
	end

	function PiMe.GetBuddy(spellName)
		return PiMe_Cfg.raidBuddy -- TODO unique buddy per spell... a feature I'm pretty sure nobody wants
	end

	function PiMe.SetBuddy(charName, spellName) -- TODO unique buddy per spell... a feature I'm pretty sure nobody wants
		PiMe_Cfg.raidBuddy = string.upper(string.sub(charName,1,1))..string.lower(string.sub(charName, 2))
		PiMe.PPrint("Set raid buddy to ".. PiMe_Cfg.raidBuddy)
-- TODO - below when verifying we could just do a "who" search... SendWho('n-"'..PiMe_Cfg.raidBuddy..'"')
		local unitId = PiMe.FindCharacterUnitId(PiMe_Cfg.raidBuddy)
		if not unitId then PiMe.PPrint(PiMe_Cfg.raidBuddy.." not found in raid/party. This is probably fine.") end -- TODO maybe: SendWho('n-"'..
		return PiMe_Cfg.raidBuddy
	end

	function PiMe.UnitIsAlive(id)
		if not id then return end
		return UnitName(id) and not UnitIsDead(id) and UnitHealth(id)>1 and not UnitIsGhost(id) and UnitIsConnected(id)
	end
	
	function PiMe.ValueInTable(value, sourceTable, options)
		for i,v in sourceTable do 
			if value and sourceTable and ((options == "sw" and string.find(value,v) == 1) or v == value) then return true end 
		end
	end

	function PiMe.InitializeCfg()
		-- If you had an older version of the app then upgrade, the new config values don't get created
		if PiMe_Cfg.printAnnoyingBanner == nil then PiMe_Cfg.printAnnoyingBanner = true end
		if PiMe_Cfg.showAnnoyingImage == nil then PiMe_Cfg.showAnnoyingImage = true end
		if PiMe_Cfg.makeAnnoyingNoise == nil then PiMe_Cfg.makeAnnoyingNoise = true end
		if PiMe_Cfg.msgPrefix == nil then PiMe_Cfg.msgPrefix = "[PiMe] " end
		if PiMe_Cfg.castRequestSuffix == nil then PiMe_Cfg.castRequestSuffix = " me" end
		if PiMe_Cfg.checkRequestSuffix == nil then PiMe_Cfg.checkRequestSuffix = " check" end
		if PiMe_Cfg.annoyingNoise == nil then PiMe_Cfg.annoyingNoise = "PVPTHROUGHQUEUE" end
		if PiMe_Cfg.configVersion == nil then PiMe_Cfg.configVersion = PiMe.VERSION end
		if PiMe_Cfg.iconScale == nil then PiMe_Cfg.iconScale=1.0 end
		if PiMe_Cfg.iconAlpha == nil then PiMe_Cfg.iconAlpha=0.8 end
		if PiMe_Cfg.iconVisibleTimeInSeconds == nil then PiMe_Cfg.iconVisibleTimeInSeconds=5 end
		if PiMe_Cfg.buttonUpdateTicInSeconds == nil then PiMe_Cfg.buttonUpdateTicInSeconds=5 end
	end
-- == == == == == == == == == == == == == == == == == == == == -- 


-- == == == == == == == == == == == == == == == == == == == == -- 
-- Actions
--		functions that interact with WoW to "do something".
-- == == == == == == == == == == == == == == == == == == == == -- 

	function PiMe.AddonMessage(msg, recipient)
		SendAddonMessage(PIME_ADDON_NAME, msg, "WHISPER", recipient)
	end

	function PiMe.PlayAnnoyingSound(sound)
		if sound then
			PlaySound(sound)
		end
	end

	function PiMe.PrintAnnoyingBanner(msg, prefix, suffix)
		if not prefix then prefix = "> > > " end
		if not suffix then suffix = " < < <" end
		local banner = prefix..string.upper(string.gsub(msg,"(.)","  %1  "))..suffix
		PiMe.PrintColor(0,0,0," ")
		PiMe.PrintColor(0,0,0,banner)
		PiMe.PrintColor(0,0,1,banner)
		PiMe.PrintColor(0,1,0,banner)
		PiMe.PrintColor(0,1,1,banner)
		PiMe.PrintColor(1,0,0,banner)
		PiMe.PrintColor(1,0,1,banner)
		PiMe.PrintColor(1,1,0,banner)
		PiMe.PrintColor(1,1,1,banner)
		PiMe.PrintColor(0,0,0," ")
	end

	function PiMe.Whisperish(message, recipient)
		if recipient == "player" or recipient == UnitName("player") then
			PiMe.PPrint(message)
		else
			SendChatMessage(PrefixMessage(message), "WHISPER", "COMMON", recipient)
		end
	end




