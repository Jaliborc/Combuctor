--[[
	Simplified Chinese Translations for Combuctor
--]]

local L = LibStub("AceLocale-3.0"):NewLocale("Combuctor", "zhCN")
if not L then return end

L.Updated = '更新至v%s'

--binding actions
L.ToggleInventory = "打开/关闭存货清单"
L.ToggleBank = "打开/关闭银行"

--frame titles
L.InventoryTitle = "%s的存货清单"
L.BankTitle = "%s的银行"

--tooltips
L.Inventory = '存货清单'
L.Bank = '银行'
L.Total = '总计'
L.ClickToPurchase = '<点击>购买'
L.Bags = '背包'
L.BagToggle = '<左键点击>打开/关闭背包列表'
L.InventoryToggle = '<右键点击>打开/关闭存货清单'
L.BankToggle = '<右键点击>打开/关闭银行（为历史记录，不一定符合银行现况）'

--itemcount tooltips
L.TipCount1 = '装备中: %d'
L.TipCount2 = '背包: %d'
L.TipCount3 = '银行: %d'
L.TipCount4 = '虚空仓库: %d'
L.TipDelimiter = '|'

-- options
L.Sets = '装备分类'
L.Panel = '面板'
L.OptionsSubtitle = '胖次们可是危险的敌人哦！让它们听话地排排坐吧。'
L.LeftFilters = '将物品分类栏显示在窗体左侧'
L.ActPanel = '作为标准面板运作'
L.TipCounts = '在道具的信息提示悬浮窗中启用道具计数器'

-- options tooltips
L.LeftFiltersTip = [[
若勾选，物品分类栏将显示在此面板左侧。]]

L.ActPanelTip = [[
若勾选，则此面板将自动定位在普通面板所定位的地方，
如|cffffffff法术书和技能|r界面或|cffffffff地下城查找器|r界面
默认出现的地点，且不可被移动。]]

L.TipCountsTip = [[
若勾选，道具的信息提示悬浮窗将显示哪位角色拥有
这项道具，拥有多少，以及这些道具处于何方。]]

--these are automatically localized (aka, don't translate them :)
do
  L.General = GENERAL
	L.All = ALL
	L.Weapon, L.Armor, L.Container, L.Consumable, L.Glyph, L.TradeGood, L.Recipe, L.Gem, L.Misc, L.Quest = GetAuctionItemClasses()
	L.Trinket = _G['INVTYPE_TRINKET']
	L.Devices, L.Explosives = select(10, GetAuctionItemSubClasses(6))
	L.SimpleGem = select(8, GetAuctionItemSubClasses(7))
end

L.Normal = '普通'
L.Equipment = '装备'
L.Trade = '商业'
L.Shards = '碎片'
L.SoulShard = '灵魂碎片'
L.Usable = '可使用道具'
