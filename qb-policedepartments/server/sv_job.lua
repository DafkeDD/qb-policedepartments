local QBCore = exports['qb-core']:GetCoreObject()

local Whitelist = {
    ["BLG82147"] = "koffiekoek" -- lionheart
}

QBCore.Functions.CreateCallback('qb-policedepartments:server:CheckLocker', function(source, cb, cid, input)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if Player.PlayerData.job.type ~= "leo" then return end

    local targetJob = MySQL.scalar.await('SELECT job FROM players WHERE citizenid = ?', {cid})
    if targetJob then
        if json.decode(targetJob).name ~= Player.PlayerData.job.name then
            TriggerClientEvent('QBCore:Notify', src, "This player is not in your department..", "error", 2500)
            cb(false)
            return
        else
            if Whitelist[cid] ~= nil then
                if input == Whitelist[cid] then
                    -- log
                    TriggerEvent("qb-log:server:CreateLog", "policeabuse", "HC Open Locker", "red", "**"..Player.PlayerData.name.."** has opened the personal locker of: "..cid)
                    cb(true)
                else
                    TriggerClientEvent('QBCore:Notify', src, "Nice try "..Player.PlayerData.charinfo.lastname, "error", 5000)
                    cb(false)
                end
            else
                -- log
                TriggerEvent("qb-log:server:CreateLog", "policeabuse", "HC Open Locker", "red", "**"..Player.PlayerData.name.."** has opened the personal locker of: "..cid)
                cb(true)
            end
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Incorrect citizen id", "error", 2500)
        cb(false)
        return
    end
end)

QBCore.Commands.Add("evidence", "Open evidence locker", {{name="case", help="Case ID"}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    if args[1] ~= nil then 
        if ((Player.PlayerData.job.type == "leo") and Player.PlayerData.job.onduty) then
            TriggerClientEvent("qb-policedepartments:client:OpenEvidenceLocker", src, args[1])
        else
            TriggerClientEvent('QBCore:Notify', src, "You are not an on duty police officer..", "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Fill out all arguments..", "error")
    end
end)

QBCore.Commands.Add("palert", "Create a police alert (LEO HC Only)", {{name="message", help="Message"}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local message = table.concat(args, ' ')
    if Player.PlayerData.job.type == "leo" and Player.PlayerData.job.grade.level >= 5 and Player.PlayerData.job.onduty then
        local sourceCoords = GetEntityCoords(GetPlayerPed(src))
        for _, v in pairs(QBCore.Functions.GetPlayers()) do
            local dist = #(sourceCoords - GetEntityCoords(GetPlayerPed(v)))
            if dist < 500 then
                TriggerClientEvent('qb-phone:client:CustomNotification', v, 'Police Alert', message, 'fas fa-bell', '#ADD8E6', 10000)
            end
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "You are not an on duty LEO high command member..", "error")
    end
end)