--[[
	Russian	Translations
		By ZZa
--]]

local L = LibStub("AceLocale-3.0"):NewLocale("Combuctor", "ruRU")
if not L then return end

L.Updated = 'Обновлен для v%s'

--binding actions
L.ToggleInventory = "Инвентарь"
L.ToggleBank = "Банк"

--frame titles
L.InventoryTitle = "%s: Инвентарь"
L.BankTitle = "%s: Банк"

--tooltips
L.Inventory = 'Инвентарь'
L.Total = 'Всего'
L.ClickToPurchase = '<Кликните> чтобы приобрести'
L.Bags = 'Сумки'
L.BagToggle = '<ЛеваяКнопкаМыши> Показать сумки'
L.InventoryToggle = '<ПраваяКнопкаМыши> Показать окно инвентаря'
L.BankToggle = '<ПраваяКнопкаМыши> Показать окно банка'

L.Normal = 'Обычное'
L.Equipment = 'Обмундирование'
L.Trade = 'Товары'
L.Ammo = 'Боеприпасы'
L.Shards = 'Камни'
L.SoulShard = 'Камни душ'
L.Usable = 'Расходуемые'

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
