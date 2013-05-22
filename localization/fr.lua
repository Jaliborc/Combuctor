--[[
  French Translations
	By Legrandseb2212
--]]

local L = LibStub("AceLocale-3.0"):NewLocale("Combuctor", "frFR")
if not L then return end

L.Updated = 'Mise à jour de v%s'

--binding actions
L.ToggleInventory = "Basculer inventaire"
L.ToggleBank = "Basculer banque"

--frame titles
L.InventoryTitle = "Inventaire de %s"
L.BankTitle = "Banque de %s"

--tooltips
L.Inventory = 'Inventaire'
L.Bank = 'Banque'
L.Total = 'Total'
L.ClickToPurchase = '<Click> pour comparer'
L.Bags = 'Sacs'
L.BagToggle = "<Click-gauche> pour afficher vos sacs."
L.InventoryToggle = '<Click-droit> pour afficher votre inventaire.'
L.BankToggle = '<Click-droit> pour afficher votre banque.'

--itemcount tooltips
L.TipCount1 = 'Équipé: %d'
L.TipCount2 = 'Sacs: %d'
L.TipCount3 = 'Banque: %d'
L.TipCount4 = 'Vault: %d'
L.TipDelimiter = '|'

-- options
L.Sets = 'Icon'
L.Panel = 'Panneau'
L.OptionsSubtitle = 'Les sacs sont des ennemis dangereux !. Les garder organisés.'
L.LeftFilters = 'Afficher les Icons sur la gauche'
L.ActPanel = 'Agir en tant que panneau standard'
L.TipCounts = "Activer la possession d'article dans l'infobulle." 

-- options tooltips
L.LeftFiltersTip = [[
S'il est activé, les onglets latéraux seront
affichée sur le côté gauche du panneau.]]

L.ActPanelTip = [[
S'il est activé, ce panneau va automatiquement se positionner
lui-même, faire comme les standards, comme |cffffffffSpellbook|r
ou |cffffffffDungeon Finder|r, et ne sera pas mobile.]]

L.TipCountsTip = [[S'il est activé, les info-bulles afficheront lequel de vos personnages en a en sa possession.]]

--these are automatically localized (aka, don't translate them :)
do
  L.General = GENERAL
	L.All = ALL
	L.Weapon, L.Armor, L.Container, L.Consumable, L.Glyph, L.TradeGood, L.Recipe, L.Gem, L.Misc, L.Quest, L.BattlePets = GetAuctionItemClasses()
	L.Trinket = _G['INVTYPE_TRINKET']
	L.Devices, L.Explosives = select(10, GetAuctionItemSubClasses(6))
	L.SimpleGem = select(8, GetAuctionItemSubClasses(7))
end

L.Normal = 'Normal'
L.Equipment = 'Equipement'
L.Trade = 'Commerce'
L.Shards = 'Éclats'
L.SoulShard = "Fragment d'âme"
L.Usable = 'Utilisable'
