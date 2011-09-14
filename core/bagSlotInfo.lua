--[[
		Generic methods for accessing player bag slot information
--]]

local AddonName, Addon = ...
local BagSlotInfo = Addon:NewModule('BagSlotInfo')

--[[ Slot Info ]]--

--returns true if the given bagSlot is a purchasable bank slot
function BagSlotInfo:IsBankBag(bagSlot)
	if not tonumber(bagSlot) then
		error('Usage: BagSlotInfo:IsBankBag(bagSlot)', 2)
	end
	
	return bagSlot > NUM_BAG_SLOTS and bagSlot < (NUM_BAG_SLOTS + NUM_BANKBAGSLOTS + 1)
end

--returns true if the given bagSlot is the bank container slot
function BagSlotInfo:IsBank(bagSlot)
	if not tonumber(bagSlot) then
		error('Usage: BagSlotInfo:IsBank(bagSlot)', 2)
	end
	
	return bagSlot == BANK_CONTAINER
end

--returns true if the given bagSlot is the backpack
function BagSlotInfo:IsBackpack(bagSlot)
	if not tonumber(bagSlot) then
		error('Usage: BagSlotInfo:IsBackpack(bagSlot)', 2)
	end
	
	return bagSlot == BACKPACK_CONTAINER
end

--returns true if the given bagSlot is an optional inventory bag slot
function BagSlotInfo:IsBackpackBag(bagSlot)
	if not tonumber(bagSlot) then
		error('Usage: BagSlotInfo:IsBackpackBag(bagSlot)', 2)
	end
	
	return bagSlot > 0 and bagSlot < (NUM_BAG_SLOTS + 1)
end

--returns true if the given bagSlot for the given player is cached
function BagSlotInfo:IsCached(player, bagSlot)
	if not(type(player) == 'string' and tonumber(bagSlot)) then
		error('Usage: BagSlotInfo:IsCached(\'player\', bagSlot)', 2)
	end
	
	if Addon('PlayerInfo'):IsCached(player) then
		return true
	end

	if self:IsBank(bagSlot) or self:IsBankBag(bagSlot) then
		return not Addon('PlayerInfo'):AtBank()
	end

	return false
end

--returns true if the given bagSlot is purchasable for the given player and false otherwise
function BagSlotInfo:IsPurchasable(player, bagSlot)
	if not(type(player) == 'string' and tonumber(bagSlot)) then
		error('Usage: BagSlotInfo:IsPurchasable(\'player\', bagSlot)', 2)
	end
	
	local purchasedSlots
	if self:IsCached(player, bagSlot) then
		if BagnonDB then
			purchasedSlots = BagnonDB:GetNumBankSlots(player) or 0
		else
			purchasedSlots = 0
		end
	else
		purchasedSlots = GetNumBankSlots()
	end
	return bagSlot > (purchasedSlots + NUM_BAG_SLOTS)
end

function BagSlotInfo:IsLocked(player, bagSlot)
	if not(type(player) == 'string' and tonumber(bagSlot)) then
		error('Usage: BagSlotInfo:IsLocked(\'player\', bagSlot)', 2)
	end
	
	if self:IsBackpack(bagSlot) or self:IsBank(bagSlot) or self:IsCached(player, bagSlot) then
		return false
	end
	return IsInventoryItemLocked(self:ToInventorySlot(bagSlot))
end


--[[ Slot Item Info ]]--

--returns how many items can fit in the given bag
function BagSlotInfo:GetSize(player, bagSlot)
	if not(type(player) == 'string' and tonumber(bagSlot)) then
		error('Usage: BagSlotInfo:GetSize(\'player\', bagSlot)', 2)
	end
	
	local size = 0
	if self:IsCached(player, bagSlot) then
		if BagnonDB then
			size = (BagnonDB:GetBagData(bagSlot, player))
		end
	elseif self:IsBank(bagSlot) then
		size = NUM_BANKGENERIC_SLOTS
	else
		size = GetContainerNumSlots(bagSlot)
	end
	return size or 0
end

--returns the itemLink, number of items in, and item icon texture of the given bagSlot
function BagSlotInfo:GetItemInfo(player, bagSlot)
	if not(type(player) == 'string' and tonumber(bagSlot)) then
		error('Usage: size = BagSlotInfo:GetItemInfo(\'player\', bagSlot)', 2)
	end
	
	local link, texture, count, size
	if self:IsCached(player, bagSlot) then
		if BagnonDB then
			size, link, count, texture = BagnonDB:GetBagData(bagSlot, player)
		end
	else
		local invSlot = self:ToInventorySlot(bagSlot)
		link = GetInventoryItemLink('player', invSlot)
		texture = GetInventoryItemTexture('player', invSlot)
		count = GetInventoryItemCount('player', invSlot)
	end
	return link, count, texture
end


--[[ Slot Type Info ]]--

--[[
	bagType - Bitwise OR of bag type flags: (number, bitfield)
		0x0001 - Quiver
		0x0002 - Ammo Pouch
		0x0004 - Soul Bag
		0x0008 - Leatherworking Bag
		0x0010 - Inscription Bag
		0x0020 - Herb Bag
		0x0040 - Enchanting Bag
		0x0080 - Engineering Bag
		0x0100 - Keyring
		0x0200 - Gem Bag
		0x0400 - Mining Bag
		0x0800 - Unused
		0x1000 - Vanity Pets
		0x8000 - Tackle Box
--]]

-- BAGTYPE_PROFESSION = Leather + Inscription + Herb + Enchanting + Engineering + Gem + Mining + Tackle Box
local BAGTYPE_PROFESSION = 0x0008 + 0x0010 + 0x0020 + 0x0040 + 0x0080 + 0x0200 + 0x0400  + 0x8000 

function BagSlotInfo:GetBagType(player, bagSlot)
	if not(type(player) == 'string' and tonumber(bagSlot)) then
		error('Usage: size = BagSlotInfo:GetBagType(\'player\', bagSlot)', 2)
	end

	if self:IsBank(bagSlot) or self:IsBackpack(bagSlot) then
		return 0
	end
	
	local itemLink = (self:GetItemInfo(player, bagSlot))
	if itemLink then
		return GetItemFamily(itemLink)
	end
	
	return 0
end

function BagSlotInfo:IsTradeBag(player, bagSlot)
	if not(type(player) == 'string' and tonumber(bagSlot)) then
		error('Usage: size = BagSlotInfo:IsTradeBag(\'player\', bagSlot)', 2)
	end
	
	return bit.band(self:GetBagType(player, bagSlot), BAGTYPE_PROFESSION) > 0
end


--[[ Conversion Methods ]]--

--converts the given bag slot into an applicable inventory slot
function BagSlotInfo:ToInventorySlot(bagSlot)
	if not tonumber(bagSlot) then
		error('Usage: BagSlotInfo:ToInventorySlot(bagSlot)', 2)
	end
	
	if self:IsBackpackBag(bagSlot) then
		return ContainerIDToInventoryID(bagSlot)
	end
	
	if self:IsBankBag(bagSlot) then
		return BankButtonIDToInvSlotID(bagSlot, 1)
	end
	
	return nil
end