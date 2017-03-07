--[[
	frame.lua
		A combuctor frame object
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Frame = Addon.Frame


--[[ Constructor ]]--

function Frame:New(id)
	local f = self:Bind(CreateFrame('Frame', ADDON .. 'Frame' .. id, UIParent, ADDON .. 'FrameTemplate'))
	f.profile = Addon.profile[id]
	f.frameID = id

	f.sortButton = Addon.SortButton:New(f)
	f.sortButton:SetPoint('LEFT', f.searchBox, 'RIGHT', 9, -1)

	f.bagToggle = Addon.BagToggle:New(f)
	f.bagToggle:SetPoint('LEFT', f.sortButton, 'RIGHT', 7, 0)

	f.moneyFrame = Addon.MoneyFrame:New(f)
	f.moneyFrame:SetPoint('BOTTOMRIGHT', -8, 4)

	f.qualityFilter = Addon.QualityFilter:New(f)
	f.qualityFilter:SetPoint('BOTTOMLEFT', 10, 4)

	f.sideFilter = Addon.SideFilter:New(f)
	f.bottomFilter = Addon.BottomFilter:New(f)
	f.bottomFilter:SetPoint('TOPLEFT', f, 'BOTTOMLEFT')

	f.bagFrame = Addon.BagFrame:New(f, 'TOP', 0, -36)
	f.bagFrame:SetPoint('TOPRIGHT', -12, -66)

	f.itemFrame = Addon.ItemFrame:New(f, self.Bags)
	f.itemFrame:SetPoint('TOPLEFT', 12, -66)

	f:Hide()
	f:SetMinResize(300, 300)
	f:SetSize(f.profile.width, f.profile.height)

	f:SetScript('OnShow', self.OnShow)
	f:SetScript('OnHide', self.OnHide)
	f:SetScript('OnSizeChanged', self.OnSizeChanged)

	tinsert(UISpecialFrames, f:GetName())
	return f
end

function Frame:RegisterMessages()
	self:RegisterMessage('UPDATE_ALL', 'Update')
	self:RegisterMessage('SEARCH_CHANGED', 'UpdateSearch')
	self:RegisterFrameMessage('PLAYER_CHANGED', 'UpdateTitle')
	self:RegisterFrameMessage('BAG_FRAME_TOGGLED', 'UpdateItems')
	self:Update()
end


--[[ Frame Events ]]--

function Frame:OnSizeChanged()
	self.profile.width = self:GetWidth()
	self.profile.height = self:GetHeight()
	self:UpdateItems()
end

function Frame:OnSearchTextChanged(text)
	if text ~= Addon.search then
		Addon.search = text
		Addon:SendMessage('SEARCH_CHANGED', text)
	end
end


--[[ Update ]]--

function Frame:Update()
	self:UpdateTitle()
	self:UpdateSettings()
	self:UpdateSideFilter()
end

function Frame:UpdateTitle()
	self.titleText:SetFormattedText(self.Title, self:GetPlayer())
	self.titleText:SetWidth(self.titleText:GetTextWidth())
end

function Frame:UpdateItems()
	self.itemFrame:RequestLayout()
end

function Frame:UpdateSideFilter()
	self.sideFilter:ClearAllPoints()

	if self.profile.reversedTabs then
 		self.sideFilter:SetPoint('TOPRIGHT', self, 'TOPLEFT', 0, -40)
	else
 		self.sideFilter:SetPoint('TOPLEFT', self, 'TOPRIGHT')
	end
end

function Frame:UpdateSearch()
	if Addon.search ~= self.searchBox:GetText() then
		self.searchBox:SetText(Addon.search or '')
	end
end