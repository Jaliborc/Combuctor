--[[
	BagEvents
		A library of functions for accessing and updating bag slot information

	Based on SpecialEvents-Bags by Tekkub Stoutwrithe (tekkub@gmail.com)

	ITEM_SLOT_ADD
	args:		bag, slot, itemLink, count, coolingDown
		called when a new slot becomes available to the player

	ITEM_SLOT_REMOVE
	args:		bag, slot
		called when an item slot is removed from being in use

	ITEM_SLOT_UPDATE
	args:		bag, slot, itemLink, count
		called when an item slot's item or item count changes

	ITEM_SLOT_UPDATE_COOLDOWN
	args:		bag, slot, coolingDown
		called when an item's cooldown starts/ends

	BANK_OPENED
	args:		none
		called when the bank has opened and all of the bagnon events have SendMessaged

	BANK_CLOSED
	args:		none
		called when the bank is closed and all of the bagnon events have SendMessaged

	BAG_UPDATE_TYPE
	args:	bag, type
		called when the type of a bag changes (aka, what items you can put in it changes)

	Usage:
		Addon('InventoryEvents'):Register(frame, 'message' [, 'method' or function])
		Addon('InventoryEvents'):Unregister(frame, 'message')
		Addon('InventoryEvents'):UnregisterAlll(frame)
		playerAtBank = Addon('InventoryEvents'):AtBank()
--]]


local AddonName, Addon = ...
local InventoryEvents = Addon:NewModule('InventoryEvents')
local Sender = LibStub('CallbackHandler-1.0'):New(InventoryEvents, 'Register', 'Unregister', 'UnregisterAll')
local AtBank = false

function InventoryEvents:AtBank()
	return AtBank
end

local function sendMessage(msg, ...)
	Sender:Fire(msg, ...)
end


--[[
	Update Functions
--]]

local Slots
do
	local function getIndex(bagId, slotId)
		return (bagId < 0 and bagId * 100 - slotId) or bagId * 100 + slotId
	end

	Slots = {
		Set = function(self, bagId, slotId, itemLink, count, isLocked, onCooldown)
			local index = getIndex(bagId, slotId)

			local item = self[index] or {}
			item[1] = itemLink
			item[2] = count
			item[4] = onCooldown

			self[index] = item
		end,

		Remove = function(self, bagId, slotId)
			local index = getIndex(bagId, slotId)
			local item = self[index]

			if item then
				self[index] = nil
				return true
			end
		end,

		Get = function(self, bagId, slotId)
			return self[getIndex(bagId, slotId)]
		end,
	}

	setmetatable(Slots, {__call = Slots.Get})
end

local BagTypes = {}
local BagSizes = {}


--[[ Item Updating ]]--

local function addItem(bagId, slotId)
	local texture, count, locked, quality, readable, lootable, itemLink = GetContainerItemInfo(bagId, slotId)
	local start, duration, enable = GetContainerItemCooldown(bagId, slotId)
	local onCooldown = (start > 0 and duration > 0 and enable > 0)

	Slots:Set(bagId, slotId, link, count, locked, onCooldown)
	sendMessage('ITEM_SLOT_ADD', bagId, slotId, itemLink, count, onCooldown)
end

local function removeItem(bagId, slotId)
	if Slots:Remove(bagId, slotId) then
		sendMessage('ITEM_SLOT_REMOVE', bagId, slotId, prevLink)
	end
end

local function updateItem(bagId, slotId)
	local item = Slots(bagId, slotId)
	if item then
		local prevLink = item[1]
		local prevCount = item[2]

		local texture, count, locked, quality, readable, lootable, itemLink = GetContainerItemInfo(bagId, slotId)
		if not(prevLink == itemLink and prevCount == count) then
			item[1] = link
			item[2] = count

			sendMessage('ITEM_SLOT_UPDATE', bagId, slotId, itemLink, count)
		end
	end
end

local function updateItemCooldown(bagId, slotId)
	local item = Slots(bagId, slotId)

	if item and item[1] then
		local start, duration, enable = GetContainerItemCooldown(bagId, slotId)
		local onCooldown = (start > 0 and duration > 0 and enable > 0)

		if item[4] ~= onCooldown then
			item[4] = onCooldown
			sendMessage('ITEM_SLOT_UPDATE_COOLDOWN', bagId, slotId, onCooldown)
		end
	end
end

--[[ Bag Updating ]]--

local function getBagSize(bagId)
	if bagId == KEYRING_CONTAINER then
		return GetKeyRingSize()
	end
	if bagId == BANK_CONTAINER then
		return NUM_BANKGENERIC_SLOTS
	end
	return GetContainerNumSlots(bagId)
end

--bag sizes
local function updateBagSize(bagId)
	local prevSize = BagSizes[bagId] or 0
	local newSize = getBagSize(bagId)
	BagSizes[bagId] = newSize

	if prevSize > newSize then
		for slotId = newSize + 1, prevSize do
			removeItem(bagId, slotId)
		end
	elseif prevSize < newSize then
		for slotId = prevSize + 1, newSize do
			addItem(bagId, slotId)
		end
	end
end

local function updateBagType(bagId)
	local _, newType = GetContainerNumFreeSlots(bagId)
	local prevType = BagTypes[bagId]

	if newType ~= prevType then
		BagTypes[bagId] = newType
		sendMessage('BAG_UPDATE_TYPE', bagId, newType)
	end
end

--[[ metamethods ]]--

local function forEachItem(bagId, f, ...)
	if not bagId and f then error('Usage: forEachItem(bagId, function, ...)', 2) end

	for slotId = 1, getBagSize(bagId) do
		f(bagId, slotId, ...)
	end
end

local function forEachBag(f, ...)
	if not f then error('Usage: forEachBag(function, ...)', 2) end

	if AtBank then
		for bagId = 1, NUM_BAG_SLOTS + GetNumBankSlots() do
			f(bagId, ...)
		end
	else
		for bagId = 1, NUM_BAG_SLOTS do
			f(bagId, ...)
		end
	end
	f(KEYRING_CONTAINER, ...)
end


--[[ inventory event watcher ]]--

do
	local eventFrame = CreateFrame('Frame'); eventFrame:Hide()

	eventFrame:SetScript('OnEvent', function(self, event, ...)
		local a = self[event]
		if a then
			a(self, event, ...)
		end
	end)
	eventFrame:RegisterEvent('PLAYER_LOGIN')

	function eventFrame:PLAYER_LOGIN(event, ...)
		self:RegisterEvent('BAG_UPDATE')
		self:RegisterEvent('BAG_UPDATE_COOLDOWN')
		self:RegisterEvent('PLAYERBANKSLOTS_CHANGED')

		updateBagSize(KEYRING_CONTAINER)
		forEachItem(KEYRING_CONTAINER, updateItem)

		updateBagSize(BACKPACK_CONTAINER)
		forEachItem(BACKPACK_CONTAINER, updateItem)
	end

	function eventFrame:BAG_UPDATE(event, bagId, ...)
		forEachBag(updateBagType)
		forEachBag(updateBagSize)
		forEachItem(bagId, updateItem)
	end

	--[[
		per http://wowprogramming.com/docs/events/PLAYERBANKSLOTS_CHANGED
			slotID - The slot id that changes.
					 1-28 is the bank slots.
					 29-35 are the bank bags.
	--]]
	function eventFrame:PLAYERBANKSLOTS_CHANGED(event, slotId, ...)
		if slotId > GetContainerNumSlots(BANK_CONTAINER) then
			local bagId = (slotId - getBagSize(BANK_CONTAINER)) + ITEM_INVENTORY_BANK_BAG_OFFSET
			updateBagType(bagId)
			updateBagSize(bagId)
		else
			updateItem(BANK_CONTAINER, slotId)
		end
	end

	function eventFrame:BAG_UPDATE_COOLDOWN(event, ...)
		forEachBag(forEachItem, updateItemCooldown)
	end
end


--[[
	bank open/close events
		this is here for my crazy theory that the main bank contents aren't available immediately
		but are available on the next frame
--]]

do
	local bankWatcher = CreateFrame('Frame'); bankWatcher:Hide()

	bankWatcher:SetScript('OnShow', function(self)
		AtBank = true

		updateBagSize(BANK_CONTAINER)
		forEachItem(BANK_CONTAINER, updateItem)

		forEachBag(updateBagType)
		forEachBag(updateBagSize)

		sendMessage('BANK_OPENED')

		self:SetScript('OnShow', function(self) 
			AtBank = true
			sendMessage('BANK_OPENED') 
		end)
	end)

	bankWatcher:SetScript('OnHide', function(self)
		AtBank = false
		sendMessage('BANK_CLOSED')
	end)

	bankWatcher:SetScript('OnEvent', function(self, event, ...)
		if event == 'BANKFRAME_OPENED' then
			self:Show()
		else
			self:Hide()
		end
	end)

	bankWatcher:RegisterEvent('BANKFRAME_OPENED')
	bankWatcher:RegisterEvent('BANKFRAME_CLOSED')
end