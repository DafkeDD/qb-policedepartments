local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    exports['qb-target']:SpawnPed({
        model = 's_m_y_ranger_01',
        coords = vector4(384.81, 794.35, 187.46, 266.2),
        minusOne = true,
        freeze = true,
        invincible = true,
        blockevents = true,
        target = {
            options = { 
                {
                    event = "qb-policejob:ToggleDuty",
                    icon = "far fa-clipboard",
                    label = "Toggle Duty",
                    job = "sapr",
                },
                {
                    event = "qb-policedepartments:client:Evidence",
                    icon = "far fa-hand-holding",
                    label = "Open Evidence",
                    job = "sapr",
                },
                {
                    event = "qb-policedepartments:client:OpenArmory",
                    icon = "far fa-hand-holding",
                    label = "Open Armory",
                    job = "sapr",
                }
            },
            distance = 3.0,
        }
    })

    exports['qb-target']:AddBoxZone("sapr_fingerprint", vector3(385.75, 795.08, 187.46), 0.4, 0.4, {
        name = "sapr_fingerprint",
        heading = 88.86,
        debugPoly = false,
        minZ = 187.46,
        maxZ = 187.66,
    }, {
        options = { 
            {
                event = "qb-police:client:scanFingerPrint",
                icon = "far fa-hand-holding",
                label = "Scan Fingerprint",
                job = "sapr",
            }
        },
        distance = 3.0,
    })

    exports['qb-target']:AddBoxZone("sapr_personallocker", vector3(387.41, 800.17, 187.46), 0.4, 2.0, {
        name = "sapr_personallocker",
        heading = 0.00,
        debugPoly = false,
        minZ = 186.46,
        maxZ = 188.46,
    }, {
            options = { 
            {
                event = "qb-policedepartments:client:PersonalLocker",
                icon = "far fa-hand-holding",
                label = "Personal Locker",
                job = "sapr",
            },
            {
                event = "qb-policedepartments:client:CheckLocker",
                icon = "far fa-hand-holding",
                label = "Check Locker (HC)",
                job = {
                    ["sapr"] = 4   
                }
            }
        },
        distance = 3.0,
    })
end)