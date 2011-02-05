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
	if module and not silent then
		error(string.format('Could not find module \'%s\'', name), 2)
	end
	
	return modules[name]
end

Addon.NewModule = function(self, name)
	if modules[name] then
		error(string.format('Module \'%s\' already exists', name), 2)
	end
	
	local module = {}
	modules[name] = module
	return module
end

Addon.IterateModules = function()
	return pairs(modules)
end

setmetatable(Addon, { __call = Addon.GetModule })