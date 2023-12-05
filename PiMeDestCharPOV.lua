--
-- Functions specific to running the addon as the recipient of the spell
--

PiMe.DestChar = { }

-- == == == == == == == == == == == == == == == == == == == == -- 
-- Local Actions
--		Private functions that interact with WoW to "do something".
-- == == == == == == == == == == == == == == == == == == == == -- 

	function PiMe.DestChar.ChatMsgAddon(msgText, msgSender)
PiMe.Print("TODO - PiMe.DestChar.ChatMsgAddon: "..msgText) -- TODO should be something like "PIME:Power Infusion|COOLDOWN|123.345" 
	end

	function PiMe.DestChar.AuraUpdate()
		local unitId = "player" 
		local now = GetTime()
		for _, cd in PiMe.cooldowns do
			if cd and cd.spell and cd.spell.icon then
				if (not cd.timerExpiration or cd.timerExpiration < now) and unitId and PiMe.BuffCheck("Interface\\Icons\\"..cd.spell.icon, unitId) then
					local cooldownTime = cd.spell.cooldownInSeconds
					cd.timerExpiration = now + cooldownTime
					PiMe.UI.Announce(cd.spell.name.."!")
					PiMe.UI.ShowCountdownButton(false)
				end

				if cd.timerExpiration and now > cd.timerExpiration then
					cd.timerExpiration = nil
				end

				if cd.timerExpiration and (not PiMe.nextExpiration or PiMe.nextExpiration > cd.timerExpiration) then
					PiMe.nextExpiration = cd.timerExpiration
				end
			end
		end
	end

	local function spellRequest(spellName, recipient, requestType)
		local buddy = PiMe.GetBuddy()
		if not buddy then PiMe.PPrint("Set a buddy then try checking again.") return end
		local spell = PiMe.COOLDOWN_SPELLS[spellName]
		if spell and spell.phrase then
			local suffix = requestType == "CAST" and PiMe_Cfg.castRequestSuffix or PiMe_Cfg.checkRequestSuffix
			local msg = spell.phrase .. suffix
			PiMe.Whisperish(msg, buddy)
		else
			PiMe.PPrint("Could not find spell "..(spellName and spellName or '-nil-'))
		end
	end

	function PiMe.DestChar.CooldownCast(spellName, recipient)
		spellRequest(spellName, recipient, "CAST")
	end

	function PiMe.DestChar.CooldownCheck(spellName, recipient)
		spellRequest(spellName, recipient, "CHECK")
	end