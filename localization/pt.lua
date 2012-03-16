--[[
	Localization.lua
		Translations for Combuctor

	Português
	Translation by Jaliborc (João Cardoso) and madcampos
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
L.Bank = 'Banco'
L.TotalOnRealm = 'Total em %s'
L.ClickToPurchase = '<Clique> para comprar'
L.Bags = 'Sacos'
L.BagToggle = '<Clique-esquerdo> para mostrar os sacos'
L.InventoryToggle = '<Clique-direito> para mostrar o banco'
L.BankToggle = '<Clique-direito> para mostrar o banco'

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
	L.All = ALL
	L.Weapon, L.Armor, L.Container, L.Consumable, L.Glyph, L.TradeGood, L.Recipe, L.Gem, L.Misc, L.Quest = GetAuctionItemClasses()
	L.Trinket = _G['INVTYPE_TRINKET']
	L.Devices, L.Explosives = select(10, GetAuctionItemSubClasses(6))
	L.SimpleGem = select(8, GetAuctionItemSubClasses(7))
end

L.Normal = 'Normal'
L.Equipment = 'Equipamento'
L.Trade = 'Comércio'
L.Shards = 'Lascas'
L.SoulShard = 'Lascas de Alma'
L.Usable = 'Usável'