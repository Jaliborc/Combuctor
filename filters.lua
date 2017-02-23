--[[
	sets.lua
		Methods for registering and acessing item sets.
		See ??? for details.
--]]


local ADDON, Addon = ...
local Sets = {}


--[[ Registry ]]--

function Addon:RegisterSet(id, icon, rule)
	assert(id, 'No unique ID specified for set')
	assert(icon, 'No icon specified for set')

	local set = Sets[id] or {children = {}}
	set.icon = icon
	set.rule = rule
	Sets[id] = set

	self:SendMessage('SETS_CHANGED')
end

function Addon:RegisterSubset(id, subid, rule)
	assert(id, 'No set ID specified for subset')
	assert(subid, 'No unique ID specified for subset')
	assert(Sets[id], 'Specified set ID is not registered')

	Sets[id].children[subid] = rule or true
	
	self:SendMessage('SETS_CHANGED')
end

function Addon:UnregisterSet(id, subid)
	assert(id, 'No set ID specified for operation')

	if subid then
		assert(Sets[id], 'Specified set ID is not registered')
		Sets[id].children[subid] = nil
	else
		Sets[id] = nil
	end

	self:SendMessage('SETS_CHANGED')
end


--[[ Queries ]]--

function Addon:GetSet(id, subid)
	local set = id and Sets[id]
	if subid then
		return set and set.children[subid]
	end
	return set
end

function Addon:IterateSets(id)
	if id then
		assert(Sets[id], 'Specified set ID is not registered')
		return pairs(Sets[id].children)
	end
	return pairs(Sets)
end