dropInventories, isShowingTaskbar = {}, false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlJustReleased(0, 289) and IsInputDisabled(0) and not isUsingItem then
            openInventory()
        end

        if not isShowingTaskbar and (IsDisabledControlJustPressed(0, 37)) then
            isShowingTaskbar = true

            SendUiMessage({ eventName = 'setActionBar', status = true, actionData = CRP.RPC:execute('GetActionBarData') })
        end

        if isShowingTaskbar and (IsDisabledControlReleased(0, 37)) then
            SendUiMessage({ eventName = 'setActionBar', status = false })

            isShowingTaskbar = false
        end

        if IsControlJustPressed(0, 157) and not isUsingItem then
            if not isWeaponEquiped or (isWeaponEquiped and weaponSlot ~= 1) then
                UseItem(1)
            elseif isWeaponEquiped then
                Holster()
            end
        end

        if IsControlJustPressed(0, 158) and not isUsingItem then
            if not isWeaponEquiped or (isWeaponEquiped and weaponSlot ~= 2) then
                UseItem(2)
            elseif isWeaponEquiped then
                Holster()
            end
        end

        if IsControlJustPressed(0, 160) and not isUsingItem then
            if not isWeaponEquiped or (isWeaponEquiped and weaponSlot ~= 3) then
                UseItem(3)
            elseif isWeaponEquiped then
                Holster()
            end
        end

        if IsControlJustPressed(0, 164) and not isUsingItem then
            if not isWeaponEquiped or (isWeaponEquiped and weaponSlot ~= 4) then
                UseItem(4)
            elseif isWeaponEquiped then
                Holster()
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local coords, letSleep = GetEntityCoords(PlayerPedId()), true

        for i = 1, #dropInventories, 1 do
            local distance = #(vector3(dropInventories[i].coords.x, dropInventories[i].coords.y, dropInventories[i].coords.z) - coords)

            if distance < 20.0 then
				DrawMarker(20, dropInventories[i].coords.x, dropInventories[i].coords.y, dropInventories[i].coords.z - 0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.25, 0.25, 255, 255, 255, 100, false, true, 2, false, false, false, false)

				letSleep = false
			end
        end

        if letSleep then
			Citizen.Wait(1500)
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        DisableControlAction(0, 14, true)
        DisableControlAction(0, 15, true)
        DisableControlAction(0, 16, true)
        DisableControlAction(0, 17, true)
        DisableControlAction(0, 37, true)
        DisableControlAction(0, 99, true)

        DisableControlAction(0, 100, true)
        DisableControlAction(0, 115, true)
        DisableControlAction(0, 116, true)
    end
end)

function openInventory()
    local playerPed = PlayerPedId()

    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if vehicle ~= 0 then
            TriggerInventoryAnimation(playerPed)
            TriggerEvent('crp-ui:openMenu', 'inventory', { type = 3, name = 'glovebox-' .. GetVehicleNumberPlateText(vehicle) })
        end
    else
        local coords = GetEntityCoords(playerPed)
        local inventoryName, inventoryDistance, inventoryCoords

        for i = 1, #dropInventories, 1 do
            local distance = #(coords - vector3(dropInventories[i].coords.x, dropInventories[i].coords.y, dropInventories[i].coords.z))

            if distance <= 2.0 then
                if inventoryName == nil or inventoryDistance < distance then
                    inventoryName, inventoryDistance = dropInventories[i].name
                    inventoryCoords = { x = dropInventories[i].coords.x, y = dropInventories[i].coords.y, z = dropInventories[i].coords.z }
                end
            end
        end

        if inventoryName ~= nil then
            TriggerInventoryAnimation(playerPed)
            TriggerEvent('crp-ui:openMenu', 'inventory', { type = 1, name = inventoryName, coords = inventoryCoords })
        else
            local vehicle = GetVehicleInFront(playerPed)

            if vehicle ~= 0 then
                if IsThisModelABicycle(GetEntityModel(vehicle)) then
                    return
                end

                local minimum, maximum = GetModelDimensions(vehicle)
                local position = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, minimum - 0.5, 0.0)

                if #(position - GetEntityCoords(playerPed)) < 3.5 then
                    local vehicleStatus = GetVehicleDoorLockStatus(vehicle)

                    if vehicleStatus == 0 or vehicleStatus == 1 then
                        SetVehicleDoorOpen(vehicle, 5, 0, 0)

                        RequestAnimDict('mini@repair')

                        while not HasAnimDictLoaded('mini@repair') do
                            Citizen.Wait(0)
                        end

                        -- RequestAnimDict('amb@prop_human_bum_bin@idle_b')

                        -- while not HasAnimDictLoaded('amb@prop_human_bum_bin@idle_b') do
                        --     Citizen.Wait(0)
                        -- end

                        TaskTurnPedToFaceEntity(playerPed, vehicle, 1.0)

                        Citizen.Wait(1000)

                        TriggerEvent('crp-ui:openMenu', 'inventory', { type = 2, name = 'trunk-' .. GetVehicleNumberPlateText(vehicle) })

                        while true do
                            if not IsEntityPlayingAnim(playerPed, 'mini@repair', 'fixing_a_player', 3) then
                                TaskPlayAnim(playerPed, 'mini@repair', 'fixing_a_player', 8.0, -8, -1, 16, 0, 0, 0, 0)
                            end

                            -- if not IsEntityPlayingAnim(playerPed, 'amb@prop_human_bum_bin@idle_b', 'idle_d', 3) then
                            --     TaskPlayAnim(playerPed, 'amb@prop_human_bum_bin@idle_b', 'idle_d', 8.0, -8, -1, 16, 0, 0, 0, 0)
                            -- end

                            Citizen.Wait(0)
                        end
                    else
                        TriggerEvent('crp-ui:setAlert', { text = 'O veículo está trancado', type = 'inform' })
                    end
                end
            else
                local inventoryName = 'drop-' .. math.random(0, 100000)

                while DoesDropInventoryExist(inventoryName) do
                    inventoryName = 'drop-' .. math.random(0, 100000)
                end

                inventoryCoords = { x = coords.x, y = coords.y, z = coords.z }

                TriggerInventoryAnimation(playerPed)
                TriggerEvent('crp-ui:openMenu', 'inventory', { type = 1, name = inventoryName, coords = inventoryCoords })
            end
        end
    end
end

RegisterUiCallback('getInventories', function(data, cb)
    cb(CRP.RPC:execute('GetInventories', data))
end)

RegisterUiCallback('moveItem', function(moveData, cb)
    local data = CRP.RPC:execute('MoveItem', moveData)

    if not data.status then
        PlaySoundFrontend(-1, 'ERROR', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
    else
        PlaySoundFrontend(-1, 'ERROR', 'HUD_LIQUOR_STORE_SOUNDSET', false)
    end

    cb(data)
end)

RegisterNetEvent('crp-inventory:updateDropInventories')
AddEventHandler('crp-inventory:updateDropInventories', function(newInventories)
	dropInventories = newInventories
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == 'crp-inventory' then
        TriggerEvent('crp-ui:closeMenu')
    end
end)