--[[
	Combuctor Set API
--]]

local ADDON, Addon = ...
local Sets = Addon:NewModule('Sets')
local sets = {}

Sets.Send = LibStub('CallbackHandler-1.0'):New(Sets, 'RegisterMessage', 'UnregisterMessage', 'UnregisterAllMessages').Fire

--[[
	true | false = setRule(player, bagType, name, link, quality, level, ilvl, type, subType, stackCount, equipLoc)

	A setRule is passed both the bag slot info information for a bag where an item is stored, along with all return values from GetItemInfo for an item in the slot we're looking at
	The function should return either true (the slot is in the set defined by this rule), or false (the slot is not)
--]]

--[[
	Sets:Register('name', 'icon' [, setRule])

	registers a new rule function with combuctor
	will rewrite if rule exists already for a given name/parent (which in this case is null)
	calls <setRule> to test if a rule is in the set or not
	
	if <setRule> is nil, then the set is assume to be all items
--]]


function Sets:Register(name, icon, rule)
	assert(name, 'Set must include a name')
	assert(icon, format('No icon specified for set \'%s\'', icon))
	
	local set = self:Get(name)
	if set then
		if not(set.icon == icon and set.rule == rule) then
			set.icon = icon
			set.rule = rule
			self:Send('COMBUCTOR_SET_UPDATE', name, icon, rule)
		end
	else
		tinsert(sets, {['name'] = name, ['icon'] = icon, ['rule'] = rule})
		self:Send('COMBUCTOR_SET_ADD', name, icon, rule)
	end
end


--[[
	Sets:RegisterSubSet('name', 'parent' [, 'icon'] [, setRule])

	registers a new subrule function with combuctor
	will blow up if a rule named 'parent' cannot be found
	will not allow subsets of subsets

	filter function will be tested after the parent filter function is tested (ie, inSet == parentRule(...) and setRule(...))
	if a filter function is not specified, then it is assumed the subset contains all items of the parent set
--]]

function Sets:RegisterSubSet(name, parent, icon, rule)
	assert(name, 'Subset must include a name')
	assert(self:Get(parent), format('Cannot find a parent set named \'%s\'', parent))

	local set = self:Get(name, parent)
	if set then
		if not(set.icon == icon and set.rule == rule) then
			set.icon = icon
			set.rule = rule
			self:Send('COMBUCTOR_SUBSET_UPDATE', name, parent, icon, rule)
		end
	else
		tinsert(sets, {['parent'] = parent, ['name'] = name, ['icon'] = icon, ['rule'] = rule})
		self:Send('COMBUCTOR_SUBSET_ADD', name, parent, icon, rule)
	end
end


--[[
	Sets:Unregister('name' [, 'parent'])

	removes the given set from the database
	in the even that the set has children, those child sets are removed as well
--]]

local function removeSetAndChildren(self, parent)
	local i = 1
	local found = false

	while i <= #sets do
		local set = sets[i]

		if set.parent == parent or (set.parent == nil and set.name == parent) then
			tremove(sets, i)
			found = true
		else
			i = i + 1
		end
	end

	if found then
		self:Send('COMBUCTOR_SET_REMOVE', parent)
	end
end

function Sets:Unregister(name, parent)
	if parent then
		for i,set in pairs(sets) do
			if set.name == name and set.parent == parent then
				tremove(sets, i)
				self:Send('COMBUCTOR_SUBSET_REMOVE', name, parent)
				break
			end
		end
	else
		removeSetAndChildren(self, name)
	end
end

--[[
	set = Sets:Get('name' [, 'parent'])

	Returns a set, if found
--]]

function Sets:Get(name, parent)
	for _,set in pairs(sets) do
		if set.name == name and set.parent == parent then
			return set
		end
	end
end

--[[
	iterator = Sets:GetParentSets()

	returns an iterator of all head sets (sets that are not children)
	example usage:
	for i, set in Sets:GetParentSets() do
		print(set.name, set.icon, set.rule)
	end
--]]

local function parentSetIterator(_, i)
	for j = i + 1, #sets do
		local set = sets[j]
		if set and not set.parent then
			return j, set
		end
	end
end

function Sets:GetParentSets()
	return parentSetIterator, nil, 0
end


--[[
	iterator  = Sets:GetChildSets('parent')

	returns an iterator on all subsets for the given set
	example usage:
	for i, set in Sets:GetChildSets('parentSet') do
		print(set.name, set.icon, set.rule)
	end
--]]

local function getChildSetIterator(parent, i)
	for j = i + 1, #sets do
		local set = sets[j]
		if set and set.parent == parent then
			return j, set
		end
	end
end

function Sets:GetChildSets(parent)
--	assert(self:Get(parent), format('Cannot find a parent set named \'%s\'', parent))
	return getChildSetIterator, parent, 0
end

Sets:Register(ALL, 'Interface/Icons/INV_Misc_EngGizmos_17', function() return true end)