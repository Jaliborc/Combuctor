local WoWTest = LibStub('WoWTest')
local Lib = LibStub('LibItemCache-1.0')

local AreEqual, Replace = WoWTest.AreEqual, WoWTest.Replace
local Tests = WoWTest:New('GET_ITEM_INFO_RECEIVED')


--[[ Links ]]--

function Tests:ProcessNothing()
	AreEqual(nil, Lib:ProcessLink(nil))
end

function Tests:ProcessItemLink()
	local results = {Lib:ProcessLink('49623')}
	local expected = {
		'Interface\\Icons\\inv_axe_113',
		'|cffff8000|Hitem:49623:0:0:0:0:0:0:0:29:0:0|h[Shadowmourne]|h|r',
		5
	}
	
	AreEqual(expected, results)
end

function Tests:ProcessPetLink()
	local results = {Lib:ProcessLink('236:1:2:157:157:10:10')}
	local expected = {
		strupper('Interface\\Icons\\Ability_Mount_Raptor.blp'),
		'|cff1eff00|Hbattlepet:236:1:2:157:157:10:10|h[Obsidian Hatchling]|h|r',
		2
	}

	AreEqual(expected, results)
end

