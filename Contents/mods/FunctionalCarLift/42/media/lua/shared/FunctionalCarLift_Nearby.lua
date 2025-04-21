require "FunctionalCarLift"

function CheckCarLiftNearby(vehicle)
  local range = SandboxVars.FunctionalCarLift.Range  -- how close the Car Lift must be
  local square = vehicle:getSquare()
  local carLiftFound = false
  
  if square then
    for dx = -range, range do
      for dy = -range, range do
        local sq = square:getCell():getGridSquare(square:getX() + dx, square:getY() + dy, square:getZ())
        if sq then
          for i=0, sq:getObjects():size()-1 do
            local obj = sq:getObjects():get(i)
            if obj and FunctionalCarLift.IsCarLiftSprite(obj:getSprite():getName()) then
              if not SandboxVars.FunctionalCarLift.RequirePower or getWorld():isHydroPowerOn() or sq:haveElectricity() then
                carLiftFound = true
              end
              break
            end
          end
        end
      end
    end
  end

  if carLiftFound == true then
    print("[FunctionalCarLift] Car Lift found nearby")
    FunctionalCarLift.CarsNearLift[vehicle:getKeyId()] = true
  else
    print("[FunctionalCarLift] Car Lift not found or no power available")
    FunctionalCarLift.CarsNearLift[vehicle:getKeyId()] = nil
  end
end

function IsCarLiftNearby(vehicle)
  if FunctionalCarLift.CarsNearLift[vehicle:getKeyId()] ~= nil then return FunctionalCarLift.CarsNearLift[vehicle:getKeyId()] end
  return false
end