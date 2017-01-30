--[[
	Quality Filter 
		Used for setting what quality of items to show
--]]

local AddonName, Addon = ...
local FilterButton = Addon.QualityFilterButton
local QualityFilter = Addon:NewClass('QualityFilter', 'Frame')

do
	local QualityFlags = {}
	for quality = 0, 7 do
		QualityFlags[quality] = bit.lshift(1, quality)
	end
	Addon.QualityFlags = QualityFlags
end


--[[ Constructor ]]--

function QualityFilter:New(parent)
	local f = self:Bind(CreateFrame('Frame', nil, parent))

	f:AddQualityButton(0)
	f:AddQualityButton(1)
	f:AddQualityButton(2)
	f:AddQualityButton(3)
	f:AddQualityButton(4)
	f:AddQualityButton(5, Addon.QualityFlags[5] + Addon.QualityFlags[6])
	f:AddQualityButton(7, nil, 6)

	f:SetSize(FilterButton.SIZE * 7, FilterButton.SIZE)
	f:UpdateHighlight()

	return f
end

function QualityFilter:AddQualityButton(quality, qualityFlags, qualityColor)
	local button = FilterButton:Create(self, quality, qualityFlags or Addon.QualityFlags[quality], qualityColor or quality)
	if self.prev then
		button:SetPoint('LEFT', self.prev, 'RIGHT', 1, 0)
	else
		button:SetPoint('LEFT', 0, 2)
	end
	self.prev = button
end


--[[ Update ]]--

function QualityFilter:UpdateHighlight()
	local quality = self:GetParent():GetQuality()

	for i = 1, select('#', self:GetChildren()) do
		select(i, self:GetChildren()):UpdateHighlight(quality)
	end
end