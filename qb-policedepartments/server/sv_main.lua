local QBCore = exports['qb-core']:GetCoreObject()

local debug = true

local balances = {}

RegisterServerEvent('qb-policedepartments:server:withdrawBank', function(amount, society)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if Player.PlayerData.job.name ~= society then return end
    if Player.PlayerData.job.grade.level < Shared.Departments[society].moneyMenuThreshold then return end

    local result = MySQL.scalar.await('SELECT amount FROM management_funds WHERE job_name = ?', {society})
    local bank = math.floor(result)
    local newBalance = (bank - amount)
    if amount <= bank then
        -- notify client
        TriggerClientEvent('QBCore:Notify', src, "You withdrew "..amount, "success", 2500)    
        -- give bank money
        Player.Functions.AddMoney('bank', amount, "LEO Department bank")
        -- update cached
        balances[society] = newBalance
        -- update database
        MySQL.update('UPDATE management_funds SET amount = ? WHERE job_name = ?', {newBalance, society})
        --log
        TriggerEvent("qb-log:server:CreateLog", "societies", "Withdraw "..society, "red", "**" .. Player.PlayerData.name .. "** (citizenid: *" .. Player.PlayerData.citizenid .. "* | id: *" .. Player.PlayerData.source .. ")*: Withdrew **" .. amount .. "**. New balance: "..newBalance)
        if debug then
            print("^3[qb-policedepartments] ^5"..Player.PlayerData.name.." withdrew "..amount..". New balance: "..newBalance.." ("..society..")".."^7")
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "There is not enough money on the bank account.", "error", 2500)
    end
end)

RegisterServerEvent('qb-policedepartments:server:depositBank', function(amount, society)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if Player.PlayerData.job.name ~= society then return end
    if Player.PlayerData.job.grade.level < Shared.Departments[society].moneyMenuThreshold then return end
    
    local result = MySQL.scalar.await('SELECT amount FROM management_funds WHERE job_name = ?', {society})
    local bank = math.floor(result)
    local newBalance = (bank + amount)
    local sourceBank = Player.PlayerData.money.bank

    if amount <= sourceBank then
        -- notify client
        TriggerClientEvent('QBCore:Notify', src, "You deposited "..amount, "success", 2500)   
        -- take bank money
        Player.Functions.RemoveMoney('bank', amount, "LEO Department bank")
        -- update cached
        balances[society] = newBalance
        -- update database
        MySQL.update('UPDATE management_funds SET amount = ? WHERE job_name = ?', {newBalance, society})
        -- log
        TriggerEvent("qb-log:server:CreateLog", "societies", "Deposit "..society, "green", "**" .. Player.PlayerData.name .. "** (citizenid: *" .. Player.PlayerData.citizenid .. "* | id: *" .. Player.PlayerData.source .. ")*: Deposited **" .. amount .. "**. New balance: "..newBalance)
        if debug then
            print("^3[qb-policedepartments] ^5"..Player.PlayerData.name.." deposit "..amount..". New balance: "..newBalance.." ("..society..")".."^7")
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "There is not enough money on your bank account.", "error", 2500)
    end
end)

RegisterNetEvent('qb-policedepartments:server:SetJob', function(employee, job, action, grade)
    local src = source
    local sourcePlayer = QBCore.Functions.GetPlayer(src)
    if not sourcePlayer then return end
    if sourcePlayer.PlayerData.job.name ~= job then return end
    if sourcePlayer.PlayerData.job.grade.level < Shared.Departments[job].bossMenuThreshold then return end

    local citizenid = employee.citizenid
    local Player = QBCore.Functions.GetPlayerByCitizenId(citizenid)
    if Player then -- Online
        if action == "promote" then
            if grade <= Shared.Departments[job].maxGrade then
                Player.Functions.SetJob(job, grade)
                TriggerClientEvent('QBCore:Notify', sourcePlayer.PlayerData.source, "You successfully promoted "..employee.name, "success", 3500)
                TriggerEvent("qb-log:server:CreateLog", "societies", "Promoted "..job, "blue", "**" .. employee.name .. "** (citizenid: *" .. citizenid .. "* | id: *" .. Player.PlayerData.source .. ")*: Has been promoted to "..job.." "..grade)
            else
                -- MAX GRADE
                TriggerClientEvent('QBCore:Notify', sourcePlayer.PlayerData.source, "You can't promote this person (Max Grade).", "error", 3500)
            end
        elseif action == "demote" then
            if grade >= 0 then
                Player.Functions.SetJob(job, grade)
                TriggerClientEvent('QBCore:Notify', sourcePlayer.PlayerData.source, "You successfully demoted "..Player.PlayerData.name, "success", 3500)
                TriggerEvent("qb-log:server:CreateLog", "societies", "Demoted "..job, "blue", "**" .. employee.name .. "** (citizenid: *" .. citizenid .. "* | id: *" .. Player.PlayerData.source .. ")*: Has been demoted to "..job.." "..grade)
            else
                -- LOWEST GRADE
                TriggerClientEvent('QBCore:Notify', sourcePlayer.PlayerData.source, "You can't demote this person (Min Grade).", "error", 3500)
            end
        elseif action == "fire" then
            Player.Functions.SetJob("unemployed", 0)
            TriggerClientEvent('QBCore:Notify', sourcePlayer.PlayerData.source, "You successfully fired "..Player.PlayerData.name, "success", 3500)
            TriggerEvent("qb-log:server:CreateLog", "societies", "Fired "..job, "blue", "**" .. employee.name .. "** (citizenid: *" .. citizenid .. "* | id: *" .. Player.PlayerData.source .. ")*: Has been fired from "..job)
        elseif action == "hire" then
            Player.Functions.SetJob(job, 0)
            TriggerClientEvent('QBCore:Notify', sourcePlayer.PlayerData.source, "You successfully hired "..Player.PlayerData.name, "success", 3500)
            TriggerEvent("qb-log:server:CreateLog", "societies", "Hired "..job, "blue", "**" .. employee.name .. "** (citizenid: *" .. citizenid .. "* | id: *" .. Player.PlayerData.source .. ")*: Has been hired for "..job)
        end
    else -- Offline
        if action == "promote" then
            if grade <= Shared.Departments[job].maxGrade then
                local jobInfo = QBCore.Shared.Jobs[job]
                local temp = {
                    name = job,
                    label = jobInfo.label,
                    onduty = true,
                    type = jobInfo.type,
                    payment = jobInfo.grades[tostring(grade)].payment,
                    isboss = false,
                    grade = {
                        name = jobInfo.grades[tostring(grade)].name,
                        level = grade
                    }
                }
                MySQL.update('UPDATE players SET job = ? WHERE citizenid = ?', {json.encode(temp), citizenid})
                TriggerClientEvent('QBCore:Notify', sourcePlayer.PlayerData.source, "You successfully promoted "..employee.name, "success", 3500)
                TriggerEvent("qb-log:server:CreateLog", "societies", "Offline Promoted "..job, "blue", "**"..employee.name.."** (citizenid: *"..citizenid.."*): Has been promoted to "..job.." "..grade)
            else
                -- MAX GRADE
                TriggerClientEvent('QBCore:Notify', sourcePlayer.PlayerData.source, "You can't promote this person (Max Grade).", "error", 3500)
            end
        elseif action == "demote" then
            if grade >= 0 then
                local jobInfo = QBCore.Shared.Jobs[job]
                local temp = {
                    name = job,
                    label = jobInfo.label,
                    onduty = true,
                    type = jobInfo.type,
                    payment = jobInfo.grades[tostring(grade)].payment,
                    isboss = false,
                    grade = {
                        name = jobInfo.grades[tostring(grade)].name,
                        level = grade
                    }
                }
                MySQL.update('UPDATE players SET job = ? WHERE citizenid = ?', {json.encode(temp), citizenid})
                TriggerClientEvent('QBCore:Notify', sourcePlayer.PlayerData.source, "You successfully demoted "..employee.name, "success", 3500)
                TriggerEvent("qb-log:server:CreateLog", "societies", "Offline Demoted "..job, "blue", "**"..employee.name.."** (citizenid: *"..citizenid.."*): Has been demoted to "..job.." "..grade)
            else
                -- LOWEST GRADE
                TriggerClientEvent('QBCore:Notify', sourcePlayer.PlayerData.source, "You can't demote this person (Min Grade).", "error", 3500)
            end
        elseif action == "fire" then
            local jobInfo = QBCore.Shared.Jobs['unemployed']
            local temp = {
                name = 'unemployed',
                label = jobInfo.label,
                onduty = true,
                type = jobInfo.type,
                payment = jobInfo.grades['0'].payment,
                isboss = false,
                grade = {
                    name = jobInfo.grades['0'].name,
                    level = 0
                }
            }
            MySQL.update('UPDATE players SET job = ? WHERE citizenid = ?', {json.encode(temp), citizenid})
            TriggerClientEvent('QBCore:Notify', sourcePlayer.PlayerData.source, "You successfully fired "..employee.name, "success", 3500)
            TriggerEvent("qb-log:server:CreateLog", "societies", "Offline Fired "..job, "blue", "**"..employee.name.."** (citizenid: *"..citizenid.."*): Has been fired from "..job)
        end
    end
end)

RegisterNetEvent('qb-policedepartments:server:ToggleCert', function(data)
    local src = source
    local sourcePlayer = QBCore.Functions.GetPlayer(src)
    if not sourcePlayer then return end

    local targetPlayer = QBCore.Functions.GetPlayerByCitizenId(data.cid)
    if targetPlayer then -- Online
        local CData = targetPlayer.PlayerData.metadata.certificates
        CData[data.cert] = not CData[data.cert]
        targetPlayer.Functions.SetMetaData("certificates", CData)

        -- Notify
        TriggerClientEvent('QBCore:Notify', sourcePlayer.PlayerData.source, "Set "..data.cert.." of "..data.name.." to "..tostring(CData[data.cert]), "success", 3500)
        TriggerClientEvent('QBCore:Notify', targetPlayer.PlayerData.source, "Your "..data.cert.." has been set to "..tostring(CData[data.cert]), "success", 3500)
        
        -- Log
        TriggerEvent("qb-log:server:CreateLog", "societies", "Toggle Cert "..data.cert, "blue", "**" .. targetPlayer.PlayerData.name .. "** (citizenid: *" .. targetPlayer.PlayerData.citizenid .. "* | id: *" .. targetPlayer.PlayerData.source .. ")*: "..data.cert.." set to "..tostring(CData[data.cert]).." by "..sourcePlayer.PlayerData.name)
    else -- Offline
        local result = MySQL.query.await('SELECT * FROM players WHERE citizenid = ?', {data.cid})
        local MetaData = json.decode(result[1].metadata)
        MetaData.certificates[data.cert] = not MetaData.certificates[data.cert]
        MySQL.update('UPDATE players SET metadata = ? WHERE citizenid = ?', {json.encode(MetaData), data.cid})
        
        -- Notify
        TriggerClientEvent('QBCore:Notify', sourcePlayer.PlayerData.source, "Set "..data.cert.." of "..data.name.." to "..tostring(MetaData.certificates[data.cert]), "success", 3500)
        
        -- Log
        TriggerEvent("qb-log:server:CreateLog", "societies", "Toggle Cert "..data.cert, "blue", "**" .. data.name .. "** (citizenid: *" .. data.cid .. ")*: "..data.cert.." set to "..tostring(MetaData.certificates[data.cert]).." by "..sourcePlayer.PlayerData.name)
    end
end)

QBCore.Functions.CreateCallback('qb-policedepartments:server:GetDepartmentData', function(source, cb, department)
    -- Bank
    local balance = MySQL.scalar.await('SELECT amount FROM management_funds WHERE job_name = ?', {department})
    balances[department] = balance

    -- Employees
    local employees = {}
    local players = MySQL.query.await("SELECT * FROM `players` WHERE `job` LIKE '%"..department.."%'", {})
    for k, v in pairs(players) do
        local isOnline = QBCore.Functions.GetPlayerByCitizenId(v.citizenid)
        if isOnline then
            employees[#employees+1] = {
                citizenid = isOnline.PlayerData.citizenid,
                grade = isOnline.PlayerData.job.grade,
                certs = isOnline.PlayerData.metadata.certificates,
                name = '🟢 '..isOnline.PlayerData.charinfo.firstname..' '..isOnline.PlayerData.charinfo.lastname
            }
        else
            employees[#employees+1] = {
                citizenid = v.citizenid,
                grade =  json.decode(v.job).grade,
                certs = json.decode(v.metadata).certificates,
                name = '🔴 '..json.decode(v.charinfo).firstname..' '..json.decode(v.charinfo).lastname
            }
        end
        table.sort(employees, function(a, b)
            return a.grade.level > b.grade.level
        end)
    end

    -- Unemployed
    local unemployed = {}
    local online = QBCore.Functions.GetQBPlayers()
    for _, Player in pairs(online) do
        if Player.PlayerData.job.name == "unemployed" then
            unemployed[#unemployed+1] = {
                citizenid = Player.PlayerData.citizenid,
                name = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname
            }
        end
    end

    cb({
        balance = balances[department],
        unemployed = unemployed,
        employees = employees
    })
end)

CreateThread(function()
    MySQL.query('SELECT amount FROM management_funds WHERE job_name IN (?, ?, ?, ?)', {"lspd", "bcso", "sasp", "sapr"}, function(result)
        balances["lspd"] = math.floor(result[1].amount)
        balances["bcso"] = math.floor(result[2].amount)
        balances["sasp"] = math.floor(result[3].amount)
        balances["sapr"] = math.floor(result[4].amount)
    end)
end)