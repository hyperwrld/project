local dropInventories = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlJustReleased(0, 289) then
            openInventory()
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

RegisterNetEvent('crp-inventory:updateDropInventories')
AddEventHandler('crp-inventory:updateDropInventories', function(newInventories)
	dropInventories = newInventories
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

                local vehicleStatus = GetVehicleDoorLockStatus(vehicle)

                if vehicleStatus == 0 and vehicleStatus == 1 then
                    local minimum, maximum = GetModelDimensions(vehicle)
                    local position = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, minimum - 0.5, 0.0)

                    if #(position - GetEntityCoords(playerPed)) then
                        TriggerEvent('crp-ui:openMenu', 'inventory', { type = 2, name = 'trunk-' .. GetVehicleNumberPlateText(vehicle) })
                    end
                else
                    TriggerEvent('crp-ui:setAlert', { text = 'O veículo está trancado', type = 'inform' })
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

function TriggerInventoryAnimation(playerPed)
    RequestAnimDict('pickup_object')

    while not HasAnimDictLoaded('pickup_object') do
        Citizen.Wait(0)
    end

    TaskPlayAnim(playerPed,'pickup_object', 'putdown_low', 5.0, 2.5, 1.0, 48, 0.0, 0, 0, 0)
end

function DoesDropInventoryExist(inventoryName)
    for i = 1, #dropInventories, 1 do
        if dropInventories[i].name == inventoryName then
            return true
        end
    end

    return false
end

function GetVehicleInFront(playerPed)
    local position, entity = GetEntityCoords(playerPed), GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 3.0, 0.0)
    local rayHandle = CastRayPointToPoint(position.x, position.y, position.z, entity.x, entity.y, entity.z, 10, playerPed, 0)
    local retval, hit, endCoords, surfaceNormal, entityHit = GetRaycastResult(rayHandle)

    return entityHit
end

function RegisterUiCallback(name, func)
    TriggerEvent('crp-ui:registerNuiCallback', name, func)
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

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == 'crp-inventory' then
        TriggerEvent('crp-ui:closeMenu')
    end
end)