local _, addon = ...

local U = addon.utils
local options
local fsSlider, mlSlider, durSlider, bgSlider, framesButton, resetBtn, showTimerBtn

-- ======================================================
-- CREATE OPTIONS FRAME AND OPTIONS
-- ======================================================
local function CreateOptions()
    if options then return end

    -- create options frame
    options = CreateFrame("Frame", "PetBattleSpectatorOptions", UIParent)
    options:SetWidth(300)
    options:SetPoint("CENTER")
    options:SetFrameStrata("DIALOG")
    options:Hide()

    -- Background
    local bg = options:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0, 0, 0, 0.9)

    -- Title
    local title = options:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 10, -10)
    title:SetText("Pet Battle Spectator Options")
    title:SetTextColor(1, 0.81, 0)

    -- Close button
    local close = CreateFrame("Button", nil, options, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -5, -5)
    close:SetScript("OnClick", function() options:Hide() end)

    -- Create a content frame to hold all options
    local content = CreateFrame("Frame", nil, options)
    content:SetPoint("TOPLEFT", 30, -80)
    content:SetPoint("RIGHT", -10, 0)

    -- Font Size Slider
    fsSlider = U.slider:Create(options, 8, 18, 1, "TOPLEFT", content, "TOPLEFT", 20, 0,
        "Font Size: " .. PetBattleSpectatorDB.fontSize)
    fsSlider:SetValue(math.min(18, math.max(8, PetBattleSpectatorDB.fontSize)))
    fsSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        PetBattleSpectatorDB.fontSize = value
        self.label:SetText(string.format("Font Size: " .. value))
        addon.UpdateAppearance()
    end)

    -- Max Lines Slider
    mlSlider = U.slider:Create(options, 50, 200, 10, "TOPLEFT", fsSlider, "BOTTOMLEFT", 0, -40,
        "Frame Height (in lines): " .. PetBattleSpectatorDB.maxLines)
    mlSlider:SetValue(math.min(200, math.max(50, PetBattleSpectatorDB.maxLines)))
    mlSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        PetBattleSpectatorDB.maxLines = value
        self.label:SetText(string.format("Frame Height (in lines): " .. value))

        -- Calculate and set new frame height and content size
        local newHeight = addon.baseHeight + (value * addon.lineHeight / 4)
        addon.leftFrame:SetHeight(newHeight)
        addon.rightFrame:SetHeight(newHeight)
        addon.leftContent:SetHeight(newHeight - 10)
        addon.rightContent:SetHeight(newHeight - 10)
        addon.leftScroll:UpdateScrollChildRect()
        addon.rightScroll:UpdateScrollChildRect()
    end)

    -- Log Duration Slider
    durSlider = U.slider:Create(options, 2, 20, 1, "TOPLEFT", mlSlider, "BOTTOMLEFT", 0, -40,
        "Show Log Duration: " .. PetBattleSpectatorDB.logDuration .. "sec")
    durSlider:SetValue(math.min(20, math.max(2, PetBattleSpectatorDB.logDuration)))
    durSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        PetBattleSpectatorDB.logDuration = value
        self.label:SetText(string.format("Show Log Duration: " .. value .. "sec"))
    end)

    -- Background Opacity Slider
    bgSlider = U.slider:Create(options, 0.1, 1.0, 0.1, "TOPLEFT", durSlider, "BOTTOMLEFT", 0, -40,
        "Background Opacity: " .. PetBattleSpectatorDB.backgroundOpacity)
    bgSlider:SetValue(math.min(1.0, math.max(0.1, PetBattleSpectatorDB.backgroundOpacity)))
    bgSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value * 10) / 10 -- Round to 1 decimal place
        PetBattleSpectatorDB.backgroundOpacity = value
        self.label:SetText(string.format("Background Opacity: " .. value))
        addon.UpdateAppearance()
    end)

    -- Reset Frames Position Button
    framesButton = U.button:Create(options, "Reset Logs Positions", "TOP", bgSlider, "BOTTOM", 0, -30)
    framesButton:SetScript("OnClick", function()
        -- Clear all points first
        addon.leftFrame:ClearAllPoints()
        addon.rightFrame:ClearAllPoints()
        -- Set new positions relative to UIParent
        addon.leftFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 10, -100)
        addon.rightFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -10, -100)
    end)

    -- Reset Timer Position Button
    resetBtn = U.button:Create(options, "Reset Timer Position", "TOP", framesButton, "BOTTOM", 0, -10)
    resetBtn:SetScript("OnClick", function()
        if addon.Timer and addon.Timer.timerFrame then
            addon.Timer.timerFrame:ClearAllPoints()
            addon.Timer.timerFrame:SetPoint("TOP", 0, -150)
            addon.Timer:SavePosition()
        end
    end)

    -- Show or hide the timer
    showTimerBtn = CreateFrame("CheckButton", nil, options, "UICheckButtonTemplate")
    showTimerBtn:SetPoint("TOP", resetBtn, "BOTTOMLEFT", 5, -20)
    showTimerBtn:SetSize(24, 24)
    showTimerBtn.text:SetText(" Show the timer (only in PvP)")
    showTimerBtn.text:SetTextColor(1, 1, 1)
    showTimerBtn:SetChecked(PetBattleSpectatorDB.showTimer)
    showTimerBtn:SetScript("OnClick", function(self)
        PetBattleSpectatorDB.showTimer = self:GetChecked()
        if addon.Timer then
            addon.Timer:UpdateVisibility()
        end
    end)

    -- Calculate total height needed
    local totalHeight = 100 + fsSlider:GetHeight() + mlSlider:GetHeight() +
        durSlider:GetHeight() + bgSlider:GetHeight() + framesButton:GetHeight() + resetBtn:GetHeight() +
        showTimerBtn:GetHeight() + 200

    -- Set frame height
    options:SetHeight(totalHeight)

    -- Make draggable
    options:SetMovable(true)
    options:EnableMouse(true)
    options:RegisterForDrag("LeftButton")
    options:SetScript("OnDragStart", options.StartMoving)
    options:SetScript("OnDragStop", options.StopMovingOrSizing)
end

-- ======================================================
-- REFRESH OPTIONS
-- ======================================================
local function RefreshOptions()
    fsSlider:SetValue(PetBattleSpectatorDB.fontSize)
    fsSlider.label:SetText("Font Size: " .. PetBattleSpectatorDB.fontSize)

    mlSlider:SetValue(PetBattleSpectatorDB.maxLines)
    mlSlider.label:SetText("Frame Height (in lines): " .. PetBattleSpectatorDB.maxLines)

    durSlider:SetValue(PetBattleSpectatorDB.logDuration)
    durSlider.label:SetText("Show Log Duration: " .. PetBattleSpectatorDB.logDuration .. "sec")

    bgSlider:SetValue(PetBattleSpectatorDB.backgroundOpacity)
    bgSlider.label:SetText("Background Opacity: " .. PetBattleSpectatorDB.backgroundOpacity)

    showTimerBtn:SetChecked(PetBattleSpectatorDB.showTimer)
end

-- ======================================================
-- SHOW OPTIONS
-- ======================================================
local function ShowOptions()
    if not PetBattleSpectatorDB then return end

    CreateOptions()
    RefreshOptions()
    options:Show()
    options:Raise()
end

-- ======================================================
-- SLASH COMMANDS
-- ======================================================
SLASH_PETBATTLESPECTATOR1 = "/pbs"
SLASH_PETBATTLESPECTATOR2 = "/petbattlespectator"
SLASH_PETBATTLESPECTATOR3 = "/pbspec"
SlashCmdList.PETBATTLESPECTATOR = ShowOptions

-- Expose functions if needed
addon.ShowOptions = ShowOptions
