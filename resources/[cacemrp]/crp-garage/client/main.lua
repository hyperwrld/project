local garages = {
    [1]  = { ['marker'] = { ['x'] = 275.637,   ['y'] = -344.797,  ['z'] = 45.173 }, ['spawner'] = { ['x'] = 271.267,  ['y'] = -343.01,   ['z'] = 44.484, ['h'] = 338.962 }, ['info'] = 'Occupation Ave - Alta' },
    [2]  = { ['marker'] = { ['x'] = 213.738,   ['y'] = -809.301,  ['z'] = 31.015 }, ['spawner'] = { ['x'] = 211.480,  ['y'] = -801.728,  ['z'] = 30.458, ['h'] = 341.781 }, ['info'] = 'San Andreas Ave - Pillbox Hill' },
    [3]  = { ['marker'] = { ['x'] = -73.322,   ['y'] = -2004.00,  ['z'] = 18.275 }, ['spawner'] = { ['x'] = -73.376,  ['y'] = -1999.697, ['z'] = 17.432, ['h'] = 260.904 }, ['info'] = 'Autopia Pkwy - Davis' },
    [4]  = { ['marker'] = { ['x'] = -665.87,   ['y'] = -2003.235, ['z'] = 7.607  }, ['spawner'] = { ['x'] = -657.87,  ['y'] = -2000.973, ['z'] = 6.302,  ['h'] = 260.904 }, ['info'] = 'Davis Ave - La Puerta' },
    [5]  = { ['marker'] = { ['x'] = -2030.658, ['y'] = -465.486,  ['z'] = 11.604 }, ['spawner'] = { ['x'] = -2035.31, ['y'] = -470.744,  ['z'] = 10.796, ['h'] = 227.128 }, ['info'] = 'Del Perro Fwy - Pacific Bluffs' },
    [6]  = { ['marker'] = { ['x'] = -340.799,  ['y'] = 266.764,   ['z'] = 85.679 }, ['spawner'] = { ['x'] = -336.927, ['y'] = 268.878,   ['z'] = 85.245, ['h'] = 178.462 }, ['info'] = 'Eclipse Blvd - West Vinewood' },
    [7]  = { ['marker'] = { ['x'] = -450.521,  ['y'] = -794.007,  ['z'] = 30.54  }, ['spawner'] = { ['x'] = -454.177, ['y'] = -795.095,  ['z'] = 29.964, ['h'] = 358.17  }, ['info'] = 'Vespucci Blvd - Little Seoul' },
    [8]  = { ['marker'] = { ['x'] = 83.754,    ['y'] = 6420.745,  ['z'] = 31.76  }, ['spawner'] = { ['x'] = 88.099,   ['y'] = 6424.168,  ['z'] = 30.778, ['h'] = 39.292  }, ['info'] = 'Great Ocean Hwy - Paleto Bay' },
    [9]  = { ['marker'] = { ['x'] = 638.405,   ['y'] = 206.675,   ['z'] = 97.604 }, ['spawner'] = { ['x'] = 643.17,   ['y'] = 203.575,   ['z'] = 96.277, ['h'] = 329.768 }, ['info'] = 'Clinton Ave - Downtown Vinewood' },
    [10] = { ['marker'] = { ['x'] = 563.73,    ['y'] = 2727.383,  ['z'] = 42.06  }, ['spawner'] = { ['x'] = 569.169,  ['y'] = 2727.733,  ['z'] = 41.475, ['h'] = 273.803 }, ['info'] = 'Route 68 - Harmony' },
}

local currentGarage, isMenuOpen, menuTime = 1, false, 0

local function closeMenu()
    isMenuOpen = false

    SendNUIMessage({ eventName = 'toggleMenu', status = false })
end

local function openMenu(type, data)
	if isMenuOpen then
		closeMenu()
		return
    end

    SendNUIMessage({ eventName = 'toggleMenu', status = true })

	isMenuOpen = true

    Citizen.CreateThread(function()
		while isMenuOpen do
			Citizen.Wait(10)

			if IsControlPressed(0, 18) and IsInputDisabled(0) and (GetGameTimer() - menuTime) > 150 then
                SendNUIMessage({ eventName = 'controlPressed', control = 13 })

                menuTime = GetGameTimer()

                PlaySound(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
			end

			if IsControlPressed(0, 177) and IsInputDisabled(0) and (GetGameTimer() - menuTime) > 150 then
                SendNUIMessage({ eventName  = 'controlPressed', control = 27 })

                menuTime = GetGameTimer()

                PlaySound(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
			end

			if IsControlPressed(0, 174) and IsInputDisabled(0) and (GetGameTimer() - menuTime) > 150 then
                SendNUIMessage({ eventName  = 'controlPressed', control = 37 })

                menuTime = GetGameTimer()

                PlaySound(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
            end

            if IsControlPressed(0, 27) and IsInputDisabled(0) and (GetGameTimer() - menuTime) > 200 then
                SendNUIMessage({ eventName  = 'controlPressed', control = 38 })

                menuTime = GetGameTimer()

                PlaySound(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
			end

			if IsControlPressed(0, 175) and IsInputDisabled(0) and (GetGameTimer() - menuTime) > 150 then
                SendNUIMessage({ eventName  = 'controlPressed', control = 39 })

                menuTime = GetGameTimer()

                PlaySound(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
            end

            if IsControlPressed(0, 173) and IsInputDisabled(0) and (GetGameTimer() - menuTime) > 200 then
                SendNUIMessage({ eventName  = 'controlPressed', control = 40 })

                menuTime = GetGameTimer()

                PlaySound(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 0, 0, 1)
			end
		end
	end)
end

local function nuiCallBack(data, cb)
    local events = exports['crp-base']:getModule('Events')

	if data.close then closeMenu() end

    if data.storeVehicle then
        local closestVehicle = GetClosestVehicle(garages[currentGarage]['spawner']['x'], garages[currentGarage]['spawner']['y'], garages[currentGarage]['spawner']['z'], 3.0, 0, 70)

        if not DoesEntityExist(closestVehicle) then
            closestVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        end

        if #(vector3(garages[currentGarage]['spawner']['x'], garages[currentGarage]['spawner']['y'], garages[currentGarage]['spawner']['z']) - GetEntityCoords(closestVehicle)) > 5.0 then
            exports['crp-notifications']:SendAlert('inform', 'Não foi encontrado nenhum veículo.')
            return
        end

        if DoesEntityExist(closestVehicle) then
            local vehiclePlate = GetVehicleNumberPlateText(closestVehicle)

            local success = RPC.execute('StoreVehicle', { garage = currentGarage, plate = vehiclePlate })

            if success then
                -- Remove keys

                DeleteVehicle(closestVehicle)
            else
                exports['crp-notifications']:SendAlert('inform', 'O veículo que tentou guardar não existe.')
            end
        else
            exports['crp-notifications']:SendAlert('inform', 'Não foi encontrado nenhum veículo.')
        end
    end

    if data.getVehicles then
        cb(RPC.execute('GetPlayerVehicles', currentGarage))
    end

    if data.spawnVehicle then
        local closestVehicle = GetClosestVehicle(garages[currentGarage]['spawner']['x'], garages[currentGarage]['spawner']['y'], garages[currentGarage]['spawner']['z'], 5.0, 0, 70)

        if DoesEntityExist(closestVehicle) then
            exports['crp-notifications']:SendAlert('inform', 'A área de spawn está bloqueada.')
        else
            local vehicle = RPC.execute('SpawnVehicle', { garage = currentGarage, plate = data.vehicleInfo.plate })

            if vehicle.status then
                local vehicleData = json.decode(vehicle.data.vehicle)
                local vehicleHash = GetHashKey(vehicleData.model)

                RequestModel(vehicleHash)

                while not HasModelLoaded(vehicleHash) do
                    Citizen.Wait(0)
                end

                SetModelAsNoLongerNeeded(vehicleHash)

                vehicle = CreateVehicle(vehicleHash, garages[currentGarage]['spawner']['x'], garages[currentGarage]['spawner']['y'], garages[currentGarage]['spawner']['z'], true, false)

                DecorSetInt(vehicle, 'currentFuel', vehicle.data.fuel)

                SetVehicleOnGroundProperly(vehicle)
				SetEntityInvincible(vehicle, false)
                SetVehicleModKit(vehicle, 0)
                SetVehicleNumberPlateText(vehicle, vehicle.data.plate)

                if vehicle.data.mods then
                    local vehicleMods = json.decode(vehicle.data.mods)

                    SetVehicleWheelType(vehicle, vehicleMods.wheelType)

                    for i = 0, 49 do
                        if i >= 17 and i <= 22 then
                            ToggleVehicleMod(vehicle, i, vehicleMods.mods[tostring(i)])
                        else
                            SetVehicleMod(vehicle, i, vehicleMods.mods[tostring(i)])
                        end
                    end

                    for i = 0, 3 do
						SetVehicleNeonLightEnabled(vehicle, i, vehicleMods.neon[tostring(i)])
                    end

                    SetVehicleColours(vehicle, vehicleMods.colors[1], vehicleMods.colors[2])
					SetVehicleExtraColours(vehicle, vehicleMods.extraColors[1], vehicleMods.extraColors[2])
					SetVehicleNeonLightsColour(vehicle, vehicleMods.lights[1], vehicleMods.lights[2], vehicleMods.lights[3])
					SetVehicleTyreSmokeColor(vehicle, vehicleMods.smokeColor[1], vehicleMods.smokeColor[2], vehicleMods.smokeColor[3])
					SetVehicleWindowTint(vehicle, vehicleMods.tint)
                else
                    SetVehicleColours(vehicle, 0, 0)
					SetVehicleExtraColours(vehicle, 0, 0)
                end

                SetVehicleHasBeenOwnedByPlayer(vehicle, true)

                local networkId = NetworkGetNetworkIdFromEntity(vehicle)

                SetNetworkIdCanMigrate(networkId, true)


            else
                exports['crp-notifications']:SendAlert('inform', 'Ooops! Alguma coisa não correu bem.')
            end
        end
    end
end

RegisterNUICallback('nuiMessage', nuiCallBack)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed, canSleep = GetPlayerPed(-1), true

        for i = 1, #garages do
            local distance = #(GetEntityCoords(playerPed) - vector3(garages[i]['marker']['x'], garages[i]['marker']['y'], garages[i]['marker']['z']))

            if distance < 35.0 then
                canSleep = false

                DrawMarker(20, garages[i]['marker']['x'], garages[i]['marker']['y'], garages[i]['marker']['z'], 0, 0, 0, 0, 0, 0, 0.7, 1.0, 0.3, 222, 55, 55, 1.0, 0, 0, 2, 0, 0, 0, 0)

                if distance < 2.0 and not IsPedInAnyVehicle(playerPed, true) then
                    if IsControlJustPressed(1, 38) and not isMenuOpen then
                        openMenu()

                        currentGarage = i
                    end
                elseif isMenuOpen then
                    closeMenu()
                end
            end
        end

        if canSleep then
            Citizen.Wait(1500)
        end
    end
end)