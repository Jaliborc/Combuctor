--[[
Copyright 2011-2012 João Cardoso
LibItemCache is distributed under the terms of the GNU General Public License (or the Lesser GPL).
This file is part of LibItemCache.

LibItemCache is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

LibItemCache is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with LibItemCache. If not, see <http://www.gnu.org/licenses/>.
--]]

local Lib = LibStub('LibItemCache-1.0')
if not BagBrother or Lib:HasCache() then
  return
end

local Cache, Realm = Lib:NewCache()
local Realm = BrotherBags[Realm]


--[[ Items ]]--

function Cache:GetBag (player, _, slot)
  local bag = Realm[player].equip[slot]
  if bag then
    return strsplit(';', bag)
  end
end

function Cache:GetItem (player, bag, slot)
  local bag = Realm[player][bag]
  local item = bag and bag[slot]
  if item then
    local link, count = strsplit(';', item)
    return 'item:' .. link, count
  end
end

function Cache:GetMoney (player)
  return Realm[player].money
end


--[[ Item Counts ]]--

function Cache:GetItemCounts (player, id)
	local bags = 0
	for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		bags = bags + self:GetItemCount(player, i, id)
	end
	
	local bank = 0
	for i = 1 + NUM_BAG_SLOTS, NUM_BANKBAGSLOTS + NUM_BAG_SLOTS do
      bank = bank + self:GetItemCount(player, i, id)
    end
	
	return self:GetItemCount(player, 'equip', id, true), bags, bank + self:GetItemCount(player, BANK_CONTAINER, id)
end

function Cache:GetItemCount (player, bag, id, unique)
	local bag = Realm[player][bag]
	local i = 0
	
	if bag then
	  for _,item in pairs(bag) do
	    if item:match('^(%d+)') == id then
			if not unique then
		  		i = i + tonumber(item:match(';(%d+)$') or 1)
			else
				i = i + 1
			end
		end
	  end
	end
	
	return i
end


--[[ Players ]]--

function Cache:GetPlayer (player)
  player = Realm[player]
  return player.class, player.race, player.sex
end

function Cache:DeletePlayer (player)
  Realm[player] = nil
end

function Cache:GetPlayers ()
  return Realm
end