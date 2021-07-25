local healthstoneId = 5512;
local healthstone = "healthstone";
local healingPotId = 171267;
local healingPotName = "spiritual healing potion";

local function usableItemName(itemId)
    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, GetContainerNumSlots(bag) do
            if GetContainerItemID(bag, slot) == itemId then
                local _, duration = GetContainerItemCooldown(bag, slot)
                if duration == 0 then
                    return true, true;
                else
                    return true, false;
                end
                break
            end
        end
    end
    return false, false;
end

local function editMacro(itemNames, itemCount)
    if itemNames ~= nil and itemCount > 0 then
        local macro = "#showtooltip";
        if itemCount > 1 then
            macro = macro .. "\n/castsequence reset=combat";
        else
            macro = macro .. "\n/use";
        end
        for _, itemName in pairs(itemNames) do
            if itemName ~= nil then
                macro = macro .. " " .. itemName .. ","
            end
        end
        macro = macro:sub(1, -2)
        EditMacro("SelfHeal", "SelfHeal", nil, macro, 1, nil);
    end
end

local SelfHeal = CreateFrame("Frame");
SelfHeal:RegisterEvent("PLAYER_REGEN_DISABLED");
SelfHeal:SetScript("OnEvent",function(self,event,...)
    local itemNames = {};
    itemNames[1] = nil;
    itemNames[2] = nil;
    local hsExists, hsUsable = usableItemName(healthstoneId);
    local potExists, potUsable = usableItemName(healingPotId);
    local itemCount = 0;
    if hsExists and potExists then
        itemCount = 2;
        if hsUsable then
            itemNames[1] = healthstone;
            itemNames[2] = healingPotName;
        else
            itemNames[1] = healingPotName;
            itemNames[2] = healthstone;
        end
    else
        if hsExists then
            itemCount = itemCount + 1;
            itemNames[1] = healthstone;
        end
        if potExists then
            itemCount = itemCount + 1;
            itemNames[2] = healingPotName;
        end
    end
    editMacro(itemNames, itemCount);
end)