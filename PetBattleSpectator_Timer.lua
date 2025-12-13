local addonName, addon = ...
local Timer = {
  isPvP = false,
  currentTurnTime = 30,
  lastUpdate = 0
}

function Timer:Initialize()
  -- Create a single timer frame
  self.timerFrame = CreateFrame("Frame", "PetBattleTimerSingle", UIParent)
  self.timerFrame:SetSize(150, 60)
  self.timerFrame:SetFrameStrata("TOOLTIP")
  self.timerFrame:SetMovable(true)
  self.timerFrame:EnableMouse(true)
  self.timerFrame:RegisterForDrag("LeftButton")
  self.timerFrame:SetScript("OnDragStart", function() self.timerFrame:StartMoving() end)
  self.timerFrame:SetScript("OnDragStop", function()
    self.timerFrame:StopMovingOrSizing()
    self:SavePosition()
  end)

  -- Large timer text
  self.timerText = self.timerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
  self.timerText:SetFont("Fonts\\FRIZQT__.TTF", 32) -- Very large font
  self.timerText:SetPoint("CENTER")
  self.timerText:SetText("30.0")
  self.timerText:SetTextColor(1, 1, 1) -- White by default

  -- Set default position (top-center)
  self.timerFrame:ClearAllPoints()
  self.timerFrame:SetPoint("TOP", UIParent, "TOP", 0, -150)

  -- Load position before setting up the rest
  self:LoadPosition()
  self:Hide()

  -- Set up update frame
  self.updateFrame = CreateFrame("Frame")
  -- self.updateFrame:SetScript("OnUpdate", function(_, elapsed) self:OnUpdate(elapsed) end)
  self.updateFrame:SetScript("OnUpdate", function(_, elapsed)
    if self.isPvP then
      self:OnUpdate(elapsed)
    end
  end)
end

function Timer:OnUpdate(elapsed)
  if not self.isPvP then return end
  if not PetBattleSpectatorDB.showTimer then return end

  self.lastUpdate = self.lastUpdate + elapsed
  if self.lastUpdate > 0.1 then -- Update every 0.1 seconds
    if self.currentTurnTime > 0 then
      self.currentTurnTime = self.currentTurnTime - self.lastUpdate
      if self.currentTurnTime < 0 then self.currentTurnTime = 0 end
      self:UpdateDisplay()
    end
    self.lastUpdate = 0
  end
end

function Timer:UpdateDisplay()
  self.timerText:SetText(string.format("%.1f", self.currentTurnTime))

  -- Color changes
  if self.currentTurnTime < 5 then
    self.timerText:SetTextColor(1, 0, 0)   -- Red when critical
  elseif self.currentTurnTime < 10 then
    self.timerText:SetTextColor(1, 0.5, 0) -- Orange when low
  else
    self.timerText:SetTextColor(1, 1, 1)   -- White normally
  end
end

function Timer:ResetTurnTimer()
  self.currentTurnTime = 30            -- Make sure this matches your variable name
  self.timerText:SetText("30.0")
  self.timerText:SetTextColor(1, 1, 1) -- Reset to white
end

function Timer:UpdateVisibility()
  if self.timerFrame
      and self.isPvP
      and PetBattleSpectatorDB.showTimer then
    self.timerFrame:Show()
  else
    self.timerFrame:Hide()
  end
end

function Timer:Show()
  self:UpdateVisibility()
end

function Timer:Hide()
  if self.timerFrame then
    self.timerFrame:Hide()
  end
end

function Timer:SavePosition()
  PetBattleSpectatorDB.timerPosition = PetBattleSpectatorDB.timerPosition or {}
  PetBattleSpectatorDB.timerPosition.point = { self.timerFrame:GetPoint() }
end

function Timer:LoadPosition()
  if PetBattleSpectatorDB and PetBattleSpectatorDB.timerPosition then
    self.timerFrame:ClearAllPoints()
    self.timerFrame:SetPoint("TOP", UIParent, "TOP", 0, -150)
  end
end

addon.Timer = Timer
