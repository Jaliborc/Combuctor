--[[
	item.lua
		Generic methods for accessing item slot information
--]]

local AddonName, Addon = ...
local ItemInfo = Addon:NewModule('ItemInfo')
local Cache = LibStub('LibItemCache-1.0')

function ItemInfo:GetInfo(...)
	return Cache:GetItemInfo(...)
end

function ItemInfo:IsLocked(...)
  return select(3, self:GetInfo(...))
end

function ItemInfo:IsCached(...)
	return select(8, self:GetInfo(...))
end