--[[
	Localization.lua
	简体中文 zhCN
		Translations for Combuctor
--]]


local L = LibStub("AceLocale-3.0"):NewLocale("Combuctor", "zhCN")
if not L then return end

L.Updated = 'Updated to v%s'

--binding actions
L.ToggleInventory = "显示背包"
L.ToggleBank = "显示银行"

--frame titles
L.InventoryTitle = "%s的背包"
L.BankTitle = "%s的银行"

--tooltips
L.Inventory = '整合背包'
L.Bank = '银行'
L.TotalOnRealm = '总计 %s'
L.ClickToPurchase = '<点击> 购买'
L.Bags = '背包'
L.BagToggle = '<左键点击> 切换是否显示背包'
L.InventoryToggle = '<右键点击> 显示整合背包'
L.BankToggle = '<右键点击> 显示银行'

L.Normal = '常规'
L.Equipment = '装备'
L.Trade = '商业'
L.Ammo = '弹药'
L.Shards = '碎片'
L.Usable = '消耗品'