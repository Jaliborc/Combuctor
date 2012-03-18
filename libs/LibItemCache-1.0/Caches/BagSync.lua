--[[
Copyright 2011-2012 João Cardoso
LibItemCache is distributed under the terms of the GNU General Public License (or the Lesser GPL).
This file is part of LibItemCache.

LibItemCache is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

LibItemCache is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with LibItemCache. If not, see <http://www.gnu.org/licenses/>.
--]]

local Lib = LibStub('LibItemCache-1.0')
if not BagSync or Lib:HasCache() then
  return
end

local Cache, Realm = Lib:NewCache()
local Realm = BagSyncDB[Realm]
local CLASS = 'class'
local MONEY = 'gold'


--[[ Items ]]--

function Cache:GetBag (player, bag, _, isBank)
  local type = 'bd:' .. (isBank and 'bank:' or 'bag:')
  local bag = Realm[player][type .. bag]
  if bag then
    local size, id = strsplit(',', bag)
    return id, size
  end
end

function Cache:GetItem (player, bag, slot, isBank)
  local type = isBank and 'bank:' or 'bag:'
  local item = Realm[player][type .. bag .. ':' .. slot]
  if item then
    return strsplit(',', item)
  end
end

function Cache:GetMoney (player)
  return Realm[player][MONEY]
end


--[[ Players ]]--

function Cache:GetPlayer (player)
  return Realm[player][CLASS]
end

function Cache:DeletePlayer (player)
  Realm[player] = nil
end

function Cache:GetPlayers ()
  return Realm
end