--[[
		Generic methods for accessing player bag slot information
--]]

local AddonName, Addon = ...
local BagInfo = Addon:NewModule('BagInfo')
local Cache = LibStub('LibItemCache-1.0')


--[[ Bag Slot Type ]]--

--returns true if the given slot is the backpack
function BagInfo:IsBackpack(slot)
	return slot == BACKPACK_CONTAINER
end

--returns true if the given bagSlot is an optional inventory bag slot
function BagInfo:IsBackpackBag(bagSlot)
  return bagSlot > 0 and bagSlot < (NUM_BAG_SLOTS + 1)
end

--returns true if the given slot is the bank container slot
function BagInfo:IsBank(slot)
  return slot == BANK_CONTAINER
end

--returns true if the given slot is an optional bank slot
function BagInfo:IsBankBag(slot)
  return slot > NUM_BAG_SLOTS and slot < (NUM_BAG_SLOTS + NUM_BANKBAGSLOTS + 1)
end


--[[ Bag State ]]--

--returns link, count, icon, slot, size, cached
function BagInfo:GetInfo(...)
  return Cache:GetBagInfo(...)
end

function BagInfo:IsPurchasable(player, bag)
	return not self:IsCached(player, bag) and (bag - NUM_BAG_SLOTS) > GetNumBankSlots()
end

function BagInfo:IsLocked(player, bag)
	if not self:IsBackpack(bag) and not self:IsBank(bag) then
    	local slot, size, cached = select(4, self:GetInfo(player, bag))
		return not cached and IsInventoryItemLocked(slot)
	end
end

function BagInfo:IsCached(...)
  return select(6, self:GetInfo(...))
end

function BagInfo:GetSize(...)
  return select(5, self:GetInfo(...))
end

function BagInfo:ToInventorySlot(...)
  return select(4, self:GetInfo(...))
end


--[[ Bag Type ]]--

do
	Addon.TRADE_TYPE = 0
	Addon.BAG_TYPES = {
		[0x0008] = 'leather',
		[0x0010] = 'inscri',
		[0x0020] = 'herb',
		[0x0040] = 'enchant',
		[0x0080] = 'engineer',
		[0x0200] = 'gem',
		[0x0400] = 'mine',
	 	[0x8000] = 'tackle'
	}

	for v in ipairs(Addon.BAG_TYPES) do
		Addon.TRADE_TYPE = Addon.TRADE_TYPE + v
	end
end

function BagInfo:IsTradeBag(...)
	return bit.band(self:GetFamily(...), Addon.TRADE_TYPE) > 0
end

function BagInfo:GetType(...)
	return Addon.BAG_TYPES[self:GetFamily(...)] or 'normal'
end

function BagInfo:GetFamily(player, bag)
	if self:IsBank(bag) or self:IsBackpack(bag) then
		return 0
	end
	
	local link = self:GetInfo(player, bag)
	if link then
		return GetItemFamily(link)
	end
end