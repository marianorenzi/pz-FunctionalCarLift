FunctionalCarLift = FunctionalCarLift or {}
FunctionalCarLift.CarsNearLift = {}

local carLiftSpriteNames = {
  ["location_business_machinery_01_0"] = true,
  ["location_business_machinery_01_1"] = true,
  ["location_business_machinery_01_2"] = true,
  ["location_business_machinery_01_3"] = true,
  ["location_business_machinery_01_4"] = true,
  ["location_business_machinery_01_5"] = true,
  ["location_business_machinery_01_8"] = true,
  ["location_business_machinery_01_9"] = true,
  ["location_business_machinery_01_10"] = true,
  ["location_business_machinery_01_11"] = true,
  ["location_business_machinery_01_12"] = true,
  ["location_business_machinery_01_13"] = true,
}

function CheckCarLiftNearby(vehicle)
  local range = 1  -- how close the Car Lift must be
  local square = vehicle:getSquare()
  local carLiftFound = false
  
  if square then
    for dx = -range, range do
      for dy = -range, range do
        local sq = square:getCell():getGridSquare(square:getX() + dx, square:getY() + dy, square:getZ())
        if sq then
          for i=0, sq:getObjects():size()-1 do
            local obj = sq:getObjects():get(i)
            if obj and carLiftSpriteNames[obj:getSprite():getName()] then
              carLiftFound = true
              break
            end
          end
        end
      end
    end
  end

  if carLiftFound == true then
    print("Car Lift found nearby")
    FunctionalCarLift.CarsNearLift[vehicle:getKeyId()] = true
  else
    print("Car Lift not found")
    FunctionalCarLift.CarsNearLift[vehicle:getKeyId()] = nil
  end
end

function IsCarLiftNearby(vehicle)
  if FunctionalCarLift.CarsNearLift[vehicle:getKeyId()] ~= nil then return FunctionalCarLift.CarsNearLift[vehicle:getKeyId()] end
  return false
end