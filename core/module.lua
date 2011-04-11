--[[ 
	LibStubish code to define addon modules
	
	Usage:
		local module = Addon('moduleId') or Addon:GetModule('moduleId')
		
		local module = Addon:NewModule('moduleId')
		
		for name, module in Addon:IterateModules() do
			--some sort of things
		end
--]]

local AddonName, Addon = ...
local modules = {}

Addon.GetModule = function(self, name, silent)
	local module = modules[name]
	if not(module or silent) then
		error(('Could not find module \'%s\''):format(name), 2)
	end

	return module
end

Addon.NewModule = function(self, name, obj)
	if modules[name] then
		error(('Module \'%s\' already exists'):format(name), 2)
	end

	local module = obj or {}
	modules[name] = module
	return module
end

Addon.IterateModules = function()
	return pairs(modules)
end

setmetatable(Addon, { __call = Addon.GetModule })