--[[
	English Translations
		Default language
--]]

local L = LibStub("AceLocale-3.0"):NewLocale("Combuctor", "enUS", true)

L.Updated = 'Updated to v%s'

--binding actions
L.ToggleInventory = "Toggle Inventory"
L.ToggleBank = "Toggle Bank"

--frame titles
L.InventoryTitle = "%s's Inventory"
L.BankTitle = "%s's Bank"

--tooltips
L.Inventory = 'Inventory'
L.Total = 'Total'
L.Bags = 'Bags'
L.BagToggle = '<Left-Click> to toggle the bag display'
L.InventoryToggle = '<Right-Click> to toggle your inventory'
L.BankToggle = '<Right-Click> to toggle your bank'
L.SortItems = '<Left-Click> to sort items.'
L.DepositReagents = '<Right-Click> to deposit reagents in reagent bank.'
L.PurchaseBag = 'Click to purchase this bank slot.'

--itemcount tooltips
L.TipCount1 = 'Equipped: %d'
L.TipCount2 = 'Bags: %d'
L.TipCount3 = 'Bank: %d'
L.TipCount4 = 'Vault: %d'
L.TipDelimiter = '|'

-- options
L.Sets = 'Sets'
L.Panel = 'Panel'
L.OptionsSubtitle = 'Pants are a dangerous foe! Keep them organized.'
L.LeftFilters = 'Display Sets on Left'
L.ActPanel = 'Act as Standard Panel'
L.HighlightItemsByQuality = 'Highlight Items by Quality'
L.HighlightNewItems = 'Highlight New Items'  
L.HighlightUnusableItems = 'Highlight Unusable Items'
L.HighlightSetItems = 'Highlight Equipment Set Items'
L.HighlightQuestItems = 'Highlight Quest Items'
L.TipCounts = 'Tooltip Item Count'

-- options tooltips
L.LeftFiltersTip = [[
If enabled, the side tabs will be
displayed on the left side of the panel.]]

L.ActPanelTip = [[
If enabled, this panel will automatically position
itself as the standard ones do, such as the |cffffffffSpellbook|r
or the |cffffffffDungeon Finder|r, and will not be movable.]]

L.TipCountsTip = [[
If enabled, item tooltips will show
which of your characters possess it.]]

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

L.Normal = 'Normal'
L.Equipment = 'Equipment'
L.Trade = 'Trade'
L.Shards = 'Shards'
L.SoulShard = 'Soul Shard'
L.Usable = 'Usable'