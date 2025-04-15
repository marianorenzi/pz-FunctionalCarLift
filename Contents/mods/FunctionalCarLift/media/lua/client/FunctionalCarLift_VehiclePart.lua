require("FunctionalCarLift")

local index = __classmetatables[VehiclePart.class].__index
local old_getTable = index.getTable
index.getTable = function(self, ...)
  local keyvalues = old_getTable(self, ...)

  if keyvalues ~= nil and IsCarLiftNearby(self:getVehicle()) then
    for i = 1, #keyvalues.items - 1 do
      local item = keyvalues.items[i]
      if item.type == "Base.Jack" then
        table.remove(keyvalues.items, i)
        break
      end
    end
  end
  
  return keyvalues
end