require "FunctionalCarLift"

local craftableLiftSprites = {
  "car_lift_01_8",
  "car_lift_01_9",
  "car_lift_01_10",
  "car_lift_01_11",
  "car_lift_01_12",
  "car_lift_01_13",
}

local craftableColumnSearchTable = {
  ["car_lift_01_8"] = "E",
  ["car_lift_01_9"] = "W",
  ["car_lift_01_10"] = "N",
  ["car_lift_01_11"] = "S",
  ["car_lift_01_12"] = "WE",
  ["car_lift_01_13"] = "NS",
}

local craftableColumnSearchResult = {
  ["car_lift_01_8"] = "W",
  ["car_lift_01_9"] = "E",
  ["car_lift_01_10"] = "S",
  ["car_lift_01_11"] = "N",
  ["car_lift_01_12"] = "WE",
  ["car_lift_01_13"] = "NS",
}

local function findCraftableLiftColumn(square, searchDirection, requireCenterPieces)
  requireCenterPieces = requireCenterPieces or true
  -- validate there are center pieces
  local foundCenterPiece = false

  while square ~= nil do
    -- advance square in search direction
    if searchDirection == "E" then
      square = square:getCell():getGridSquare(square:getX() + 1, square:getY(), square:getZ())
    elseif searchDirection == "W" then
      square = square:getCell():getGridSquare(square:getX() - 1, square:getY(), square:getZ())
    elseif searchDirection == "N" then
      square = square:getCell():getGridSquare(square:getX(), square:getY() - 1, square:getZ())
    elseif searchDirection == "S" then
      square = square:getCell():getGridSquare(square:getX(), square:getY() + 1, square:getZ())
    end

    local spriteName = FunctionalCarLift.SquareGetOneOfSprites(square, craftableLiftSprites)
    local searchResult = craftableColumnSearchResult[spriteName]

    if searchResult == searchDirection then
      break
    elseif searchResult and string.find(craftableColumnSearchResult[spriteName], searchDirection) then
      foundCenterPiece = true
    else
      print("[FunctionalCarLift] Incomplete car lift structure.")
      square = nil
    end
  end
  
  -- return nil if a center piece was not found
  if requireCenterPieces and not foundCenterPiece then return nil end

  return square
end

local function checkFullCraftableLift(square, initialSpriteName)
  initialSpriteName = initialSpriteName or FunctionalCarLift.SquareGetOneOfSprites(square, craftableLiftSprites)

  local searchDirection = craftableColumnSearchTable[initialSpriteName]

  if searchDirection == nil then return false
  elseif searchDirection == "WE" then return findCraftableLiftColumn(findCraftableLiftColumn(square, "W", false), "E") ~= nil
  elseif searchDirection == "NS" then return findCraftableLiftColumn(findCraftableLiftColumn(square, "N", false), "S") ~= nil 
  else return findCraftableLiftColumn(square, searchDirection) ~= nil end
end

function CheckCarLiftNearby(vehicle)
  local range = SandboxVars.FunctionalCarLift.Range  -- how close the Car Lift must be
  local square = vehicle:getSquare()
  local carLiftFound = false

  if square then
    if not SandboxVars.FunctionalCarLift.RequirePower or getWorld():isHydroPowerOn() or square:haveElectricity() then
      for dx = -range, range do
        for dy = -range, range do
          local sq = square:getCell():getGridSquare(square:getX() + dx, square:getY() + dy, square:getZ())
          if sq then
            for i=0, sq:getObjects():size()-1 do
              local obj = sq:getObjects():get(i)
              if obj then
                local spriteName = obj:getSprite():getName()
                if FunctionalCarLift.IsCarLiftSprite(spriteName) or checkFullCraftableLift(square, spriteName) then
                  carLiftFound = true
                  break
                end
              end
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