--[[
	Combuctor.lua
		Some sort of crazy visual inventory management system
--]]

local ADDON, Addon = ...
LibStub('AceAddon-3.0'):NewAddon(Addon, ADDON, 'AceEvent-3.0', 'AceConsole-3.0')
Addon.__call = Addon.GetModule
_G[ADDON] = setmetatable(Addon, Addon)


--[[ Constants ]]--

local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local CURRENT_VERSION = GetAddOnMetadata(ADDON, 'Version')

BINDING_HEADER_COMBUCTOR = ADDON
BINDING_NAME_COMBUCTOR_TOGGLE_INVENTORY = L.ToggleInventory
BINDING_NAME_COMBUCTOR_TOGGLE_BANK = L.ToggleBank


--[[ Startup ]]--

function Addon:OnInitialize()
	self.profile = self:InitDB()

	-- version update
	if self.db.version ~= CURRENT_VERSION then
		self:UpdateSettings()
		self:UpdateVersion()
	end

	-- base set, slash commands
	self('Sets'):Register(L.All, 'Interface/Icons/INV_Misc_EngGizmos_17', function() return true end)
	self:RegisterChatCommand('combuctor', 'OnSlashCommand')
	self:RegisterChatCommand('cbt', 'OnSlashCommand')

	-- option frame loader
	local f = CreateFrame('Frame', nil, InterfaceOptionsFrame)
	f:SetScript('OnShow', function(self)
		self:SetScript('OnShow', nil)
		LoadAddOn('Combuctor_Config')
	end)
end

function Addon:OnEnable()
	local profile = self:GetProfile(UnitName('player'))

	self.Frame:New(L.InventoryTitle, profile.inventory, false, 'inventory')
	self.Frame:New(L.BankTitle, profile.bank, true, 'bank')
	self:HookTooltips()
	self:HookBagEvents()
end


--[[ Settings ]]--

function Addon:InitDB()
	CombuctorDB2 = CombuctorDB2 or {
		version = CURRENT_VERSION,
		global = {}, profiles = {}
	}

	self.db = CombuctorDB2
	self.sets = self.db.global

	return self:GetProfile() or self:InitProfile()
end

function Addon:UpdateSettings(major, minor, bugfix)
	local expansion, patch, release = strsplit('.', self.db.version)
	local version = tonumber(expansion) * 10000 + tonumber(patch or 0) * 100 + tonumber(release or 0)

	-- Remove keyring
	if version < 40309 then
		for char, prefs in pairs(CombuctorDB2.profiles) do
			local bags = prefs.inventory and prefs.inventory.bags
			
			if bags then
				for i, bag in ipairs(bags) do
					if bag == -2 then
						tremove(bags, i)
					end
				end
			end
		end
	end
end

function Addon:UpdateVersion()
	self.db.version = CURRENT_VERSION
	self:Print(format(L.Updated, self.db.version))
end

function Addon:ToggleSetting(set)
	self.sets[set] = not self.sets[set] or nil
end

function Addon:GetSetting(set)
	return self.sets[set]
end


--[[ Profiles ]]--

function Addon:GetProfile(player)
	if not player then
		player = UnitName('player')
	end
	return self.db.profiles[player .. ' - ' .. GetRealmName()]
end


local function addSet(sets, exclude, name, ...)
	if sets then
		tinsert(sets, name)
	else
		sets = {name}
	end

	if select('#', ...) > 0 then
		if exclude then
			tinsert(exclude, {[name] = {...}})
		else
			exclude = {[name] = {...}}
		end
	end

	return sets, exclude
end

local function getDefaultInventorySets(class)
	local sets, exclude = addSet(sets, exclude, L.All, L.All)
	return sets, exclude
end

local function getDefaultBankSets(class)
	local sets, exclude = addSet(sets, exclude, L.All, L.All)
	sets, exclude = addSet(sets, exclude, L.Equipment)
	sets, exclude = addSet(sets, exclude, L.TradeGood)
	sets, exclude = addSet(sets, exclude, L.Misc)

	return sets, exclude
end

function Addon:InitProfile()
	local player, realm = UnitName('player'), GetRealmName()
	local class = select(2, UnitClass('player'))
	local profile = self:GetBaseProfile()

	profile.inventory.sets, profile.inventory.exclude = getDefaultInventorySets(class)
	profile.bank.sets, profile.bank.exclude = getDefaultBankSets(class)

	self.db.profiles[player .. ' - ' .. realm] = profile
	return profile
end

function Addon:GetBaseProfile()
	return {
		inventory = {
			bags = {0, 1, 2, 3, 4},
			position = {'RIGHT'},
			showBags = false,
			leftSideFilter = true,
			w = 384,
			h = 512,
		},

		bank = {
			bags = {-1, 5, 6, 7, 8, 9, 10, 11},
			showBags = false,
			w = 512,
			h = 512,
		}
	}
end


--[[ Events ]]--

function Addon:HookBagEvents()
	local AutoShowInventory = function()
		self:Show(BACKPACK_CONTAINER, true)
	end
	local AutoHideInventory = function()
		self:Hide(BACKPACK_CONTAINER, true)
	end

	--auto magic display code
	OpenBackpack = AutoShowInventory
	hooksecurefunc('CloseBackpack', AutoHideInventory)

	ToggleBag = function(bag)
		self:Toggle(bag)
	end

	ToggleBackpack = function()
		self:Toggle(BACKPACK_CONTAINER)
	end

	OpenAllBags = function(frame)
		self:Show(BACKPACK_CONTAINER)
	end

	if _G['ToggleAllBags'] then
		ToggleAllBags = function()
			self:Toggle(BACKPACK_CONTAINER)
		end
	end

	--closing the game menu triggers this function, and can be done in combat,
	hooksecurefunc('CloseAllBags', function()
		self:Hide(BACKPACK_CONTAINER)
	end)
	
	BankFrame:UnregisterAllEvents()
	
	self.BagEvents.Listen(self, 'BANK_OPENED', function()
		self:Show(BANK_CONTAINER, true)
		self:Show(BACKPACK_CONTAINER, true)
	end)
	
	self.BagEvents.Listen(self, 'BANK_CLOSED', function()
		self:Hide(BANK_CONTAINER, true)
		self:Hide(BACKPACK_CONTAINER, true)
	end)

	self:RegisterEvent('MAIL_CLOSED', AutoHideInventory)
	self:RegisterEvent('TRADE_SHOW', AutoShowInventory)
	self:RegisterEvent('TRADE_CLOSED', AutoHideInventory)
	self:RegisterEvent('TRADE_SKILL_SHOW', AutoShowInventory)
	self:RegisterEvent('TRADE_SKILL_CLOSE', AutoHideInventory)
	self:RegisterEvent('AUCTION_HOUSE_SHOW', AutoShowInventory)
	self:RegisterEvent('AUCTION_HOUSE_CLOSED', AutoHideInventory)
	self:RegisterEvent('AUCTION_HOUSE_SHOW', AutoShowInventory)
	self:RegisterEvent('AUCTION_HOUSE_CLOSED', AutoHideInventory)
end


--[[ Frames ]]--

function Addon:Show(bag, auto)
	for _,frame in pairs(self.frames) do
		for _,bagID in pairs(frame.sets.bags) do
			if bagID == bag then
				frame:ShowFrame(auto)
				return
			end
		end
	end
end

function Addon:Hide(bag, auto)
	for _,frame in pairs(self.frames) do
		for _,bagID in pairs(frame.sets.bags) do
			if bagID == bag then
				frame:HideFrame(auto)
				return
			end
		end
	end
end

function Addon:Toggle(bag, auto)
	for _,frame in pairs(self.frames) do
		for _,bagID in pairs(frame.sets.bags) do
			if bagID == bag then
				frame:ToggleFrame(auto)
				return
			end
		end
	end
end

function Addon:UpdateFrames()
	for _,frame in pairs(self.frames or {}) do
		frame.itemFrame:Regenerate()
	end
end

function Addon:GetFrame(key)
  return self.frames[key]
end


--[[ Extras ]]--

function Addon:ShowOptions()
	if LoadAddOn('Combuctor_Config') then
		InterfaceOptionsFrame_OpenToCategory(ADDON)
		InterfaceOptionsFrame_OpenToCategory(ADDON) -- sometimes once not enough
	end
end

function Addon:OnSlashCommand(msg)
	local msg = msg and msg:lower()

	if msg == 'bank' then
		self:Toggle(BANK_CONTAINER)
	elseif msg == 'bags' then
		self:Toggle(BACKPACK_CONTAINER)
	elseif msg == '' or msg == 'config' or msg == 'options' then
		self:ShowOptions()
	elseif msg == 'version' then
		self:Print(self.db.version)
	else
		self:Print('Commands (/cbt or /combuctor)\n- bank: Toggle bank\n- bags: Toggle inventory\n- options: Shows the options menu')
	end
end

function Addon:Print(...)
	return print('|cffFFBA00'.. ADDON .. '|r:', ...)
end