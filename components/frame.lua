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

	f.sideFilter = Addon.SideFilter:New(f)
	--f.bottomFilter = Addon.BottomFilter:New(f)

	f.bagFrame = Addon.BagFrame:New(f, 'TOP', 0, -36)
	f.bagFrame:SetPoint('TOPRIGHT', -12, -66)

	f.itemFrame = Addon.ItemFrame:New(f, self.Bags)
	f.itemFrame:SetPoint('TOPLEFT', 12, -66)

	f:Hide()
	f:SetScript('OnShow', self.OnShow)
	f:SetScript('OnHide', self.OnHide)
	f:SetScript('OnSizeChanged', self.OnSizeChanged)
	f:SetMinResize(300, 300)

	tinsert(UISpecialFrames, f:GetName())
	return f
end

function Frame:RegisterMessages()
	self:RegisterMessage('UPDATE_ALL', 'Update')
	self:RegisterFrameMessage('PLAYER_CHANGED', 'UpdateTitle')
	self:RegisterFrameMessage('BAG_FRAME_TOGGLED', 'UpdateItems')
end


--[[ Frame Events ]]--

function Frame:OnSizeChanged()
	local width, height = self:GetSize()

	self.profile.width = width
	self.profile.height = height
	self:UpdateItems()
end

function Frame:OnSearchTextChanged(text)

end


--[[ Update ]]--

function Frame:Update()
	self.profile = Addon.profile[self.frameID]
	self:UpdateShown()

	if self:IsVisible() then
		-- magic here
		self:SetPoint('TOP')
		self:SetSize(self.profile.width, self.profile.height)

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