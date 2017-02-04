--[[
	main.lua
		Some sort of crazy visual inventory management system
--]]

local ADDON, Addon = ...
_G[ADDON] = Addon
Addon.frames = {}


--[[ Startup ]]--

function Addon:OnEnable()
	self:StartupSettings()
	self:RegisterEvents()
	self:HookTooltips()
	self:HookDefaultDisplayFunctions()

	self:CreateFrame('inventory')
	self:CreateOptionsLoader()
	self:AddSlashCommands(ADDON:lower(), 'cbt')
end

function Addon:CreateFrameLoader(module, method)
	local addon = ADDON .. '_' .. module
	if GetAddOnEnableState(UnitName('player'), addon) >= 2 then
		_G[method] = function()
			if LoadAddOn(addon) then
				self:GetModule(module):OnOpen()
			end
		end
	end
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


--[[ Bank Display ]]--

function Addon:RegisterEvents()
	self:RegisterEvent('BANKFRAME_CLOSED')
	self:RegisterMessage('BANK_OPENED')
	BankFrame:UnregisterAllEvents()
end

function Addon:BANK_OPENED()
	if self:GetFrame('bank') then
		self:GetFrame('bank'):SetPlayer(nil)
	end
	
	self.Cache.AtBank = true
	self:ShowFrame('bank')

	if self.sets.displayBank then
		self:ShowFrame('inventory')
	end
end

function Addon:BANKFRAME_CLOSED()
	self.Cache.AtBank = nil
	self:HideFrame('bank')

	if self.sets.closeBank then
		self:HideFrame('inventory')
	end
end
