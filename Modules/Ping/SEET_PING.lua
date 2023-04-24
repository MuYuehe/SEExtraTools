Scorpio "SEExtraTools.core.PING" ""

namespace "SEExtraTools.PING"

SEETPingDataProviderMixin       = CreateFromMixins(MapCanvasDataProviderMixin)
SEETPingPinMixin                = CreateFromMixins(MapCanvasPinMixin)

_G.SEETPingPinMixin = SEETPingPinMixin

CURRENT_PING                    = {}
SORT_USER_PING                  = List()

SEET_PING_PREFIX = "SEET:PING"

function SEETPingDataProviderMixin:GetPinTemplate()
    return "SEETPingPinTemplate"
end

function SEETPingDataProviderMixin:OnAdded(mapCanvas)
    MapCanvasDataProviderMixin.OnAdded(self, mapCanvas)
    self:RegisterEvent("CHAT_MSG_ADDON")
end

function SEETPingDataProviderMixin:OnEvent(event, prefix, text, ...)
    if prefix ~= SEET_PING_PREFIX then return end
    local user, map, x, y       = text:match("^(.*):(%d+)%(([%d%.]+),%s*([%d%.]+)%)$")
    if user and map and x and y then
        if tonumber(map) ~= WorldMapFrame.mapID then return end
        self:GetMap():AcquirePin(self:GetPinTemplate(), user, map, x, y)
    end
end
function SEETPingDataProviderMixin:RemoveAllData()
    self:GetMap():RemoveAllPinsByTemplate(self:GetPinTemplate())
end

function SEETPingDataProviderMixin:RefreshAllData(fromOnShow)
    self:RemoveAllData()
end


function SEETPingPinMixin:OnLoad()
    self:SetScalingLimits(1.0, 1.0, 2.00)

    self:UseFrameLevelType("PIN_FRAME_LEVEL_MAP_HIGHLIGHT")
end


function SEETPingPinMixin:OnAcquired(user, map, x, y)

    self.sender                 = user
    self.map                    = map
    self.x                      = x
    self.y                      = y
    self.endtime                = GetTime()
    self:SetPosition(x/100, y/100)

    CURRENT_PING[self] = true
    SORT_USER_PING:Clear()

    for ping in pairs(CURRENT_PING) do
        if ping.sender == user then
            SORT_USER_PING:Insert(ping.endtime)
        end
    end

    if #SORT_USER_PING > 1 then
        SORT_USER_PING:Sort()
        local last              = SORT_USER_PING[#SORT_USER_PING - 1]
        for ping in pairs(CURRENT_PING) do
            local map   = ping:GetMap()
            if map then map:RemovePin(ping) end
        end
    end
end

function SEETPingPinMixin:OnReleased()
    CURRENT_PING[self]          = nil

    self.sender                 = nil
    self.map                    = nil
    self.x                      = nil
    self.y                      = nil
    self.endtime                = nil
end

__Service__(true)
function ProcessPing()
    while true do
        NextEvent("SEET_PING_ACQUIRED")

        local hasping           = true
        while hasping do
            hasping             = false

            for ping in pairs(CURRENT_PING) do
                hasping         = true

                local map   = ping:GetMap()
                if map then map:RemovePin(ping) end
            end
        end
    end
end


local mouseDownTime

function Container_OnMouseDown(self, button)
    mouseDownTime               = GetTime()
end

function Container_OnMouseUp(self, button)
    if button == "LeftButton" and GetTime() - mouseDownTime < 0.3 then

        local mapID = WorldMapFrame.mapID
        local x, y = self:GetCursorPosition()
        x                       = self:NormalizeHorizontalSize(x / self:GetCanvasScale() - self.Child:GetLeft())
        y                       = self:NormalizeVerticalSize(self.Child:GetTop() - y / self:GetCanvasScale())
        C_ChatInfo.SendAddonMessage(SEET_PING_PREFIX, ("%s:%d(%.2f, %.2f)"):format(GetRealmName() .. "-" .. UnitName("player"), mapID, x * 100, y * 100), "WHISPER", UnitName("player"))
    end
end

C_ChatInfo.RegisterAddonMessagePrefix(SEET_PING_PREFIX)

-- WorldMapFrame.ScrollContainer:HookScript("OnMouseDown", Container_OnMouseDown)
-- WorldMapFrame.ScrollContainer:HookScript("OnMouseUp", Container_OnMouseUp)

WorldMapFrame:AddDataProvider(CreateFromMixins({}, SEETPingDataProviderMixin))