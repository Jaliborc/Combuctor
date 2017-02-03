--[[
	main.lua
		Some sort of crazy visual inventory management system
--]]

local ADDON, Addon = ...
_G[ADDON] = Addon
Addon.frames = {}

local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
_G['BINDING_HEADER_' .. ADDON] = ADDON
_G['BINDING_NAME_' .. ADDON .. '_TOGGLE'] = L.ToggleBags
_G['BINDING_NAME_' .. ADDON .. '_BANK_TOGGLE'] = L.ToggleBank
_G['BINDING_NAME_' .. ADDON .. '_VAULT_TOGGLE'] = L.ToggleVault
_G['BINDING_NAME_' .. ADDON .. '_GUILD_TOGGLE'] = L.ToggleGuild


--[[ Startup ]]--

function Addon:OnEnable()
	self:StartupSettings()
	self:RegisterEvents()
	self:HookBagClickEvents()
	self:HookTooltips()
	self:AddSlashCommands()

	self:CreateFrame('inventory')
	self:CreateFrameLoader('GuildBank', 'GuildBankFrame_LoadUI')
	self:CreateFrameLoader('VoidStorage', 'VoidStorage_LoadUI')
	self:CreateOptionsLoader()
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


--[[ Bags ]]--

function Addon:ToggleBag(frame, bag)
	if self:ControlsBag(frame, bag) then
		return self:ToggleFrame(frame)
	end
end

function Addon:ShowBag(frame, bag)
	if self:ControlsBag(frame, bag) then
		return self:ShowFrame(frame)
	end
end

function Addon:ControlsBag(frame, bag)
	return true
end


--[[ Frames ]]--

function Addon:UpdateFrames()
	self:SendMessage('UPDATE_ALL')
	self:UpdateEvents()
end

function Addon:AreBasicFramesEnabled()
	return true
end

function Addon:ToggleFrame(id)
	if self:IsFrameShown(id) then
		return self:HideFrame(id, true)
	else
		return self:ShowFrame(id)
	end
end

function Addon:ShowFrame(id)
	local frame = self:CreateFrame(id)
	if frame then
		frame:ShowFrame()
	end
	return frame
end

function Addon:HideFrame(id, force)
	local frame = self:GetFrame(id)
	if frame then
		frame:HideFrame(force)
	end
	return frame
end

function Addon:CreateFrame(id)
	if self:IsFrameEnabled(id) then
 		--self.frames[id] = self.frames[id] or self[id:gsub('^.', id.upper) .. 'Frame']:New(id)
 		self.frames[id] = self.frames[id] or self.Frame:New(id)
 		return self.frames[id]
 	end
end

function Addon:IsFrameShown(id)
	local frame = self:GetFrame(id)
	return frame and frame:IsShown()
end

function Addon:IsFrameEnabled(id)
	return true
end

function Addon:GetFrame(id)
	return self.frames[id]
end

function Addon:IterateFrames()
	return pairs(self.frames)
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


--[[ Bag Buttons Hooks ]]--

function Addon:HookBagClickEvents()
	-- inventory
	local canHide = true
	local onMerchantHide = MerchantFrame:GetScript('OnHide')

	local hideInventory = function()
		if canHide then
			self:HideFrame('inventory')
		end
	end

	MerchantFrame:SetScript('OnHide', function(...)
		canHide = false
		onMerchantHide(...)
		canHide = true
	end)

	hooksecurefunc('CloseBackpack', hideInventory)
	hooksecurefunc('CloseAllBags', hideInventory)

	-- backpack
	local oToggleBackpack = ToggleBackpack
	ToggleBackpack = function()
		if not self:ToggleBag('inventory', BACKPACK_CONTAINER) then
			oToggleBackpack()
		end
	end

	local oOpenBackpack = OpenBackpack
	OpenBackpack = function()
		if not self:ShowBag('inventory', BACKPACK_CONTAINER) then
			oOpenBackpack()
		end
	end

	-- single bag
	local oToggleBag = ToggleBag
	ToggleBag = function(bag)
		local frame = self:IsBankBag(bag) and 'bank' or 'inventory'
		if not self:ToggleBag(frame, bag) then
			oToggleBag(bag)
		end
	end

	local oOpenBag = OpenBag
	OpenBag = function(bag)
		local frame = self:IsBankBag(bag) and 'bank' or 'inventory'
		if not self:ShowBag(frame, bag) then
			oOpenBag(bag)
		end
	end

	-- all bags
	local oOpenAllBags = OpenAllBags
	OpenAllBags = function(frame)
		if not self:ShowFrame('inventory') then
			oOpenAllBags(frame)
		end
	end

	if ToggleAllBags then
		local oToggleAllBags = ToggleAllBags
		ToggleAllBags = function()
			if not self:ToggleFrame('inventory') then
				oToggleAllBags()
			end
		end
	end

	local function checkIfInventoryShown(button)
		if self:IsFrameEnabled('inventory') then
			button:SetChecked(self:IsFrameShown('inventory'))
		end
	end

	hooksecurefunc('BagSlotButton_UpdateChecked', checkIfInventoryShown)
	hooksecurefunc('BackpackButton_UpdateChecked', checkIfInventoryShown)
end


--[[ Slash Commands ]]--

function Addon:AddSlashCommands()
	self:RegisterChatCommand(ADDON:lower(), 'HandleSlashCommand')
	self:RegisterChatCommand('cbt', 'HandleSlashCommand')
end

function Addon:HandleSlashCommand(cmd)
	cmd = cmd and cmd:lower() or ''
	
	if cmd == 'bank' then
		self:ToggleFrame('bank')
	elseif cmd == 'bags' or cmd == 'inventory' then
		self:ToggleFrame('inventory')
	elseif cmd == 'guild' and LoadAddOn(ADDON .. '_GuildBank') then
		self:ToggleFrame('guild')
	elseif cmd == 'vault' and LoadAddOn(ADDON .. '_VoidStorage') then
		self:ToggleFrame('vault')
	elseif cmd == 'version' then
		self:Print(GetAddOnMetadata(ADDON, 'Version'))
	elseif cmd == '?' or cmd == 'help' or not self:ShowOptions() and cmd ~= 'config' and cmd ~= 'options' then
		self:PrintHelp()
	end
end

function Addon:PrintHelp()
	local function PrintCmd(cmd, desc)
		print(format(' - |cFF33FF99%s|r: %s', cmd, desc))
	end

	self:Print(L.Commands)
	PrintCmd('bags', L.CmdShowInventory)
	PrintCmd('bank', L.CmdShowBank)
	PrintCmd('version', L.CmdShowVersion)
end

function Addon:ShowOptions()
	if LoadAddOn(ADDON .. '_Config') then
		InterfaceOptionsFrame_OpenToCategory(ADDON)
		InterfaceOptionsFrame_OpenToCategory(ADDON) -- sometimes once not enough
		return true
	end
end