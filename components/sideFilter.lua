--[[
	Side Filter
		Used for setting what types of items to show
--]]

local AddonName, Addon = ...
local FilterButton = Addon.SideFilterButton
local SideFilter = Addon:NewClass('SideFilter', 'Frame')


--[[ Constructor ]]--

function SideFilter:New(parent, reversed)
	local f = self:Bind(CreateFrame('Frame', nil, parent))

	--metatable magic for button creation on demand
	f.buttons = setmetatable({}, {__index = function(t, k)
		local b = FilterButton:New(f, f:Reversed())
		t[k] = b

    if k > 1 then
      b:SetPoint('TOPLEFT', t[k-1], 'BOTTOMLEFT', 0, -17)
    end
  
		return b
	end})

	f:SetReversed(reversed)
	return f
end


--[[ Update ]]--

function SideFilter:UpdateFilters()
	local numFilters = 0
	local parent = self:GetParent()

	for _,set in Combuctor('Sets'):GetParentSets() do
		if parent:HasSet(set.name) then
			numFilters = numFilters + 1
			self.buttons[numFilters]:Set(set)
		end
	end

	--show only used buttons
	if numFilters > 1 then
		for i = 1, numFilters do
			self.buttons[i]:Show()
		end

		for i = numFilters + 1, #self.buttons do
			self.buttons[i]:Hide()
		end

		self:UpdateHighlight()
		self:Show()
	--at most one filter active, hide all side buttons
	else
		self:Hide()
	end
end

function SideFilter:UpdateHighlight()
	local category = self:GetParent():GetCategory()

	for _,button in pairs(self.buttons) do
		if button:IsShown() then
			button:UpdateHighlight(category)
		end
	end
end


--[[ Reversed ]]--

function SideFilter:SetReversed(reversed)
  local first = self.buttons[1]
  first:ClearAllPoints()

  if reversed then
    first:SetPoint('TOPRIGHT', self:GetParent(), 'TOPLEFT', 0, -80)
  else
    first:SetPoint('TOPLEFT', self:GetParent(), 'TOPRIGHT', 0, -40)
  end

	for i, button in pairs(self.buttons) do
		button:SetReversed(reversed)
	end

  self.reversed = reversed
end

function SideFilter:Reversed()
	return self.reversed
end
