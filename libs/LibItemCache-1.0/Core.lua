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

local Lib = LibStub:NewLibrary('LibItemCache-1.0', 11)
if not Lib then
	return
end

local PetLinkFormat = '|c%s|Hbattlepet:%s|h[%s]|h|r'
local PetDataFormat = '^' .. strrep('%d+:', 6) .. '%d+$'

local Cache = function(method, ...)
	if Lib.Cache[method] then
		return Lib.Cache[method](Lib.Cache, ...)
	end
end


--[[ Startup ]]--

LibStub('AceEvent-3.0'):Embed(Lib)
Lib:RegisterEvent('BANKFRAME_OPENED', function() Lib.atBank = true end)
Lib:RegisterEvent('BANKFRAME_CLOSED', function() Lib.atBank = nil end)
Lib:RegisterEvent('VOID_STORAGE_OPEN', function() Lib.atVault = true end)
Lib:RegisterEvent('VOID_STORAGE_CLOSE', function() Lib.atVault = nil end)

Lib.PLAYER = UnitName('player')
Lib.REALM = GetRealmName()
Lib.Cache = {}


--[[ Bags ]]--

function Lib:GetBagInfo (player, bag)
	local isCached, isBank = self:GetBagType(player, bag)

 	if bag ~= BACKPACK_CONTAINER and bag ~= BANK_CONTAINER then
		local slot = ContainerIDToInventoryID(bag)

   		if isCached then
			local data, size = Cache('GetBag', player or self.PLAYER, bag, slot, isBank)
			local icon, link = self:ProcessLink(data)
			
			return link, 0, icon, slot, tonumber(size) or 0, true
		else
			local link = GetInventoryItemLink('player', slot)
			local count = GetInventoryItemCount('player', slot)
			local icon = GetInventoryItemTexture('player', slot)

			return link, count, icon, slot, GetContainerNumSlots(bag)
		end
	end

	return nil, 0, nil, nil, GetContainerNumSlots(bag), isCached
end

function Lib:GetBagType(player, bag)
	local isVault = bag == 'vault'
	local isBank = not isVault and (bag == BANK_CONTAINER or bag > NUM_BAG_SLOTS)

	local isCached = self:IsPlayerCached(player) or (isBank and not self.atBank) or (isVault and not self.atVault)
	return isCached, isBank, isVault
end


--[[ Items ]]--

function Lib:GetItemInfo (player, bag, slot)
	local isCached, isBank, isVault = self:GetBagType(player, bag)

	if isCached then
		local data, count = Cache('GetItem', player, bag, slot, isBank, isVault)
		local icon, link, quality = self:ProcessLink(data)
		
		if isVault then
			return link, icon, nil, nil, nil, true
		else
			return icon, tonumber(count) or 1, nil, quality, nil, nil, link, true
		end
		
	elseif isVault then
		return GetVoidItemInfo(slot)
	else
		local icon, count, locked, quality, readable, lootable, link = GetContainerItemInfo(bag, slot)
		if link and quality < 0 then
			quality = select(3, GetItemInfo(link)) 
		end
	
		return icon, count, locked, quality, readable, lootable, link
	end
end

function Lib:GetItemCounts (player, id)
	if self:IsPlayerCached(player) then
		return Cache('GetItemCounts', player, id)
	else
		local vault = select(4, Cache('GetItemCounts', player, id))
		local id, equip = tonumber(id), 0
		local total = GetItemCount(id, true)
		local bags = GetItemCount(id)

		for i = 1, INVSLOT_LAST_EQUIPPED do
			if GetInventoryItemID('player', i) == id then
				equip = equip + 1
			end
		end

		return equip, bags - equip, total - bags, vault or 0
	end
end


--[[ Links ]]--

function Lib:ProcessLink (link)
	if not link then
		return
	end
	
	if link:find(PetDataFormat) then
		return self:ProcessPetLink(link)
	else
		return self:ProcessItemLink('item:' .. link)
	end
end

function Lib:ProcessPetLink (partial)
	local id, _, quality = strsplit(':', partial)
	local name, icon = C_PetJournal.GetPetInfoBySpeciesID(id)
	
	local color = select(4, GetItemQualityColor(quality))
	local link = PetLinkFormat:format(color, partial, name)
	
	return icon, link, tonumber(quality)
end

function Lib:ProcessItemLink (partial)
	local _, link, quality = GetItemInfo(partial)
	return GetItemIcon(partial), link, quality
end


--[[ Money ]]--

function Lib:GetMoney (player)
	if self:IsPlayerCached(player) then
		return Cache('GetMoney', player) or 0, true
	else
		return GetMoney() or 0
	end
end


--[[ Players ]]--

function Lib:GetPlayerInfo (player)
	if self:IsPlayerCached(player) then
		return Cache('GetPlayer', player)
	else
		local _,class = UnitClass('player')
		local _,race = UnitRace('player')
		local sex = UnitSex('player')
		
		return class, race, sex
	end
end

function Lib:IsPlayerCached (player)
	return player and player ~= self.PLAYER
end

function Lib:IteratePlayers ()
	if not self.players then
		self.players = {}

		local list = Cache('GetPlayers')
		if list then
			for player in pairs(list) do
				tinsert(self.players, player)
			end

			sort(self.players)
		end
	end

	return pairs(self.players)
end

function Lib:DeletePlayer (player)
	Cache('DeletePlayer', player)
	self.players = nil
end


--[[ Caches ]]--

function Lib:NewCache()
	self.NewCache = nil
	return self.Cache, self.REALM
end

function Lib:HasCache()
	return not self.NewCache
end