--
-- PiMe UI functions. These were in XML but programmatic control 
-- 

PiMe.UI = { }
PiMe.UI.locked = true
PiMe.UI.PiMeFrame = nil
PiMe.UI.CountdownButton = nil

-- == == == == == == == == == == == == == == == == == == == == -- 
-- UI Generation Functions
--		Functions that manage UI components programmatically
-- == == == == == == == == == == == == == == == == == == == == -- 
	local function CreateUiElement(elementType, parent, height, width, strata, movable, enableMouse)
		local elt = CreateFrame(elementType,nil,parent,"UIPanelButtonTemplate");
		elt:SetPoint("CENTER",0,0);
		elt:SetHeight(height);
		elt:SetWidth(width);
		elt:SetFrameStrata(strata);
		elt:SetMovable(movable)
		elt:EnableMouse(enableMouse)
		return elt
	end

	function PiMe.UI.CreateButton(parent, text, height, width, strata, movable, enableMouse, show)
		local button = CreateUiElement("Button", parent, height, width, strata, movable, enableMouse)
		button:SetText(text);
		if not show then button:Hide() end
		return button
	end

	function PiMe.UI.CreateFrame(parent, height, width, strata, movable, enableMouse)
		return CreateUiElement("Frame", parent, height, width, strata, movable, enableMouse)
	end


	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	-- UI Support
	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	local function CountdownButtonAllowed()
		return UnitClass("player") ~= "Priest"
	end
	
	local function GenerateCountdownButtonText()
		local text = nil
		if not PiMe_Cfg.hasEverUnlocked then
			text = "PiMe | Try '/pime unlock' to move me"
		elseif not PiMe.UI.locked then
			text = "PiMe | Move then '/pime lock'"
		else
			local buddyText = PiMe.GetBuddy()
			if not buddyText then 
				buddyText = ""
			else
				buddyText = buddyText.." | "
			end
			
			if not PiMe.nextExpiration then
				text = "PI | "..buddyText.."Available" -- TODO  would be cool to hold onto the last successful cast so you knew "btw you last cast this 12 mins ago, maybe dont worry about holding onto it so long the next time you're in here"
			else
				local now = GetTime()
				local duration = PiMe.nextExpiration - now
				local timeStr = PiMe.SecondsToString(duration+0.5) -- Adding time because the visual tics I see in my testing 2m59s as the earliest and then, ticing by 5, i'd rather it show ":00" and "55" and such than ":59" and ":54".
				local remainingStr = nil
				if duration > 0 then
					remainingStr = timeStr
				else
					remainingStr = "!! "..timeStr.." !!"
				end
				text = "PI | "..buddyText..remainingStr
			end
		end
		return text
	end

	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	-- UI Initialization
	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	PiMe.UI.PiMeFrame = PiMe.UI.CreateFrame(UIParent, 15, 180,"LOW")
	PiMe.UI.CountdownButton = PiMe.UI.CreateButton(UIParent, GenerateCountdownButtonText(), 15, 180, "LOW", nil, nil, CountdownButtonAllowed())

	PiMe.UI.CountdownButton:SetMovable(true)
	PiMe.UI.CountdownButton:Disable()
	PiMe.UI.CountdownButton:SetScript("OnMouseDown",function(self,button)
		PiMe.UI.CountdownButton:StartMoving();
	end)
	
	PiMe.UI.CountdownButton:SetScript("OnMouseUp", function(self, button)
		PiMe.UI.CountdownButton:StopMovingOrSizing();
		point, relativeTo, relativePoint, xOfs, yOfs = PiMe.UI.CountdownButton:GetPoint();
		PiMe_Cfg.countdownTimerRef=point;
		PiMe_Cfg.countdownTimerX=xOfs;
		PiMe_Cfg.countdownTimerY=yOfs;
	end)

	
	function PiMe.UI.Initialize()
		PiMe.UI.CountdownButton:SetAllPoints()
	end
	
	function PiMe.UI.UpdateCountownButton()
		local text = GenerateCountdownButtonText()
		
		if text ~= nil then
			PiMe.UI.CountdownButton:SetText(text)
		end
	end

	
-- == == == == == == == == == == == == == == == == == == == == -- 
-- Show/Hide/Execute UI functions
-- == == == == == == == == == == == == == == == == == == == == -- 

	function PiMe.UI.ShowAnnoyingImage(allowMove) 
		PiMe_IconFrame:Show()
		PiMe_IconFrame:EnableMouse(allowMove)
	end

	function PiMe.UI.HideAnnoyingImage()
		PiMe_IconFrame:Hide()
	end

	function PiMe.UI.ShowCountdownButton(allowMove)
		if not CountdownButtonAllowed() then return end
		PiMe.UI.CountdownButton:Show()
		PiMe.UI.CountdownButton:EnableMouse(allowMove)
	end
	
	function PiMe.UI.Lock()
		PiMe.UI.locked = true
		PiMe.UI.HideAnnoyingImage() 
		PiMe.UI.ShowCountdownButton(false)
	end
	
	function PiMe.UI.Unlock()
		PiMe.UI.locked = false
		PiMe.UI.ShowAnnoyingImage(true) 
		PiMe.UI.CountdownButton:SetText("PiMe | Move then '/pime lock'")
		PiMe.UI.ShowCountdownButton(true)
		PiMe_Cfg.hasEverUnlocked = true
	end

	function PiMe.UI.Announce(eventMessage)
		if PiMe_Cfg.printAnnoyingBanner then
			PiMe.PrintAnnoyingBanner(eventMessage, nil, nil)
		end
		if PiMe_Cfg.makeAnnoyingNoise then
			PiMe.PlayAnnoyingSound(PiMe_Cfg.annoyingNoise)
		end
		if PiMe_Cfg.showAnnoyingImage then
			PiMe.hideButtonAfter = GetTime() + PiMe_Cfg.iconVisibleTimeInSeconds
			PiMe.UI.ShowAnnoyingImage(false)
		end
	end
	
