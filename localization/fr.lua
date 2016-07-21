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
L.Equipment = 'Equipement'
L.Trade = 'Commerce'
L.Shards = 'Éclats'
L.SoulShard = "Fragment d'âme"
L.Usable = 'Utilisable'
