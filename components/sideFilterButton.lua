--[[
	Side Filter Button
		The elements of the side filter
--]]

local ADDON, Addon = ...
local SideButton = Addon:NewClass('SideFilterButton', 'CheckButton')
local id = 1


--[[ Constructor ]]--

function SideButton:New(parent)
	local b = self:Bind(CreateFrame('CheckButton', ADDON .. 'SideFilterButton' .. id, parent, ADDON .. 'SideButtonTemplate'))
	b:GetNormalTexture():SetTexCoord(0.06, 0.94, 0.06, 0.94)
	b:SetScript('OnHide', b.UnregisterEvents)
	b:SetScript('OnClick', b.OnClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)

	id = id + 1
	return b
end
	
	
--[[ Frame Events ]]--

function SideButton:OnClick()
	self:GetParent().selection = self.id
	self:SendFrameMessage('FILTERS_CHANGED')
end

function SideButton:OnEnter()
	if self:GetRight() > (GetScreenWidth() / 2) then
		GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
	else
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	end

	GameTooltip:SetText(self.name)
	GameTooltip:Show()
end

function SideButton:OnLeave()
	GameTooltip:Hide()
end


--[[ Update ]]--

function SideButton:Setup(id, icon, name)
	self.id, self.name = id, name or id
	self:RegisterFrameMessage('FILTERS_CHANGED', 'UpdateHighlight')
	self:SetNormalTexture(icon)
	self:UpdateOrientation()
	self:UpdateHighlight()
	self:Show()
end

function SideButton:UpdateOrientation()
	self.border:ClearAllPoints()

	if self:GetProfile().reversedTabs then
		self.border:SetTexCoord(1, 0, 0, 1)
		self.border:SetPoint('TOPRIGHT', 3, 11)
	else
		self.border:SetTexCoord(0, 1, 0, 1)
		self.border:SetPoint('TOPLEFT', -3, 11)
	end
end

function SideButton:UpdateHighlight()
	self:SetChecked(self:GetParent().selection == self.id)
end