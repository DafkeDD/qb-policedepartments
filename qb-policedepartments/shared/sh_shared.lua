Shared = Shared or {}

Shared.Departments = {
    lspd = {
        maxGrade = 8,
        bossMenuCoords = vector3(462.15109, -985.5545, 30.728075),
        bossMenuThreshold = 5,
        moneyMenuThreshold = 7,
        vehicleSpawn = vector4(458.48, -992.04, 25.96, 0.67),
        impoundSpawn = vector4(425.76, -978.81, 25.37, 271.26),
        heliSpawn = vector4(449.39, -981.06, 43.69, 94.15),
        livery = 0,
    },
    bcso = {
        maxGrade = 8,
        bossMenuCoords = vector3(-432.8, 6005.76, 37.0),
        bossMenuThreshold = 5,
        moneyMenuThreshold = 7,
        vehicleSpawn = vector4(-449.01, 6052.85, 31.01, 213.34),
        impoundSpawn = vector4(-445.43, 6055.33, 31.01, 207.82),
        heliSpawn = vector4(-475.09, 5988.42, 31.34, 35.88),
        livery = 1,
    },
    sasp = {
        maxGrade = 4,
        bossMenuCoords = vector3(2505.22, -422.02, 118.03),
        bossMenuThreshold = 3,
        moneyMenuThreshold = 3,
        vehicleSpawn = vector4(2505.22, -422.02, 118.03, 309.32),
        impoundSpawn = vector4(2505.22, -422.02, 118.03, 309.32),
        heliSpawn = vector4(2511.26, -426.58, 118.19, 120.39),
        livery = 2,
    },
    sapr = {
        maxGrade = 4,
        bossMenuCoords = vector3(387.03, 798.55, 190.49),
        bossMenuThreshold = 3,
        moneyMenuThreshold = 3,
        vehicleSpawn = vector4(372.82, 785.92, 186.88, 173.35),
        impoundSpawn = vector4(372.82, 785.92, 186.88, 173.35),
        heliSpawn = vector4(405.85, 711.63, 198.95, 231.38),
        livery = 3,
    },

}

Shared.Extras = {
    -- Patrol
    ['volpolbike'] = {1},
    ['volpolvic'] = {1, 2, 3, 4, 5, 6, 7, 10, 11, 12},
    ['volpolimpala'] = {1, 2, 3, 4, 5, 6, 7, 10, 11, 12},
    ['volpolcharger'] = {1, 2, 3, 4, 5, 6, 7, 10, 11, 12},
    ['volpolexplorer'] = {1, 2, 3, 4, 5, 6, 7, 10, 11, 12},
    ['volpoldurango'] = {1, 2, 3, 4, 5, 6, 7, 10, 11, 12},
    ['volpolf150'] = {1, 2, 3, 4, 5, 6, 7, 10, 11, 12},
    ["volpoltaurus"] = {1, 2, 3, 4, 5, 6, 7, 10, 11, 12},
    ['volpoltahoe'] = {1, 2, 3, 4, 5, 6, 7, 10, 11, 12},

    -- SWAT
    ['volpoltru'] = {},

    -- Bike
    ['volpolbmw'] = {1, 3, 4},
    ['volpolharley'] = {1, 2, 3, 4, 5, 6},

    -- Heat
    ['volpolviper'] = {1, 2, 3, 4, 5, 6, 8, 9, 10, 11},
    ['volpoldemon'] = {1, 2, 3, 4, 5, 6, 12},
    ['volpolstang'] = {1, 2, 3, 5},

    -- Unmarked
    ['ucballer'] = {10, 12},
    ['ucbanshee'] = {1, 2, 10},
    ['ucbuffalo'] = {11, 12},
    ['uccomet'] = {},
    ['uccoquette'] = {1, 2, 10, 11},
    ['ucprimo'] = {11, 12},
    ['ucrancher'] = {10, 11, 12},
    ['ucwashington'] = {12},

    -- K9
    ['volpoltahoek9'] = {1, 2, 3, 4, 5, 6, 7, 10, 11, 12},
    
    -- Other
    ['pbus'] = {}
}

Shared.Whitelist = {
    ["BLG82147"] = true -- lh
}

Shared.Armory = {
    label = "Police Armory",
    slots = 34,
    items = {
        [1] = {
            name = "weapon_stungun",
            price = 250,
            amount = 1,
            info = {
                serie = "",            
            },
            type = "weapon",
            slot = 1,
            authorizedJobGrades = 0,
            cert = "all"
        },
        [2] = {
            name = "taser_ammo",
            price = 12,
            amount = 15,
            info = {},
            type = "item",
            slot = 2,
            authorizedJobGrades = 0,
            cert = "all"
        },
        [3] = {
            name = "weapon_combatpistol",
            price = 560,
            amount = 1,
            info = {
                serie = "",                
                attachments = {
                    {component = "COMPONENT_AT_PI_FLSH", label = "Flashlight"},
                }
            },
            type = "weapon",
            slot = 3,
            authorizedJobGrades = 0,
            cert = "all"
        },
        [4] = {
            name = "weapon_g17",
            price = 560,
            amount = 1,
            info = {
                serie = "",            
            },
            type = "weapon",
            slot = 4,
            authorizedJobGrades = 0,
            cert = "all"
        },
        [5] = {
            name = "weapon_p226",
            price = 720,
            amount = 1,
            info = {
                serie = "",            
            },
            type = "weapon",
            slot = 5,
            authorizedJobGrades = 2,
            cert = "all"
        },
        [6] = {
            name = "pistol_ammo",
            price = 12,
            amount = 15,
            info = {},
            type = "item",
            slot = 6,
            authorizedJobGrades = 0,
            cert = "all"
        },
        [7] = {
            name = "weapon_nightstick",
            price = 0,
            amount = 1,
            info = {},
            type = "weapon",
            slot = 7,
            authorizedJobGrades = 0,
            cert = "all"
        },
        [8] = {
            name = "pd_emergencybutton",
            price = 0,
            amount = 1,
            info = {},
            type = "item",
            slot = 8,
            authorizedJobGrades = 0,
            cert = "all"
        },
        [9] = {
            name = "weapon_flashlight",
            price = 75,
            amount = 1,
            info = {},
            type = "weapon",
            slot = 9,
            authorizedJobGrades = 0,
            cert = "all"
        },
        [10] = {
            name = "handcuffs",
            price = 25,
            amount = 1,
            info = {},
            type = "item",
            slot = 10,
            authorizedJobGrades = 0,
            cert = "all"
        },
        [11] = {
            name = "radio",
            price = 34,
            amount = 1,
            info = {},
            type = "item",
            slot = 11,
            authorizedJobGrades = 0,
            cert = "all"
        },
        [12] = {
            name = "bandage",
            price = 25,
            amount = 5250,
            info = {},
            type = "item",
            slot = 12,
            authorizedJobGrades = 0,
            cert = "all"
        },
        [13] = {
            name = "empty_evidence_bag",
            price = 0,
            amount = 15,
            info = {},
            type = "item",
            slot = 13,
            authorizedJobGrades = 0,
            cert = "all"
        },
        [14] = {
            name = "pd_gsrtest",
            price = 0,
            amount = 15,
            info = {},
            type = "item",
            slot = 14,
            authorizedJobGrades = 0,
            cert = "all"
        },
        [15] = {
            name = "armor",
            price = 75,
            amount = 5,
            info = {},
            type = "item",
            slot = 15,
            authorizedJobGrades = 0,
            cert = "all"
        },
        [16] = {
            name = "weapon_m870",
            price = 980,
            amount = 1,
            info = {
                serie = "",                
                attachments = {}
            },
            type = "weapon",
            slot = 16,
            authorizedJobGrades = 1,
            cert = "all"
        },
        [17] = {
            name = "shotgun_ammo",
            price = 10,
            amount = 15,
            info = {},
            type = "item",
            slot = 17,
            authorizedJobGrades = 1,
            cert = "all"
        },
        [18] = {
            name = "police_stormram",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 18,
            authorizedJobGrades = 2,
            cert = "all"
        },
        [19] = {
            name = "pd_spikestrip",
            price = 1000,
            amount = 50,
            info = {},
            type = "item",
            slot = 19,
            authorizedJobGrades = 2,
            cert = "all"
        },
        [20] = {
            name = "heavyarmor",
            price = 150,
            amount = 5,
            info = {},
            type = "item",
            slot = 20,
            authorizedJobGrades = 2,
            cert = "all"
        },
        [21] = {
            name = "weapon_smg",
            price = 1100,
            amount = 1,
            info = {
                serie = "",                
                attachments = {
                    {component = "COMPONENT_AT_SCOPE_MACRO_02", label = "1x Scope"},
                    {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                }
            },
            type = "weapon",
            slot = 21,
            authorizedJobGrades = 2,
            cert = "all"
        },
        [22] = {
            name = "smg_ammo",
            price = 10,
            amount = 15,
            info = {},
            type = "item",
            slot = 22,
            authorizedJobGrades = 2,
            cert = "all"
        },
        [23] = {
            name = "weapon_carbinerifle",
            price = 1400,
            amount = 1,
            info = {
                serie = "",
                attachments = {
                    {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                    {component = "COMPONENT_AT_SCOPE_MEDIUM", label = "3x Scope"},
                }
            },
            type = "weapon",
            slot = 23,
            authorizedJobGrades = 3,
            cert = "all"
        },
        [24] = {
            name = "rifle_ammo",
            price = 10,
            amount = 15,
            info = {},
            type = "item",
            slot = 24,
            authorizedJobGrades = 3,
            cert = "all"
        },
        [25] = {
            name = "diving_gear",
            price = 2500,
            amount = 5,
            info = {},
            type = "item",
            slot = 25,
            authorizedJobGrades = 3,
            cert = "leoswat"
        },
        [26] = {
            name = "nightvision",
            price = 4500,
            amount = 5,
            info = {},
            type = "item",
            slot = 26,
            authorizedJobGrades = 3,
            cert = "leoswat"
        },
        [27] = {
            name = "parachute",
            price = 2500,
            amount = 5,
            info = {},
            type = "item",
            slot = 27,
            authorizedJobGrades = 3,
            cert = "leoswat"
        },
        [28] = {
            name = "weapon_p416",
            price = 1600,
            amount = 1,
            info = {
                serie = "",            
            },
            type = "weapon",
            slot = 28,
            authorizedJobGrades = 4,
            cert = "leoswat"
        },
        [29] = {
            name = "weapon_hk416b",
            price = 1750,
            amount = 1,
            info = {
                serie = "",            
            },
            type = "weapon",
            slot = 29,
            authorizedJobGrades = 4,
            cert = "leoswat"
        },
        [30] = {
            name = "weapon_scar",
            price = 1950,
            amount = 1,
            info = {
                serie = "",            
            },
            type = "weapon",
            slot = 30,
            authorizedJobGrades = 4,
            cert = "leoswat"
        },
        [31] = {
            name = "weapon_pdtraining",
            price = 100,
            amount = 1,
            info = {
                serie = "",            
            },
            type = "weapon",
            slot = 31,
            authorizedJobGrades = 4,
            cert = "all"
        },
        [32] = {
            name = "practice_ammo",
            price = 10,
            amount = 15,
            info = {},
            type = "item",
            slot = 32,
            authorizedJobGrades = 4,
            cert = "all"
        },
        [33] = {
            name = "pd_breachingcharge",
            price = 8000,
            amount = 5,
            info = {},
            type = "item",
            slot = 33,
            authorizedJobGrades = 3,
            cert = "leoswat"
        },
        [34] = {
            name = "pet_k9",
            price = 20000,
            amount = 1,
            info = {},
            type = "item",
            slot = 34,
            authorizedJobGrades = 1,
            cert = "leok9"
        }
    }
}