--[[
	frame.lua
		A combuctor frame object
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Frame = Addon:NewClass('Frame', 'Frame')
Frame.OpenSound = 'igBackPackOpen'
Frame.CloseSound = 'igBackPackClose'

local BASE_WIDTH = 300
local BASE_HEIGHT = 300
local ITEM_FRAME_WIDTH_OFFSET = 278 - BASE_WIDTH
local ITEM_FRAME_HEIGHT_OFFSET = 205 - BASE_HEIGHT


--[[ Constructor ]]--

function Frame:New(id)
	local f = self:Bind(CreateFrame('Frame', 'CombuctorFrame' .. id, UIParent, ADDON .. 'FrameTemplate'))
	f.shownCount = 0
	f.frameID = id

	f.sortButton = Addon.SortButton:New(f)
	f.sortButton:SetPoint('LEFT', f.searchBox, 'RIGHT', 9, -1)

	f.bagToggle = Addon.BagToggle:New(f)
	f.bagToggle:SetPoint('LEFT', f.sortButton, 'RIGHT', 7, 0)

	f.moneyFrame = Addon.MoneyFrame:New(f)
	f.moneyFrame:SetPoint('BOTTOMRIGHT', -8, 4)

	f.qualityFilter = Addon.QualityFilter:New(f)
	f.qualityFilter:SetPoint('BOTTOMLEFT', 10, 4)

	--[[f.sideFilter = Addon.SideFilter:New(f)
	f.bottomFilter = Addon.BottomFilter:New(f)--]]

	f.bagFrame = Addon.BagFrame:New(f, 'TOP', 0, -36)
	f.bagFrame:SetPoint('TOPRIGHT', -12, -66)

	f.itemFrame = Addon.ItemFrame:New(f, self.Bags)
	f.itemFrame:SetPoint('TOPLEFT', 12, -66)

	f:Hide()
	f:SetScript('OnShow', self.OnShow)
	f:SetScript('OnHide', self.OnHide)
	f:SetMinResize(BASE_WIDTH, BASE_HEIGHT)

	tinsert(UISpecialFrames, f:GetName())
	return f
end


--[[ Visibility ]]--

function Frame:UpdateShown()
	if self:IsFrameShown() then
		self:Show()
	else
		self:Hide()
	end
end

function Frame:ShowFrame()
	self.shownCount = self.shownCount + 1
	self:Show()
end

function Frame:HideFrame(force) -- if a frame was manually opened, then it should only be closable manually
	self.shownCount = self.shownCount - 1

	if force or self.shownCount <= 0 then
		self.shownCount = 0
		self:Hide()
	end
end

function Frame:IsFrameShown()
	return self.shownCount > 0
end

function Frame:OnShow()
	PlaySound(self.OpenSound)
	self:RegisterMessage('UPDATE_ALL', 'Update')
	self:RegisterFrameMessage('PLAYER_CHANGED', 'UpdateTitle')
	self:RegisterFrameMessage('BAG_FRAME_TOGGLED', 'UpdateItems')
	self:Update()
end

function Frame:OnHide()
	PlaySound(self.CloseSound)
	self:UnregisterMessages()

	if self:IsFrameShown() then
		self:HideFrame()
	end

	if Addon.sets.resetPlayer then
		self.player = nil
	end
end


--[[ Update ]]--

function Frame:Update()
	self.profile = Addon.profile[self.frameID]
	self:UpdateShown()

	if self:IsVisible() then
		-- magic here
		self:SetPoint('TOP')
		self:UpdateTitle()
		self:UpdateItems()
	end
end

function Frame:UpdateTitle()
	self.title:SetFormattedText(self.Title, self:GetPlayer())
	self.title:SetWidth(self.title:GetTextWidth())
end

function Frame:UpdateItems()
	self.itemFrame:RequestLayout()
end


--[[ Components Frame Events ]]--

function Frame:OnSearchTextChanged(text)

end


--[[ Shared ]]--

function Frame:GetProfile()
	return Addon:GetProfile(self.player)[self.frameID]
end

function Frame:IsCached()
	return Addon:IsBagCached(self.player, self.Bags[1])
end

function Frame:GetPlayer()
	return self.player or UnitName('player')
end

function Frame:GetFrameID()
	return self.frameID
end

function Frame:IsBank()
	return false
end