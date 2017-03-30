--[[
	main.lua
		Some sort of crazy visual inventory management system
--]]

local ADDON, Addon = ...
_G[ADDON] = Addon


--[[ Startup ]]--

function Addon:OnEnable()
	self:StartupSettings()
	self:SetupAutoDisplay()
	self:AddSlashCommands(ADDON:lower(), 'cbt')
	self:HookTooltips()

	self:CreateFrame('inventory')
	self:CreateOptionsLoader()
end

function Addon:CreateOptionsLoader()
	local f = CreateFrame('Frame', nil, InterfaceOptionsFrame)
	f:SetScript('OnShow', function(self)
		self:SetScript('OnShow', nil)
		LoadAddOn(ADDON .. '_Config')
	end)
end

function Addon:ShowOptions()
	if LoadAddOn(ADDON .. '_Config') then
		InterfaceOptionsFrame_OpenToCategory(ADDON)
		InterfaceOptionsFrame_OpenToCategory(ADDON) -- sometimes once not enough
		return true
	end
end


--[[ Custom Item Layout ]]--

local function bestFit(w, h, n)
  local r, r2 = h/w, w/h

  local px = ceil(sqrt(n*r2))
  local py = ceil(sqrt(n*r))

  local sx = ((floor(px*r) * px) < n) and h/ceil(px*r) or w/px
  local sy = ((floor(py*r2) * py) < n) and w/ceil(py*r2) or h/py

  return sx, sy
end

function Addon.ItemFrame:LayoutTraits()
	local w, h = self:GetFrame():GetSize()
	w = w - (self:GetProfile().showBags and 59 or 23)
	h = h - 100

	local size = bestFit(w, h, self:NumButtons())
	local cols = floor(w / size)
	local scale = size / self:GetButtonSize()

	return cols, scale
end

function Addon.ItemFrame:BagBreak()
end
