--[[
  playerDropdown.lua
    A player selector dropdown
--]]

local AddonName, Addon = ...
local Cache = LibStub('LibItemCache-1.0')
if not Cache:HasCache() then
  return
end

local Target
local Dropdown
local Info = {}

local function CharSelect_OnClick(self, player, delete)
	if delete then
    	-- set to current player if deleted is selected
		if player == Target:GetPlayer() then
      		Target:SetPlayer(UnitName('player'))
    	end

		Cache:DeletePlayer(player)
	else
		Target:SetPlayer(player)
	end

	--hide the previous dropdown menus (hack)
	for i = 1, UIDROPDOWNMENU_MENU_LEVEL-1 do
		_G['DropDownList'..i]:Hide()
	end
end

--adds a checkable item to a dropdown menu
local function AddItem(text, checkable, checked, hasArrow, level, arg1, arg2)
	Info.func = CharSelect_OnClick
	Info.text = text
	Info.value = text
	Info.hasArrow = hasArrow
	Info.notCheckable = not checkable
	Info.checked = checked
	Info.arg1 = arg1
	Info.arg2 = arg2
	UIDropDownMenu_AddButton(Info, level)
end

--populate the list, add a delete button to all characters that aren't the current player
local function CharSelect_Initialize(self, level)
	if level == 2 then
		AddItem(REMOVE, nil, nil, nil, level, UIDROPDOWNMENU_MENU_VALUE, true)
	else
		local selected = Target:GetPlayer()

    	for i, player in Cache:IteratePlayers() do
      		AddItem(player, true, player == selected, Cache:IsPlayerCached(player), level, player)
    	end
	end
end

local function CharSelect_Create()
	Dropdown = CreateFrame("Frame", AddonName .. 'PlayerDropdown', UIParent, 'UIDropDownMenuTemplate')
	Dropdown:SetID(1)
	
	UIDropDownMenu_Initialize(Dropdown, CharSelect_Initialize, "MENU")
	return Dropdown
end


--[[ Usable Function ]]--

--show the character select list at the given location
function Addon:TogglePlayerDropdown(anchor, target, offX, offY)
 	Target = target
	ToggleDropDownMenu(1, nil, Dropdown or CharSelect_Create(), anchor, offX, offY)
end