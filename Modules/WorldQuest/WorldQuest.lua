Scorpio "SEExtraTools.core.worldquest" ""

--======================--
import "SEExtraTools.Layout"
--======================--

class "SEWorldMapButton"            (function (_ENV)
    inherit "Button"

    __Observable__()
    property "IconPoints"   { type = Table, default = { Anchor("TOPLEFT", 6, -6) } }

    property "factionID"    { type = Number }
    __Observable__()
    property "texture"      { type = String }


    function __ctor(self)
        self.OnMouseDown = function(self)
            self.IconPoints = { Anchor("TOPLEFT", 8, -8) }
        end
        self.OnMouseUp = function(self)
            self.IconPoints = { Anchor("TOPLEFT", 6, -6) }
        end
    end
end)

class "SEWorldMapButtonMajor"       (function (_ENV)
    inherit "SEWorldMapButton"
    
    property "data"                 { type = Table, handler = function(self, table)
        self.texture    = table["texture"]
        self.factionID  = table["factionID"]
        self.ownerMap   = table["ownerMap"]
    end}
    property "ownerMap"             { type = Number }
    property "chooseMajor"          { type = Number, handler = function(self, id)
        if id == self.factionID then
            self:SetAlpha(1)
        else
            self:SetAlpha(0.5)
        end
    end}
    property "currentMap"           { type = Number, handler = function(self, id)
        self:SetAlpha(0.5)
        self:SetShown(IsQuestInCurrentMap(id, self.ownerMap))
    end}

    function __ctor(self)
        self.OnEnter = function(self)
            local name = GetFactionInfoByID(self.factionID)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(name)
        end
        self.OnLeave = function(self)
            GameTooltip:Hide()
        end
        self.OnClick = function(self)
            if self:GetAlpha() == 1 then
                FireSystemEvent("CHOOSE_MAJOR_CLICK", -1)
            else
                FireSystemEvent("CHOOSE_MAJOR_CLICK", self.factionID)
            end
        end
    end
end)

class "SEWorldMapButtonQuest"       (function (_ENV)
    inherit "SEWorldMapButton"

    property "uiMapID"          { type = Number }
    property "questID"          { type = Number }
    property "chooseMajor"      { type = Number, handler = function(self, id)
        self:SetShown(IsQuestInCurrentMap(self.uiMapID, WorldMapFrame.mapID) and (id == -1 or id == self.factionID))
    end}
    property "currentMap"       { type = Number, handler = function(self, id)
        self:Hide()
    end}
    property "hasQuest"         { type = Number, handler = function(self, id)
        if id == self.questID then
            self:Show()
        end
    end}

    function Container_OnEnter(self)
        local mapID = WorldMapFrame.mapID
        local x, y = C_TaskQuest.GetQuestLocation(self.questID, mapID)
        C_ChatInfo.SendAddonMessage("SEET:PING", ("%s:%d(%.2f, %.2f)"):format(GetRealmName() .. "-" .. UnitName("player"), mapID, x * 100, y * 100), "WHISPER", UnitName("player"))
    end

    function __ctor(self)
        self:Hide()
        self.OnEnter = function(self)
            if self.questID then
                TaskPOI_OnEnter(self, false)
                Container_OnEnter(self)
            end
        end
        self.OnLeave = function(self)
            GameTooltip:Hide()
            FireSystemEvent("SEET_PING_ACQUIRED")
        end
        self.OnClick = function(self)
            WorldMapFrame:SetMapID(self.uiMapID)
            C_QuestLog.AddWorldQuestWatch(self.questID)
            C_SuperTrack.SetSuperTrackedQuestID(self.questID)
        end
    end
end)

class "SEMajorButtonContainer"      (function (_ENV)
    inherit "Frame"

    function __ctor(self)
        -- ^.^
    end
end)

class "SEWorldQuestFrameContainer"  (function (_ENV)
    inherit "Frame"

    __Observable__()
    property "selfOffY" { type = Number, default = 0 }
    function __ctor(self)
        self.OnMouseWheel = function(self, delta)
            local parentHeigth = self:GetParent():GetHeight()
            local height = self:GetHeight()
            if height < parentHeigth then
                return
            end
            if delta == 1 then
                self.selfOffY = self.selfOffY - 20
            elseif delta == -1 then
                self.selfOffY = self.selfOffY + 20
            end

            if self.selfOffY < 0 then
                self.selfOffY = 0
            elseif self.selfOffY > height - parentHeigth then
                self.selfOffY = height - parentHeigth
            end
        end
    end
end)
class "SEContainerFrame"            (function (_ENV)
    inherit "Frame"

    function __ctor(self)
        -- ^.^
    end
end)


Style.UpdateSkin("Default",                 {
    [SEWorldMapButton]                      = {
        size                                = Size(32, 32),
        HighlightTexture                    = {
            file                            = [[Interface\Minimap\UI-Minimap-ZoomButton-Highlight]],
        },
        backdrop                            = {
            bgFile                          = [[Interface\Minimap\UI-Minimap-Background]],
            insets                          = {left = 2,right = 2,top = 2, bottom = 2}
        },
        IconTexture                         = {
            SubLevel                        = 1,
            size                            = Size(54,54),
            location                        = { Anchor("TOPLEFT")},
            file                            = [[Interface\Minimap\MiniMap-TrackingBorder]],
        },
    },
    [SEWorldMapButtonMajor]                 = {
        alpha                               = 0.5,
        BackgroundTexture                   = {
            SubLevel                        = 0,
            size                            = Size(20,20),
            location                        = Wow.FromUIProperty("IconPoints"),
            atlas                           = Wow.FromUIProperty("texture"):Map(function(x)
                                                return {
                                                    atlas = x,
                                                    useAtlasSize = false,
                                                }
            end),
        },
        chooseMajor                         = Wow.FromEvent("CHOOSE_MAJOR_CLICK"),
        currentMap                          = Wow.FromEvent("WORLD_MAP_ID_CHANGED"),
    },
    [SEMajorButtonContainer]                = {
        location                            = { Anchor("TOPRIGHT", -72, -44, nil, "TOPLEFT") },
        LayoutManager                       = HorizontalLayoutManager(false, false),
        size                                = Size(32,32)
    },
    [SEWorldMapButtonQuest]                 = {
        BackgroundTexture                   = {
            SubLevel                        = 0,
            size                            = Size(20,20),
            location                        = Wow.FromUIProperty("IconPoints"),
            atlas                           = Wow.FromUIProperty("texture"):Map(function(x)
                                                return {
                                                    atlas = x,
                                                    useAtlasSize = false,
                                                }
            end),
        },
        chooseMajor                         = Wow.FromEvent("CHOOSE_MAJOR_CLICK"),
        currentMap                          = Wow.FromEvent("WORLD_MAP_ID_CHANGED"),
        hasQuest                            = Wow.FromEvent("WORLD_MAP_QUESTID_HAVE"),
    },

    [SEWorldQuestFrameContainer]            = {
        location                            = Wow.FromUIProperty("selfOffY"):Map(function (x)
                                                return { Anchor("TOP", 0, x) }
        end),
        size                                = Size(32,32),
        LayoutManager                       = VerticalLayoutManager(false, false),
    },
    [SEContainerFrame]                      = {
        size                                = Size(32,417),
        location                            = { Anchor("TOPRIGHT", -40, -76, nil, "TOPLEFT") },
        ClipChildren                        = true,
    },
})