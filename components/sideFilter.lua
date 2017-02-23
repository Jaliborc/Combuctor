--[[
	Side Filter
		Used for setting what types of items to show
--]]

local AddonName, Addon = ...
local SideFilter = Addon:NewClass('SideFilter', 'Frame')
SideFilter.Button = Addon.SideFilterButton


--[[ Constructor ]]--

function SideFilter:New(parent)
	local f = self:Bind(CreateFrame('Frame', nil, parent))
	f:SetScript('OnShow', f.RegisterEvents)
	f:SetScript('OnHide', f.UnregisterEvents)
	f.buttons = {[-1] = f}
	f:SetSize(50, 30)

	return f
end

function SideFilter:RegisterEvents()
	self:RegisterMessage('UPDATE_ALL', 'Update')
	self:RegisterMessage('SETS_CHANGED', 'UpdateContent')
	self:Update()
end


--[[ Update ]]--

function SideFilter:Update()
	self:UpdateSide()
	self:UpdateContent()
end

function SideFilter:UpdateContent()
	local i = 0

	for id, set in Addon:IterateSets() do
		if i == 0 and not self.selection then -- default selection
			self.selection = id
		end

		local button = self.buttons[i] or self.Button:New(self)
		button:SetPoint('TOPLEFT', self.buttons[i-1], 'BOTTOMLEFT', 0, -17)
		button:Setup(id, set.icon, set.name)

		self.buttons[i] = button
		i = i + 1
	end

	if i > 1 then -- if one filter, hide all
		i = i + 1
	end 

	for k = i, #self.buttons do
		self.buttons[k]:Hide()
	end
end

function SideFilter:UpdateSide()
	self:ClearAllPoints()

	if self:GetProfile().reversedTabs then
 		self:SetPoint('TOPRIGHT', self:GetParent(), 'TOPLEFT', 0, -40)
	else
 		self:SetPoint('TOPLEFT', self:GetParent(), 'TOPRIGHT', 0, 0)
	end
end