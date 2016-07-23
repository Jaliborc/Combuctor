--[[
	Traditional Chinese
		By Irene Wang
--]]

local L = LibStub("AceLocale-3.0"):NewLocale("Combuctor", "zhTW")
if not L then return end


L.Updated = '更新到%s版'

--binding actions
L.ToggleInventory = "打開或關閉背包"
L.ToggleBank = "打開或關閉銀行"

--frame titles
L.InventoryTitle = "%s的背包"
L.BankTitle = "%s的銀行"

--tooltips
L.Inventory = '背包'
L.Total = '總'
L.ClickToPurchase = '<點選>購買'
L.Bags = '容器'
L.BagToggle = '<左鍵點選>顯示或隱藏容器'
L.InventoryToggle = '<右鍵點選>打開或關閉背包視窗'
L.BankToggle = '<右鍵點選>打開或關閉銀行視窗'

L.Normal = '一般'
L.Equipment = '裝備'
L.Trade = '商業'
L.Ammo = '彈藥'
L.Shards = '碎片'
L.SoulShard = '靈魂碎片'
L.Usable = '消耗品'

--itemcount tooltips
L.TipCount1 = ', 已裝備: %d'
L.TipCount2 = ', 背包: %d'
L.TipCount3 = ', 銀行: %d'

--these are automatically localized (aka, don't translate them :)
do
  L.General = GENERAL
  L.Weapon = GetItemClassInfo(LE_ITEM_CLASS_WEAPON)
  L.Armor = GetItemClassInfo(LE_ITEM_CLASS_ARMOR)
  L.Container = GetItemClassInfo(LE_ITEM_CLASS_CONTAINER)
  L.Consumable = GetItemClassInfo(LE_ITEM_CLASS_CONSUMABLE)
  L.Glyph = GetItemClassInfo(LE_ITEM_CLASS_GLYPH)
  L.TradeGood = GetItemClassInfo(LE_ITEM_CLASS_TRADEGOODS)
  L.Recipe = GetItemClassInfo(LE_ITEM_CLASS_RECIPE)
  L.Gem = GetItemClassInfo(LE_ITEM_CLASS_GEM)
  L.Misc = GetItemClassInfo(LE_ITEM_CLASS_MISCELLANEOUS)
  L.Quest = GetItemClassInfo(LE_ITEM_CLASS_QUESTITEM)
  L.Trinket = _G['INVTYPE_TRINKET']
end
