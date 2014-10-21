--[[
	frame.lua
		A combuctor frame object

	Set Events:
		COMBUCTOR_SET_ADD:
			name
				If visible, then update side tabs + highlight

		COMBUCTOR_SET_UPDATE:
			name, icon, rule
				if visible, then update side tabs + highlight
				If we're showing set, then need to update rule

		COMBUCTOR_SUBSET_ADD:
			name, parent, icon, rule
				if visible and we're showing parent set, then update bottom tabs + highlight

		COMBUCTOR_SUBSET_UPDATE:
			name, parent, icon, rule
				if visible and we're showing parent set, then update bottom tabs + highlight
				If on subset, then need to update rule

		COMBUCTOR_SET_REMOVE:
			name
				If visible, then update side tabs + highlight
				If on set, then need to switch to default set

		COMBUCTOR_SUBSET_REMOVE
			name, parent:
				If visible and on parent set, then need to update subsets
				If on subset, then need to switch to default subset

		COMBUCTOR_CONFIG_SET_ADD
		COMBUCTOR_CONFIG_SET_REMOVE
			frameID, name
				If visible, and self.frameID == frameID, then update sets


	User Events:
		User shows frame:
			Show default set + subset
			In the future, should create events (show keys) that map to set + subset

		User clicks on set:
			Switch to set, switch to default subset of that set

		User clicks on subset:
			Switch to given subset
--]]

local ADDON, Addon = ...
local Sets = Addon('Sets')
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Frame = Addon:NewClass('Frame', 'Frame')
Addon.frames = {}

local BASE_WIDTH = 300
local BASE_HEIGHT = 300
local ITEM_FRAME_WIDTH_OFFSET = 278 - BASE_WIDTH
local ITEM_FRAME_HEIGHT_OFFSET = 205 - BASE_HEIGHT


--[[ Constructor ]]--

function Frame:New(titleText, bags, settings, frameID)
	local f = self:Bind(CreateFrame('Frame', 'CombuctorFrame' .. frameID, UIParent, 'CombuctorInventoryTemplate'))
	f:SetScript('OnShow', self.OnShow)
	f:SetScript('OnHide', self.OnHide)

	f.sets = settings
	f.frameID = frameID
	f.titleText = titleText
	f.bags = bags

	f.bagButtons = {}
	f.filter = {quality = 0}

	f:SetWidth(settings.w or BASE_WIDTH)
	f:SetHeight(settings.h or BASE_HEIGHT)

	f.sideFilter = Addon.SideFilter:New(f, f:IsSideFilterOnLeft())
	f.bottomFilter = Addon.BottomFilter:New(f)

	f.qualityFilter = Addon.QualityFilter:New(f)
	f.qualityFilter:SetPoint('BOTTOMLEFT', 10, 4)

	f.itemFrame = Addon.ItemFrame:New(f, bags)
	f.itemFrame:SetPoint('TOPLEFT', 10, -64)

	f.moneyFrame = Addon.MoneyFrame:New(f)
	f.moneyFrame:SetPoint('BOTTOMRIGHT', -8, 8)
	
	--load what the title says
	f:UpdateTitleText()

	--update if bags are shown or not
	f:CreateBags()
	f:UpdateBagToggle()

	--place the frame
	f.sideFilter:UpdateFilters()
	f:LoadPosition()
	f:UpdateClampInsets()

	tinsert(UISpecialFrames, f:GetName())
  	Addon.frames[frameID] = f

	return f
end


--[[ Title Frame ]]--

function Frame:UpdateTitleText()
	self.title:SetFormattedText(self.titleText, self:GetPlayer())
end


--[[ Sort Button ]]--

function Frame:OnSortButtonClick(button)
	if button == 'RightButton' then
		DepositReagentBank()
	else
		SetSortBagsRightToLeft(true)

		if self.frameID == 'bank' then
			SortReagentBankBags()
			SortBankBags()
		else
			SortBags()
		end
	end
end

function Frame:OnSortButtonEnter(button)
	GameTooltip:SetOwner(button)
	GameTooltip:SetText(BAG_CLEANUP_BAGS, 1,1,1)
	GameTooltip:AddLine(L.SortItems)
	GameTooltip:AddLine(L.DepositReagents)
	GameTooltip:Show()
end


--[[ Bag Toggle ]]--

function Frame:OnBagToggleClick(toggle, button)
	if button == 'LeftButton' then
		_G[toggle:GetName() .. 'Icon']:SetTexCoord(0.075, 0.925, 0.075, 0.925)
		self:ToggleBags()
	else
		if self:IsBank() then
			Addon:Toggle(BACKPACK_CONTAINER)
		else
			Addon:Toggle(BANK_CONTAINER)
		end
	end
end

function Frame:OnBagToggleEnter(toggle)
	GameTooltip:SetOwner(toggle, 'ANCHOR_LEFT')
	GameTooltip:SetText(L.Bags, 1, 1, 1)
	GameTooltip:AddLine(L.BagToggle)

	if self:IsBank() then
		GameTooltip:AddLine(L.InventoryToggle)
	else
		GameTooltip:AddLine(L.BankToggle)
	end
	GameTooltip:Show()
end

function Frame:OnPortraitEnter(portrait)
	GameTooltip:SetOwner(portrait, 'ANCHOR_RIGHT')
	GameTooltip:SetText(self:GetPlayer(), 1, 1, 1)
	GameTooltip:AddLine('<Left Click> to switch characters')
	GameTooltip:Show()
end


--[[ Bag Frame ]]--

function Frame:CreateBags()
	for i, slot in ipairs(self.bags) do
		tinsert(self.bagButtons, Addon.Bag:New(self, slot))
	end

	self.bagButtons[1]:SetPoint('TOPRIGHT', -12, -66)
	for i = 2, #self.bagButtons do
		self.bagButtons[i]:SetPoint('TOP', self.bagButtons[i-1], 'BOTTOM', 0, -2)
	end
end

function Frame:ToggleBags()
	self.sets.showBags = not self.sets.showBags
	self:UpdateBagToggle()
end

function Frame:UpdateBagToggle()
	self:UpdateItemFrameSize()
	self:UpdateBags()

	if self.sets.showBags then
		_G[self:GetName() .. 'BagToggle']:LockHighlight()
	else
		_G[self:GetName() .. 'BagToggle']:UnlockHighlight()
	end
end

function Frame:UpdateBags()
	for i, bag in pairs(self.bagButtons) do
		bag:Update()
		bag:SetShown(self.sets.showBags)
	end
end


--[[ Filters ]]--

function Frame:SetFilter(key, value)
	if self.filter[key] ~= value then
		self.filter[key] = value

		self.itemFrame:Regenerate()
		return true
	end
end

function Frame:GetFilter(key)
	return self.filter[key]
end


--[[ Player ]]--

function Frame:SetPlayer(player)
	if self:GetPlayer() ~= player then
		self.player = player

		self:UpdateTitleText()
		self:UpdateBags()
		self:UpdateSets()

		self.itemFrame:SetPlayer(player)
		self.moneyFrame:Update()
	end
end

function Frame:GetPlayer()
	return self.player or UnitName('player')
end


--[[ Sets and Subsets ]]--

function Frame:UpdateSets(category)
	self.sideFilter:UpdateFilters()
	self:SetCategory(category or self:GetCategory())
	self:UpdateSubSets()
end

function Frame:UpdateSubSets(subCategory)
	self.bottomFilter:UpdateFilters()
	self:SetSubCategory(subCategory or self:GetSubCategory())
end

function Frame:HasSet(name)
	for i,setName in self:GetSets() do
		if setName == name then
			return true
		end
	end
	return false
end

function Frame:HasSubSet(name, parent)
	if self:HasSet(parent) then
		local excludeSets = self:GetExcludedSubsets(parent)
		if excludeSets then
			for _,childSet in pairs(excludeSets) do
				if childSet == name then
					return false
				end
			end
		end
		return true
	end
	return false
end

function Frame:GetSets()
	local profile = Addon:GetProfile(self:GetPlayer()) or Addon:GetProfile(UnitName('player'))
	return ipairs(profile[self.frameID].sets)
end

function Frame:GetExcludedSubsets(parent)
	local profile = Addon:GetProfile(self:GetPlayer()) or Addon:GetProfile(UnitName('player'))
	return profile[self.frameID].exclude[parent]
end


--Set
function Frame:SetCategory(name)
	if not(self:HasSet(name) and Sets:Get(name)) then
		name = self:GetDefaultCategory()
	end

	local set = name and Sets:Get(name)
	if self:SetFilter('rule', (set and set.rule) or nil) then
		self.category = name
		self.sideFilter:UpdateHighlight()
		self:UpdateSubSets()
	end
end

function Frame:GetCategory()
	return self.category or self:GetDefaultCategory()
end

function Frame:GetDefaultCategory()
	for _,set in Sets:GetParentSets() do
		if self:HasSet(set.name) then
			return set.name
		end
	end
end


--Subset
function Frame:SetSubCategory(name)
	local parent = self:GetCategory()
	if not(parent and self:HasSubSet(name, parent) and Sets:Get(name, parent)) then
		name = self:GetDefaultSubCategory()
	end

	local set = name and Sets:Get(name, parent)
	if self:SetFilter('subRule', (set and set.rule) or nil) then
		self.subCategory = name
		self.bottomFilter:UpdateHighlight()
	end
end

function Frame:GetSubCategory()
	return self.subCategory or self:GetDefaultSubCategory()
end

function Frame:GetDefaultSubCategory()
	local parent = self:GetCategory()
	if parent then
		for _,set in Sets:GetChildSets(parent) do
			if self:HasSubSet(set.name, parent) then
				return set.name
			end
		end
	end
end


--Quality
function Frame:AddQuality(quality)
	self:SetFilter('quality', self:GetFilter('quality') + quality)
	self.qualityFilter:UpdateHighlight()
end

function Frame:RemoveQuality(quality)
	self:SetFilter('quality', self:GetFilter('quality') - quality)
	self.qualityFilter:UpdateHighlight()
end

function Frame:SetQuality(quality)
	self:SetFilter('quality', quality)
	self.qualityFilter:UpdateHighlight()
end

function Frame:GetQuality()
	return self:GetFilter('quality') or 0
end


--[[ Sizing ]]--

function Frame:OnSizeChanged()
	local w, h = self:GetWidth(), self:GetHeight()
	self.sets.w = w
	self.sets.h = h

	self:UpdateItemFrameSize()
end

function Frame:UpdateItemFrameSize()
	local prevW, prevH = self.itemFrame:GetSize()
	local width = self:GetWidth() + ITEM_FRAME_WIDTH_OFFSET
	local height = self:GetHeight() + ITEM_FRAME_HEIGHT_OFFSET

	if self.sets.showBags then
		width = width - 36
	end

	if prevW ~= width or prevH ~= height then
		self.itemFrame:SetSize(width, height)
		self.itemFrame:RequestLayout()
	end
end

--updates where we can position the frame based on if the side and bottom filters are shown
function Frame:UpdateClampInsets()
	local l, r, b

	if self.bottomFilter:IsShown() then
		b = -32
	else
		b = 0
	end

	if self.sideFilter:IsShown() then
		if self.sideFilter:Reversed() then
			l = -35
			r = 0
		else
			l = -8
			r = 35
		end
	else
		l = -8
		r = 0
	end

	self:SetClampRectInsets(l, r, 12, b)
end


--[[ Positioning ]]--

function Frame:SavePosition(point, parent, relPoint, x, y)
	if point then
		if self.sets.position then
			self.sets.position[1] = point
			self.sets.position[2] = nil
			self.sets.position[3] = relPoint
			self.sets.position[4] = x
			self.sets.position[5] = y
		else
			self.sets.position = {point, nil, relPoint, x, y}
		end
	else
		self.sets.position = nil
	end
	self:LoadPosition()
end

function Frame:LoadPosition()
	if self.sets.position then
		local point, parent, relPoint, x, y = unpack(self.sets.position)
		self:SetPoint(point, self:GetParent(), relPoint, x, y)
		self:SetUserPlaced(true)
	else
		self:SetUserPlaced(nil)
	end
	self:UpdateManagedPosition()
end

function Frame:UpdateManagedPosition()
  local shown = self:IsShown()

	if self.sets.position then
		if self:GetAttribute('UIPanelLayout-enabled') then
      HideUIPanel(self)
      self:SetAttribute('UIPanelLayout-defined', false)
      self:SetAttribute('UIPanelLayout-enabled', false)
      self:SetAttribute('UIPanelLayout-whileDead', false)
      self:SetAttribute('UIPanelLayout-area', nil)
      self:SetAttribute('UIPanelLayout-pushable', nil)
      
      if shown then
		ShowUIPanel(self)
      end
    end
	elseif not self:GetAttribute('UIPanelLayout-enabled') then
		self:SetAttribute('UIPanelLayout-defined', true)
		self:SetAttribute('UIPanelLayout-enabled', true)
		self:SetAttribute('UIPanelLayout-whileDead', true)
		self:SetAttribute('UIPanelLayout-area', 'left')
		self:SetAttribute('UIPanelLayout-pushable', 1)

		if shown then
			HideUIPanel(self)
			ShowUIPanel(self)
		end
	end
end


--[[ Display ]]--

function Frame:OnShow()
	PlaySound('igBackPackOpen')
	Addon('FrameEvents'):Register(self)
	
	self:UpdateSets(self:GetDefaultCategory())
	self:OnSizeChanged()
end

function Frame:OnHide()
	PlaySound('igBackPackClose')
	Addon('FrameEvents'):Unregister(self)

	if self:IsBank() and self:AtBank() then
		CloseBankFrame()
	end

	self:SetPlayer(UnitName('player'))
end

function Frame:ToggleFrame(auto)
	if self:IsShown() then
		self:HideFrame(auto)
	else
		self:ShowFrame(auto)
	end
end

function Frame:ShowFrame(auto)
	if not self:IsShown() then
		ShowUIPanel(self)
		self.autoShown = auto or nil
	end
end

function Frame:HideFrame(auto)
	if self:IsShown() then
		if not auto or self.autoShown then
			HideUIPanel(self)
			self.autoShown = nil
		end
	end
end


--[[ Side Filter Positioning ]]--

function Frame:SetLeftSideFilter(enable)
	self.sets.leftSideFilter = enable and true or nil
	self.sideFilter:SetReversed(enable)
end

function Frame:IsSideFilterOnLeft()
	return self.sets.leftSideFilter
end


--[[ Accessors ]]--

function Frame:IsBank()
	return self.frameID == 'bank'
end

function Frame:AtBank()
	return Addon.BagEvents.atBank
end
