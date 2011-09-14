--[[
	Envoy
		A simple message passing object.
--]]

local AddonName, Addon = ...
local Envoy = Addon:NewModule('Envoy')


local assert = function(condition, msg)
	if not condition then
		return error(msg, 3)
	end
end

--ye old constructor
local Envoy_MT = {__index = Envoy}

function Envoy:New(obj)
	local o = setmetatable(obj or {}, Envoy_MT)
	o.listeners = {}
	return o
end


--trigger a message, with the given args
function Envoy:Send(msg, ...)
	assert(msg, 'Usage: Envoy:Send(msg[, args])')
	assert(type(msg) == 'string', 'String expected for <msg>, got: \'' .. type(msg) .. '\'')

	local listeners = self.listeners[msg]
	if listeners then
		for obj, action in pairs(listeners) do
			action(obj, msg, ...)
		end
	end
end


--tells obj to do something when msg happens
function Envoy:Register(obj, msg, method)
	assert(obj and msg, 'Usage: Envoy:Register(obj, msg[, method])')
	assert(type(msg) == 'string', 'String expected for <msg>, got: \'' .. type(msg) .. '\'')

	local method = method or msg
	local action

	if type(method) == 'string' then
		assert(obj[method] and type(obj[method]) == 'function', 'Object does not have an instance of ' .. method)
		action = obj[method]
	else
		assert(type(method) == 'function', 'String or function expected for <method>, got: \'' .. type(method) .. '\'')
		action = method
	end

	local listeners = self.listeners[msg] or {}
	listeners[obj] = action
	self.listeners[msg] = listeners

--	assert(self.listeners[msg] and self.listeners[msg][obj], 'Envoy: Failed to register ' .. msg)
end

function Envoy:RegisterMany(obj, ...)
	assert(obj and select('#', ...) > 0, 'Usage: Envoy:RegisterMany(obj, msg, [...])')
	for i = 1, select('#', ...) do
		self:Register(obj, (select(i, ...)))
	end
end


--tells obj to do nothing when msg happens
function Envoy:Unregister(obj, msg)
	assert(obj and msg, 'Usage: Envoy:Unregister(obj, msg)')
	assert(type(msg) == 'string', 'String expected for <msg>, got: \'' .. type(msg) .. '\'')

	local listeners = self.listeners[msg]
	if listeners then
		listeners[obj] = nil
		if not next(listeners) then
			self.listeners[msg] = nil
		end
	end

--	assert(not(self.listeners[msg] and self.listeners[msg][obj]), 'Envoy: Failed to ignore ' .. msg)
end


--ignore all messages for obj
function Envoy:UnregisterAll(obj)
	assert(obj, 'Usage: Envoy:UnregisterAll(obj)')

	for msg in pairs(self.listeners) do
		self:Ignore(obj, msg)
	end
end