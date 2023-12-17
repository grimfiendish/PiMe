--
-- Functions specific to running the addon as the caster of the spell
--

PiMe.SourceChar = {}

-- == == == == == == == == == == == == == == == == == == == == -- 
-- Local Actions
--		Private functions that interact with WoW to "do something".
-- == == == == == == == == == == == == == == == == == == == == -- 

	function PiMe.SourceChar.ReactToWhisper (eventMessage, eventOriginator)
		-- Here we weither Announce to the player (via annoying alerts) that someone wants a spell cast, or auto-reply that it's not available
		local spell = PiMe.GetSpellRequest(eventMessage)
		if not spell then return end
		
		local spellStatusCheck = PiMe.IsCheckRequest(spell, eventMessage)
		local buddy = PiMe.GetBuddy(spell.name)

		if spell and spell.name then
			if not buddy then
				PiMe.PPrint("Auto-setting "..eventOriginator.." to be your PiMe buddy")
				buddy = PiMe.SetBuddy(eventOriginator)
			end

			if buddy ~= eventOriginator and UnitName("player") ~= eventOriginator then
				PiMe.PPrint(PiMe.START_COLOR..PiMe.GREEN_COLOR..eventOriginator..PiMe.END_COLOR..
						" is asking for "..PiMe.START_COLOR..PiMe.GREEN_COLOR..spell.name..PiMe.END_COLOR..
						" but your buddy is "..PiMe.START_COLOR..PiMe.GREEN_COLOR..buddy..PiMe.END_COLOR..
						"! Ignoring. Change that by typing '/PiMe buddy "..eventOriginator.."'")
			else
				local cdCountdownSecs = PiMe.GetCooldown(spell.name)
				if cdCountdownSecs == nil or cdCountdownSecs == 0 then
					if spellStatusCheck then
						PiMe.Whisperish(spell.name.." is available!", eventOriginator)
					else
						PiMe.UI.Announce(eventMessage)
					end
				else
					local cdCountdownMsg = PiMe.SecondsToString(cdCountdownSecs)
					PiMe.Whisperish(spell.name.." available in "..cdCountdownMsg, eventOriginator)
				end
			end
		end
	end

	local function TargetSpellRecipient(recipient)
		local unitId = nil
		if PiMe.ValueInTable(recipient, PiMe.UNITS, "sw") then 
			TargetUnit(recipient)
			unitId = recipient
		else
			TargetByName(recipient,true)
			if recipient == UnitName("target") then
				unitId = "target"
			end
		end
		return unitId
	end

	function PiMe.SourceChar.CooldownCheck(spellName, recipient)
		local cdCountdownSecs = PiMe.GetCooldown(spellName)
		if cdCountdownSecs == nil or cdCountdownSecs == 0 then
			PiMe.Whisperish(spellName.." is available!", recipient)
		else
			PiMe.Whisperish(spellName.." available in "..PiMe.SecondsToString(cdCountdownSecs), recipient)
		end
	end

	-- Casts cooldown on recipient and messages them to help ensure they don't waste it
	function PiMe.SourceChar.CooldownCast(spellName, recipient)
		if not spellName then return end
		if not recipient then recipient = PiMe.GetBuddy() end
		if not recipient then PiMe.Print("Cannot cast without a buddy set"); return end

		local cdCountdownSecs = PiMe.GetCooldown(spellName)
		if cdCountdownSecs == nil or cdCountdownSecs == 0 then
			local unitId = TargetSpellRecipient(recipient)

			if not PiMe.UnitIsAlive(unitId) then
				PiMe.Print(recipient.." is not findable.")
			elseif unitId and UnitName("target") == UnitName(unitId) then
				PiMe.Whisperish("Casting "..spellName.." on you!", recipient)
				CastSpellByName(spellName)
				TargetLastTarget()
			else
				PiMe.Print("Could not target "..UnitName(unitId))
			end
		else
			PiMe.Whisperish(spellName.." available in "..PiMe.SecondsToString(cdCountdownSecs), recipient)
		end
	end
	