--[[
Copyright 2011-2013 João Cardoso
LibItemCache is distributed under the terms of the GNU General Public License.
You can redistribute it and/or modify it under the terms of the license as
published by the Free Software Foundation.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this library. If not, see <http://www.gnu.org/licenses/>.

This file is part of LibItemCache.
--]]

local Lib = LibStub('LibItemCache-1.0')
if not BagBrother or Lib:HasCache() then
	return
end

local Cache = Lib:NewCache()
Cache.Realm = BagBrother.Realm

local Bank = BANK_CONTAINER
local Backpack = BACKPACK_CONTAINER
local LastBagSlot = NUM_BAG_SLOTS

local LastBankSlot = LastBagSlot + NUM_BANKBAGSLOTS
local FirstBankSlot = LastBagSlot + 1

local ItemCount = ';(%d+)$'
local ItemID = '^(%d+)'


--[[ Items ]]--

function Cache:GetBag (player, _, slot)
	local bag = self.Realm[player].equip[slot]
	if bag then
		return strsplit(';', bag)
	end
end

function Cache:GetItem (player, bag, slot)
	local bag = self.Realm[player][bag]
	local item = bag and bag[slot]
	
	if item then
		return strsplit(';', item)
	end
end

function Cache:GetMoney (player)
	return self.Realm[player].money
end


--[[ Item Counts ]]--

function Cache:GetItemCounts (player, id)
	local equipment = self:GetItemCount(player, 'equip', id, true)
	local vault = self:GetItemCount(player, 'vault', id, true)
	local bank = self:GetItemCount(player, Bank, id)
	local bags = 0
	
	for i = Backpack, LastBagSlot do
		bags = bags + self:GetItemCount(player, i, id)
	end
	
	for i = FirstBankSlot, LastBankSlot do
		bank = bank + self:GetItemCount(player, i, id)
    end
	
	return equipment, bags, bank, vault
end

function Cache:GetItemCount (player, bag, id, unique)
	local bag = self.Realm[player][bag]
	local i = 0
	
	if bag then
		for _,item in pairs(bag) do
			if strmatch(item, ItemID) == id then
				if not unique then
					i = i + tonumber(strmatch(item, ItemCount) or 1)
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
	player = self.Realm[player]
	return player.class, player.race, player.sex
end

function Cache:DeletePlayer (player)
	self.Realm[player] = nil
end

function Cache:GetPlayers ()
	return self.Realm
end