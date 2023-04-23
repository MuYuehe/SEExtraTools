Scorpio "SEExtraTools.core.uniticon" ""
--======================--
import "SEExtraTools.Layout"
--======================--
function OnLoad(self)
    _SVDB = SVManager("SEExtraTools_NPCData_DB")

    _SVDB:SetDefault {
        NPCExtraData = {}
    }

    _NPCExtraData = _SVDB.NPCExtraData
end
function OnQuit(self)
    _SVDB.NPCExtraData = _NPCExtraData
end
--======================--

class "IconViewer" (function (_ENV)
    inherit "Frame"

    function __ctor(self)
        -- ^.^
        self:Hide()
    end
end)
class "IconList"    (function (_ENV)
    inherit "Frame"

    __Observable__()
    property "texture" { type = String }

    function __ctor(self)
        self:SetAlpha(0.5)
        self.OnEnter = function(self)
            self:SetAlpha(1)
        end
        self.OnLeave = function(self)
            self:SetAlpha(0.5)
        end
        self.OnMouseUp = function(self)
            if not MouseIsOver(self) then
                return
            end
            if not UnitGUID("target") then
                return
            end

            local npcID = select(6, strsplit("-", UnitGUID("target")))
            if not npcID or npcID == "" then
                return
            end
            local texture = self.texture
            if texture == "Interface/BUTTONS/UI-GroupLoot-Pass-Up" then
                texture = ""
            end
            _NPCExtraData[npcID] = texture
            FireSystemEvent("ADD_OR_DELETE_NPCICON", {
                ["texture"] = texture,
                ["id"]      = tonumber(npcID),
            })
        end
    end
end)
class "IconFrame" (function (_ENV)
    inherit "Frame"

    __Observable__()
    property "texture"      { type = String }
    __Observable__()
    property "textCoord"    { type = Table, default = {0, 1, 0, 1} }
    property "id"           { type = Number }
    property "addOrDelete"  { type = Table, handler = function(self, table)
        if table["id"] == self.id then
            self.texture = table["texture"]
        end
    end}
end)

Style.UpdateSkin("Default",     {
    [IconViewer]                = {
        size                    = Size(30, 30),
        location                = { Anchor("CENTER")},
        LayoutManager           = HorizontalLayoutManager(false, false),
    },
    [IconList]                  = {
        size                    = Size(30, 30),
        IconTexture             = {
            file                = Wow.FromUIProperty("texture"),
            setAllPoints        = true,
        }
    },
    [IconFrame]                 = {
        visible                 = _Config.showuniticon,
        size                    = Size(40, 40),
        location                = { Anchor("CENTER", 0, 40) },
        IconTexture             = {
            SetAllPoints        = true,
            file                = Wow.FromUIProperty("texture"),
            TexCoords           = Wow.FromUIProperty("textCoord"):Map(function (table)
                                    return {
                                        ["left"]    = table[1],
                                        ["right"]   = table[2],
                                        ["top"]     = table[3],
                                        ["bottom"]  = table[4],
                                    }
            end)
        },
        addOrDelete             = Wow.FromEvent("ADD_OR_DELETE_NPCICON"),
    },
})