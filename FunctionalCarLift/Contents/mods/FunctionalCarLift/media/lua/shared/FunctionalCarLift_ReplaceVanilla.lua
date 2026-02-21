local convertVanilla = {
  -- vanilla conversion
  ["location_business_machinery_01_11"] = "car_lift_01_8", -- W
  ["location_business_machinery_01_13"] = "car_lift_01_9", -- E
  ["location_business_machinery_01_2"] = "car_lift_01_11", -- N
  ["location_business_machinery_01_0"] = "car_lift_01_10", -- S
  ["location_business_machinery_01_9"] = "car_lift_01_12", -- WE
  ["location_business_machinery_01_4"] = "car_lift_01_13", -- NS
  ["location_business_machinery_01_1"] = "remove",
  ["location_business_machinery_01_3"] = "remove",
  ["location_business_machinery_01_5"] = "remove",
  ["location_business_machinery_01_8"] = "remove",
  ["location_business_machinery_01_10"] = "remove",
  ["location_business_machinery_01_12"] = "remove",
  -- backward compatibility conversion (old tiles)
  ["car_lift_01_0"] = "car_lift_01_8", -- W
  ["car_lift_01_3"] = "car_lift_01_9", -- E
  ["car_lift_01_7"] = "car_lift_01_11", -- N
  ["car_lift_01_4"] = "car_lift_01_10", -- S
  ["car_lift_01_1"] = "car_lift_01_12", -- WE
  ["car_lift_01_2"] = "car_lift_01_12", -- WE
  ["car_lift_01_5"] = "car_lift_01_13", -- NS
  ["car_lift_01_6"] = "car_lift_01_13", -- NS
}

FunctionalCarLift.CraftableCarLiftSpriteNames = {
  ["car_lift_01_8"] = true, -- W
  ["car_lift_01_9"] = true, -- E
  ["car_lift_01_10"] = true, -- S
  ["car_lift_01_11"] = true, -- N
  ["car_lift_01_12"] = true, -- WE
  ["car_lift_01_13"] = true, -- NS
}

local revertVanilla = {
  -- backward compatibility (old tiles)
  ["car_lift_01_0"] = {"location_business_machinery_01_8", "location_business_machinery_01_11"},
  ["car_lift_01_1"] = {"location_business_machinery_01_9", "location_business_machinery_01_12"},
  ["car_lift_01_2"] = {"location_business_machinery_01_9", "location_business_machinery_01_12"},
  ["car_lift_01_3"] = {"location_business_machinery_01_10", "location_business_machinery_01_13"},
  ["car_lift_01_4"] = {"location_business_machinery_01_3", "location_business_machinery_01_0"},
  ["car_lift_01_5"] = {"location_business_machinery_01_4", "location_business_machinery_01_1"},
  ["car_lift_01_6"] = {"location_business_machinery_01_4", "location_business_machinery_01_1"},
  ["car_lift_01_7"] = {"location_business_machinery_01_5", "location_business_machinery_01_2"},
  -- craftable tiles
  ["car_lift_01_8"] = {"location_business_machinery_01_8", "location_business_machinery_01_11"}, -- W
  ["car_lift_01_12"] = {"location_business_machinery_01_9", "location_business_machinery_01_12"}, -- WE
  ["car_lift_01_9"] = {"location_business_machinery_01_10", "location_business_machinery_01_13"}, -- E
  ["car_lift_01_10"] = {"location_business_machinery_01_3", "location_business_machinery_01_0"}, -- S
  ["car_lift_01_13"] = {"location_business_machinery_01_4", "location_business_machinery_01_1"}, -- NS
  ["car_lift_01_11"] = {"location_business_machinery_01_5", "location_business_machinery_01_2"}, -- N
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