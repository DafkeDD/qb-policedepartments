local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-policedepartments:client:MRPDevidence1', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "pd_evidence1", {
        maxweight = 4000000,
        slots = 500,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "pd_evidence1")
end)

RegisterNetEvent('qb-policedepartments:client:MRPDevidence2', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "pd_evidence2", {
        maxweight = 4000000,
        slots = 500,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "pd_evidence2")
end)

RegisterNetEvent('qb-policedepartments:client:MRPDevidence3', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "pd_evidence3", {
        maxweight = 4000000,
        slots = 500,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "pd_evidence3")
end)

RegisterNetEvent('qb-policedepartments:client:MRPDProcessing', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "mrpdprocessing", {
        maxweight = 4000000,
        slots = 50,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "mrpdprocessing")
end)

CreateThread(function()
    exports['qb-target']:AddBoxZone("lspd_duty", vector3(441.79, -982.05, 30.67), 0.45, 0.35, {
        name="lspd_duty",
        heading = 11.0,
        debugPoly = false,
        minZ = 30.77,
        maxZ = 30.87,
     }, {
        options = {
            {
                event = "qb-policejob:ToggleDuty",
                icon = "far fa-clipboard",
                label = "Toggle Duty",
                job = "lspd",
            },
        },
        distance = 1.5
    })

    exports['qb-target']:AddBoxZone("lspd_personallocker", vector3(461.98, -1000.26, 30.69), 3.35, 0.55, {
        name = "lspd_personallocker",
        heading = 269.3,
        debugPoly = false,
        minZ = 29.77834,
        maxZ = 32.47834,
     }, {
        options = {
            {
                event = "qb-policedepartments:client:PersonalLocker",
                icon = "fas fa-hand-holding",
                label = "Personal Locker",
                job = "lspd",
            },
            {
                event = "qb-policedepartments:client:CheckLocker",
                icon = "fas fa-hand-holding",
                label = "Check Locker (HC)",
                job = {
                    ["lspd"] = 7
                }
            }
        },
        distance = 1.5
    })

    exports['qb-target']:AddBoxZone("lspd_evidence1", vector3(471.91, -995.34, 26.27), 0.75, 3.65, {
        name="lspd_evidence1",
        heading = 89.65,
        debugPoly = false,
        minZ = 25.47,
        maxZ = 28.27,
     }, {
        options = {
            {
                event = "qb-policedepartments:client:MRPDevidence1",
                icon = "far fa-hand-holding",
                label = "Evidence Locker #1",
                job = "lspd",
            },
        },
        distance = 2.0
    })

    exports['qb-target']:AddBoxZone("lspd_evidence2", vector3(473.89, -995.28, 26.27), 0.75, 3.65, {
        name="lspd_evidence2",
        heading = 89.65,
        debugPoly = false,
        minZ = 25.47,
        maxZ = 28.27,
     }, {
        options = {
            {
                event = "qb-policedepartments:client:MRPDevidence2",
                icon = "far fa-hand-holding",
                label = "Evidence Locker #2",
                job = "lspd",
            },
        },
        distance = 2.0
    })

    exports['qb-target']:AddBoxZone("lspd_evidence3", vector3(475.86, -995.32, 26.27), 0.75, 3.65, {
        name="lspd_evidence3",
        heading = 89.65,
        debugPoly = false,
        minZ = 25.47,
        maxZ = 28.27,
     }, {
        options = {
            {
                event = "qb-policedepartments:client:MRPDevidence3",
                icon = "far fa-hand-holding",
                label = "Evidence Locker #3",
                job = "lspd",
            },
        },
        distance = 2.0
    })

    exports['qb-target']:AddBoxZone("lspd_fingerprint", vector3(473.62, -1014.01, 27.19), 0.75, 0.6, {
        name = "lspd_fingerprint",
        heading = 180.31,
        debugPoly = false,
        minZ = 25.87834,
        maxZ = 26.27834,
     }, {
        options = {
            {
                event = "qb-police:client:scanFingerPrint",
                icon = "far fa-hand-holding",
                label = "Scan Fingerprint",
                job = "lspd",
            },
        },
        distance = 1.5
    })

    exports['qb-target']:AddBoxZone("lspd_armory", vector3(481.42, -994.87, 30.69), 0.4, 3.0, {
        name = "lspd_armory",
        heading = 0.0,
        debugPoly = false,
        minZ = 29.69,
        maxZ = 31.69,
     }, {
        options = {
            {
                event = "qb-policedepartments:client:OpenArmory",
                icon = "far fa-hand-holding",
                label = "Open Armory",
                job = "lspd",
            },
        },
        distance = 2.5
    })

    exports['qb-target']:AddBoxZone("lspd_processing", vector3(473.28, -1006.99, 26.67), 0.4, 2.1, {
        name = "lspd_processing",
        heading = 1.07,
        debugPoly = false,
        minZ = 25.47,
        maxZ = 27.27,
     }, {
        options = {
            {
                event = "qb-policedepartments:client:MRPDProcessing",
                icon = "far fa-hand-holding",
                label = "Item Processing",
                job = "lspd",
            },
        },
        distance = 2.5
    })
end)