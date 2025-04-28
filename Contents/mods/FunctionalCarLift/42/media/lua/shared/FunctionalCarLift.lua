FunctionalCarLift = FunctionalCarLift or {}
FunctionalCarLift.CarsNearLift = {}

FunctionalCarLift.VanillaCarLiftSpriteNames = {
  ["location_business_machinery_01_0"] = true,
  ["location_business_machinery_01_2"] = true,
  ["location_business_machinery_01_4"] = true,
  ["location_business_machinery_01_9"] = true,
  ["location_business_machinery_01_11"] = true,
  ["location_business_machinery_01_13"] = true,
  ["location_business_machinery_01_1"] = true,
  ["location_business_machinery_01_3"] = true,
  ["location_business_machinery_01_5"] = true,
  ["location_business_machinery_01_8"] = true,
  ["location_business_machinery_01_10"] = true,
  ["location_business_machinery_01_12"] = true,
}

FunctionalCarLift.CustomCarLiftSpriteNames = {
  ["car_lift_01_0"] = true,
  ["car_lift_01_1"] = true,
  ["car_lift_01_2"] = true,
  ["car_lift_01_3"] = true,
  ["car_lift_01_4"] = true,
  ["car_lift_01_5"] = true,
  ["car_lift_01_6"] = true,
  ["car_lift_01_7"] = true,
}

FunctionalCarLift.CraftableCarLiftSpriteNames = {
  ["car_lift_01_8"] = true, -- W
  ["car_lift_01_9"] = true, -- E
  ["car_lift_01_10"] = true, -- S
  ["car_lift_01_11"] = true, -- N
  ["car_lift_01_12"] = true, -- WE
  ["car_lift_01_13"] = true, -- NS
}

function FunctionalCarLift.IsCarLiftSprite(spriteName)
  if spriteName == nil then return false end
  if FunctionalCarLift.VanillaCarLiftSpriteNames[spriteName] == true then return true end
  if FunctionalCarLift.CustomCarLiftSpriteNames[spriteName] == true then return true end
  return false
end

function FunctionalCarLift.SquareGetOneOfSprites(square, spriteNames)
  if square == nil or spriteNames == nil then return nil end
  
  for i = square:getObjects():size() - 1, 0, -1 do
    for _, spriteName in ipairs(spriteNames) do
      if square:getObjects():get(i):getSprite():getName() == spriteName then return spriteName end
    end
  end
  
  return nil
end

return FunctionalCarLift