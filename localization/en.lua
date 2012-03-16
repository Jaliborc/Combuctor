--[[
	Localization.lua
		Translations for Combuctor

	English: Default language
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
L.Bank = 'Bank'
L.TotalOnRealm = 'Total on %s'
L.ClickToPurchase = '<Click> to purchase'
L.Bags = 'Bags'
L.BagToggle = '<Left-Click> to toggle the bag display'
L.InventoryToggle = '<Right-Click> to toggle your inventory'
L.BankToggle = '<Right-Click> to toggle your bank'

-- options
L.Sets = 'Sets'
L.Panel = 'Panel'
L.OptionsSubtitle = 'Pants are a dangerous foe! Keep them organized.'
L.LeftFilters = 'Display Sets on Left'
L.ActPanel = 'Act as Standard Panel'

-- options tooltips
L.LeftFiltersTip = [[
If enabled, the side tabs will be
displayed on the left side of the panel.]]

L.ActPanelTip = [[
If enabled, this panel will automatically position
itself as the standard ones do, such as the |cffffffffSpellbook|r
or the |cffffffffDungeon Finder|r, and will not be movable.]]

--these are automatically localized (aka, don't translate them :)
do
  L.General = GENERAL
	L.All = ALL
	L.Weapon, L.Armor, L.Container, L.Consumable, L.Glyph, L.TradeGood, L.Recipe, L.Gem, L.Misc, L.Quest = GetAuctionItemClasses()
	L.Trinket = _G['INVTYPE_TRINKET']
	L.Devices, L.Explosives = select(10, GetAuctionItemSubClasses(6))
	L.SimpleGem = select(8, GetAuctionItemSubClasses(7))
end

L.Normal = 'Normal'
L.Equipment = 'Equipment'
L.Trade = 'Trade'
L.Shards = 'Shards'
L.SoulShard = 'Soul Shard'
L.Usable = 'Usable'