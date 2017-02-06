--[[
	Quality Filter Button
		The elements of the quality filter
--]]

local AddonName, Addon = ...
local FilterButton = Addon:NewClass('QualityFilterButton', 'Checkbutton')
FilterButton.SIZE = 18


--[[ Constructor ]]--

function FilterButton:Create(parent, quality, flag, qualityColor)
	local button = self:Bind(CreateFrame('Checkbutton', nil, parent, 'UIRadioButtonTemplate'))
	button:SetScript('OnClick', self.OnClick)
	button:SetScript('OnEnter', self.OnEnter)
	button:SetScript('OnLeave', self.OnLeave)
	button:SetSize(self.SIZE, self.SIZE)
	button:SetCheckedTexture(nil)

	local r, g, b = GetItemQualityColor(qualityColor)
	button:GetNormalTexture():SetVertexColor(r, g, b)
	button:GetHighlightTexture():SetDesaturated(true)
	
	local bg = button:CreateTexture(nil, 'BACKGROUND')
	bg:SetTexture(r, g, b)
	bg:SetPoint('CENTER')
	bg:SetSize(8,8)

	button.color = qualityColor
	button.quality = quality
	button.flag = flag
	button.bg = bg
	return button
end


--[[ Frame Events ]]--

function FilterButton:OnClick()
	local parent = self:GetParent()

	if parent:IsSelected(self.quality) then
		if IsModifierKeyDown() or parent.selection == self.flag then
			parent:RemoveQuality(self.flag)
		else
			parent:SetQuality(self.flag)
		end
	elseif IsModifierKeyDown() then
		parent:AddQuality(self.flag)
	else
		parent:SetQuality(self.flag)
	end
end

function FilterButton:OnEnter()
	GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	GameTooltip:SetText(_G[format('ITEM_QUALITY%d_DESC', self.quality)], GetItemQualityColor(self.color))
	GameTooltip:Show()
end

function FilterButton:OnLeave()
	GameTooltip:Hide()
end


--[[ Update ]]--

function FilterButton:UpdateHighlight()
	if self:GetParent():IsSelected(self.quality) then
		self:LockHighlight()
		self.bg:SetVertexColor(.95, .95, .95)
	else
		self:UnlockHighlight()
		self.bg:SetVertexColor(.4, .4, .4)
	end
end