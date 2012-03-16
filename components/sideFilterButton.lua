--[[
	Side Filter Button
		The elements of the side filter
--]]

local AddonName, Addon = ...
local SideFilterButton = Addon:NewClass('SideFilterButton', 'CheckButton')
local id = 1


--[[ Constructor ]]--

function SideFilterButton:New(parent, reversed)
	local b = self:Bind(CreateFrame('CheckButton', 'CombuctorSideButton' .. id, parent, 'CombuctorSideTabButtonTemplate'))
	b:GetNormalTexture():SetTexCoord(0.06, 0.94, 0.06, 0.94)
	b:SetScript('OnClick', b.OnClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b:SetReversed(reversed)

	id = id + 1
	return b
end
	
	
--[[ Frame Events ]]--

function SideFilterButton:OnClick()
	self:GetParent():GetParent():SetCategory(self.set.name)
end

function SideFilterButton:OnEnter()
	GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	GameTooltip:SetText(self.set.name)
	GameTooltip:Show()
end

function SideFilterButton:OnLeave()
	GameTooltip:Hide()
end

function SideFilterButton:Set(set)
	self.set = set
	self:SetNormalTexture(set.icon)
end


--[[ Update ]]--

function SideFilterButton:UpdateHighlight(setName)
	self:SetChecked(self.set.name == setName)
end


--[[ Reversed ]]--

function SideFilterButton:SetReversed(reversed)
	local border = _G[self:GetName() .. 'Border']
	border:ClearAllPoints()

	if reversed then
		border:SetTexCoord(1, 0, 0, 1)
		border:SetPoint('TOPRIGHT', 3, 11)
	else
		border:SetTexCoord(0, 1, 0, 1)
		border:ClearAllPoints()
		border:SetPoint('TOPLEFT', -3, 11)
	end

  self.reversed = reversed
end

function SideFilterButton:Reversed()
	return self.reversed
end