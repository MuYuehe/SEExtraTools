Scorpio "SEExtraTools" ""

function OnLoad(self)
    _Addon:SetSavedVariable("SEExtraTools_DB"):UseConfigPanel()
end

__Config__(_Config, "showuniticon", true)
function ShowUnitIcon(enable)
    assert(enable == _Config.showuniticon:GetValue())
end
__Config__(_Config, "selljunk", true)
function SellJunk(enable)
    assert(enable == _Config.selljunk:GetValue())
end

__Config__(_Config, "useguidbankrepair", true)
function UseGuidBankRepair(enable)
    assert(enable == _Config.useguidbankrepair:GetValue())
end