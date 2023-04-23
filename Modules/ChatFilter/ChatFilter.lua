Scorpio "SEExtraTools.core.chatfilter" ""

local Caches = {}

local function GetChatItemInfo(ChatLink)
    if (Caches[ChatLink]) then
        return Caches[ChatLink]
    end
    local itemLink          = string.match(ChatLink, "|H(.-)|h")
    local data              = GetItemUseInfo(itemLink)
    local itemLevel         = data["itemInfo"]["itemLevel"]
    local itemEquipLocGS    = data["itemInfo"]["itemEquipLocGS"]
    local itemEquipLoc      = data["itemInfo"]["itemEquipLoc"]
    local itemSubType       = data["itemInfo"]["itemSubType"]
    local itemQuality       = data["itemInfo"]["itemQualityNum"]
    local itemType          = data["itemInfo"]["itemType"]
    local itemName          = data["itemInfo"]["itemName"]
    if tonumber(itemLevel) and itemLevel > 0 then
        if XList({"INVTYPE_CLOAK", "INVTYPE_TRINKET", "INVTYPE_FINGER", "INVTYPE_NECK"}):Any(function(x) return x == itemEquipLocGS end) then
            itemLevel = format("%s(%s)", itemLevel, itemEquipLoc)
        elseif itemType == WEAPON then
            itemLevel = format("%s(%s)", itemLevel, itemSubType)
        elseif itemType == ARMOR then
            itemLevel = format("%s(%s-%s)", itemLevel, itemSubType, itemEquipLoc)
        elseif itemType == AUCTION_CATEGORY_GEMS  then
            itemLevel = format("%s(%s)", itemLevel, itemType)
        else
            itemLevel = nil
        end
        if itemLevel then
            local number, name, stats = 0, "",GetItemStats(itemLink)
            for k, v in pairs(stats) do
                if string.find(k, "EMPTY_SOCKET_") then
                    number = v
                    name = string.sub(k, 14)
                    break
                end
            end
            local gemTexture = string.rep("|TInterface\\ItemSocketingFrame\\UI-EMPTYSOCKET-" .. name .. ":0|t", number)
            if (itemQuality == 6 and itemType == WEAPON) then
                gemTexture = ""
            end
            ChatLink = ChatLink:gsub("|h%[(.-)%]|h", "|h[" .. itemLevel .. ":" .. itemName .. "]|h" .. gemTexture)
        end
    elseif itemSubType and itemSubType == MOUNTS then
        ChatLink = ChatLink:gsub("|h%[(.-)%]|h", "|h[("..itemSubType..")%1]|h")
    end
    Caches[ChatLink] = ChatLink
    return ChatLink
end

function MapFilter(self, event, msg, ...)
    if true then
        msg = msg:gsub("(|Hitem:%d+:.-|h.-|h)", GetChatItemInfo)
    end
    return false, msg, ...
end