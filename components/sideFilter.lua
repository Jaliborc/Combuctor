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
	f.selection = 'all'
	f:SetSize(50, 30)

	return f
end

function SideFilter:RegisterEvents()
	self:RegisterMessage('UPDATE_ALL', 'Update')
	self:RegisterMessage('FILTERS_ADDED', 'UpdateContent')
	self:Update()
end


--[[ Update ]]--

function SideFilter:Update()
	self:UpdateSide()
	self:UpdateContent()
end

function SideFilter:UpdateContent()
	self:FindFilters()
	self:UpdateButtons()
end

function SideFilter:FindFilters()
	local profile = self:GetProfile()
	local sorted = {}

	for i, id in ipairs(profile.filters) do
		sorted[id] = true
	end

	for id, filter in Addon.Filters:Iterate() do
		if not sorted[id] and not profile.hiddenFilters[id] then
			tinsert(profile.filters, id)
		end
	end
end

function SideFilter:UpdateButtons()
	local n = 0

	for i, id in ipairs(self:GetProfile().filters) do
		local filter = Addon.Filters:Get(id)
		if filter then
			local button = self.buttons[n] or self.Button:New(self)
			button:SetPoint('TOPLEFT', self.buttons[n-1], 'BOTTOMLEFT', 0, -17)
			button:Setup(id, filter.icon, filter.name)

			self.buttons[n] = button
			n = n + 1
		end
	end

	if n > 1 then -- if one filter, hide all
		n = n + 1
	end 

	for k = n, #self.buttons do
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