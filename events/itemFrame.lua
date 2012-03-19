--[[
	itemFrameEvents.lua
		A single event handler for the itemFrame object
--]]

local AddonName, Addon = ...
local FrameEvents = Addon:NewModule('ItemFrameEvents')
local frames = {}


--[[ Events ]]--

function FrameEvents:GET_ITEM_INFO_RECEIVED()
	self:UpdateCached()
end

function FrameEvents:ITEM_LOCK_CHANGED(msg, ...)
	self:UpdateSlotLock(...)
end

function FrameEvents:UNIT_QUEST_LOG_CHANGED(msg, ...)
	self:UpdateBorder(...)
end

function FrameEvents:QUEST_ACCEPTED(msg, ...)
	self:UpdateBorder(...)
end

function FrameEvents:ITEM_SLOT_ADD(msg, ...)
	self:UpdateSlot(...)
end

function FrameEvents:ITEM_SLOT_REMOVE(msg, ...)
	self:RemoveItem(...)
end

function FrameEvents:ITEM_SLOT_UPDATE(msg, ...)
	self:UpdateSlot(...)
end

function FrameEvents:ITEM_SLOT_UPDATE_COOLDOWN(msg, ...)
	self:UpdateSlotCooldown(...)
end

function FrameEvents:BANK_OPENED(msg, ...)
	self:UpdateBankFrames(...)
end

function FrameEvents:BANK_CLOSED(msg, ...)
	self:UpdateBankFrames(...)
end

function FrameEvents:BAG_UPDATE_TYPE(msg, ...)
	self:UpdateSlotColor(...)
end

--[[ Update Methods ]]--

function FrameEvents:UpdateCached()
	for f in self:GetFrames() do
		f:Regenerate()
	end
end

function FrameEvents:UpdateBorder(...)
	for f in self:GetFrames() do
		if f:GetPlayer() == UnitName('player') then
			f:UpdateBorder(...)
		end
	end
end

function FrameEvents:UpdateSlotColor(...)
	for f in self:GetFrames() do
		if f:GetPlayer() == UnitName('player') then
			f:UpdateSlotColor(...)
		end
	end
end

function FrameEvents:UpdateSlot(...)
	for f in self:GetFrames() do
		if f:GetPlayer() == UnitName('player') then
			if f:UpdateSlot(...) then
				f:RequestLayout()
			end
		end
	end
end

function FrameEvents:RemoveItem(...)
	for f in self:GetFrames() do
		if f:GetPlayer() == UnitName('player') then
			if f:RemoveItem(...) then
				f:RequestLayout()
			end
		end
	end
end

function FrameEvents:UpdateSlotLock(...)
	for f in self:GetFrames() do
		if f:GetPlayer() == UnitName('player') then
			f:UpdateSlotLock(...)
		end
	end
end

function FrameEvents:UpdateSlotCooldown(...)
	for f in self:GetFrames() do
		if f:GetPlayer() == UnitName('player') then
			f:UpdateSlotCooldown(...)
		end
	end
end

function FrameEvents:UpdateBankFrames()
	for f in self:GetFrames() do
		f:Regenerate()
	end
end

function FrameEvents:LayoutFrames()
	for f in self:GetFrames() do
		if f.needsLayout then
			f.needsLayout = nil
			f:Layout()
		end
	end
	
	self.Updater:Hide()
end

function FrameEvents:RequestLayout()
	self.Updater:Show()
end

function FrameEvents:GetFrames()
	return pairs(frames)
end

function FrameEvents:Register(f)
	frames[f] = true
end

function FrameEvents:Unregister(f)
	frames[f] = nil
end


--[[ Initialization ]]--

do
	local f = CreateFrame('Frame')
	f:RegisterEvent('GET_ITEM_INFO_RECEIVED')
	f:RegisterEvent('UNIT_QUEST_LOG_CHANGED')
	f:RegisterEvent('QUEST_ACCEPTED')
	f:RegisterEvent('QUEST_ACCEPTED')
	f:Hide()
	
	f:SetScript('OnEvent', function(self, event, ...)
		local method = FrameEvents[event]
		if method then
			method(FrameEvents, event, ...)
		end
	end)
	
	f:SetScript('OnUpdate', function(self, elapsed)
		FrameEvents:LayoutFrames()
	end)
	
	local Events = Addon('InventoryEvents')
	Events.Register(FrameEvents, 'ITEM_SLOT_ADD')
	Events.Register(FrameEvents, 'ITEM_SLOT_REMOVE')
	Events.Register(FrameEvents, 'ITEM_SLOT_UPDATE')
	Events.Register(FrameEvents, 'ITEM_SLOT_UPDATE_COOLDOWN')
	Events.Register(FrameEvents, 'BANK_OPENED')
	Events.Register(FrameEvents, 'BANK_CLOSED')
	Events.Register(FrameEvents, 'BAG_UPDATE_TYPE')
	
	FrameEvents.Updater = f
end