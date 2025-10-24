local addonName, addon = ...

-- Slash commands
SLASH_PETBATTLESPECTATOR1 = "/pbs"
SLASH_PETBATTLESPECTATOR2 = "/petbattlespectator"

local function ShowOptions()
    local options = CreateFrame("Frame", "PetBattleSpectatorOptions", UIParent)
    options:SetWidth(240)
    options:SetPoint("CENTER")
    options:SetFrameStrata("DIALOG")

    -- Background
    local bg = options:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.1, 0.1, 0.1, 0.9)

    -- Title
    local title = options:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 10, -10)
    title:SetText("PBS Options")
    title:SetTextColor(1, 1, 1, 1)

    -- Close button
    local close = CreateFrame("Button", nil, options, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -5, -5)
    close:SetScript("OnClick", function() options:Hide() end)

    -- Create a content frame to hold all options
    local content = CreateFrame("Frame", nil, options)
    content:SetPoint("TOPLEFT", 10, -60)
    content:SetPoint("RIGHT", -10, 0)

    -- Font Size Slider
    local slider = CreateFrame("Slider", nil, options, "OptionsSliderTemplate")
    slider:SetPoint("TOPLEFT", content, "TOPLEFT", 20, 0)
    slider:SetWidth(180)
    slider:SetMinMaxValues(8, 15)
    slider:SetValue(PetBattleSpectatorDB.fontSize or 12)
    slider:SetValueStep(1)

    local sliderText = slider:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    sliderText:SetPoint("BOTTOM", slider, "TOP", 0, 4)
    sliderText:SetText(string.format("Font Size: %d", PetBattleSpectatorDB.fontSize or 14))

    slider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        PetBattleSpectatorDB.fontSize = value
        sliderText:SetText(string.format("Font Size: %d", value))
        addon.UpdateAppearance()
    end)

    -- Max Lines Slider
    local maxLinesSlider = CreateFrame("Slider", nil, options, "OptionsSliderTemplate")
    maxLinesSlider:SetPoint("TOPLEFT", slider, "BOTTOMLEFT", 0, -35)
    maxLinesSlider:SetWidth(180)
    maxLinesSlider:SetMinMaxValues(50, 200)
    maxLinesSlider:SetValue(PetBattleSpectatorDB.maxLines or 100)
    maxLinesSlider:SetValueStep(10)

    local maxLinesText = maxLinesSlider:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    maxLinesText:SetPoint("BOTTOM", maxLinesSlider, "TOP", 0, 4)
    maxLinesText:SetText(string.format("Frame Height (in lines): %d", PetBattleSpectatorDB.maxLines or 100))

    maxLinesSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        PetBattleSpectatorDB.maxLines = value
        maxLinesText:SetText(string.format("Frame Height (in lines): %d", value))

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
    local durationSlider = CreateFrame("Slider", nil, options, "OptionsSliderTemplate")
    durationSlider:SetPoint("TOPLEFT", maxLinesSlider, "BOTTOMLEFT", 0, -35)
    durationSlider:SetWidth(180)
    durationSlider:SetMinMaxValues(2, 20)
    durationSlider:SetValue(PetBattleSpectatorDB.logDuration or 5)
    durationSlider:SetValueStep(1)

    local durationText = durationSlider:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    durationText:SetPoint("BOTTOM", durationSlider, "TOP", 0, 4)
    durationText:SetText(string.format("Show Log Duration: %d sec",
        PetBattleSpectatorDB.logDuration or 5))

    durationSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        PetBattleSpectatorDB.logDuration = value
        durationText:SetText(string.format("Show Log Duration: %d sec", value))
    end)

    -- Background Opacity Slider
    local opacitySlider = CreateFrame("Slider", nil, options, "OptionsSliderTemplate")
    opacitySlider:SetPoint("TOPLEFT", durationSlider, "BOTTOMLEFT", 0, -35)
    opacitySlider:SetWidth(180)
    opacitySlider:SetMinMaxValues(0.1, 1.0)
    opacitySlider:SetValue(PetBattleSpectatorDB.backgroundOpacity or 0.3)
    opacitySlider:SetValueStep(0.1)

    local opacityText = opacitySlider:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    opacityText:SetPoint("BOTTOM", opacitySlider, "TOP", 0, 4)
    opacityText:SetText(string.format("Background Opacity: %.1f", PetBattleSpectatorDB.backgroundOpacity or 0.3))

    opacitySlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value * 10) / 10 -- Round to 1 decimal place
        PetBattleSpectatorDB.backgroundOpacity = value
        opacityText:SetText(string.format("Background Opacity: %.1f", value))
        addon.UpdateAppearance()
    end)

    -- Reset Frames Position Button
    local framesButton = CreateFrame("Button", nil, options, "UIPanelButtonTemplate")
    framesButton:SetPoint("TOP", opacitySlider, "BOTTOM", 0, -15)
    framesButton:SetSize(150, 25)
    framesButton:SetText("Reset Logs Positions")
    framesButton:SetScript("OnClick", function()
        -- Clear all points first
        addon.leftFrame:ClearAllPoints()
        addon.rightFrame:ClearAllPoints()
        -- Set new positions relative to UIParent
        addon.leftFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 10, -100)
        addon.rightFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -10, -100)
    end)

    -- Reset Timer Position Button
    local resetBtn = CreateFrame("Button", nil, options, "UIPanelButtonTemplate")
    resetBtn:SetPoint("TOP", framesButton, "BOTTOM", 0, -5)
    resetBtn:SetSize(150, 25)
    resetBtn:SetText("Reset Timer Position")
    resetBtn:SetScript("OnClick", function()
        if addon.Timer and addon.Timer.timerFrame then
            addon.Timer.timerFrame:ClearAllPoints()
            addon.Timer.timerFrame:SetPoint("TOP", 0, -150)
            addon.Timer:SavePosition()
        end
    end)

    -- Calculate total height needed
    local totalHeight = 100 + slider:GetHeight() + maxLinesSlider:GetHeight() +
        durationSlider:GetHeight() + opacitySlider:GetHeight() + framesButton:GetHeight() + resetBtn:GetHeight() + 100

    -- Set frame height
    options:SetHeight(totalHeight)

    -- Make draggable
    options:SetMovable(true)
    options:EnableMouse(true)
    options:RegisterForDrag("LeftButton")
    options:SetScript("OnDragStart", options.StartMoving)
    options:SetScript("OnDragStop", options.StopMovingOrSizing)

    options:Show()
end

SlashCmdList.PETBATTLESPECTATOR = ShowOptions

-- Expose functions if needed
addon.ShowOptions = ShowOptions
