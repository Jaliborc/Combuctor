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

local FilterButton = LibStub('Classy-1.0'):New('Button')
local SIZE = 20

function FilterButton:Create(parent, quality, qualityFlag)
	local button = self:Bind(CreateFrame('Button', nil, parent, 'UIRadioButtonTemplate'))
	button:SetWidth(SIZE)
	button:SetHeight(SIZE)
	button:SetScript('OnClick', self.OnClick)
	button:SetScript('OnEnter', self.OnEnter)
	button:SetScript('OnLeave', self.OnLeave)

	local bg = button:CreateTexture(nil, 'BACKGROUND')
	bg:SetWidth(SIZE/2)
	bg:SetHeight(SIZE/2)
	bg:SetPoint('CENTER')
	bg:SetTexture(GetItemQualityColor(quality))
	button.bg = bg
	button.quality = quality
	button.qualityFlag = qualityFlag

	return button
end

function FilterButton:OnClick()
	local frame = self:GetParent():GetParent()
	if bit.band(frame:GetQuality(), self.qualityFlag) > 0 then
		frame:RemoveQuality(self.qualityFlag)
	elseif IsModifierKeyDown() then
		frame:SetQuality(self.qualityFlag)
	else
		frame:AddQuality(self.qualityFlag)
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
	if bit.band(quality, self.qualityFlag) > 0 then
		if self.bg then
			self.bg:SetAlpha(1)
		end
		self:GetNormalTexture():SetVertexColor(1, 0.82, 0)
		self:LockHighlight()
	else
		if self.bg then
			self.bg:SetAlpha(0.5)
		end
		self:GetNormalTexture():SetVertexColor(1, 1, 1)
		self:UnlockHighlight()
	end
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