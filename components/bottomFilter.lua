--[[
	bottomFilter.lua
		A list of tabs that shows the subrules of a ruleset
--]]

local ADDON, Addon = ...
local BottomFilter = Addon:NewClass('BottomFilter', 'Frame')
BottomFilter.Button = Addon.BottomTab


--[[ Constructor ]]--

function BottomFilter:New(parent)
	local f = self:Bind(CreateFrame('Frame', nil, parent))
	f.buttons = {[-1] = f}
	f:SetSize(10, 30)

	f:RegisterFrameMessage('RULE_CHANGED', 'Update')
	f:RegisterMessage('UPDATE_ALL', 'Update')
	f:Update()

	return f
end


--[[ API ]]--

function BottomFilter:Update()
	local n = 0

	for i, id in ipairs(self:GetRules()) do
		local rule = Addon.Rules:Get(id)
		if rule then
			local button = self.buttons[n] or self.Button:New(self)
			button:SetPoint('LEFT', self.buttons[n-1], 'RIGHT', -10, 0)
			button:Setup(id, rule.name)

			self.buttons[n] = button
			n = n + 1
		end
	end

	if n == 1 then -- if one filter, hide all
		n = 0
	end

	for k = n, #self.buttons do
		self.buttons[k]:Hide()
	end
end

function BottomFilter:GetRules()
	local frame = self:GetFrame()
	local rules = {}

	for i, id in ipairs(frame.profile.rules) do
		if id:match(frame.rule .. '/.+') then
			tinsert(rules, id)
		end
	end

	return rules
end