print("MicroMenuAndBagsSettings loaded ! Type /MMBS for settings")

-- Variable
local event = CreateFrame("Frame")
local MMBSsettings

local HideBagsBar 
local MicroMenuMO -- false (CheckButton unchecked) = Mouse Over Disable

-- Table with micro menu button
local micro_button = {
	CharacterMicroButton,
	SpellbookMicroButton,
	TalentMicroButton,
	AchievementMicroButton,
	QuestLogMicroButton,
	GuildMicroButton,
	LFDMicroButton,
	CollectionsMicroButton,
	EJMicroButton,
	StoreMicroButton,
	MainMenuMicroButton
}

-- Function create settings frame
function MMBS_settings_frame()
	-- Main frame
	MMBSsettings = CreateFrame("Frame", "MMBSsettings", UIParent, "UIPanelDialogTemplate")
	MMBSsettings:SetPoint("CENTER", 0, 0)
	MMBSsettings:SetSize(300, 138)
	MMBSsettings:SetMovable(true) -- Drag and drop option's
	MMBSsettings:EnableMouse(true) -- Drag and drop option's
	MMBSsettings:RegisterForDrag("LeftButton") -- Drag and drop option's
	MMBSsettings:SetScript("OnDragStart", MMBSsettings.StartMoving) -- Drag and drop option's
	MMBSsettings:SetScript("OnDragStop", MMBSsettings.StopMovingOrSizing) -- Drag and drop option's

	-- Create settings frame title
	MMBSsettings.title = MMBSsettings:CreateFontString(nil, "OVERLAY")
	MMBSsettings.title:ClearAllPoints()
	MMBSsettings.title:SetFontObject("GameFontHighlight")
	MMBSsettings.title:SetPoint("TOPLEFT", 12, -8)
	MMBSsettings.title:SetText("MicroMenuAndBags Settings")

	-- Button Hide/Show Bag
	MMBSsettings.HideBagsButton = MMBS_CreateCheckButton(MMBSsettings, HideBagsButton, 12, -30)
	MMBSsettings.HideBagsButtonText = MMBS_CreateText(MMBSsettings, HideBagsButtonText, 50, -42, "Hide bags bar")

	-- Button Mouse Over Micro Menu
	MMBSsettings.MicroMenuButton = MMBS_CreateCheckButton(MMBSsettings, MicroMenuButton, 12, -60)
	MMBSsettings.MicroMenuMouseOver = MMBS_CreateText(MMBSsettings, MicroMenuMouseOver, 50, -72, "Enable micro menu mouseover")
	
	-- Button Move bar
	MMBSsettings.MoveBarButton = MMBS_CreateCheckButton(MMBSsettings, MoveBarButton, 12, -90)
	MMBSsettings.MoveBarButtonText = MMBS_CreateText(MMBSsettings, MicroMenuMouseOver, 50, -102, "Move bars")

	-- Check / uncheck checkbutton when player open settings frame with sv info
	MMBS_loadSettingsCheckButton(HideBagsBar, MMBSsettings.HideBagsButton)
	MMBS_loadSettingsCheckButton(MicroMenuMO, MMBSsettings.MicroMenuButton)



	-- Function
	-- Hide / Show Bags bar when user click on checkbutton
	MMBSsettings.HideBagsButton:SetScript("OnClick",
	function()
		if MMBSsettings.HideBagsButton:GetChecked() == true then
			HideBagsBar = true
			MicroButtonAndBagsBar:Hide()
		else
			HideBagsBar = false
			MicroButtonAndBagsBar:Show()
		end
	end)

	-- Enable Micro Menu Mouseover
	MMBSsettings.MicroMenuButton:SetScript("OnClick", 
	function()
		if MMBSsettings.MicroMenuButton:GetChecked() == true then
			MicroMenuMO = true
			MMBS_Micro_Button_Transparency(0)
		else
			MicroMenuMO = false
			MMBS_Micro_Button_Transparency(1)
		end
	end)

	-- Unlock bars for moving
	MMBSsettings.MoveBarButton:SetScript("OnClick",
	function()
		if MMBSsettings.MoveBarButton:GetChecked() == true then
			-- Unlock bags bar and micro menu
			MMBS_unlockElement(MicroButtonAndBagsBar)
		else
			-- Lock bags bar and micro menu
			MMBS_lockElement(MicroButtonAndBagsBar)
			-- Save new position
			point, _, _, xPos, yPos = MMBS_getPos(MicroButtonAndBagsBar)
			MMBSSV[3] = point
			MMBSSV[4] = xPos
			MMBSSV[5] = yPos
		end
	end)


	MMBSsettings:Show()
end

-- Function for MouseOver Micro menu
for _, v in ipairs(micro_button) do
	v:HookScript("OnEnter", function() if MicroMenuMO == true then MMBS_Micro_Button_Transparency(1) end end)
	v:HookScript("OnLeave", function() if MicroMenuMO == true then MMBS_Micro_Button_Transparency(0) end end)
end 

-- Function to modify Micro button transparency
function MMBS_Micro_Button_Transparency(transparency)
	for _, v in ipairs(micro_button) do
		v:SetAlpha(transparency)
	end
end

-- Create check button
function MMBS_CreateCheckButton(parent, children, btnX, btnY)
	parent.children = CreateFrame("CheckButton", children, parent, "ChatConfigCheckButtonTemplate")
	parent.children:SetPoint("TOPLEFT", btnX, btnY)
	parent.children:SetSize(40, 40)

	return parent.children
end

-- Create text
function MMBS_CreateText(parent, children, txtX, txtY, txt)
	parent.children = parent:CreateFontString(nil, "OVERLAY")
	parent.children:ClearAllPoints()
	parent.children:SetFontObject("GameFontHighlight")
	parent.children:SetPoint("TOPLEFT", txtX, txtY)
	parent.children:SetText(txt)

	return parent.children
end

-- load check button statue
function MMBS_loadSettingsCheckButton(var, frame)
	if var == true then
		frame:SetChecked(true)
	else
		frame:SetChecked(false)
	end
end

-- Unlock and enable drag and drop for wow element
function MMBS_unlockElement(parent)
	-- Create Texture
	parent.texture = parent:CreateTexture()
	parent.texture:SetAllPoints(parent)
	parent.texture:SetAlpha(0.5)
	parent.texture:SetTexture(1,1,1)

	-- Set frame movable
	parent:SetMovable(true) -- Drag and drop option's
	parent:EnableMouse(true) -- Drag and drop option's
	parent:RegisterForDrag("LeftButton") -- Drag and drop option's
	parent:SetScript("OnDragStart", parent.StartMoving) -- Drag and drop option's
	parent:SetScript("OnDragStop", parent.StopMovingOrSizing) -- Drag and drop option's
end

-- Lock and disable drag and drop for wow element
function MMBS_lockElement(parent)
	-- Remove Texture
	parent.texture:SetTexture(nil)

	-- Disable drag and drop
	parent:SetMovable(false)
	parent:EnableMouse(false)
end

-- Get Region Point
function MMBS_getPos(parent)
	return parent:GetPoint()
end

-- Set Region Point
function MMBS_setPos(parent, point, ofsx, ofsy)
	parent:ClearAllPoints()
	parent:SetPoint(point, nil, point, ofsx, ofsy)
end

-- Slash Command for showing or create settings frame
SLASH_MMBS1 = "/MMBS";
SlashCmdList["MMBS"] = function(msg)
	if MMBSsettings == nil then
		MMBS_settings_frame()
	else
		MMBSsettings:Show()
	end
end

-- Events
event:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		-- Create Table if not exist
		if not MMBSSV then 
			MMBSSV = {

			}
		else -- Else init variable with sv info
			--Hide / Show Bags bar when player login
			HideBagsBar = MMBSSV[1]
			if HideBagsBar == true then
				MicroButtonAndBagsBar:Hide()
			else
				MicroButtonAndBagsBar:Show()
			end

			-- Enable / Disable Micro Menu Mouseover
			MicroMenuMO = MMBSSV[2]
			if MicroMenuMO == true then
				MMBS_Micro_Button_Transparency(0)
			else
				MMBS_Micro_Button_Transparency(1)
			end

			-- Set bags bar and micro menu positon
			if MMBSSV[3] ~= nil and MMBSSV[4] ~= nil then
				MMBS_setPos(MicroButtonAndBagsBar, MMBSSV[3], MMBSSV[4], MMBSSV[5])
			end
		end
	end


	if event == "PLAYER_LOGOUT" then
		-- Saved info in sv
		MMBSSV[1] = HideBagsBar -- Bags Bar Statue
		MMBSSV[2] = MicroMenuMO -- Micro Menu Mouseover Statue
	end
end)

event:RegisterEvent("PLAYER_LOGIN")
event:RegisterEvent("PLAYER_LOGOUT")