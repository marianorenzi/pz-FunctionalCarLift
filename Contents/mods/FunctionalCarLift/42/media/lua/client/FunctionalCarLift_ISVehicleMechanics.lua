require("FunctionalCarLift")

--hook the menu to install our button
local old_ISVehicleMechanics_onListRightMouseUp = ISVehicleMechanics.onListRightMouseUp
function ISVehicleMechanics:onListRightMouseUp(x,y)
  print("onListRightMouseUp for vehicle: "..self.parent.vehicle:getScript():getName()..' ('..tostring(self.parent.vehicle)..')')
  CheckCarLiftNearby(self.parent.vehicle)
  return old_ISVehicleMechanics_onListRightMouseUp(self,x,y);
end

local old_ISVehicleMechanics_doPartContextMenu = ISVehicleMechanics.doPartContextMenu
function ISVehicleMechanics:doPartContextMenu(part,x,y)
  print("doPartContextMenu for vehicle: "..self.vehicle:getScript():getName()..' ('..tostring(self.vehicle)..')')
  CheckCarLiftNearby(self.vehicle)
  return old_ISVehicleMechanics_doPartContextMenu(self,part,x,y);
end

local old_ISVehicleMechanics_onRightMouseUp = ISVehicleMechanics.onRightMouseUp
function ISVehicleMechanics:onRightMouseUp(x, y)
  print("onRightMouseUp for vehicle: "..self.vehicle:getScript():getName()..' ('..tostring(self.vehicle)..')')
  CheckCarLiftNearby(self.vehicle)
  return old_ISVehicleMechanics_onRightMouseUp(self,x,y);
end