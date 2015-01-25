if not WoWUnit then
	return
end

local Sets = Combuctor:GetModule('Sets')
local Exists, None = WoWUnit.Exists, WoWUnit.IsFalse
local Tests = WoWUnit('Combuctor.Sets')

function Tests:Set()
	Sets:Register('bacon', 'someIcon')
	Exists(Sets:Get('bacon'))

	Sets:Unregister('bacon')
	None(Sets:Get('bacon'))
end

function Tests:Subset()
	Sets:Register('bacon', 'someIcon')
	Sets:RegisterSubSet('cheese', 'bacon', 'someIcon')
	Exists(Sets:Get('cheese', 'bacon'))

	Sets:Unregister('cheese', 'bacon')
	None(Sets:Get('cheese'))

	Sets:Unregister('bacon')
end