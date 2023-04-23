Scorpio "SEExtraTools.core.uniticon.handler" ""

import "SEExtraTools.data"

local iconViewer = IconViewer("SetNPCICONViewer", UIParent)
function OnEnable(self)
    for i, v in ipairs(SEData.GetIcon()) do
        local icon = IconList("SENPCICON" .. i, iconViewer)
        icon.texture = v
        icon:SetID(i)
    end
end

__SlashCmd__ "sen"
function ShowOrHideIconFrame()
    iconViewer:SetShown(not iconViewer:IsShown())
end

__SystemEvent__ "NAME_PLATE_UNIT_ADDED" "FORBIDDEN_NAME_PLATE_UNIT_ADDED"
function EVENT_NAME_PLATE_UNIT_ADDED(unitToken)
    local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(unitToken, issecure())
    if not namePlateFrameBase then
        return
    end

    if not namePlateFrameBase.f then
        namePlateFrameBase.f = IconFrame(namePlateFrameBase:GetName() .. "TestClassIcon", namePlateFrameBase)
    end

    local npcID = select(6, strsplit("-", UnitGUID(unitToken)))

    if UnitIsPlayer(unitToken) then
        local _, class = UnitClass(unitToken)
        namePlateFrameBase.f.id = 0
        namePlateFrameBase.f.texture = "Interface/ARENAENEMYFRAME/UI-Classes-Circles"
        namePlateFrameBase.f.textCoord = CLASS_ICON_TCOORDS[class]
    elseif SEData.GetNPCData(npcID) then
        namePlateFrameBase.f.id = tonumber(npcID)
        namePlateFrameBase.f.texture = _NPCExtraData[npcID] or SEData.GetNPCData(npcID)
        namePlateFrameBase.f.textCoord = {0, 1, 0, 1}
    else
        namePlateFrameBase.f.id = tonumber(npcID)
        namePlateFrameBase.f.texture = ""
        namePlateFrameBase.f.textCoord = {0, 1, 0, 1}
    end
end