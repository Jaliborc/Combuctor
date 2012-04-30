--[[
	moneyFrame.lua
		A money frame object
--]]

local AddonName, Addon = ...
local MoneyFrame = LibStub('Classy-1.0'):New('Frame'); Addon.MoneyFrame = MoneyFrame
local L = LibStub('AceLocale-3.0'):GetLocale('Combuctor')
local ItemCache = LibStub('LibItemCache-1.0')


--[[ Constructor ]]--

function MoneyFrame:New(parent)
	local f = self:Bind(CreateFrame('Frame', parent:GetName() .. 'MoneyFrame', parent, 'SmallMoneyFrameTemplate'))
	f:SetScript('OnShow', self.Update)
	f:Update()

	local click = CreateFrame('Button', f:GetName() .. 'Click', f)
	click:SetFrameLevel(f:GetFrameLevel() + 4)
	click:SetAllPoints(f)

	click:SetScript('OnClick', function() f:OnClick() end)
	click:SetScript('OnEnter', function() f:OnEnter() end)
	click:SetScript('OnLeave', function() f:OnLeave() end)

	return f
end

function MoneyFrame:Update()
	local player = self:GetParent():GetPlayer()
	if player == UnitName('player') or not BagnonDB then
		MoneyFrame_Update(self:GetName(), GetMoney())
	else
		MoneyFrame_Update(self:GetName(), BagnonDB:GetMoney(player))
	end
end


--[[ Frame Events ]]--

function MoneyFrame:OnClick()
	local name = self:GetName()

	if MouseIsOver(_G[name .. 'GoldButton']) then
		OpenCoinPickupFrame(COPPER_PER_GOLD, MoneyTypeInfo[self.moneyType].UpdateFunc(self), self)
		self.hasPickup = 1
	elseif MouseIsOver(_G[name .. 'SilverButton']) then
		OpenCoinPickupFrame(COPPER_PER_SILVER, MoneyTypeInfo[self.moneyType].UpdateFunc(self), self)
		self.hasPickup = 1
	elseif MouseIsOver(_G[name .. 'CopperButton']) then
		OpenCoinPickupFrame(1, MoneyTypeInfo[self.moneyType].UpdateFunc(self), self)
		self.hasPickup = 1
	end
	
	self:OnLeave()
end

function MoneyFrame:OnEnter()
	if not ItemCache:HasCache() then
    	return
  	end

	-- Total
	local total = 0
	for i, player in ItemCache:IteratePlayers() do
		total = total + ItemCache:GetMoney(player)
	end

	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOM')
	GameTooltip:AddDoubleLine(L.Total, GetCoinTextureString(total), nil,nil,nil, 1,1,1)
	GameTooltip:AddLine(' ')
	
	-- Each player
	for i, player in ItemCache:IteratePlayers() do
		local money = ItemCache:GetMoney(player)
		if money > 0 then
			GameTooltip:AddDoubleLine(player, self:GetCoinsText(money), 1,1,1, 1,1,1)
		end
	end
	
	GameTooltip:Show()
end

function MoneyFrame:OnLeave()
	GameTooltip:Hide()
end


--[[ Methods ]]--

function MoneyFrame:GetCoinsText(money)
	local gold, silver, copper = self:GetCoins(money)
	local text = ''

	if gold > 0 then
		text = text .. format(' %d|cffffd700%s|r', gold, GOLD_AMOUNT_SYMBOL)
	end

	if silver > 0 then
		text = text .. format(' %d|cffc7c7cf%s|r', silver, SILVER_AMOUNT_SYMBOL)
	end

	if copper > 0 or money == 0 then
		text = text .. format(' %d|cffeda55f%s|r', copper, COPPER_AMOUNT_SYMBOL)
	end

	return text
end

function MoneyFrame:GetCoins(money)
	local gold = floor(money / (COPPER_PER_SILVER * SILVER_PER_GOLD))
	local silver = floor((money - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER)
	local copper = money % COPPER_PER_SILVER
	return gold, silver, copper
end