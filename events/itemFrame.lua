--[[
	itemFrameEvents.lua
		A single event handler for the itemFrame object
--]]

local AddonName, Addon = ...
local FrameEvents = CreateFrame('Frame')
local frames = {}


--[[ Startup ]]--

function FrameEvents:Startup()
	self.QUEST_ACCEPTED = self.UNIT_QUEST_LOG_CHANGED
	self:RegisterEvent('GET_ITEM_INFO_RECEIVED')
	self:RegisterEvent('ITEM_LOCK_CHANGED')
	self:RegisterEvent('UNIT_QUEST_LOG_CHANGED')
	self:RegisterEvent('QUEST_ACCEPTED')
	self:Hide()
	
	self:SetScript('OnEvent', function(self, event, ...)
		local method = self[event]
		if method then
			method(self, ...)
		end
	end)
	
	self:SetScript('OnUpdate', function(self, elapsed)
		self:LayoutFrames()
	end)
	
	local Events = Addon.BagEvents
	Events.Listen(self, 'ITEM_SLOT_ADD', 'ITEM_SLOT_UPDATE')
	Events.Listen(self, 'ITEM_SLOT_UPDATE')
	Events.Listen(self, 'ITEM_SLOT_UPDATE_COOLDOWN')
	Events.Listen(self, 'ITEM_SLOT_REMOVE')

	Events.Listen(self, 'BAG_UPDATE_TYPE')
	Events.Listen(self, 'BANK_OPENED', 'GET_ITEM_INFO_RECEIVED')
	Events.Listen(self, 'BANK_CLOSED', 'GET_ITEM_INFO_RECEIVED')
end


--[[ Events ]]--

function FrameEvents:ITEM_SLOT_UPDATE(event, ...)
	for f in self:GetFrames() do
		if f:GetPlayer() == UnitName('player') then
			if f:UpdateSlot(...) then
				f:RequestLayout()
			end
		end
	end
end

function FrameEvents:ITEM_SLOT_UPDATE_COOLDOWN(event, ...)
	for f in self:GetFrames() do
		if f:GetPlayer() == UnitName('player') then
			f:UpdateSlotCooldown(...)
		end
	end
end

function FrameEvents:ITEM_LOCK_CHANGED(...)
	for f in self:GetFrames() do
		if f:GetPlayer() == UnitName('player') then
			f:UpdateSlotLock(...)
		end
	end
end

function FrameEvents:ITEM_SLOT_REMOVE(event, ...)
	for f in self:GetFrames() do
		if f:GetPlayer() == UnitName('player') then
			if f:RemoveItem(...) then
				f:RequestLayout()
			end
		end
	end
end

function FrameEvents:BAG_UPDATE_TYPE(event, ...)
	for f in self:GetFrames() do
		if f:GetPlayer() == UnitName('player') then
			f:UpdateSlotColor(...)
		end
	end
end

function FrameEvents:UNIT_QUEST_LOG_CHANGED(...)
		for f in self:GetFrames() do
		if f:GetPlayer() == UnitName('player') then
			f:UpdateBorder(...)
		end
	end
end

function FrameEvents:GET_ITEM_INFO_RECEIVED()
	Addon:UpdateFrames()
end


--[[ Registry ]]--

function FrameEvents:LayoutFrames()
	for f in self:GetFrames() do
		if f.needsLayout then
			f.needsLayout = nil
			f:Layout()
		end
	end
	
	self:Hide()
end

function FrameEvents:RequestLayout()
	self:Show()
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

FrameEvents:Startup()
Addon.FrameEvents = FrameEvents