--[[
	Quality Filter Widget
		used for setting what quality of items to show
--]]

local AddonName, Addon = ...


--[[
	CombuctorQualityFlags
--]]

do
	local QualityFlags = {}
	for quality = 0, 7 do
		QualityFlags[quality] = bit.lshift(1, quality)
	end
	Addon.QualityFlags = QualityFlags
end


--[[ filter button ]]--

local FilterButton = LibStub('Classy-1.0'):New('Checkbutton')
local SIZE = 20

function FilterButton:Create(parent, quality, qualityFlag)
	local button = self:Bind(CreateFrame('Checkbutton', nil, parent, 'UIRadioButtonTemplate'))
	button:SetWidth(SIZE)
	button:SetHeight(SIZE)
	button:SetScript('OnClick', self.OnClick)
	button:SetScript('OnEnter', self.OnEnter)
	button:SetScript('OnLeave', self.OnLeave)

	local bg = button:CreateTexture(nil, 'BACKGROUND')
	bg:SetSize(SIZE/3, SIZE/3)
	bg:SetPoint('CENTER')
	
	local r, g, b = GetItemQualityColor(quality)
	bg:SetTexture(r * 1.25, g * 1.25, b * 1.25, 0.75)

	button:SetCheckedTexture(bg)	
	button:GetNormalTexture():SetVertexColor(r, g, b)
	
	button.quality = quality
	button.qualityFlag = qualityFlag
	return button
end

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

	local quality = self.quality
	if quality then
		local r,g,b = GetItemQualityColor(quality)
		GameTooltip:SetText(_G[format('ITEM_QUALITY%d_DESC', quality)], r, g, b)
	else
		GameTooltip:SetText(ALL)
	end

	GameTooltip:Show()
end

function FilterButton:OnLeave()
	GameTooltip:Hide()
end

function FilterButton:UpdateHighlight(quality)
	self:SetChecked(bit.band(quality, self.qualityFlag) > 0)
end


--[[
	QualityFilter, A group of filter buttons
--]]

local QualityFilter = LibStub('Classy-1.0'):New('Frame'); Addon.QualityFilter = QualityFilter

function QualityFilter:New(parent)
	local f = self:Bind(CreateFrame('Frame', nil, parent))

	f:AddQualityButton(0)
	f:AddQualityButton(1)
	f:AddQualityButton(2)
	f:AddQualityButton(3)
	f:AddQualityButton(4)
	f:AddQualityButton(5, Addon.QualityFlags[5] + Addon.QualityFlags[6])
	f:AddQualityButton(7)

	f:SetWidth(SIZE * 6)
	f:SetHeight(SIZE)
	f:UpdateHighlight()

	return f
end

function QualityFilter:AddQualityButton(quality, qualityFlags)
	local button = FilterButton:Create(self, quality, qualityFlags or Addon.QualityFlags[quality])
	if self.prev then
		button:SetPoint('LEFT', self.prev, 'RIGHT', 1, 0)
	else
		button:SetPoint('LEFT')
	end
	self.prev = button
end

function QualityFilter:UpdateHighlight()
	local quality = self:GetParent():GetQuality()

	for i = 1, select('#', self:GetChildren()) do
		select(i, self:GetChildren()):UpdateHighlight(quality)
	end
end