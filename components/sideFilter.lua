--[[
	sideFilter.lua
		A list of tabs for each item ruleset
--]]

local ADDON, Addon = ...
local SideFilter = Addon:NewClass('SideFilter', 'Frame')
SideFilter.Button = Addon.SideTab


--[[ Constructor ]]--

function SideFilter:New(parent)
	local f = self:Bind(CreateFrame('Frame', nil, parent))
	f.buttons = {[-1] = f}
	f:SetSize(50, 30)

	f:RegisterMessage('RULES_LOADED', 'OnRulesLoaded')
	f:RegisterMessage('UPDATE_ALL', 'Update')
	f:FindNewRules()
	f:Update()

	return f
end

function SideFilter:OnRulesLoaded()
	local rules = self:GetRules()
	local count = #rules

	self:FindNewRules()
	if #rules > count then
		self:Update()
	end
end


--[[ API ]]--

function SideFilter:Update()
	local n = 0

	for i, id in ipairs(self:GetRules()) do
		local rule = Addon.Rules:Get(id)
		if rule and rule.icon then
			local button = self.buttons[n] or self.Button:New(self)
			button:SetPoint('TOPLEFT', self.buttons[n-1], 'BOTTOMLEFT', 0, -17)
			button:Setup(id, rule.name, rule.icon)

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

function SideFilter:FindNewRules()
	local profile = self:GetFrame().profile
	local sorted = {}

	for i, id in ipairs(profile.rules) do
		sorted[id] = true
	end

	for id, filter in Addon.Rules:Iterate() do
		if not sorted[id] and not profile.hiddenRules[id] then
			tinsert(profile.rules, id)
		end
	end
end

function SideFilter:GetRules()
	return self:GetFrame().profile.rules
end