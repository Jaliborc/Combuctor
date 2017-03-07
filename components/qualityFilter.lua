--[[
	qualityFilter.lua 
		A set of buttons to set what quality of items to show
--]]

local AddonName, Addon = ...
local FilterButton = Addon.QualityFilterButton
local QualityFilter = Addon:NewClass('QualityFilter', 'Frame')

do
	local QualityFlags = {}
	for quality = 0, 7 do
		QualityFlags[quality] = bit.lshift(1, quality)
	end

	QualityFlags[5] = QualityFlags[5] + QualityFlags[6]
	QualityFilter.Flags = QualityFlags
end


--[[ Constructor ]]--

function QualityFilter:New(parent)
	local f = self:Bind(CreateFrame('Frame', nil, parent))
	f:SetSize(FilterButton.SIZE * 7, FilterButton.SIZE)
	f.selection = 0

	f:AddQualityButton(0)
	f:AddQualityButton(1)
	f:AddQualityButton(2)
	f:AddQualityButton(3)
	f:AddQualityButton(4)
	f:AddQualityButton(5)
	f:AddQualityButton(7, 6)
	f:UpdateHighlight()

	return f
end

function QualityFilter:AddQualityButton(quality, color)
	local button = FilterButton:Create(self, quality, self.Flags[quality], color or quality)
	if self.prev then
		button:SetPoint('LEFT', self.prev, 'RIGHT', 1, 0)
	else
		button:SetPoint('LEFT', 0, 2)
	end

	self.prev = button
end

function QualityFilter:UpdateHighlight()
	for i = 1, select('#', self:GetChildren()) do
		select(i, self:GetChildren()):UpdateHighlight()
	end
end


--[[ API ]]--

function QualityFilter:SetQuality(flags)
	self.selection = flags
	self:SendFrameMessage('QUALITY_CHANGED')
	self:SendFrameMessage('FILTERS_CHANGED')
	self:UpdateHighlight()
end

function QualityFilter:AddQuality(flags)
	self:SetQuality(self.selection + flags)
end 

function QualityFilter:RemoveQuality(flags)
	self:SetQuality(self.selection - flags)
end

function QualityFilter:IsSelected(quality)
	return bit.band(self.selection, self.Flags[quality] or 0) > 0
end