--[[ 
	Inventory View
		Keeps track of a filtered set of inventory items
--]]

local AddonName, Addon = ...
local InventoryEvents = Addon('InventoryEvents')
local PlayerInfo = Addon('PlayerInfo')

--[[ Module Town ]]--

local InventoryView = Addon:NewModule('InventoryView', Envoy:New())
local InventoryView.__index = InventoryView

function InventoryView:New(obj)
	local obj = obj or {
		bags = {},
		player = UnitName('player'),
	}
	return setmetatable(obj, self)
end

function InventoryView:Enable(enable)
	self.enabled = enable and true or nil
	self:UpdateMessages()
end

function InventoryView:UpdateMessages()
	if not self.enabled or PlayerInfo:IsCached(self.player) then
		InventoryEvents:UnregisterAll(self)
		return
	end

	InventoryEvents:RegisterMany(self, 
		'ITEM_SLOT_ADD',
		'ITEM_SLOT_REMOVE',
		'ITEM_SLOT_UPDATE',
		'ITEM_SLOT_UPDATE_COOLDOWN',
		'BANK_OPENED',
		'BANK_CLOSED'
	)
end

--[[ messages ]]--

function InventoryView:ITEM_SLOT_ADD(msg, bag, slot, link, count, locked, coolingDown)
end

function InventoryView:ITEM_SLOT_REMOVE(msg, bag, slot)
end

function InventoryView:ITEM_SLOT_UPDATE(msg, bag, slot, link, count, locked, coolingDown)
end

function InventoryView:ITEM_SLOT_UPDATE_COOLDOWN(msg, bag, slot, coolingDown)
end

function InventoryView:BANK_OPENED()
end

function InventoryView:BANK_CLOSED()
end