--[[
	Portuguese Translations
		By Jaliborc and madcampos
--]]

local L = LibStub("AceLocale-3.0"):NewLocale("Combuctor", "ptBR")
if not L then return end

L.Updated = 'Atualizado para a versão %s'

--binding actions
L.ToggleInventory = "Mostrar/Ocultar mochila"
L.ToggleBank = "Mostrar/Ocultar banco"

--frame titles
L.InventoryTitle = "Mochila de %s"
L.BankTitle = "Banco de %s"

--tooltips
L.Inventory = 'Mochila'
L.Total = 'Total'
L.ClickToPurchase = '<Clique> para comprar'
L.Bags = 'Sacos'
L.BagToggle = '<Clique-esquerdo> para mostrar os sacos'
L.InventoryToggle = '<Clique-direito> para mostrar o banco'
L.BankToggle = '<Clique-direito> para mostrar o banco'

--itemcount tooltips
L.TipCount1 = 'Equipado: %d'
L.TipCount2 = 'Mochila: %d'
L.TipCount3 = 'Banco: %d'
L.TipCount4 = 'Cofre: %d'

-- options
L.Sets = 'Conjuntos'
L.Panel = 'Janelas'
L.LeftFilters = 'Mostrar conjuntos à esquerda'
L.ActPanel = 'Comportar como painel padrão'

-- options tooltips
L.LeftFiltersTip = [[
Se ativado, as abas laterais serão
exibidas do lado esquerdo.]]

L.ActPanelTip = [[
Se ativado, este painel será imovível e se posicionará
automaticamente da mesma forma que os painéis padrão,como
o |cffffffffGrimório|r ou o |cffffffffLocalizador de Masmorras|r.]]

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
L.Equipment = 'Equipamento'
L.Trade = 'Comércio'
L.Shards = 'Lascas'
L.SoulShard = 'Lascas de Alma'
L.Usable = 'Usável'