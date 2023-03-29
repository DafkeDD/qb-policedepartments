local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    exports['qb-target']:AddBoxZone("bcso_duty", vector3(-447.23, 6012.95, 32.29), 0.35, 0.35, {
        name="bcso_duty",
        heading = 45.0,
        debugPoly = false,
        minZ = 32.29,
        maxZ = 32.59,
     }, {
        options = {
            {
                event = "qb-policejob:ToggleDuty",
                icon = "far fa-clipboard",
                label = "Toggle Duty",
                job = "bcso",
            },
        },
        distance = 1.5
    })

    exports['qb-target']:AddBoxZone("bcso_personallocker", vector3(-436.14, 6009.68, 37.0), 0.55, 2.20, {
        name = "bcso_personallocker",
        heading = 225.0,
        debugPoly = false,
        minZ = 36.00,
        maxZ = 38.20,
     }, {
        options = {
            {
                event = "qb-policedepartments:client:PersonalLocker",
                icon = "far fa-hand-holding",
                label = "Personal Locker",
                job = "bcso",
            },
            {
                event = "qb-policedepartments:client:CheckLocker",
                icon = "far fa-hand-holding",
                label = "Check Locker (HC)",
                job = {
                    ["bcso"] = 7
                }
            }
        },
        distance = 1.5
    })

    exports['qb-target']:SpawnPed({
        model = 'mp_m_weed_01',
        coords = vector4(-453.75, 6001.23, 37.0, 220.88),
        minusOne = true,
        freeze = true,
        invincible = true,
        blockevents = true,
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        target = {
            options = {
                {
                    event = "qb-policedepartments:client:Evidence",
                    icon = "far fa-hand-holding",
                    label = "Open Evidence",
                    job = "bcso",
                },
            },
            distance = 3.0
        }
    })

    exports['qb-target']:AddBoxZone("bcso_fingerprint", vector3(-439.9, 6011.52, 27.58), 1.15, 1.75, {
        name = "bcso_fingerprint",
        heading = 316.00,
        debugPoly = false,
        minZ = 26.98,
        maxZ = 27.68,
    }, {
        options = {
            {
                event = "qb-police:client:scanFingerPrint",
                icon = "far fa-hand-holding",
                label = "Scan Fingerprint",
                job = "bcso",
            },
        },
        distance = 1.5
    })

    exports['qb-target']:AddBoxZone("bcso_armory", vector3(-449.63, 6015.62, 37.0), 0.4, 3.0, {
        name = "bcso_armory",
        heading = 45.00,
        debugPoly = false,
        minZ = 36.00,
        maxZ = 38.00,
    }, {
        options = {
            {
                event = "qb-policedepartments:client:OpenArmory",
                icon = "far fa-hand-holding",
                label = "Open Armory",
                job = "bcso",
            },
        },
        distance = 2.5
    })
end)