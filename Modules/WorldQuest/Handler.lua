Scorpio "SEExtraTools.core.worldquest.handler" ""

local seMajorButtonContainer            = SEMajorButtonContainer("seMajorButtonContainer", QuestMapFrame)
local seContainerFrame                  = SEContainerFrame("seContainerFrame", QuestMapFrame)
local seWorldQuestFrameContainer        = SEWorldQuestFrameContainer("seWorldQuestFrameContainer", seContainerFrame)

--     -- 清理存在的itembutton中的信息
--     -- FireSystemEvent("WORLD_MAP_ID_CHANGED_TO_QUEST", -1)
--     local mapID = WorldMapFrame.mapID

--     -- 拿到的地图任务还要分开世界任务
--     local mapQuestData = C_TaskQuest.GetQuestsForPlayerByMapID(mapID)
--     if not mapQuestData then
--         return
--     end

--     local mapHasMajor = {}
--     local majorData, rewardData = {}, {}
--     local majorNumber, rewardNumber = 0, 0

--     -- for i, questInfo in ipairs(mapQuestData) do
--     --     -- 获取任务id
--     --     local questId = questInfo.questId
--     --     -- 判断是否为世界任务
--     --     if C_QuestLog.IsWorldQuest(questId) then
            
--     --         if IsQuestInCurrentMap(questInfo.mapID, mapID) then
--     --             local name, factionID = C_TaskQuest.GetQuestInfoByQuestID(questId)
--     --             -- print(questId, questInfo.mapID, name)
--     --         end
--     --         -- 获取任务信息
--     --         -- 获取任务的派系信息,并拿到派系的atlas材质
--     --         -- local _, factionID = C_TaskQuest.GetQuestInfoByQuestID(questId)
--     --         -- local uiMapID = C_TaskQuest.GetQuestZoneID(questId)
--     --         -- if factionID and factionID ~= "" and IsQuestInCurrentMap(uiMapID, mapID) then
--     --         --     -- 显示该地图所拥有的派系
--     --         --     if C_Reputation.IsMajorFaction(factionID) then
--     --         --         majorData = {
--     --         --             ["texture"] = GetMajorAtlasTexture(factionID),
--     --         --             ["factionID"] = factionID,
--     --         --         }
--     --         --         if not mapHasMajor[factionID] then
--     --         --             print(factionID)
--     --         --             mapHasMajor[factionID] = true
--     --         --             majorNumber = majorNumber + 1
--     --         --             local seWorldMapMajorButton = SEWorldMapMajorButton("seWorldMapMajorButton" .. factionID, seMajorButtonContainer)
--     --         --             seWorldMapMajorButton.data = majorData
--     --         --             seWorldMapMajorButton:SetID(majorNumber)
--     --         --         end
--     --         --     end

--     --         --     -- 获取存在的物品奖励
--     --         --     for j = 1, GetNumQuestLogRewards(questId), 1 do
--     --         --         local name, texture, numItems, quality, _, itemID, itemLevel = GetQuestLogRewardInfo(j, questId)
--     --         --         rewardData = {
--     --         --             ["texture"]     = texture,
--     --         --             ["numItems"]    = numItems,
--     --         --             ["quality"]     = quality,
--     --         --             ["itemID"]      = itemID,
--     --         --             ["itemLevel"]   = itemLevel,
--     --         --             ["itemType"]    = 1,
--     --         --             ["factionID"]   = factionID,
--     --         --             ["uiMapID"]     = uiMapID,
--     --         --             ["questId"]     = questId,
--     --         --         }
--     --         --         rewardNumber = rewardNumber + 1
--     --         --         local seWorldMapItemButton = SEWorldMapItemButton("seWorldMapItemButton" .. rewardNumber, seWorldQuestFrameContainer)
--     --         --         seWorldMapItemButton.data = rewardData
--     --         --     end
--     --         --     -- 获取任务奖励货币
--     --         --     for j = 1, GetNumQuestLogRewardCurrencies(questId), 1 do
--     --         --         local name, texture, numItems, currencyId, quality = GetQuestLogRewardCurrencyInfo(j, questId)
--     --         --         rewardData = {
--     --         --             ["texture"]     = texture,
--     --         --             ["numItems"]    = numItems,
--     --         --             ["itemID"]      = currencyId,
--     --         --             ["quality"]     = quality,
--     --         --             ["itemType"]    = 2,
--     --         --             ["factionID"]   = factionID,
--     --         --             ["uiMapID"]     = uiMapID,
--     --         --             ["questId"]     = questId,
--     --         --         }
--     --         --         rewardNumber = rewardNumber + 1
--     --         --         local seWorldMapItemButton = SEWorldMapItemButton("seWorldMapItemButton" .. rewardNumber, seWorldQuestFrameContainer)
--     --         --         seWorldMapItemButton.data = rewardData
--     --         --     end
--     --         --     -- 获取金币奖励
--     --         --     local money = GetQuestLogRewardMoney(questId)
--     --         --     if money > 0 then
--     --         --         rewardData = {
--     --         --             ["texture"]     = [[Interface/MINIMAP/TRACKING/Auctioneer]],
--     --         --             ["numItems"]    = money,
--     --         --             ["itemType"]    = 3,
--     --         --             ["factionID"]   = factionID,
--     --         --             ["uiMapID"]     = uiMapID,
--     --         --             ["questId"]     = questId,
--     --         --         }
--     --         --         rewardNumber = rewardNumber + 1
--     --         --         local seWorldMapItemButton = SEWorldMapItemButton("seWorldMapItemButton" .. rewardNumber, seWorldQuestFrameContainer)
--     --         --         seWorldMapItemButton.data = rewardData
--     --         --     end

--     --         -- end
--     --     end
--     -- end
-- -- print(majorNumber, rewardNumber)
--     if majorNumber > 0 then
--         FireSystemEvent("WORLD_MAP_ID_CHANGED_TO_QUEST", mapID)
--     end
--     if rewardNumber > 0 then
--         FireSystemEvent("WORLD_MAP_ID_CHANGED_TO_MAJOR", mapHasMajor)
--     end
-- end

function OnEnable(self)
    -- 10.0声望派系
    local MajorData = {
        -- 10.0
        { ["factionID"] = 2503,  ["texture"] = [[MajorFactions_Icons_Centaur512]],       ["ownerMap"] = 1978 },
        { ["factionID"] = 2507,  ["texture"] = [[MajorFactions_Icons_Expedition512]],    ["ownerMap"] = 1978 },
        { ["factionID"] = 2510,  ["texture"] = [[MajorFactions_Icons_Valdrakken512]],    ["ownerMap"] = 1978 },
        { ["factionID"] = 2511,  ["texture"] = [[MajorFactions_Icons_Tuskarr512]],       ["ownerMap"] = 1978 },
        { ["factionID"] = 2523,  ["texture"] = [[Interface/AddOns/SEExtraTools/Modules/Image/ovtrqrme.png]],       ["ownerMap"] = 1978 },
        -- 9.0
        -- { ["factionID"] = 1536, ["texture"] = [[shadowlands-landingbutton-NightFae-up]], ["ownerMap"] = 1550 },
        -- { ["factionID"] = 1533, ["texture"] = [[shadowlands-landingbutton-venthyr-up]],  ["ownerMap"] = 1550 },
        -- { ["factionID"] = 1565, ["texture"] = [[shadowlands-landingbutton-kyrian-up]],   ["ownerMap"] = 1550 },
        -- { ["factionID"] = 1525, ["texture"] = [[shadowlands-landingbutton-necrolord-up]],["ownerMap"] = 1550 },
    }
    -- 10.0世界任务id
    local WorldQuestData = {
        72058,
        75257,
        70064,
        70068,
        70066,
        70067,
        74378,
        69927,
        66133,
        66419,
        66805,
        71160,
        70654,
        70653,
        70658,
        69995,
        69994,
        74835,
        74837,
        71140,
        66551,
        74792,
        71180,
        74836,
        74841,
        71145,
        66588,
        71166,
        71206,
        74840,
        74794,
        74838,
        69949,
        73147,
        67005,
        70439,
        70071,
        69916,
        66902,
        70602,
        66070,
        66833,
        70699,
        70075,
        70160,
        69938,
        69942,
        70632,
        70651,
        70079,
        72022,
        73080,
        73146,
        73083,
        70419,
        70429,
        70433,
        70417,
        70646,
        70638,
        69941,
        70629,
    }
    for i, v in ipairs(MajorData) do
        local seWorldMapMajorButton = SEWorldMapButtonMajor("seWorldMapMajorButton" .. v["factionID"], seMajorButtonContainer)
        seWorldMapMajorButton.data = v
        seWorldMapMajorButton:SetID(i)
    end
    for i, v in ipairs(WorldQuestData) do
        local seWorldMapItemButton = SEWorldMapButtonQuest("seWorldMapItemButton" .. v, seWorldQuestFrameContainer)
        seWorldMapItemButton:SetID(i)
        seWorldMapItemButton.questID = v
    end
end

__SecureHook__ (WorldMapFrame, "OnMapChanged")
function Hook_WorldMapFrame_OnMapChanged()
    FireSystemEvent("WORLD_MAP_ID_CHANGED", WorldMapFrame.mapID)
end

__SystemEvent__ "QUEST_DATA_LOAD_RESULT" __Async__()
function EVENT_QUEST_DATA_LOAD_RESULT(questID, success)
    Next()
    if type(questID) ~= "number" then
        return
    end

    if not C_QuestLog.IsWorldQuest(questID) then
        return
    end
    local uiMapID = C_TaskQuest.GetQuestZoneID(questID)
    if not IsQuestInCurrentMap(uiMapID, WorldMapFrame.mapID) then
        return
    end

    local name, factionID = C_TaskQuest.GetQuestInfoByQuestID(questID)
    -- if not factionID or factionID == "" then
    --     return
    -- end
    local seWorldMapItemButton = SEWorldMapButtonQuest("seWorldMapItemButton" .. questID, seWorldQuestFrameContainer)
    seWorldMapItemButton.uiMapID = uiMapID
    seWorldMapItemButton.factionID = factionID
    local tagInfo = C_QuestLog.GetQuestTagInfo(questID)
    seWorldMapItemButton.texture = GetQuestTypeAtlas(tagInfo.worldQuestType, tagInfo.tradeskillLineID, questID)
    FireSystemEvent("WORLD_MAP_QUESTID_HAVE", questID)
end


-- __SecureHook__ "TaskPOI_OnEnter"
-- function Hook_TaskPOI_OnEnter(self, ...)
--     -- local point, relativeTo, relativePoint, offsetX, offsetY = self:GetPoint()
--     -- print(point, relativePoint, offsetX, offsetY)
--     print(self.questID)
-- end


-- SEMapCanvasPinMixin = CreateFromMixins(MapCanvasPinMixin)

-- function SEMapCanvasPinMixin:OnLoad()
--     print(1)
-- end