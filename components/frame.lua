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

	f.moneyFrame = Addon.MoneyFrame:New(f)
	f.moneyFrame:SetPoint('BOTTOMRIGHT', -8, 4)

	f.qualityFilter = Addon.QualityFilter:New(f)
	f.qualityFilter:SetPoint('BOTTOMLEFT', 10, 4)

	--[[
	f.filter = {quality = 0}

	f.sideFilter = Addon.SideFilter:New(f, f:IsSideFilterOnLeft())
	f.bottomFilter = Addon.BottomFilter:New(f)

	f.itemFrame = Addon.ItemFrame:New(f, bags)
	f.itemFrame:SetPoint('TOPLEFT', 10, -64)

	f:SetWidth(settings.w or BASE_WIDTH)
	f:SetHeight(settings.h or BASE_HEIGHT)]]--

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
	self:Update()
end

function Frame:OnHide()
	PlaySound(self.CloseSound)
	self:UnregisterMessages()

	if self:IsFrameShown() then
		self:HideFrame()
	end

	if Addon.sets.resetPlayer then
		self:SetPlayer(nil)
	end
end


--[[ Update ]]--

function Frame:Update()
	self.profile = Addon.profile[self.frameID]
	self:UpdateShown()

	if self:IsVisible() then
		-- magic here
		self:SetPoint('TOP')
	end
end


--[[ Components Frame Events ]]--

function Frame:OnSortButtonEnter()
	GameTooltip:SetOwner(self.sortButton)
	GameTooltip:SetText(BAG_CLEANUP_BAGS, 1,1,1)

	if self:IsBank() then
		GameTooltip:AddLine(L.TipDepositReagents)
		GameTooltip:AddLine(L.TipCleanBank)
	else
		GameTooltip:AddLine(L.TipCleanBags)
	end

	GameTooltip:Show()
end

function Frame:OnSortButtonClick(button)
	if button == 'RightButton' then
		DepositReagentBank()
	else
		SetSortBagsRightToLeft(true)

		if self:IsBank() then
			SortReagentBankBags()
			SortBankBags()
		else
			SortBags()
		end
	end
end

function Frame:OnBagToggleEnter()
	GameTooltip:SetOwner(self.bagToggle, 'ANCHOR_LEFT')
	GameTooltip:SetText(L.TipBags, 1, 1, 1)
	GameTooltip:AddLine(L.TipShowBags)

	if self:IsBank() then
		GameTooltip:AddLine(L.TipShowInventory)
	else
		GameTooltip:AddLine(L.TipShowBank)
	end

	GameTooltip:Show()
end

function Frame:OnBagToggleClick(button)
	if button == 'LeftButton' then
		_G[self.bagToggle:GetName() .. 'Icon']:SetTexCoord(0.075, 0.925, 0.075, 0.925)
		self:ToggleBags()
	elseif self:IsBank() then
		Addon:ToggleFrame('inventory')
	else
		Addon:ToggleFrame('bank')
	end
end

function Frame:OnPortraitEnter()
	GameTooltip:SetOwner(self.portraitButton, 'ANCHOR_RIGHT')
	GameTooltip:SetText(self:GetPlayer(), 1, 1, 1)
	GameTooltip:AddLine(L.TipChangePlayer)
	GameTooltip:Show()
end

function Frame:OnSearchTextChanged(text)

end


--[[ Shared ]]--

function Frame:SetPlayer(player)
	self.player = player
	self:SendMessage(self.frameID .. '_PLAYER_CHANGED')
end

function Frame:GetPlayer()
	return self.player or UnitName('player')
end

function Frame:GetProfile()
	return Addon:GetProfile(self.player)[self.frameID]
end

function Frame:IsCached()
	return Addon:IsBagCached(self.player, self.Bags[1])
end

function Frame:IsBank()
	return false
end