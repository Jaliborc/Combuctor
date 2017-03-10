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

function Addon.ItemFrame:LayoutTraits()
	local profile = self:GetProfile()
	local w = self:GetFrame():GetWidth() - (profile.showBags and 59 or 23)

	local buttonSpace = (37 + profile.spacing) * profile.itemScale
	local emptySpace = w % buttonSpace

	local numCollumns = floor(w / buttonSpace)
	local fillScale = emptySpace / numCollumns / buttonSpace

	return numCollumns, (37 + profile.spacing), profile.itemScale + fillScale
end