--[[
	Quality Filter Button
		The elements of the quality filter
--]]

local AddonName, Addon = ...
local FilterButton = Addon:NewClass('QualityFilterButton', 'Checkbutton')
FilterButton.SIZE = 18


--[[ Constructor ]]--

function FilterButton:Create(parent, quality, qualityFlag, qualityColor)
	local button = self:Bind(CreateFrame('Checkbutton', nil, parent, 'UIRadioButtonTemplate'))
	button:SetSize(FilterButton.SIZE, FilterButton.SIZE)
	button:SetScript('OnClick', self.OnClick)
	button:SetScript('OnEnter', self.OnEnter)
	button:SetScript('OnLeave', self.OnLeave)
	button:SetCheckedTexture(nil)

	local r, g, b = GetItemQualityColor(qualityColor)
	button:GetNormalTexture():SetVertexColor(r, g, b)
	button:GetHighlightTexture():SetDesaturated(true)
	
	local bg = button:CreateTexture(nil, 'BACKGROUND')
	bg:SetTexture(r, g, b)
	bg:SetPoint('CENTER')
	bg:SetSize(8,8)

	button.qualityColor = qualityColor
	button.qualityFlag = qualityFlag
	button.quality = quality
	button.bg = bg
	return button
end


--[[ Frame Events ]]--

function FilterButton:OnClick()
	local frame = self:GetParent():GetParent()
	if bit.band(frame:GetQuality(), self.qualityFlag) > 0 then
		if IsModifierKeyDown() or frame:GetQuality() == self.qualityFlag then
			frame:RemoveQuality(self.qualityFlag)
		else
			frame:SetQuality(self.qualityFlag)
		end
	elseif IsModifierKeyDown() then
		frame:AddQuality(self.qualityFlag)
	else
		frame:SetQuality(self.qualityFlag)
	end
end

function FilterButton:OnEnter()
	GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')

	local color = self.qualityColor
	if color then
		local r,g,b = GetItemQualityColor(color)
		GameTooltip:SetText(_G[format('ITEM_QUALITY%d_DESC', self.quality)], r, g, b)
	else
		GameTooltip:SetText(ALL)
	end

	GameTooltip:Show()
end

function FilterButton:OnLeave()
	GameTooltip:Hide()
end


--[[ Update ]]--

function FilterButton:UpdateHighlight(quality)
	if bit.band(quality, self.qualityFlag) > 0 then
		self:LockHighlight()
		self.bg:SetVertexColor(.95, .95, .95)
	else
		self:UnlockHighlight()
		self.bg:SetVertexColor(.4, .4, .4)
	end
end