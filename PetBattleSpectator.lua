local _, addon = ...

local max = _G.math.max
local min = _G.math.min
local currentRound = 0

-- Create main frame
local leftFrame = CreateFrame("Frame", "PetBattleSpectatorLeftFrame", UIParent)
leftFrame:SetWidth(500)
leftFrame:SetPoint("TOPLEFT", 10, -100)
leftFrame:SetFrameStrata("HIGH")
leftFrame:SetMovable(true)
leftFrame:EnableMouse(true)
leftFrame:RegisterForDrag("LeftButton")
leftFrame:SetScript("OnDragStart", leftFrame.StartMoving)
leftFrame:SetScript("OnDragStop", leftFrame.StopMovingOrSizing)
leftFrame:Hide()

-- Add background to left frame
leftFrame.bg = leftFrame:CreateTexture(nil, "BACKGROUND")
leftFrame.bg:SetAllPoints()
leftFrame.bg:SetColorTexture(0, 0, 0, 1) -- Black background

local leftScroll = CreateFrame("ScrollFrame", nil, leftFrame)
leftScroll:SetPoint("TOPLEFT", 10, -10)
leftScroll:SetPoint("BOTTOMRIGHT", -10, 10)

local leftContent = CreateFrame("Frame")
leftContent:SetWidth(500)
leftContent:SetHeight(10000)
leftScroll:SetScrollChild(leftContent)

leftScroll:EnableMouseWheel(true)
leftScroll:SetScript("OnMouseWheel", function(self, delta)
  local currentScroll = self:GetVerticalScroll()
  local maxScroll = self:GetVerticalScrollRange()

  if delta > 0 then -- Scroll up
    self:SetVerticalScroll(min(currentScroll - 20, maxScroll))
  else              -- Scroll down
    self:SetVerticalScroll(max(currentScroll + 20, 0))
  end
end)

local leftFont = leftContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
leftFont:SetPoint("TOPLEFT")
leftFont:SetWidth(500)
leftFont:SetJustifyH("LEFT")
leftFont:SetJustifyV("TOP")
leftFont:SetWordWrap(true)
leftFont:SetShadowColor(0, 0, 0, 1)
leftFont:SetShadowOffset(1, -1)


-- Right Frame (Your Actions)
local rightFrame = CreateFrame("Frame", "PetBattleSpectatorRightFrame", UIParent)
rightFrame:SetWidth(500)
rightFrame:SetPoint("TOPRIGHT", -10, -100)
rightFrame:SetFrameStrata("HIGH")
rightFrame:SetMovable(true)
rightFrame:EnableMouse(true)
rightFrame:RegisterForDrag("LeftButton")
rightFrame:SetScript("OnDragStart", rightFrame.StartMoving)
rightFrame:SetScript("OnDragStop", rightFrame.StopMovingOrSizing)
rightFrame:Hide()

-- Add background to right frame
rightFrame.bg = rightFrame:CreateTexture(nil, "BACKGROUND")
rightFrame.bg:SetAllPoints()
rightFrame.bg:SetColorTexture(0, 0, 0, 1) -- Black background

local rightScroll = CreateFrame("ScrollFrame", nil, rightFrame)
rightScroll:SetPoint("TOPLEFT", 10, -10)
rightScroll:SetPoint("BOTTOMRIGHT", -10, 10)

local rightContent = CreateFrame("Frame")
rightContent:SetWidth(500)
rightContent:SetHeight(10000)
rightScroll:SetScrollChild(rightContent)

rightScroll:EnableMouseWheel(true)
rightScroll:SetScript("OnMouseWheel", function(self, delta)
  local currentScroll = self:GetVerticalScroll()
  local maxScroll = self:GetVerticalScrollRange()

  if delta > 0 then -- Scroll up
    self:SetVerticalScroll(min(currentScroll - 20, maxScroll))
  else              -- Scroll down
    self:SetVerticalScroll(max(currentScroll + 20, 0))
  end
end)

local rightFont = rightContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
rightFont:SetPoint("TOPLEFT")
rightFont:SetWidth(500)
rightFont:SetJustifyH("LEFT")
rightFont:SetJustifyV("TOP")
rightFont:SetWordWrap(true)
rightFont:SetShadowColor(0, 0, 0, 1)
rightFont:SetShadowOffset(1, -1)

-- Initialize database with proper defaults
PetBattleSpectatorDB = PetBattleSpectatorDB or {
  enabled = true,
  fontSize = 12,
  maxLines = 100,
  logDuration = 5,
  backgroundOpacity = 0.3,
  leftLogs = {},
  rightLogs = {},
  showTimer = true
}

-- Ensure logs table exists
PetBattleSpectatorDB.leftLogs = PetBattleSpectatorDB.leftLogs or {}
PetBattleSpectatorDB.rightLogs = PetBattleSpectatorDB.rightLogs or {}
PetBattleSpectatorDB.maxLines = PetBattleSpectatorDB.maxLines or 100
PetBattleSpectatorDB.backgroundOpacity = PetBattleSpectatorDB.backgroundOpacity or 0.3

-- Update appearance for both frames
local function UpdateAppearance()
  -- Left frame settings
  leftFont:SetFont("Fonts\\FRIZQT__.TTF", PetBattleSpectatorDB.fontSize)
  leftFont:SetTextColor(1, 1, 1, 1)

  -- Apply background opacity to left frame
  leftFrame.bg:SetAlpha(PetBattleSpectatorDB.backgroundOpacity or 0.3)

  -- Right frame settings
  rightFont:SetFont("Fonts\\FRIZQT__.TTF", PetBattleSpectatorDB.fontSize)
  rightFont:SetTextColor(1, 1, 1, 1)

  -- Apply background opacity to right frame
  rightFrame.bg:SetAlpha(PetBattleSpectatorDB.backgroundOpacity or 0.3)

  -- Refresh displayed text with proper scrolling
  if PetBattleSpectatorDB.leftLogs then
    leftFont:SetText(table.concat(PetBattleSpectatorDB.leftLogs, "\n"))
    C_Timer.After(0.01, function()
      local scrollHeight = leftScroll:GetHeight()
      local textHeight = leftFont:GetStringHeight()
      leftScroll:SetVerticalScroll(max(0, textHeight - scrollHeight))
    end)
  end

  if PetBattleSpectatorDB.rightLogs then
    rightFont:SetText(table.concat(PetBattleSpectatorDB.rightLogs, "\n"))
    C_Timer.After(0.01, function()
      local scrollHeight = rightScroll:GetHeight()
      local textHeight = rightFont:GetStringHeight()
      rightScroll:SetVerticalScroll(max(0, textHeight - scrollHeight))
    end)
  end
end


addon.UpdateAppearance = UpdateAppearance
addon.leftFrame = leftFrame
addon.rightFrame = rightFrame
addon.leftContent = leftContent
addon.rightContent = rightContent
addon.leftScroll = leftScroll
addon.rightScroll = rightScroll
addon.baseHeight = 40
addon.lineHeight = 14

-- Calculate initial height based on default maxLines (100)
local initialHeight = addon.baseHeight + (PetBattleSpectatorDB.maxLines or 100) * addon.lineHeight / 4
leftFrame:SetHeight(initialHeight)
rightFrame:SetHeight(initialHeight)

leftScroll:SetScript("OnSizeChanged", function(self)
  self:UpdateScrollChildRect()
  UpdateAppearance()
end)

rightScroll:SetScript("OnSizeChanged", function(self)
  self:UpdateScrollChildRect()
  UpdateAppearance()
end)

-- Add message to log
local function AddMessage(text, isRoundMessage)
  if not text or text == "" then return end

  -- Strip color codes
  text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")

  if isRoundMessage then
    -- Add to both frames for round markers
    table.insert(PetBattleSpectatorDB.leftLogs, text)
    table.insert(PetBattleSpectatorDB.rightLogs, text)
  else
    -- Route messages appropriately
    local isEnemy = text:lower():find("enemy")
    local isYour = text:lower():find("your")

    if isEnemy then
      table.insert(PetBattleSpectatorDB.rightLogs, text)
    elseif isYour then
      table.insert(PetBattleSpectatorDB.leftLogs, text)
    else
      -- Neutral messages go to both frames
      table.insert(PetBattleSpectatorDB.leftLogs, text)
      table.insert(PetBattleSpectatorDB.rightLogs, text)
    end
  end

  -- Trim log if too long (keeping newest messages)
  if PetBattleSpectatorDB.maxLines and #PetBattleSpectatorDB.leftLogs > PetBattleSpectatorDB.maxLines then
    table.remove(PetBattleSpectatorDB.leftLogs, 1)
  end
  if PetBattleSpectatorDB.maxLines and #PetBattleSpectatorDB.rightLogs > PetBattleSpectatorDB.maxLines then
    table.remove(PetBattleSpectatorDB.rightLogs, 1)
  end

  UpdateAppearance()
end

-- Register events on both frames
leftFrame:RegisterEvent("PLAYER_LOGIN")
leftFrame:RegisterEvent("CHAT_MSG_PET_BATTLE_COMBAT_LOG")
leftFrame:RegisterEvent("PET_BATTLE_PET_ROUND_PLAYBACK_COMPLETE")
leftFrame:RegisterEvent("PET_BATTLE_OPENING_START")
leftFrame:RegisterEvent("PET_BATTLE_CLOSE")

rightFrame:RegisterEvent("PLAYER_LOGIN")
rightFrame:RegisterEvent("CHAT_MSG_PET_BATTLE_COMBAT_LOG")
rightFrame:RegisterEvent("PET_BATTLE_PET_ROUND_PLAYBACK_COMPLETE")
rightFrame:RegisterEvent("PET_BATTLE_OPENING_START")
rightFrame:RegisterEvent("PET_BATTLE_CLOSE")

-- Single event handler for both frames
local function OnEvent(self, event, ...)
  if event == "PLAYER_LOGIN" then
    print("|cff3FC7EB[PBS]|r: addon loaded. Open options panel with: |cffFFFF00/pbs|r")
    addon.Timer:Initialize()
  elseif event == "PET_BATTLE_OPENING_START" then
    local isPvP = not C_PetBattles.IsPlayerNPC(LE_BATTLE_PET_ENEMY)
    addon.Timer.isPvP = isPvP

    PetBattleSpectatorDB.leftLogs = {}
    PetBattleSpectatorDB.rightLogs = {}
    currentRound = 0
    leftFrame:Show()
    rightFrame:Show()
    AddMessage("----- BATTLE STARTED -----\n", true)

    if isPvP then
      addon.Timer:ResetTurnTimer() -- Assume player's turn first
    end
    addon.Timer:UpdateVisibility()
  elseif event == "CHAT_MSG_PET_BATTLE_COMBAT_LOG" then
    local message = ...
    local isGeneral = message:match("Round") or message:match("BATTLE") or
        not (message:lower():find("enemy") or message:lower():find("your"))
    AddMessage(message, isGeneral)
  elseif event == "PET_BATTLE_PET_ROUND_PLAYBACK_COMPLETE" then
    currentRound = currentRound + 1
    AddMessage("\n", true)
    if addon.Timer.isPvP then
      addon.Timer:ResetTurnTimer()
      addon.Timer:UpdateDisplay()
    end
  elseif event == "PET_BATTLE_CLOSE" then
    addon.Timer:Hide()
    C_Timer.After(PetBattleSpectatorDB.logDuration or 5, function()
      leftFrame:Hide()
      rightFrame:Hide()
    end)
  end
end

-- Register single handler to left frame only
leftFrame:SetScript("OnEvent", OnEvent)

-- Right frame doesn't need its own handler
rightFrame:SetScript("OnEvent", function() end)

-- Initial setup
UpdateAppearance()
