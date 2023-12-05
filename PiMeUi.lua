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
	local function CreateUiElement(elementType, parent, height, width, movable, enableMouse)
		local elt = CreateFrame(elementType,nil,parent,"UIPanelButtonTemplate");
		elt:SetPoint("CENTER",0,0);
		elt:SetHeight(height);
		elt:SetWidth(width);
		elt:SetMovable(movable)
		elt:EnableMouse(enableMouse)
		return elt
	end

	function PiMe.UI.CreateButton(parent, text, height, width, movable, enableMouse, show)
		local button = CreateUiElement("Button", parent, height, width, movable, enableMouse)
		button:SetText(text);
		if not show then button:Hide() end
		return button
	end

	function PiMe.UI.CreateFrame(parent, height, width, movable, enableMouse)
		return CreateUiElement("Frame", parent, height, width, movable, enableMouse)
	end


	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	-- UI Support
	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	local function CountdownButtonAllowed()
		return UnitClass("player") ~= "Priest"
	end

	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	-- UI Initialization
	-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
	PiMe.UI.PiMeFrame = PiMe.UI.CreateFrame(UIParent, 15, 180)
	PiMe.UI.CountdownButton = PiMe.UI.CreateButton(UIParent, "PI | Buddy | Timer", 15, 180, nil, nil, CountdownButtonAllowed())

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
	
	function UpdateCountownButton()
		local text = nil
		if not PiMe.UI.locked then
			text = "PiMe | Unlocked"
		else
			local buddyText = PiMe.GetBuddy()
			if not buddyText then 
				buddyText = ""
			else
				buddyText = buddyText.." | "
			end
			
			if not PiMe.nextExpiration then
				--PiMe.UI.CountdownButton:Enable() -- TODO change to a texture rather than enable it.
				text = "PI | "..buddyText.."Available" -- TODO  would be cool to hold onto the last successful cast so you knew "btw you last cast this 12 mins ago, maybe dont worry about holding onto it so long the next time you're in here"
			else
				local now = GetTime()
				local duration = PiMe.nextExpiration - now
				local timeStr = PiMe.SecondsToString(duration+1) -- Adding 1s because the visual tics I see in my testing 2m59s as the earliest and then, ticing by 5, i'd rather it show ":00" and "55" and such than ":59" and ":54".
				local remainingStr = nil
				if duration > 0 then
					remainingStr = timeStr
				else
					-- PiMe.UI.CountdownButton:Enable() -- TODO change to a texture rather than enable it.
					remainingStr = "!! "..timeStr.." !!"
				end
				text = "PI | "..buddyText..remainingStr
			end
		end
		
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
		PiMe.UI.CountdownButton:SetText("PiMe | Unlocked")
		PiMe.UI.ShowCountdownButton(true)
	end

	function PiMe.UI.Announce(eventMessage)
		if PiMe_Cfg.printAnnoyingBanner then
			PiMe.PrintAnnoyingBanner(eventMessage, nil, nil)
		end
		if PiMe_Cfg.makeAnnoyingNoise then
			PiMe.PlayAnnoyingSound(PiMe_Cfg.annoyingNoise)
		end
		if PiMe_Cfg.showAnnoyingImage then
			PiMe.UI.ShowAnnoyingImage(false)
		end
	end
	
