--[[
	db.lua
		BagnonDB wrapper of BagSync
--]]

if not(BagnonDB) and BagSync then BagnonDB = {} else return end

local CURRENT_REALM = GetRealmName()

local function getBagTag(bagId)
	if bagId == KEYRING_CONTAINER then
		return 'key'
	end
	
	if bagId == BANK_CONTAINER then
		return 'bank'
	end
	
	if (bagId >= NUM_BAG_SLOTS + 1) and (bagId <= NUM_BAG_SLOTS + NUM_BANKBAGSLOTS) then
		return 'bank'
	end
	
	if (bagId >= BACKPACK_CONTAINER) and (bagId <= BACKPACK_CONTAINER + NUM_BAG_SLOTS) then
		return 'bag'
	end
end

local function getItemIndex(bagId, slotId)
	return getBagTag(bagId) .. ':' .. bagId .. ':' .. slotId
end

local function getBagIndex(bagId)
	return 'bd:' .. getBagTag(bagId) .. ':' .. bagId
end

local function playerData(player)
	return BagSyncDB[CURRENT_REALM][player]
end

local function bagData(player, bagId)
	local pd = playerData(player)
	return pd and pd[getBagIndex(bagId)]
end

local function itemData(player, bagId, slotId)
	local pd = playerData(player)
	return pd and pd[getItemIndex(bagId, slotId)]
end

--[[
	Access  Functions
		Bagnon requires all of these functions to be present when attempting to view cached data
--]]

--[[
	BagnonDB:GetPlayerList()
		returns:
			iterator of all players on this realm with data
		usage:
			for playerName, data in BagnonDB:GetPlayers()
--]]
do
	local playerList = nil
	function BagnonDB:GetPlayerList()
		if(not playerList) then
			playerList = {}

			for player in self:GetPlayers() do
				table.insert(playerList, player)
			end

			--sort by currentPlayer first, then alphabetically
			table.sort(playerList, function(a, b)
				if(a == currentPlayer) then
					return true
				elseif(b == currentPlayer) then
					return false
				end
				return a < b
			end)
		end
		return playerList
	end
	
	--removes all saved data about the given player
	function BagnonDB:RemovePlayer(player, realm)
		local rdb = BagSyncDB[realm or CURRENT_REALM]
		if rdb then
			rdb[player] = nil
		end

		if realm == currentRealm and playerList then
			for i, character in pairs(playerList) do
				if character == player then
					table.remove(playerList, i)
					break
				end
			end
		end
	end
end

function BagnonDB:GetPlayers()
	return pairs(BagSyncDB[CURRENT_REALM])
end


--[[
	BagnonDB:GetMoney(player)
		args:
			player (string)
				the name of the player we're looking at.  This is specific to the current realm we're on

		returns:
			(number) How much money, in copper, the given player has
--]]
function BagnonDB:GetMoney(player)
	local pd = playerData(player)
	local c = pd and pd['gold:0:0']
	return c or 0
end



--[[
	BagnonDB:GetNumBankSlots(player)
		args:
			player (string)
				the name of the player we're looking at.  This is specific to the current realm we're on

		returns:
			(number or nil) How many bank slots the current player has purchased
--]]
function BagnonDB:GetNumBankSlots(player)
	return NUM_BANKBAGSLOTS
end


--[[
	BagnonDB:GetBagData(bag, player)
		args:
			player (string)
				the name of the player we're looking at.  This is specific to the current realm we're on
			bag (number)
				the number of the bag we're looking at.

		returns:
			size (number)
				How many items the bag can hold (number)
			hyperlink (string)
				The hyperlink of the bag
			count (number)
				How many items are in the bag.  This is used by ammo and soul shard bags
--]]
function BagnonDB:GetBagData(bagId, player)
	local info = bagData(player, bagId)
	if info then
		local size, link, count = strsplit(',', info)
		local hyperLink = (link and select(2, GetItemInfo(link))) or nil
		return tonumber(size), hyperLink, tonumber(count) or 1, GetItemIcon(link)
	end
end

--[[
	BagnonDB:GetItemData(bag, slot, player)
		args:
			player (string)
				the name of the player we're looking at.  This is specific to the current realm we're on
			bag (number)
				the number of the bag we're looking at.
			itemSlot (number)
				the specific item slot we're looking at

		returns:
			hyperLink (string)
				The hyperLink of the item
			count (number)
				How many of there are of the specific item
			texture (string)
				The filepath of the item's texture
			quality (number)
				The numeric representaiton of the item's quality: from 0 (poor) to 7 (artifcat)
--]]
function BagnonDB:GetItemData(bagId, slotId, player)
	local info = itemData(player, bagId, slotId)
	if info then
		local link, count = strsplit(',', info)
		if link then
			local hyperLink, quality = select(2, GetItemInfo(link))
			return hyperLink, tonumber(count) or 1, GetItemIcon(link), tonumber(quality)
		end
	end
end