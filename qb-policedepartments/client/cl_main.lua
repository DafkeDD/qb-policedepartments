local QBCore = exports['qb-core']:GetCoreObject()
PlayerJob = QBCore.Functions.GetPlayerData().job

local LeoBossMenu
local inZone = false

local bank = 0
local employees = {}
local unemployed = {}

--- Fetches society data and opens boss menu
local OpenBossMenu = function()
    QBCore.Functions.Progressbar("Opening laptop", "Booting systems...", 1000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        QBCore.Functions.TriggerCallback('qb-policedepartments:server:GetDepartmentData', function(result)
            bank = result.balance
            employees = result.employees
            unemployed = result.unemployed
            TriggerEvent("qb-policedepartments:client:menu:OpenBossMenu")
        end, PlayerJob.name)
    end, function() -- Cancel
        QBCore.Functions.Notify("Cancelled..", "error", 2500)
    end)
end

--- This function removes existing boss menu boxzone and adds a new one for the current player job
local SetupPoly = function()
    if not Shared.Departments[PlayerJob.name] then return end
    if PlayerJob.grade.level < Shared.Departments[PlayerJob.name].bossMenuThreshold then return end
    LeoBossMenu = BoxZone:Create(Shared.Departments[PlayerJob.name].bossMenuCoords, 1.0, 1.0, {
        name = 'LeoBossMenu',
        heading = 0.00,
        minZ = Shared.Departments[PlayerJob.name].bossMenuCoords.z - 1.0,
        maxZ = Shared.Departments[PlayerJob.name].bossMenuCoords.z + 1.0,
        debugPoly = false
    })
    LeoBossMenu:onPlayerInOut(function(isPointInside)
        if isPointInside then
            inZone = true
            exports['qb-core']:DrawText('[E] - Manage '..PlayerJob.label, 'left')
            CreateThread(function()
                while inZone do
                    if IsControlJustPressed(0, 38) then
                        exports['qb-core']:KeyPressed(38)
                        OpenBossMenu()
                    end
                    Wait(3)
                end
            end)
        else
            inZone = false
            exports['qb-core']:HideText()
        end
    end)
end

-- (Re)start events

AddEventHandler('onResourceStop', function (resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    PlayerJob = QBCore.Functions.GetPlayerData().job
    Wait(1000)
    SetupPoly()
    SetupHeliPoly()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    SetupPoly()
    SetupHeliPoly()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerJob = {}
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    SetupPoly()
    SetupHeliPoly()
end)

-- Boss Menu Events

RegisterNetEvent('qb-policedepartments:client:menu:OpenBossMenu', function()
    local menu = {
        {
            header = "LEO Boss Menu",
            txt = "ESC or click to close",
            icon = 'fas fa-angle-left',
            params = {
                event = "qb-menu:closeMenu",
            }
        },
        {
            header = "Manage Employees",
            txt = "",
            icon = "fas fa-address-book",
            params = {
                event = "qb-policedepartments:client:menu:OpenEmployees",
            }
        },
        {
            header = "Hire Employee",
            txt = "(Must be unemployed)",
            icon = "fas fa-universal-access",
            params = {
                event = "qb-policedepartments:client:menu:OpenHire",
            }
        },
    }
    if PlayerJob.grade.level >= Shared.Departments[PlayerJob.name].moneyMenuThreshold then
        menu[#menu+1] = {
            header = "Money Management",
            txt = "($ "..bank..")",
            icon = "fas fa-dollar-sign",
            params = {
                event = "qb-policedepartments:client:menu:OpenBank",
            }
        }
    end

    exports['qb-menu']:openMenu(menu)
end)

RegisterNetEvent('qb-policedepartments:client:menu:OpenEmployees', function()
    local menu = {
        {
            header = "Go Back",
            txt = "",
            icon = 'fas fa-angle-left',
            params = {
                event = "qb-policedepartments:client:menu:OpenBossMenu"
            }
        }
    }
    for k, v in pairs(employees) do
        menu[#menu+1] = {
            header = v.name,
            txt = v.citizenid.." - "..v.grade.name,
            icon = 'fas fa-address-card',
            params = {
                event = "qb-policedepartments:client:menu:OpenEmployee",
                args = {
                    employee = v
                }
            }
        }
    end
    exports['qb-menu']:openMenu(menu)
end)

RegisterNetEvent('qb-policedepartments:client:menu:OpenEmployee', function(data)
    exports['qb-menu']:openMenu({
        {
            header = data.employee.name.." - "..data.employee.grade.name,
            txt = "Employee List",
            icon = 'fas fa-angle-left',
            params = {
                event = "qb-policedepartments:client:menu:OpenEmployees"
            }
        },
        {
            header = "Manage Rank",
            txt = "",
            icon = 'fas fa-address-card',
            params = {
                event = "qb-policedepartments:client:menu:FirePromote",
                args = {
                    employee = data.employee
                }
            }
        },
        {
            header = "SWAT Certificate: "..tostring(data.employee.certs.leoswat),
            txt = "",
            icon = 'fas fa-gun',
            params = {
                isServer = true,
                event = "qb-policedepartments:server:ToggleCert",
                args = {
                    cid = data.employee.citizenid,
                    cert = 'leoswat',
                    name = data.employee.name
                }
            }
        },
        {
            header = "Heat Certificate: "..tostring(data.employee.certs.leoheat),
            txt = "",
            icon = 'fas fa-car-rear',
            params = {
                isServer = true,
                event = "qb-policedepartments:server:ToggleCert",
                args = {
                    cid = data.employee.citizenid,
                    cert = 'leoheat',
                    name = data.employee.name
                }
            }
        },
        {
            header = "Boat Certificate: "..tostring(data.employee.certs.leoboat),
            txt = "",
            icon = 'fas fa-ship',
            params = {
                isServer = true,
                event = "qb-policedepartments:server:ToggleCert",
                args = {
                    cid = data.employee.citizenid,
                    cert = 'leoboat',
                    name = data.employee.name
                }
            }
        },
        {
            header = "Bike Certificate: "..tostring(data.employee.certs.leobike),
            txt = "",
            icon = 'fas fa-motorcycle',
            params = {
                isServer = true,
                event = "qb-policedepartments:server:ToggleCert",
                args = {
                    cid = data.employee.citizenid,
                    cert = 'leobike',
                    name = data.employee.name
                }
            }
        },
        {
            header = "Helicopter Certificate: "..tostring(data.employee.certs.leoheli),
            txt = "",
            icon = 'fas fa-helicopter',
            params = {
                isServer = true,
                event = "qb-policedepartments:server:ToggleCert",
                args = {
                    cid = data.employee.citizenid,
                    cert = 'leoheli',
                    name = data.employee.name
                }
            }
        },
        {
            header = "Unmarked Certificate: "..tostring(data.employee.certs.leounmarked),
            txt = "",
            icon = 'fas fa-user-secret',
            params = {
                isServer = true,
                event = "qb-policedepartments:server:ToggleCert",
                args = {
                    cid = data.employee.citizenid,
                    cert = 'leounmarked',
                    name = data.employee.name
                }
            }
        },
        {
            header = "K9 Certificate: "..tostring(data.employee.certs.leok9),
            txt = "",
            icon = 'fas fa-paw',
            params = {
                isServer = true,
                event = "qb-policedepartments:server:ToggleCert",
                args = {
                    cid = data.employee.citizenid,
                    cert = 'leok9',
                    name = data.employee.name
                }
            }
        },
    })
end)

RegisterNetEvent('qb-policedepartments:client:menu:FirePromote', function(data)
    local sourceGrade = PlayerJob.grade.level
    local targetGrade = data.employee.grade.level
    local input = exports['qb-input']:ShowInput({
        header = data.employee.name.." - "..data.employee.grade.name,
        submitText = "Submit",
        inputs = {
            {
                type = 'text',
                isRequired = true,
                name = 'action',
                text = "Fire/Demote/Promote"
            }
        }
    })
    if input then
        if not input.action then return end
        local answer = string.lower(input.action)
        if answer == "fire" then
            if sourceGrade > targetGrade then
                TriggerServerEvent('qb-policedepartments:server:SetJob', data.employee, PlayerJob.name, "fire", 0)
            else
                QBCore.Functions.Notify("You cannot fire employees with the same or higher rank", "error", 2500)
            end
        elseif answer == "promote" then
            -- CAN ONLY PROMOTE UNDER YOU
            if sourceGrade > targetGrade then
                TriggerServerEvent('qb-policedepartments:server:SetJob', data.employee, PlayerJob.name, "promote", targetGrade+1)
            else
                QBCore.Functions.Notify("You cannot promote employees with the same or higher rank", "error", 2500)
            end
        elseif answer == "demote" then
            -- CAN ONLY DEMOTE UNDER YOU
            if sourceGrade > targetGrade then
                TriggerServerEvent('qb-policedepartments:server:SetJob', data.employee, PlayerJob.name, "demote", targetGrade-1)
            else
                QBCore.Functions.Notify("You cannot demote employees with the same or higher rank", "error", 2500)
            end
        else
            QBCore.Functions.Notify("Invalid argument", "error", 2500)
        end
    end
end)

RegisterNetEvent('qb-policedepartments:client:menu:OpenHire', function()
    local menu = {
        {
            header = "Go Back",
            txt = "",
            icon = 'fas fa-angle-left',
            params = {
                event = "qb-policedepartments:client:menu:OpenBossMenu"
            }
        }
    }
    for k, v in pairs(unemployed) do
        menu[#menu+1] = {
            header = v.name,
            txt = v.citizenid,
            icon = 'fas fa-address-card',
            params = {
                event = "qb-policedepartments:client:menu:Hire",
                args = {
                    player = v
                }
            } 
        }
    end
    exports['qb-menu']:openMenu(menu)
end)

RegisterNetEvent('qb-policedepartments:client:menu:Hire', function(data)
    local input = exports['qb-input']:ShowInput({
        header = "Hire "..data.player.name,
        submitText = "Submit",
        inputs = {
            {
                type = 'text',
                isRequired = true,
                name = 'action',
                text = "Type 'Confirm'"
            }
        }
    })
    if input then
        if not input.action then return end
        local answer = string.lower(input.action)
        if answer == "confirm" then
            TriggerServerEvent('qb-policedepartments:server:SetJob', data.player, PlayerJob.name, "hire")
        else
            QBCore.Functions.Notify("Invalid argument", "error", 2500)
        end
    end
end)

RegisterNetEvent('qb-policedepartments:client:menu:OpenBank', function()
    exports['qb-menu']:openMenu({
        {
            header = "Go Back",
            txt = "",
            icon = 'fas fa-angle-left',
            params = {
                event = "qb-policedepartments:client:menu:OpenBossMenu"
            }
        },
        {
            header = "Deposit",
            txt = "",
            icon = 'fas fa-plus',
            params = {
                event = "qb-policedepartments:client:menu:Deposit",
            }
        },
        {
            header = "Withdraw",
            txt = "",
            icon = 'fas fa-minus',
            params = {
                event = "qb-policedepartments:client:menu:Withdraw",
            }
        }
    })
end)

RegisterNetEvent('qb-policedepartments:client:menu:Deposit', function()
    local input = exports['qb-input']:ShowInput({
        header = "Deposit Money",
        submitText = "Submit",
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'amount',
                text = 'Amount'
            }
        }
    })
    if input then
        if not input.amount then return end
        local amount = tonumber(input.amount)
        if amount > 0 then
            bank = bank + amount
            TriggerServerEvent('qb-policedepartments:server:depositBank', amount, PlayerJob.name)
            TriggerEvent('qb-policedepartments:client:menu:OpenBank')
        else
            QBCore.Functions.Notify('Invalid amount..', 'error', 2500)
        end
    end
end)

RegisterNetEvent('qb-policedepartments:client:menu:Withdraw', function(data)
    local input = exports['qb-input']:ShowInput({
        header = "Withdraw Money",
        submitText = "Submit",
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'amount',
                text = 'Amount'
            }
        }
    })
    if input then
        if not input.amount then return end
        local amount = tonumber(input.amount)
        if amount > 0 then
            if bank >= amount then
                bank = bank - amount
                TriggerServerEvent('qb-policedepartments:server:withdrawBank', amount, PlayerJob.name)
            else
                QBCore.Functions.Notify("There is not enough money on the bank account.", "error", 2500)
            end
            TriggerEvent('qb-policedepartments:client:menu:OpenBank')
        else
            QBCore.Functions.Notify('Invalid amount..', 'error', 2500)
        end
    end
end)