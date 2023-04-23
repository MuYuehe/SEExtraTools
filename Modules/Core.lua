Scorpio "SEExtraTools.core" ""

function GetItemUseInfo(itemLink,slotID, unit)
	local data = {}

	if itemLink and itemLink ~= "" then
		local _, itemID, enchantID, gemID1, gemID2, gemID3, gemID4
		local itemEquipLoc, itemType, itemSubType, itemName, itemQuality, setID
		-- get realLevel
		local itemLevel 	= GetDetailedItemLevelInfo(itemLink)
		local statsTable 	= GetItemStats(itemLink)
		_, itemID, enchantID, gemID1, gemID2, gemID3, gemID4 = strsplit(":",itemLink)
		itemName, _, itemQuality, _, _, itemType, itemSubType, _, itemEquipLoc, _, _, _, _, _, _, setID = GetItemInfo(itemLink)
		data = {
			["itemInfo"] 			= {
				["itemID"] 			= itemID,
				["itemLink"] 		= itemLink,
				["itemName"] 		= itemName or "",
				["itemQuality"] 	= ITEM_QUALITY_COLORS[itemQuality],
                ["itemEquipLocGS"]  = itemEquipLoc,
				["itemEquipLoc"]	= _G[itemEquipLoc] or "",
				["itemType"] 		= itemType or "",
                ["itemSubType"]     = itemSubType or "",
				["itemLevel"] 		= itemLevel or 0,
				["setID"] 			= setID,
			},
			["extraInfo"]			= {
				["gemID1"] 			= gemID1 and gemID1 ~= "" and gemID1,
				["gemID2"] 			= gemID2 and gemID2 ~= "" and gemID2,
				["gemID3"] 			= gemID3 and gemID3 ~= "" and gemID3,
				["gemID4"] 			= gemID4 and gemID4 ~= "" and gemID4,
				["enchantID"] 		= enchantID and enchantID ~= "" and enchantID,
			},
			["statsInfo"]			= {
				["ITEM_MOD_CRIT_RATING_SHORT"] 		= statsTable and statsTable["ITEM_MOD_CRIT_RATING_SHORT"] or 0,
				["ITEM_MOD_HASTE_RATING_SHORT"] 	= statsTable and statsTable["ITEM_MOD_HASTE_RATING_SHORT"] or 0,
				["ITEM_MOD_MASTERY_RATING_SHORT"] 	= statsTable and statsTable["ITEM_MOD_MASTERY_RATING_SHORT"] or 0,
				["ITEM_MOD_VERSATILITY"] 			= statsTable and statsTable["ITEM_MOD_VERSATILITY"] or 0,
			},
		}
	end
	data["slotID"] 					= slotID
	data["unit"] 					= unit
	return data
end

function string:split_lite(sep)
    local splits = {}

    if sep == nil then
        -- return table with whole str
        table.insert(splits, self)
    elseif sep == "" then
        -- return table with each single character
        local len = #self
        for i = 1, len do
            table.insert(splits, self:sub(i, i))
        end
    else
        -- normal split use gmatch
        local pattern = "[^" .. sep .. "]+"
        for str in string.gmatch(self, pattern) do
            table.insert(splits, str)
        end
    end

    return splits
end

-- 总是返回传入进的布尔值的反值
function ReturnOpposite(bol)
    if bol then
        return false
    else
        return true
    end
end
-- 获取派系的纹理图标
function GetMajorAtlasTexture(factionID)
    local majorFactionIconFormat = ""
    local majorFactionData = C_MajorFactions.GetMajorFactionData(factionID)
    if majorFactionData then
        local factionTextureKit = majorFactionData.textureKit
        majorFactionIconFormat = string.format("majorFactions_icons_%s512", factionTextureKit)
    end

    return majorFactionIconFormat
end
-- 判断地图是否在指定地图上
function IsQuestInCurrentMap(uiMapID, mapID)
    if uiMapID then
        return MapUtil.IsChildMap(uiMapID, mapID) or (uiMapID == mapID)
    else
        return false
    end
end
-- 获取任务奖励数据
function GetQuestInfo(questId)
    -- 获取任务集合
    local questRewardData = {}
    local rewardNumber = 0
    -- 获取存在的物品奖励
    for i = 1, GetNumQuestLogRewards(questId), 1 do
        rewardNumber = rewardNumber + 1
        local _, texture, numItems, quality, _, itemID, itemLevel = GetQuestLogRewardInfo(i, questId)
        questRewardData[rewardNumber] = {
            ["texture"]     = texture,
            ["numItems"]    = numItems,
            ["quality"]     = quality,
            ["itemID"]      = itemID,
            ["itemLevel"]   = itemLevel,
            ["itemType"]    = 1,
        }
    end
    -- 获取任务奖励货币
    for i = 1, GetNumQuestLogRewardCurrencies(questId), 1 do
        rewardNumber = rewardNumber + 1
        local _, texture, numItems, currencyId, quality = GetQuestLogRewardCurrencyInfo(i, questId)
        questRewardData[rewardNumber] = {
            ["texture"]     = texture,
            ["numItems"]    = numItems,
            ["itemID"]      = currencyId,
            ["quality"]     = quality,
            ["itemType"]    = 2,
        }
    end
    -- 获取金币奖励
    local money = GetQuestLogRewardMoney(questId)
    if money > 0 then
        rewardNumber = rewardNumber + 1
        questRewardData[rewardNumber] = {
            ["texture"]     = [[Interface/MINIMAP/TRACKING/Auctioneer]],
            ["numItems"]    = money,
            ["itemType"]    = 3,
        }
    end

    return questRewardData
end

-- 获取任务类型Atlas
function GetQuestTypeAtlas(worldQuestType, tradeskillLineID, questID)
    local iconAtlas

    if worldQuestType == _G.Enum.QuestTagType.PvP then
		iconAtlas = [[QuestBonusObjective]]
	elseif worldQuestType == _G.Enum.QuestTagType.PetBattle then
		iconAtlas = [[WildBattlePetCapturable]]
	elseif worldQuestType == _G.Enum.QuestTagType.Profession and WORLD_QUEST_ICONS_BY_PROFESSION[tradeskillLineID] then
		iconAtlas = WORLD_QUEST_ICONS_BY_PROFESSION[tradeskillLineID]
	elseif worldQuestType == _G.Enum.QuestTagType.Dungeon then
		iconAtlas = [[Dungeon]]
	elseif worldQuestType == _G.Enum.QuestTagType.Raid then
		iconAtlas = [[Raid]]
	elseif worldQuestType == _G.Enum.QuestTagType.Invasion then
		iconAtlas = [[worldquest-icon-burninglegion]]
	elseif worldQuestType == _G.Enum.QuestTagType.Islands then
		iconAtlas = [[poi-islands-table]]
	elseif worldQuestType == _G.Enum.QuestTagType.FactionAssault then
		local factionTag = UnitFactionGroup("player")
		if factionTag == "Alliance" then
			iconAtlas = [[poi-alliance]]
		else -- "Horde" or "Neutral"
			iconAtlas = [[poi-horde]]
		end
	elseif worldQuestType == _G.Enum.QuestTagType.Threat then
		iconAtlas = QuestUtil.GetThreatPOIIcon(questID)
	elseif worldQuestType == _G.Enum.QuestTagType.DragonRiderRacing then
		iconAtlas = [[racing]]
	else
		if questID then
			local theme = C_QuestLog.GetQuestDetailsTheme(questID)
			if theme then
				iconAtlas = theme.poiIcon
			end
		end
	end

    if iconAtlas then
		local info = C_Texture.GetAtlasInfo(iconAtlas)
		if info then
			return iconAtlas
		end
	end
    return [[QuestNormal]]
end