--[[
	Side Filters
		Used for setting what types of items to show
--]]

local AddonName, Addon = ...

--[[ 
	A side filter button, switches parent filters on click 
--]]

local SideFilterButton = LibStub('Classy-1.0'):New('CheckButton')
do
	local id = 1
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
end

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

function SideFilterButton:UpdateHighlight(setName)
	self:SetChecked(self.set.name == setName)
end

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


--[[
	Side Filter Object
--]]

local SideFilter = LibStub('Classy-1.0'):New('Frame'); Addon.SideFilter = SideFilter

function SideFilter:New(parent, reversed)
	local f = self:Bind(CreateFrame('Frame', nil, parent))

	--metatable magic for button creation on demand
	f.buttons = setmetatable({}, {__index = function(t, k)
		local b = SideFilterButton:New(f, f:Reversed())
		t[k] = b

    if k > 1 then
      b:SetPoint('TOPLEFT', t[k-1], 'BOTTOMLEFT', 0, -17)
    end
  
		return b
	end})

	f:SetReversed(reversed)
	return f
end

function SideFilter:UpdateFilters()
	local numFilters = 0
	local parent = self:GetParent()

	for _,set in Combuctor.Set:GetParentSets() do
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
