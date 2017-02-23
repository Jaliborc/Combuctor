--[[
	filters.lua
		Methods for registering and acessing item filters.
		See ??? for details.
--]]


local ADDON, Addon = ...
local Filters = Addon:NewClass('Filters', 'Frame')
Filters.registry = {}


--[[ Public API ]]--

function Filters:New(id, name, icon, rule)
	assert(id, 'No unique ID specified for filter')

	local parent, id = self:SplitID(id)
	local registry = self.registry

	if parent then
		parent = self:Get(parent)
		assert(parent, 'Specified parent filter is not know')
		registry = parent.children
	end

	local filter = registry[id] or {children = {}}
	filter.name = name or id
	filter.icon = icon
	filter.rule = rule
	registry[id] = filter

	self:SetScript('OnUpdate', self.BroadcastAddition)
end

function Filters:Get(id)
	local parent, id = self:SplitID(id)
	if parent then
		parent = self:Get(parent)
		return parent and parent.children[id]
	else
		return self.registry[id]
	end
end

function Filters:Iterate()
	return pairs(self.registry)
end


--[[ Additional Methods ]]--

function Filters:SplitID(id)
	local parent, child = id:match('^(.+)/(.-)$')
	if parent then
		return parent, child
	else
		return nil, id
	end
end

function Filters:BroadcastAddition()
	self:SetScript('OnUpdate', nil)
	self:SendMessage('FILTERS_ADDED')
end