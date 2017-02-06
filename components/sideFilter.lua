--[[
	Side Filter
		Used for setting what types of items to show
--]]

local AddonName, Addon = ...
local FilterButton = Addon.SideFilterButton
local SideFilter = Addon:NewClass('SideFilter', 'Frame')


--[[ Constructor ]]--

function SideFilter:New(parent)
	local f = self:Bind(CreateFrame('Frame', nil, parent))

	f:SetScript('OnShow', f.RegisterEvents)
	f:SetScript('OnHide', f.UnregisterEvents)
	f.buttons = setmetatable({}, {__index = function(t, k) -- button creation on demand
		t[k] = FilterButton:New(f)

    	if k > 1 then
      		t[k]:SetPoint('TOPLEFT', t[k-1], 'BOTTOMLEFT', 0, -17)
    	end
  
		return t[k]
	end})

	return f
end

function SideFilter:RegisterEvents()
	self:RegisterMessage('SETS_CHANGED', 'Update')
	self:Update()
end


--[[ Update ]]--

function SideFilter:Update()
	self:UpdateButtons()
	self:UpdateSide()
end

function SideFilter:UpdateButtons()
	local sets = self:GetProfile().sets
	local i = 0

	for _, id in ipairs(sets) do
		local set = Addon.Sets:Get(id)
		if set then
			local button = self.buttons[i]
			button:UpdateHighlight()
			button:SetFilter(set)
			button:Show()

			i = i + 1
		end
	end

	if i > 1 then -- if one filter, hide all
		i = i + 1
	end 

	for k = i, #self.buttons do
		self.buttons[k]:Hide()
	end
end

function SideFilter:UpdateSide()
	local first = self.buttons[1]
	first:ClearAllPoints()

	if self:GetProfile().reversedTabs then
 		first:SetPoint('TOPRIGHT', self:GetParent(), 'TOPLEFT', 0, -80)
	else
 		first:SetPoint('TOPLEFT', self:GetParent(), 'TOPRIGHT', 0, -40)
	end

	for i, button in pairs(self.buttons) do
		button:SetReversed(reversed)
	end
end