--[[
	German Translations
	
--]]

local L = LibStub("AceLocale-3.0"):NewLocale("Combuctor", "deDE")
if not L then return end

L.Updated = 'Aktualisiert auf v%s'

--binding actions
L.ToggleInventory = "Inventar umschalten"
L.ToggleBank = "Bank umschalten"

--frame titles
L.InventoryTitle = "Inventar von %s"
L.BankTitle = "Bank von %s"

--tooltips
L.Inventory = 'Inventar'
L.Total = 'Gesamt'
L.Bags = 'Taschen'
L.BagToggle = '<Linksklick>, um die Taschenanzeige ein-/auszuschalten'
L.InventoryToggle = '<Rechtsklick>, um dein Inventar zu zeigen/verstecken'
L.BankToggle = '<Rechtsklick>, um deine Bank zu zeigen/verstecken'
L.SortItems = '<Linksklick>, um Gegenstände zu sortieren.'
L.DepositReagents = '<Rechtsklick>, um Reagenzien im Materiallager einzulagern.'
L.PurchaseBag = 'Klicken, um diesen Bankplatz zu kaufen.'

--itemcount tooltips
L.TipCount1 = 'Angelegt: %d'
L.TipCount2 = 'Taschen: %d'
L.TipCount3 = 'Bank: %d'
L.TipCount4 = 'Vault: %d'
L.TipDelimiter = '|'

-- options
L.Sets = 'Sets'
L.Panel = 'Fenster'
L.OptionsSubtitle = 'Taschen sind hartnäckige Widersacher! Halte sie aufgeräumt.'
L.LeftFilters = 'Sets links anzeigen'
L.ActPanel = 'Als Standardfenster verhalten'
L.HighlightItemsByQuality = 'Gegenstände nach Qualität hervorheben'
L.HighlightNewItems = 'Neue Gegenstände hervorheben'  
L.HighlightUnusableItems = 'Benutzbare Gegenstände hervorheben'
L.HighlightSetItems = 'Ausrüstungssetgegenstände hervorheben'
L.HighlightQuestItems = 'Questgegenstände hervorheben'
L.TipCounts = 'Gegenstandsanzahl-Tooltip'

-- options tooltips
L.LeftFiltersTip = [[
Wenn aktiviert, werden die seitlichen Reiter
 auf der linken Seite des Fensters angezeigt.]]

L.ActPanelTip = [[
Wenn aktiviert, wird dieses Fenster sich automatisch wie die standardmäßigen Fenster, wie das |cffffffffZauberbuch|r
oder der |cffffffffDungeonbrowser|r, positionieren.]]

L.TipCountsTip = [[
Wenn aktiviert, zeigen Gegenstandstooltips dir,
 welcher Charakter diesen Gegenstand besitzt.]]

--these are automatically localized (aka, don't translate them :)
do
  L.General = GENERAL
  L.Weapon, L.Armor, L.Container, L.Consumable, L.Glyph, L.TradeGood, L.Recipe, L.Gem, L.Misc, L.Quest = GetAuctionItemClasses()
  L.Trinket = _G['INVTYPE_TRINKET']
  L.Devices, L.Explosives = select(10, GetAuctionItemSubClasses(6))
  L.SimpleGem = select(8, GetAuctionItemSubClasses(7))
end

L.Normal = 'Normal'
L.Equipment = 'Ausrüstung'
L.Trade = 'Handel'
L.Shards = 'Splitter'
L.SoulShard = 'Seelensplitter'
L.Usable = 'Benutzbar'
