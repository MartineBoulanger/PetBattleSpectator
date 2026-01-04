local _, addon = ...

local max = _G.math.max
local min = _G.math.min
local currentRound = 0

-- ======================================================
-- DATABASE INITIALIZATION
-- ======================================================
local function InitDB()
  PetBattleSpectatorDB = PetBattleSpectatorDB or {}

  local defaults = {
    enabled = true,
    fontSize = 12,
    maxLines = 100,
    logDuration = 2,
    backgroundOpacity = 0.3,
    leftLogs = {},
    rightLogs = {},
    showTimer = false,
  }

  for k, v in pairs(defaults) do
    if PetBattleSpectatorDB[k] == nil then
      PetBattleSpectatorDB[k] = v
    end
  end
end

-- ======================================================
-- FRAMES
-- ======================================================
-- left frame
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

-- ======================================================
-- APPEARANCE UPDATE
-- ======================================================
local function UpdateAppearance()
  if not PetBattleSpectatorDB then return end
  -- Left frame settings
  leftFont:SetFont("Fonts\\FRIZQT__.TTF", PetBattleSpectatorDB.fontSize)
  leftFont:SetTextColor(1, 1, 1, 1)

  -- Apply background opacity to left frame
  leftFrame.bg:SetAlpha(PetBattleSpectatorDB.backgroundOpacity)

  -- Right frame settings
  rightFont:SetFont("Fonts\\FRIZQT__.TTF", PetBattleSpectatorDB.fontSize)
  rightFont:SetTextColor(1, 1, 1, 1)

  -- Apply background opacity to right frame
  rightFrame.bg:SetAlpha(PetBattleSpectatorDB.backgroundOpacity)

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

leftScroll:SetScript("OnSizeChanged", function(self)
  self:UpdateScrollChildRect()
  UpdateAppearance()
end)

rightScroll:SetScript("OnSizeChanged", function(self)
  self:UpdateScrollChildRect()
  UpdateAppearance()
end)

-- ======================================================
-- ADD LOG MESSAGES TO FRAMES
-- ======================================================
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

-- ======================================================
-- EVENTS
-- ======================================================
leftFrame:RegisterEvent("ADDON_LOADED")
leftFrame:RegisterEvent("PLAYER_LOGIN")
leftFrame:RegisterEvent("CHAT_MSG_PET_BATTLE_COMBAT_LOG")
leftFrame:RegisterEvent("PET_BATTLE_PET_ROUND_PLAYBACK_COMPLETE")
leftFrame:RegisterEvent("PET_BATTLE_OPENING_START")
leftFrame:RegisterEvent("PET_BATTLE_CLOSE")

-- Single event handler for both frames
local function OnEvent(self, event, ...)
  if event == "ADDON_LOADED" then
    InitDB()

    local height = addon.baseHeight + (PetBattleSpectatorDB.maxLines * addon.lineHeight / 4)
    leftFrame:SetHeight(height)
    rightFrame:SetHeight(height)

    UpdateAppearance()
  elseif event == "PLAYER_LOGIN" then
    print(
      "|cff3FC7EB[Pet Battle Spectator]|r: addon loaded. Open options with: |cffFFFF00/pbs|r or |cffFFFF00/pbspec|r or |cffFFFF00/petbattlespectator|r")
    if addon.Timer then
      addon.Timer:Initialize()
    end
  elseif event == "PET_BATTLE_OPENING_START" then
    local isPvP = not C_PetBattles.IsPlayerNPC(2)
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
    if addon.Timer and addon.Timer.isPvP then
      addon.Timer:ResetTurnTimer()
      addon.Timer:UpdateDisplay()
    end
  elseif event == "PET_BATTLE_CLOSE" then
    addon.Timer:Hide()
    C_Timer.After(PetBattleSpectatorDB.logDuration or 2, function()
      leftFrame:Hide()
      rightFrame:Hide()
    end)
  end
end

-- Register single handler to left frame only
leftFrame:SetScript("OnEvent", OnEvent)
