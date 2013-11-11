--[[
	item.lua
		An item slot button
--]]

local AddonName, Addon = ...
local ItemSlot = Addon:NewClass('ItemSlot', 'Button')

local Unfit = LibStub('Unfit-1.0')
local ItemSearch = LibStub('LibItemSearch-1.2')

local BagInfo = Addon('BagInfo')
local Cache = LibStub('LibItemCache-1.0')


--[[ Constructor ]]--

function ItemSlot:New()
	return self:Restore() or self:Create()
end

function ItemSlot:Set(parent, bag, slot)
	self:SetParent(self:GetDummyBag(parent, bag))
	self:SetID(slot)

	if self:IsVisible() then
		self:Update()
	else
		self:Show()
	end
end

function ItemSlot:Create()
	local id = self:GetNextItemSlotID()
	local item = self:Bind(self:GetBlizzardItemSlot(id) or self:ConstructNewItemSlot(id))
	local name = item:GetName()

	local border = item:CreateTexture(nil, 'OVERLAY')
	border:SetWidth(67)
	border:SetHeight(67)
	border:SetPoint('CENTER', item)
	border:SetTexture([[Interface\Buttons\UI-ActionButton-Border]])
	border:SetBlendMode('ADD')
	border:Hide()

	item.border = border
	item.questBorder = _G[name .. 'IconQuestTexture']
	item.newItemBorder = _G[name .. 'NewItemTexture']
	item.cooldown = _G[name .. 'Cooldown']

	item:SetScript('OnEvent', nil)
	item:SetScript('OnEnter', item.OnEnter)
	item:SetScript('OnLeave', item.OnLeave)
	item:SetScript('OnShow', item.OnShow)
	item:SetScript('OnHide', item.OnHide)
	item:SetScript('PostClick', item.PostClick)
	item.UpdateTooltip = nil

	return item
end

function ItemSlot:ConstructNewItemSlot(id)
	return CreateFrame('Button', ('%sItem%d'):format(AddonName, id), nil, 'ContainerFrameItemButtonTemplate')
end

function ItemSlot:GetBlizzardItemSlot(id)
	--only allow reuse of blizzard frames if all frames are enabled
	if not self:CanReuseBlizzardBagSlots() then
		return nil
	end

	local bag = ceil(id / MAX_CONTAINER_ITEMS)
	local slot = (id-1) % MAX_CONTAINER_ITEMS + 1
	local item = _G[format('ContainerFrame%dItem%d', bag, slot)]

	if item then
		item:SetID(0)
		item:ClearAllPoints()
		return item
	end
end

function ItemSlot:CanReuseBlizzardBagSlots()
	return true
end

function ItemSlot:Restore()
	local item = ItemSlot.unused and next(ItemSlot.unused)
	if item then
		ItemSlot.unused[item] = nil
		return item
	end
end

do
	local id = 1
	function ItemSlot:GetNextItemSlotID()
		local nextID = id
		id = id + 1
		return nextID
	end
end



--[[ Destructor ]]--

function ItemSlot:Free()
	self:Hide()
	self:SetParent(nil)
	self:UnlockHighlight()

	ItemSlot.unused = ItemSlot.unused or {}
	ItemSlot.unused[self] = true
end


--[[ Frame Events ]]--

function ItemSlot:OnShow()
	self:Update()
end

function ItemSlot:OnHide()
	self:HideStackSplitFrame()
end

function ItemSlot:OnDragStart()
	if self:IsCached() and CursorHasItemSlot() then
		ClearCursor()
	end
end

function ItemSlot:OnModifiedClick(button)
	local link = self:IsCached() and self:GetItem()
	if link then
		HandleModifiedItemClick(link)
	end
end

function ItemSlot:OnEnter()
	local dummySlot = self:GetDummyItemSlot()

	if self:IsCached() then
		dummySlot:SetParent(self)
		dummySlot:SetAllPoints(self)
		dummySlot:Show()
	else
		dummySlot:Hide()

		if self:IsBank() then
			if self:GetItem() then
				self:AnchorTooltip()
				GameTooltip:SetInventoryItem('player', BankButtonIDToInvSlotID(self:GetID()))
				GameTooltip:Show()
				CursorUpdate(self)
			end
		else
			ContainerFrameItemButton_OnEnter(self)
		end
	end
end

function ItemSlot:OnLeave()
	GameTooltip:Hide()
	BattlePetTooltip:Hide()
	ResetCursor()
end


--[[ Update Methods ]]--


function ItemSlot:Update()
	if not self:IsVisible() then
		return
	end

	local icon, count, locked, quality, readable, lootable, link = self:GetInfo()
	self:SetItem(link)
	self:SetTexture(icon)
	self:SetCount(count)
	self:SetLocked(locked)
	self:SetReadable(readable)
	self:UpdateCooldown()
	self:UpdateSlotColor()
	self:UpdateBorder()

	if GameTooltip:IsOwned(self) then
		self:UpdateTooltip()
	end
end

--item link
function ItemSlot:SetItem(itemLink)
	self.hasItem = itemLink or nil
end

function ItemSlot:GetItem()
	return self.hasItem
end

--item texture
function ItemSlot:SetTexture(texture)
	SetItemButtonTexture(self, texture or self:GetEmptyItemTexture())
end

function ItemSlot:GetEmptyItemTexture()
	if self:ShowingEmptyItemSlotTexture() then
		return [[Interface\PaperDoll\UI-Backpack-EmptySlot]]
	end
	return nil
end

--item slot color
function ItemSlot:UpdateSlotColor()
	if (not self:GetItem()) and self:ColoringBagSlots() then
		if self:IsTradeBagSlot() then
			local r, g, b = self:GetTradeSlotColor()
			SetItemButtonTextureVertexColor(self, r, g, b)
			self:GetNormalTexture():SetVertexColor(r, g, b)
			return
		end
	end

	SetItemButtonTextureVertexColor(self, 1, 1, 1)
	self:GetNormalTexture():SetVertexColor(1, 1, 1)
end

--item count
function ItemSlot:SetCount(count)
	SetItemButtonCount(self, count)
end

--readable status
function ItemSlot:SetReadable(readable)
	self.readable = readable
end

--locked status
function ItemSlot:SetLocked(locked)
	SetItemButtonDesaturated(self, locked)
end

function ItemSlot:UpdateLocked()
	self:SetLocked(self:IsLocked())
end

--returns true if the slot is locked, and false otherwise
function ItemSlot:IsLocked()
	return select(3, self:GetInfo())
end

--colors the item border
function ItemSlot:UpdateBorder()
	local _,_,_, quality = self:GetInfo()
	local item = self:GetItem()
	self:HideBorder()

	if item then
		if self:IsNew() then
			return self.newItemBorder:Show()
		end

		if self:HighlightQuestItems() then
			local isQuestItem, isQuestStarter = self:IsQuestItem()
			if isQuestItem then
				return self:SetBorderColor(1, .82, .2)
			end

			if isQuestStarter then
				self.questBorder:SetTexture(TEXTURE_ITEM_QUEST_BANG)
				self.questBorder:Show()
				return
			end
		end

		if self:HighlightUnusableItems() and Unfit:IsItemUnusable(item) then
			return self:SetBorderColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		end

		if self:HighlightSetItems() and ItemSearch:InSet(item) then
	   		return self:SetBorderColor(.1, 1, 1)
	  	end
		
		if self:HighlightItemsByQuality() and quality and quality > 1 then
			return self:SetBorderColor(GetItemQualityColor(quality))
		end
	end
end

function ItemSlot:SetBorderColor(r, g, b)
	self.border:SetVertexColor(r, g, b, self:GetHighlightAlpha())
	self.border:Show()
end

function ItemSlot:HideBorder()
	self.newItemBorder:Hide()
	self.questBorder:Hide()
	self.border:Hide()
end

--cooldown
function ItemSlot:UpdateCooldown()
	if self:GetItem() and (not self:IsCached()) then
		ContainerFrame_UpdateCooldown(self:GetBag(), self)
	else
		CooldownFrame_SetTimer(self.cooldown, 0, 0, 0)
		SetItemButtonTextureVertexColor(self, 1, 1, 1)
	end
end

--stack split frame
function ItemSlot:HideStackSplitFrame()
	if self.hasStackSplit and self.hasStackSplit == 1 then
		StackSplitFrame:Hide()
	end
end

--tooltip methods
ItemSlot.UpdateTooltip = ItemSlot.OnEnter

function ItemSlot:AnchorTooltip()
	if self:GetRight() >= (GetScreenWidth() / 2) then
		GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
	else
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	end
end

--highlight
function ItemSlot:Highlight(enable)
	if enable then		
		self:LockHighlight()
	else
		self:UnlockHighlight()
	end
end



--[[ Accessor Methods ]]--

function ItemSlot:GetPlayer()
	local player
	if self:GetParent() then
		local p = self:GetParent():GetParent()
		player = p and p:GetPlayer()
	end
	return player or UnitName('player')
end

function ItemSlot:GetBag()
	return self:GetParent() and self:GetParent():GetID() or -1
end

function ItemSlot:IsSlot(bag, slot)
	return self:GetBag() == bag and self:GetID() == slot
end

function ItemSlot:IsCached()
	return select(8, self:GetInfo())
end

function ItemSlot:IsBank()
	return BagInfo:IsBank(self:GetBag())
end

function ItemSlot:GetInfo()
	return Cache:GetItemInfo(self:GetPlayer(), self:GetBag(), self:GetID())
end


--[[ Item Type Highlight ]]--

local QUEST_ITEM_SEARCH = string.format('t:%s|%s', select(10, GetAuctionItemClasses()), 'quest')
function ItemSlot:IsQuestItem()
	local item = self:GetItem()
	if not item then
		return false, false
	end

	if self:IsCached() then
		return ItemSearch:Matches(item, QUEST_ITEM_SEARCH), false
	else
		local isQuestItem, questID, isActive = GetContainerItemQuestInfo(self:GetBag(), self:GetID())
		return isQuestItem, (questID and not isActive)
	end
end

function ItemSlot:IsTradeBagSlot()
	return BagInfo:IsTradeBag(self:GetPlayer(), self:GetBag())
end

function ItemSlot:IsNew()
	local bag, slot = self:GetBag(), self:GetID()
	return C_NewItems.IsNewItem(bag, slot) and IsBattlePayItem(bag, slot)
end


--[[ Options ]]--

function ItemSlot:HighlightItemsByQuality()
	return not Addon:GetSetting('disableItemsByQuality')
end

function ItemSlot:HighlightQuestItems()
	return not Addon:GetSetting('disableQuestItems')
end

function ItemSlot:HighlightUnusableItems()
	return not Addon:GetSetting('disableUnusableItems')
end

function ItemSlot:HighlightSetItems()
	return not Addon:GetSetting('disableSetItems')
end

function ItemSlot:GetHighlightAlpha()
	return 0.5
end

function ItemSlot:GetTradeSlotColor()	
	return 0.5, 1, 0.5
end

function ItemSlot:ColoringBagSlots()
	return true
end

function ItemSlot:ShowingEmptyItemSlotTexture()
	return true
end


--[[ Delicious Hacks ]]--

-- dummy slot - A hack, used to provide a tooltip for cached items without tainting other item code
function ItemSlot:GetDummyItemSlot()
	ItemSlot.dummySlot = ItemSlot.dummySlot or ItemSlot:CreateDummyItemSlot()
	return ItemSlot.dummySlot
end

function ItemSlot:CreateDummyItemSlot()
	local slot = CreateFrame('Button')
	slot:RegisterForClicks('anyUp')
	slot:SetToplevel(true)
	slot:Hide()

	local function Slot_OnEnter(self)
		local parent = self:GetParent()
		local item = parent:IsCached() and parent:GetItem()
		
		if item then
			parent.AnchorTooltip(self)
			
			if item:find('battlepet:') then
				local _, specie, level, quality, health, power, speed = strsplit(':', item)
				local name = item:match('%[(.-)%]')
				
				BattlePetToolTip_Show(
					tonumber(specie), level, tonumber(quality), health, power, speed, name)
			else
				GameTooltip:SetHyperlink(item)
				GameTooltip:Show()
			end
		end
		
		parent:LockHighlight()
	end

	local function Slot_OnLeave(self)
		self:GetParent():OnLeave()
		self:Hide()
	end

	local function Slot_OnHide(self)
		local parent = self:GetParent()
		if parent then
			parent:UnlockHighlight()
		end
	end

	local function Slot_OnClick(self, button)
		self:GetParent():OnModifiedClick(button)
	end

	slot.UpdateTooltip = Slot_OnEnter
	slot:SetScript('OnClick', Slot_OnClick)
	slot:SetScript('OnEnter', Slot_OnEnter)
	slot:SetScript('OnLeave', Slot_OnLeave)
	slot:SetScript('OnShow', Slot_OnEnter)
	slot:SetScript('OnHide', Slot_OnHide)

	return slot
end


--dummy bag, a hack to enforce the internal blizzard rule that item:GetParent():GetID() == bagID
function ItemSlot:GetDummyBag(parent, bag)
	local dummyBags = parent.dummyBags

	--metatable magic to create a new frame on demand
	if not dummyBags then
		dummyBags = setmetatable({}, {
			__index = function(t, k)
				local f = CreateFrame('Frame', nil, parent)
				f:SetID(k)
				t[k] = f
				return f
			end
		})
		parent.dummyBags = dummyBags
	end

	return dummyBags[bag]
end