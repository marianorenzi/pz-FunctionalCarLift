local convertVanilla = {
  ["location_business_machinery_01_11"] = "car_lift_01_0",
  ["location_business_machinery_01_13"] = "car_lift_01_3",
  ["location_business_machinery_01_2"] = "car_lift_01_7",
  ["location_business_machinery_01_0"] = "car_lift_01_4",
  ["location_business_machinery_01_9"] = "next_WE",
  ["location_business_machinery_01_4"] = "next_NS",
  ["location_business_machinery_01_1"] = "remove",
  ["location_business_machinery_01_3"] = "remove",
  ["location_business_machinery_01_5"] = "remove",
  ["location_business_machinery_01_8"] = "remove",
  ["location_business_machinery_01_10"] = "remove",
  ["location_business_machinery_01_12"] = "remove",
}

local convertVanillaNextWE = {
  ["car_lift_01_0"] = "car_lift_01_1",
  ["location_business_machinery_01_11"] = "car_lift_01_1",
  ["car_lift_01_1"] = "car_lift_01_2",
  ["location_business_machinery_01_9"] = "car_lift_01_2",
}

local convertVanillaIsPrevWE = {
  "car_lift_01_0",
  "location_business_machinery_01_11",
  "car_lift_01_1",
  "location_business_machinery_01_9",
}

local convertVanillaNextNS = {
  ["car_lift_01_7"] = "car_lift_01_6",
  ["location_business_machinery_01_2"] = "car_lift_01_6",
  ["car_lift_01_6"] = "car_lift_01_5",
  ["location_business_machinery_01_4"] = "car_lift_01_5",
}

local convertVanillaIsPrevNS = {
  "car_lift_01_7",
  "location_business_machinery_01_2",
  "car_lift_01_6",
  "location_business_machinery_01_4",
}

local revertVanilla = {
  ["car_lift_01_0"] = {"location_business_machinery_01_8", "location_business_machinery_01_11"},
  ["car_lift_01_1"] = {"location_business_machinery_01_9", "location_business_machinery_01_12"},
  ["car_lift_01_2"] = {"location_business_machinery_01_9", "location_business_machinery_01_12"},
  ["car_lift_01_3"] = {"location_business_machinery_01_10", "location_business_machinery_01_13"},
  ["car_lift_01_4"] = {"location_business_machinery_01_3", "location_business_machinery_01_0"},
  ["car_lift_01_5"] = {"location_business_machinery_01_4", "location_business_machinery_01_1"},
  ["car_lift_01_6"] = {"location_business_machinery_01_4", "location_business_machinery_01_1"},
  ["car_lift_01_7"] = {"location_business_machinery_01_5", "location_business_machinery_01_2"},
}

local function convertVanillaSprite(square)
  local objects = square:getObjects()
  for i = objects:size() - 1, 0, -1 do
    local obj = objects:get(i)
    local spriteName = obj:getSprite():getName()
    local conversionResult = convertVanilla[spriteName]

    if conversionResult == "remove" then
      -- remove filler vanilla tiles
      print("[FunctionalCarLift] Removing filler car lift tile "..spriteName.." at X="..square:getX()..", Y="..square:getY())
      square:RemoveTileObject(obj)
      if isServer() then square:transmitRemoveItemFromSquare(obj) end
    elseif conversionResult == "next_WE" then
      -- replace center WE pieces
      local prevSprite = FunctionalCarLift.SquareGetOneOfSprites(square:getCell():getGridSquare(square:getX() - 1, square:getY(), square:getZ()), convertVanillaIsPrevWE)
      if prevSprite ~= nil then
        print("[FunctionalCarLift] Replacing center car lift tile "..spriteName.." with "..convertVanillaNextWE[prevSprite].." at X="..square:getX()..", Y="..square:getY())
        obj:setSpriteFromName(convertVanillaNextWE[prevSprite])
        if isServer() then obj:transmitUpdatedSpriteToClients(); end
      else
        print("[FunctionalCarLift] ERROR: Found vanilla car lift WE center tile without column at X="..square:getX()..", Y="..square:getY())
      end
    elseif conversionResult == "next_NS" then
      -- replace center NS pieces
      local prevSprite = FunctionalCarLift.SquareGetOneOfSprites(square:getCell():getGridSquare(square:getX(), square:getY() - 1, square:getZ()), convertVanillaIsPrevNS)
      if prevSprite ~= nil then
        print("[FunctionalCarLift] Replacing center car lift tile "..spriteName.." with "..convertVanillaNextNS[prevSprite].." at X="..square:getX()..", Y="..square:getY())
        obj:setSpriteFromName(convertVanillaNextNS[prevSprite])
        if isServer() then obj:transmitUpdatedSpriteToClients(); end
      else
        print("[FunctionalCarLift] ERROR: Found vanilla car lift NS center tile without column at X="..square:getX()..", Y="..square:getY())
      end
    elseif conversionResult ~= nil then
      -- replace columns
      print("[FunctionalCarLift] Replacing column car lift tile "..spriteName.." with "..conversionResult.." at X="..square:getX()..", Y="..square:getY())
      obj:setSpriteFromName(conversionResult)
      if isServer() then obj:transmitUpdatedSpriteToClients(); end
    end
  end
end

local function revertToVanillaSprite(square)
  local objects = square:getObjects()
  for i = objects:size() - 1, 0, -1 do
    local obj = objects:get(i)
    local spriteName = obj:getSprite():getName()
    local revertResult = revertVanilla[spriteName]

    if revertResult ~= nil then
      print("[FunctionalCarLift] Reverting car lift tile "..spriteName.." with "..revertResult[1].." and "..revertResult[2].." at X="..square:getX()..", Y="..square:getY())
      obj:setSpriteFromName(revertResult[1])
      square:AddTileObject(IsoObject.getNew(square, revertResult[2], nil, false))
      if isServer() then 
        obj:transmitUpdatedSpriteToClients(); 
        square:transmitAddObjectToSquare(newObj, newObj:getObjectIndex()); 
      end
    end
  end
end

local function functionalCarLift_OnLoadGridSquare(square)
  if square == nil then return end

  if SandboxVars.FunctionalCarLift.ConvertVanilla then
    convertVanillaSprite(square)
  elseif SandboxVars.FunctionalCarLift.RevertVanilla then
    revertToVanillaSprite(square)
  end
end

Events.LoadGridsquare.Add(functionalCarLift_OnLoadGridSquare)