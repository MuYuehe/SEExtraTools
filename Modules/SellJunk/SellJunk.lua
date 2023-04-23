Scorpio "SEExtraTools.core.selljunk" ""

function ItemIsJunk(id)
    if C_Item.GetItemQualityByID(id) == 0 then
        return true
    else
        return false
    end
end

__Async__()
function FoundJunkAndSell(bagID)
    local numSlots, limite = C_Container.GetContainerNumSlots(bagID), 0
    if numSlots == 0 then
        return
    end
    local limite = 0
    for slotID = 1, numSlots, 1 do
        if limite >= 10 then
            limite = 0
            Delay(0.5)
        end
        local containerInfo = C_Container.GetContainerItemInfo(bagID, slotID)
        if containerInfo then
            if not containerInfo.isLocked and ItemIsJunk(containerInfo.itemID) and MerchantFrame:IsShown() then
                local sellPrice = select(11, GetItemInfo(containerInfo.hyperlink)) or 0
                if sellPrice > 0 then
                    C_Container.UseContainerItem(bagID, slotID)
                else
                    C_Container.PickupContainerItem(bagID, slotID)
                    DeleteCursorItem()
                end
                limite = limite + 1
            end
        end
    end
end