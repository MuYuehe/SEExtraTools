Scorpio "SEExtraTools.core.selljunk.handler" ""

LocalMerchantFrame = GetWrapperUI(MerchantFrame)
function LocalMerchantFrame:OnShow()
    if not _Config.selljunk:GetValue() then
        return
    end
    for bagID = BACKPACK_CONTAINER, NUM_BAG_SLOTS, 1 do
        if IsBagOpen(bagID) then
            FoundJunkAndSell(bagID)
        end
    end
    if CanMerchantRepair() then
        local repairAllCost = GetRepairAllCost()
        RepairAllItems(_Config.useguidbankrepair:GetValue() and CanGuildBankRepair())
        print("本次修理共花费" .. repairAllCost)
    end
end