
--[[
	Korean Translations
		By Bruteforce and 노분노씹새끼
--]]

local L = LibStub("AceLocale-3.0"):NewLocale("Combuctor", "koKR")
if not L then return end

L.Updated = 'v%s 로 업데이트 되었습니다'

--binding actions
L.ToggleInventory = "가방 토글"
L.ToggleBank = "은행 토글"

--frame titles
L.InventoryTitle = "%s'의 가방"
L.BankTitle = "%s'의 은행"

--tooltips
L.Inventory = '가방'
L.Bank = '은행'
L.Total = '합계'
L.ClickToPurchase = '<클릭> 으로 구매'
L.Bags = '가방'
L.BagToggle = '<왼쪽 클릭> 으로 가방보기'
L.InventoryToggle = '<오른쪽 클릭> 으로 가방보기 '
L.BankToggle = '<오른쪽 클릭> 으로 은행보기'

--itemcount tooltips
L.TipCount1 = '착용중: %d'
L.TipCount2 = '가방: %d'
L.TipCount3 = '은행: %d'
L.TipCount4 = '금고: %d'
L.TipDelimiter = '|'

-- options
L.Sets = '셋트'
L.Panel = '패널'
L.LeftFilters = '셋트를 왼쪽에 표시'
L.ActPanel = '표준 패널로 지정'
L.TipCounts = '툴팁에 아이템 갯수를 표시'

-- options tooltips
L.LeftFiltersTip = [[체크하면 탭을 패널왼쪽에 표시합니다]]
L.ActPanelTip = [[체크하면 자동으로 마법책이나 던전 찾기 처럼 표준 패널로 지정되고 이동이 불가능해집니다]]
L.TipCountsTip = [[체크하면 아이템툴팁에 보유량을 표시합니다]]