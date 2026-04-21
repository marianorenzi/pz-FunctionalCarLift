require("FunctionalCarLift")

local index = __classmetatables[VehiclePart.class].__index
local old_getTable = index.getTable
index.getTable = function(self, ...)
  
  local keyvalues = old_getTable(self, ...)
  if not keyvalues then
    -- print("[FunctionalCarLift] VehiclePart.getTable invalid return value: "..tostring(keyvalues))
    return keyvalues
  end

  local items = keyvalues.items
  if not items then
    -- print("[FunctionalCarLift] VehiclePart.getTable no items: "..tostring(items))
    return keyvalues
  end

  if not IsCarLiftNearby(self:getVehicle()) then
    -- print("[FunctionalCarLift] VehiclePart.getTable no lift nearby, skipping item removal")
    return keyvalues
  end

  if type(items) == "table" then
    for i = #items, 1, -1 do
      local item = items[i]
      local itemType = item and (item.type or (item.getFullType and item:getFullType()))
      -- print("[FunctionalCarLift] VehiclePart.items["..i.."].type: "..tostring(itemType))
      if item.type == "Base.Jack" then
        print("[FunctionalCarLift] VehiclePart.getTable: "..tostring(self:getVehicle()).." has a lift nearby, removing jack from part items")
        table.remove(items, i)
        break
      end
    end
  else
    -- print("[FunctionalCarLift] VehiclePart.getTable unsupported VehiclePart.items type: "..type(keyvalues))
  end
  
  return keyvalues
end
