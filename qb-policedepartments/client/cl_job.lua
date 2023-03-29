local QBCore = exports['qb-core']:GetCoreObject()

-- Evidence

RegisterNetEvent('qb-policedepartments:client:Evidence', function(data)
    local stash = data.job.."_evidence"
    TriggerServerEvent("inventory:server:OpenInventory", "stash", stash, {
        maxweight = 4000000,
        slots = 500
    })
    TriggerEvent("inventory:client:SetCurrentStash", stash)
end)

RegisterNetEvent('qb-policedepartments:client:OpenEvidenceLocker', function(data)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "evidence_"..data, {
        maxweight = 6000000,
        slots = 200,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "evidence_"..data)
end)

-- Personal lockers

RegisterNetEvent('qb-policedepartments:client:PersonalLocker', function(data)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", data.job.."_"..QBCore.Functions.GetPlayerData().citizenid, {
        maxweight = 2000000,
        slots = 40
    })
    TriggerEvent("inventory:client:SetCurrentStash", data.job.."_"..QBCore.Functions.GetPlayerData().citizenid)
end)

RegisterNetEvent('qb-policedepartments:client:CheckLocker', function()
    local input = exports['qb-input']:ShowInput({
        header = "Personal Lockers",
        submitText = "Submit",
        inputs = {
            {
                type = 'text',
                isRequired = true,
                name = 'cid',
                text = "Citizen ID"
            }
        }
    })
    if input then
        if not input.cid then return end
        local answer = string.upper(input.cid)

        if Shared.Whitelist[answer] then
            local keyboard, input = exports["var-password"]:Keyboard({header = "Password", rows = {""}})
            if keyboard then
                QBCore.Functions.TriggerCallback('qb-policedepartments:server:CheckLocker', function(canOpen)
                    if canOpen then
                        TriggerServerEvent("inventory:server:OpenInventory", "stash", PlayerJob.name..'_'..answer, {
                            maxweight = 2000000,
                            slots = 40
                        })
                        TriggerEvent("inventory:client:SetCurrentStash", PlayerJob.name..'_'..answer)
                    end
                end, answer, input)
            end
        else
            QBCore.Functions.TriggerCallback('qb-policedepartments:server:CheckLocker', function(canOpen)
                if canOpen then
                    TriggerServerEvent("inventory:server:OpenInventory", "stash", PlayerJob.name..'_'..answer, {
                        maxweight = 2000000,
                        slots = 40
                    })
                    TriggerEvent("inventory:client:SetCurrentStash", PlayerJob.name..'_'..answer)
                end
            end, answer)
        end
    end
end)

-- Armory
local function SetWeaponSeries()
    for k, v in pairs(Shared.Armory.items) do
        if v.type == 'weapon' then
            v.info.serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
        end
    end
end

RegisterNetEvent('qb-policedepartments:client:OpenArmory', function()
    local pData = QBCore.Functions.GetPlayerData()

    local authorizedItems = {
        label = "Police Armory",
        slots = 34,
        items = {}
    }
    local index = 1
    for _, armoryItem in ipairs(Shared.Armory.items) do
        if armoryItem.authorizedJobGrades <= pData.job.grade.level then
            if armoryItem.cert == "all" or (armoryItem.cert and pData.metadata.certificates[armoryItem.cert]) then
                authorizedItems.items[index] = armoryItem
                authorizedItems.items[index].slot = index
                index = index + 1
            end
        end
    end
    SetWeaponSeries()
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "police", authorizedItems)
end)