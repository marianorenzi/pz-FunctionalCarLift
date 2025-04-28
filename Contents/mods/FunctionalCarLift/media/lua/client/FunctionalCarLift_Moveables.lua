require "Moveables/ISMoveableDefinitions"
Events.OnGameBoot.Add(function()
    local defs = ISMoveableDefinitions:getInstance()
    defs.addToolDefinition("Mechanic", {"Base.Wrench"}, Perks.Mechanics, 100, "RepairWithWrench", true);
end)
