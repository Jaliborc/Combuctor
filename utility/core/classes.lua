--[[ 
	LibStubish code to define widget classes
	
	Usage:
		local class = Addon:NewClass('className', 'frameType' [, parentClass])
		local class = Addon['className']
--]]

local AddonName, Addon = ...
local Classy = LibStub('Classy-1.0')

function Addon:NewClass(name, ...)
	local class = Classy:New(...)
	self[name] = class
	return class
end