local _, addon = ...

addon.utils = addon.utils or {}
local U = addon.utils

-- ======================================================
-- INITIALIZE UTILS
-- ======================================================
U.slider = U.slider or {}
U.button = U.button or {}

-- ======================================================
-- SLIDER TEMPLATE
-- ======================================================
function U.slider:Create(parent, minVal, maxVal, step, anchorPoint, relativeTo, relativePoint, xOff, yOff, labelText)
  -- safe name for the slider text and the low and high value texts
  local safeName = "PBS_Slider_" .. tostring(labelText):gsub("%W", "")
  -- creating the slider frame
  local slider = CreateFrame("Slider", nil, parent, "OptionsSliderTemplate")
  -- set the basic settings of the slider so there is no DRY
  slider:SetPoint(anchorPoint, relativeTo, relativePoint, xOff, yOff)
  slider:SetSize(200, 16)
  slider:SetMinMaxValues(minVal, maxVal)
  slider:SetValueStep(step)
  slider:SetObeyStepOnDrag(true)
  -- the slider label
  slider.label = _G[safeName .. "Text"] or slider:CreateFontString(nil, "OVERLAY", "GameFontHighLight")
  slider.label:SetPoint("BOTTOM", slider, "TOP", 0, 5)
  slider.label:SetText(labelText or "")
  slider.label:SetTextColor(1, 1, 1)
  -- built in low/high strings
  slider.Low = _G[safeName .. "Low"]
  slider.High = _G[safeName .. "High"]
  if slider.Low then slider.Low:SetText(minVal) end
  if slider.High then slider.High:SetText(maxVal) end
  -- return the created slider
  return slider
end

-- ======================================================
-- BUTTON TEMPLATE
-- ======================================================
function U.button:Create(parent, text, anchorPoint, relativeTo, relativePoint, xOff, yOff)
  -- creating the button frame
  local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  -- set the basic button settings
  btn:SetPoint(anchorPoint, relativeTo, relativePoint, xOff, yOff)
  btn:SetSize(150, 25)
  btn:SetText(text)
  -- return the button
  return btn
end
