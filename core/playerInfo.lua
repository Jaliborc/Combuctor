--[[
	player.lua
		Generic methods for accessing player information
--]]

local AddonName, Addon = ...
local PlayerInfo = Addon:NewModule('PlayerInfo')

--constants
local CURRENT_PLAYER = UnitName('player')

function PlayerInfo:IsCached(player)
	if type(player) ~= 'string' then
		error('Usage: PlayerInfo:IsCached(\'player\'', 2)
	end

	return player ~= CURRENT_PLAYER
end

function PlayerInfo:GetMoney(player)
	if type(player) ~= 'string' then
		error('Usage: PlayerInfo:GetMoney(\'player\'', 2)
	end
	
	local money = 0
	if self:IsCached(player) then
		if BagnonDB then
			money = BagnonDB:GetMoney(player)
		end
	else
		money = GetMoney()
	end

	return money
end

function PlayerInfo:AtBank()
	return Addon('InventoryEvents'):AtBank()
end