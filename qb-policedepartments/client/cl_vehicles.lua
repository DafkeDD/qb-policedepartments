local QBCore = exports['qb-core']:GetCoreObject()

local CheckHeli = false
local HeliZone

local BoatSpawned = false
local BoatDistance = 40.0

-- Grab Vehicles

local function doCarDamage(currentVehicle, veh)
	local smash = false
	local damageOutside = false
	local damageOutside2 = false
	local engine = veh.engine + 0.0
	local body = veh.body + 0.0

	if engine < 200.0 then engine = 200.0 end
    if engine  > 1000.0 then engine = 950.0 end
	if body < 150.0 then body = 150.0 end
	if body < 950.0 then smash = true end
	if body < 920.0 then damageOutside = true end
	if body < 920.0 then damageOutside2 = true end

    Wait(100)
    SetVehicleEngineHealth(currentVehicle, engine)

	if smash then
		SmashVehicleWindow(currentVehicle, 0)
		SmashVehicleWindow(currentVehicle, 1)
		SmashVehicleWindow(currentVehicle, 2)
		SmashVehicleWindow(currentVehicle, 3)
		SmashVehicleWindow(currentVehicle, 4)
	end

	if damageOutside then
		SetVehicleDoorBroken(currentVehicle, 1, true)
		SetVehicleDoorBroken(currentVehicle, 6, true)
		SetVehicleDoorBroken(currentVehicle, 4, true)
	end

	if damageOutside2 then
		SetVehicleTyreBurst(currentVehicle, 1, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 2, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 3, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 4, false, 990.0)
	end

	if body < 1000 then
		SetVehicleBodyHealth(currentVehicle, 985.1)
	end
end

local function OpenHeliMenu(department)
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local veh = GetVehiclePedIsIn(ped)
        for i=-1, 5, 1 do                
            local seat = GetPedInVehicleSeat(veh, i)
            if seat ~= 0 then
                TaskLeaveVehicle(seat, veh, 0)
            end
        end
        Wait(1500)
        NetworkFadeOutEntity(veh, true, false)
        Wait(2000)
        QBCore.Functions.DeleteVehicle(veh)
    else
        exports['qb-menu']:openMenu({
            {
                header = "LEO Helicopter",
                txt = "ESC or click to close",
                icon = 'fas fa-angle-left',
                params = {
                    event = "qb-menu:closeMenu",
                }
            },
            {
                header = "Police Maverick",
                txt = "Engine: 100% | Body: 100% | Fuel: 100%",
                icon = 'fas fa-helicopter',
                params = {
                    event = "qb-policedepartments:client:GrabHelicopter",
                    args = {
                        helicopter = "volpolmav",
                        station = department
                    }
                }
            },
        })
    end
end

SetupHeliPoly = function()
    local pData = QBCore.Functions.GetPlayerData()
    if not Shared.Departments[pData.job.name] then return end
    local coords = Shared.Departments[pData.job.name].heliSpawn
    HeliZone = BoxZone:Create(coords.xyz, 10.0, 10.0, {
        name = "helizone_"..pData.job.name,
        heading = coords.w,
        minZ = coords.z - 1.2,
        maxZ = coords.z + 2.0,
        debugPoly = false
    })

    HeliZone:onPlayerInOut(function(isPointInside, point)
        if isPointInside then
            CheckHeli = true
            exports['qb-core']:DrawText('[E] - Helicopter', 'left')
            CreateThread(function()
                while CheckHeli do
                    if IsControlJustPressed(0, 38) then
                        if not QBCore.Functions.GetPlayerData().metadata.certificates.leoheli then
                            QBCore.Functions.Notify("You are not certified to fly Air-1", "error", 2500)
                            exports['qb-core']:KeyPressed(38)
                            CheckHeli = false
                            return
                        end
                        exports['qb-core']:KeyPressed(38)
                        OpenHeliMenu(pData.job.name)
                    end
                    Wait(1)
                end
            end)
        else
            CheckHeli = false
            exports['qb-core']:HideText()
        end
    end)
end

RegisterNetEvent('qb-policedepartments:client:GrabVehicle', function(data)
    local menu = {
        {
            header = "LEO Vehicles",
            txt = "ESC or click to close",
            icon = 'fas fa-angle-left',
            params = {
                event = "qb-menu:closeMenu",
            }
        },
        {
            header = "Ford Crown Vic",
            txt = "Engine: 100% | Body: 100% | Fuel: 100%",
            icon = "fas fa-car",
            params = {
                event = "qb-policedepartments:client:SpawnVehicle",
                args = {
                    car = "volpolvic",
                    station = data.job
                }
            }
        },
        {
            header = "Prison Transport Bus",
            txt = "Engine: 100% | Body: 100% | Fuel: 100%",
            icon = "fas fa-bus",
            params = {
                event = "qb-policedepartments:client:SpawnVehicle",
                args = {
                    car = "pbus",
                    station = data.job
                }
            }
        }
    }
    exports['qb-menu']:openMenu(menu)
end)

RegisterNetEvent('qb-policedepartments:client:SpawnVehicle', function(data)
    local coords = Shared.Departments[data.station].vehicleSpawn
    QBCore.Functions.SpawnVehicle(data.car, function(veh)
        for i=1, 12, 1 do SetVehicleExtra(veh, i, 1) end
        for i=1, #Shared.Extras[data.car], 1 do 
            SetVehicleExtra(veh, Shared.Extras[data.car][i], 0) 
        end

        -- Mods
        SetVehicleModKit(veh, 0)
        ToggleVehicleMod(veh, 18, false) -- Turbo
        SetVehicleMod(veh, 11, -1, false) -- Engine
        SetVehicleMod(veh, 12, -1, false) -- Brakes
        SetVehicleMod(veh, 13, -1, false) -- Transmission
        SetVehicleMod(veh, 15, -1, false) -- Suspension

        SetVehicleLivery(veh, Shared.Departments[data.station].livery)
        SetVehicleColours(veh, 0, 0)
        SetVehicleExtraColours(veh, 134, 156)
        SetVehicleNumberPlateText(veh, "POL"..tostring(math.random(10000, 99999)))
        SetEntityHeading(veh, coords.w)
        exports['qb-fuel']:SetFuel(veh, 100.0)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
    end, coords.xyz, true)
end)

-- Impound List

RegisterNetEvent('qb-policedepartments:client:ImpoundList', function(data)
    local menu = {
        {
            header = "Police Impound",
            txt = "ESC or click to close",
            icon = 'fas fa-angle-left',
            params = {
                event = "qb-menu:closeMenu",
            }
        }
    }
    QBCore.Functions.TriggerCallback("police:GetImpoundedVehicles", function(result)
        if result[1] == nil then
            QBCore.Functions.Notify("No vehicles in impound..", "error", 5000)
        else
            for i=1, #result do
                local enginePercent = QBCore.Shared.Round(result[i].engine / 10, false)
                local bodyPercent = QBCore.Shared.Round(result[i].body / 10, false)
                local currentFuel = result[i].fuel
                local vname = QBCore.Shared.Vehicles[result[i].vehicle].name

                menu[#menu+1] = {
                    header = vname.." ["..result[i].plate.."]",
                    txt = "Engine: "..enginePercent.."% | Body: "..bodyPercent.."% | Fuel: "..currentFuel.."%",
                    icon = 'fas fa-car',
                    params = {
                        event = "qb-policedepartments:client:TakeOutImpound",
                        args = {
                            vehicle = result[i],
                            station = data.job
                        }
                    }
                }
            end

            exports['qb-menu']:openMenu(menu)
        end
    end)
end)

RegisterNetEvent('qb-policedepartments:client:TakeOutImpound', function(data)
    local vehicle = data.vehicle
    local coords = Shared.Departments[data.station].impoundSpawn

    if coords then
        QBCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
            QBCore.Functions.TriggerCallback('qb-garage:server:GetVehicleProperties', function(properties)
                QBCore.Functions.SetVehicleProperties(veh, properties)
                SetVehicleNumberPlateText(veh, vehicle.plate)
                SetEntityHeading(veh, coords.w)
                exports['qb-fuel']:SetFuel(veh, vehicle.fuel)
                doCarDamage(veh, vehicle)
                TriggerServerEvent('police:server:TakeOutImpound', vehicle.plate)
                TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
            end, vehicle.plate)
        end, coords, true)
    end
end)

-- Helicopter

RegisterNetEvent('qb-policedepartments:client:GrabHelicopter', function(data)
    local vehicle = data.helicopter
    local coords = Shared.Departments[data.station].heliSpawn

    QBCore.Functions.SpawnVehicle(vehicle, function(veh)
        SetVehicleLivery(veh, Shared.Departments[data.station].livery)
        SetVehicleColours(veh, 0, 0)
        SetVehicleExtraColours(veh, 134, 156)
        SetVehicleNumberPlateText(veh, "POL"..tostring(math.random(10000, 99999)))
        SetEntityHeading(veh, coords.w)
        exports['qb-fuel']:SetFuel(veh, 100.0)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
    end, coords.xyz, true, true)
end)

-- Boat

local function RotationToDirection(rot)
    local rotZ = math.rad(rot.z)
    local rotX = math.rad(rot.x)
    local cosOfRotX = math.abs(math.cos(rotX))
    return vector3(-math.sin(rotZ) * cosOfRotX, math.cos(rotZ) * cosOfRotX, math.sin(rotX))
end
  
local function RayCastCamera(dist)
    local camRot = GetGameplayCamRot()
    local camPos = GetGameplayCamCoord()
    local dir = RotationToDirection(camRot)
    local dest = camPos + (dir * dist)
    local ray = StartShapeTestRay(camPos, dest, 17, -1, 0)
    local _, hit, endPos, surfaceNormal, entityHit = GetShapeTestResult(ray)
    if hit == 0 then endPos = dest end
    return hit, endPos, entityHit, surfaceNormal
end

RegisterNetEvent('qb-policedepartments:client:GrabBoat', function()
    local department = QBCore.Functions.GetPlayerData().job.name
    if BoatSpawned then return end

    local ModelHash = `volpolboat`
    RequestModel(ModelHash)
    while not HasModelLoaded(ModelHash) do Wait(0) end

    exports['qb-core']:DrawText('[E] - Spawn Boat / [G] - Cancel', 'left')

    local hit, dest, _, _ = RayCastCamera(BoatDistance)
    local heading = GetEntityHeading(PlayerPedId())
    local boat = CreateVehicle(ModelHash, dest.x, dest.y, dest.z, heading, false , false)
    SetEntityCollision(boat, false, false)
    SetVehicleLivery(boat, Shared.Departments[department].livery)
    SetVehicleColours(boat, 0, 0)
    SetVehicleExtraColours(boat, 134, 156)
    SetEntityAlpha(boat, 80, true)

    while not BoatSpawned do
        Wait(3)
        hit, dest, _, _ = RayCastCamera(BoatDistance)
        if hit == 1 then
            -- Move Boat
            SetEntityCoords(boat, dest.x, dest.y, dest.z)

            -- [E] To spawn boat
            if IsControlJustReleased(0, 38) then
                BoatSpawned = true
                exports['qb-core']:KeyPressed(38)
                DeleteVehicle(boat)

                QBCore.Functions.Progressbar("spawn_boat", "Grabbing boat..", 24000, false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = false,
                }, {}, {}, {}, function() 
                    QBCore.Functions.SpawnVehicle('volpolboat', function(veh)
                        SetVehicleLivery(veh, Shared.Departments[department].livery)
                        SetVehicleColours(veh, 0, 0)
                        SetVehicleExtraColours(veh, 134, 156)
                        SetVehicleNumberPlateText(veh, "POL"..tostring(math.random(10000, 99999)))
                        local camRot = GetGameplayCamRot(0)
                        SetEntityHeading(veh, heading)
                        exports['qb-fuel']:SetFuel(veh, 100.0)
                        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                        SetVehicleEngineOn(veh, true, true)
                    end, dest, true, false)
                    BoatSpawned = false
                end, function() 
                    QBCore.Functions.Notify("Cancelled..", "error")
                    BoatSpawned = false
                end)
            end
            
            -- [G] to cancel
            if IsControlJustReleased(0, 47) then
                exports['qb-core']:KeyPressed(47)
                BoatSpawned = false
                DeleteVehicle(boat)
                return
            end

            -- Mousewheel up to rotate
            if IsControlPressed(0, 15) then
                heading += 10.0
                SetEntityHeading(boat, heading + 10.0)
            end

            -- Mousewheel down to rotate
            if IsControlPressed(0, 14) then
                heading -= 10.0
                SetEntityHeading(boat, heading - 10.0)
            end
        else
            Wait(1000)
        end
    end
end)

-- Reset Vehicle

RegisterNetEvent('qb-policedepartments:client:ResetVehicle', function()
    local department = QBCore.Functions.GetPlayerData().job.name
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local veh = GetVehiclePedIsIn(ped)
        local hash = GetEntityModel(veh)
        local model = QBCore.Shared.VehicleHashes[hash].model

        if GetVehicleClass(veh) ~= 18 then return end
        if not Shared.Extras[model] then return end
        if PlayerJob.type ~= "leo" then return end

        -- Extras
        for i=1, 12, 1 do SetVehicleExtra(veh, i, 1) end
        for i=1, #Shared.Extras[model], 1 do SetVehicleExtra(veh, Shared.Extras[model][i], 0) end
        
        -- Livery & Colours
        SetVehicleLivery(veh, Shared.Departments[department].livery)
        SetVehicleColours(veh, 0, 0)
        SetVehicleExtraColours(veh, 134, 156)

        -- Mods
        SetVehicleModKit(veh, 0)
        ToggleVehicleMod(veh, 18, false) -- Turbo
        SetVehicleMod(veh, 11, -1, false) -- Engine
        SetVehicleMod(veh, 12, -1, false) -- Brakes
        SetVehicleMod(veh, 13, -1, false) -- Transmission
        SetVehicleMod(veh, 15, -1, false) -- Suspension

        TriggerServerEvent('qb-vehicletuning:server:SaveVehicleProps', QBCore.Functions.GetVehicleProperties(veh))

    else
        QBCore.Functions.Notify('You must be in a police vehicle', 'error', 2500)
    end
end)

-- Locked Compartment

RegisterNetEvent('qb-policedepartments:client:lockedcompartment', function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        local plate = GetVehicleNumberPlateText(vehicle)
        if GetVehicleClass(vehicle) ~= 18 then return end
        TriggerServerEvent("inventory:server:OpenInventory", "stash", "LockedCompartment_"..plate, {
            maxweight = 20000,
            slots = 5,
        })
        TriggerEvent("inventory:client:SetCurrentStash", "LockedCompartment_"..plate)
    end
end)

CreateThread(function()
    local helipad = "prop_helipad_01"
    local helicoords = vector3(405.58, 712.04, 195.68)

    RequestModel(helipad)
	while not HasModelLoaded(helipad) do Wait(10) end
	if not HasModelLoaded(helipad) then
		SetModelAsNoLongerNeeded(helipad)
	else
		local created_object = CreateObjectNoOffset(helipad, helicoords, false, false, true)
        SetEntityHeading(created_object, 141.7)
		FreezeEntityPosition(created_object, true)
        SetEntityInvincible(created_object, true)
		SetModelAsNoLongerNeeded(helipad)
	end
end)