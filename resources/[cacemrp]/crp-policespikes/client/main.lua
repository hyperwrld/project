local spikeCoords, isRemovingSpikes = {}, false
local spikesBlip, spikeObject

RegisterNetEvent('crp-policespikes:addSpikes')
AddEventHandler('crp-policespikes:addSpikes', function(id, spikesList)
    spikeCoords[id] = spikesList
end)

RegisterNetEvent('crp-policespikes:removeSpikes')
AddEventHandler('crp-policespikes:removeSpikes', function(id)
    local source = GetPlayerServerId(PlayerId())

    if spikeCoords[id].id == source then
        DeleteSpike(id)
        if DoesBlipExist(spikesBlip) then
            RemoveBlip(spikesBlip)

            exports['crp-notifications']:SendAlert('inform', 'O teu tapete de pregos foi apanhado.')
        end
    end

    table.remove(spikeCoords, id)
end)

RegisterNetEvent('crp-policespikes:watchSpikes')
AddEventHandler('crp-policespikes:watchSpikes', function(watchedSpike)
    local _watchedSpike = watchedSpike

	while true do
        Citizen.Wait(0)
        
        local playerPed = GetPlayerPed(-1)

        if not IsPedInAnyVehicle(playerPed, false) then
	    	return
        end
        
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local vehicleDriver = GetPedInVehicleSeat(vehicle, -1)

        if vehicleDriver ~= playerPed then
            return
        end

        if spikeCoords[_watchedSpike] == nil then
			return
        end
        
        if #(vector3(spikeCoords[_watchedSpike]['x'], spikeCoords[_watchedSpike]['y'], spikeCoords[_watchedSpike]['z']) - GetEntityCoords(playerPed)) > 40.0 then
			spikeCoords[_watchedSpike]['watching'] = false
			return
        end
        
		if not spikeCoords[_watchedSpike]['watching'] then
			return
		end

        local spike = {['x'] = spikeCoords[_watchedSpike]['x'], ['y'] = spikeCoords[_watchedSpike]['y'], ['z'] = spikeCoords[_watchedSpike]['z']}

        local minimum, maximum = GetModelDimensions(GetEntityModel(vehicle))

        local leftFront = GetOffsetFromEntityInWorldCoords(vehicle, minimum['x'] - 0.25, 0.25, 0.0)
        local rightFront = GetOffsetFromEntityInWorldCoords(vehicle, maximum['x'] + 0.25, 0.25, 0.0)
        local leftBack = GetOffsetFromEntityInWorldCoords(vehicle, minimum['x'] - 0.25, -0.85, 0.0)
        local rightBack = GetOffsetFromEntityInWorldCoords(vehicle, maximum['x'] + 0.25, -0.85, 0.0)

        local frontLeftClose, frontRightClose, backLeftClose, backRightClose = false, false, false, false
        
        if #(vector3(spike['x'], spike['y'], spike['z']) - leftFront) < 1.5 then
            if not IsVehicleTyreBurst(vehicle, 0, true) or not IsVehicleTyreBurst(vehicle, 1, true) or not IsVehicleTyreBurst(vehicle, 2, true) then
                frontLeftClose = true

  			    SetVehicleTyreBurst(vehicle, 0, true,  1000.0)
  			    SetVehicleTyreBurst(vehicle, 1, false, 1000.0)
                SetVehicleTyreBurst(vehicle, 2, false, 1000.0)
            end
    	end

        if #(vector3(spike['x'], spike['y'], spike['z']) - rightFront) < 1.5 then
            if not IsVehicleTyreBurst(vehicle, 0, true) or not IsVehicleTyreBurst(vehicle, 1, true) or not IsVehicleTyreBurst(vehicle, 2, true) or not IsVehicleTyreBurst(vehicle, 3, true) then
                frontRightClose = true
                
                SetVehicleTyreBurst(vehicle, 0, false, 1000.0)
                SetVehicleTyreBurst(vehicle, 1, true,  1000.0)
                SetVehicleTyreBurst(vehicle, 2, false, 1000.0)
                SetVehicleTyreBurst(vehicle, 3, false, 1000.0)
            end
    	end

        if #(vector3(spike['x'], spike['y'], spike['z']) - leftBack) < 1.5 then
            if not IsVehicleTyreBurst(vehicle, 0, true) or not IsVehicleTyreBurst(vehicle, 1, true) or not IsVehicleTyreBurst(vehicle, 2, true) or not IsVehicleTyreBurst(vehicle, 3, true) then
                backLeftClose = true
                
                SetVehicleTyreBurst(vehicle, 2, true,  1000.0)
                SetVehicleTyreBurst(vehicle, 1, false, 1000.0)
                SetVehicleTyreBurst(vehicle, 0, false, 1000.0)
                SetVehicleTyreBurst(vehicle, 3, false, 1000.0)	
            end	      		
    	end

        if #(vector3(spike['x'], spike['y'], spike['z']) - rightBack) < 1.5 then
            if not IsVehicleTyreBurst(vehicle, 3, true) or not IsVehicleTyreBurst(vehicle, 4, true) or not IsVehicleTyreBurst(vehicle, 5, true) or not IsVehicleTyreBurst(vehicle, 6, true)  or not IsVehicleTyreBurst(vehicle, 7, true) then
                backRightClose = true
               
                SetVehicleTyreBurst(vehicle, 3, true,  1000.0)
                SetVehicleTyreBurst(vehicle, 4, false, 1000.0)
                SetVehicleTyreBurst(vehicle, 5, false, 1000.0)
                SetVehicleTyreBurst(vehicle, 6, false, 1000.0)
                SetVehicleTyreBurst(vehicle, 7, false, 1000.0)  
            end   		
        end
        
        if (frontLeftClose and frontRightClose) and (backLeftClose and backLeftClose) then 
            Citizen.Wait(1500)
        end
	end
end)

RegisterNetEvent('crp-policespikes:drop')
AddEventHandler('crp-policespikes:drop', function()
    local source = GetPlayerServerId(PlayerId())

    local found = false

    for k, v in pairs(spikeCoords) do
        if v.id == source then
            found = true
            break
        end
    end

    if found then
        exports['crp-notifications']:SendAlert('error', 'Já tens um tapete de pregos no chão.')
        return
    end

    DropSpikesOnGround()
end)

RegisterNetEvent('crp-policespikes:pickup')
AddEventHandler('crp-policespikes:pickup', function()
    if isRemovingSpikes then
        exports['crp-notifications']:SendAlert('error', 'Já estás a remover um tapete de pregos, aguarde!')
        return
    end

    if #spikeCoords == 0 then
        exports['crp-notifications']:SendAlert('error', 'Não existe nenhum tapete de pregos no chão de momento.')
        return
    end

    local playerPed, removing, attempt = GetPlayerPed(-1), true, 0

    isRemovingSpikes = true

	while removing do
        RemoveSpikes()

        Citizen.Wait(500)
        
        attempt = attempt + 1
        
		if attempt > 4 then removing = false end
    end

    Wait(1000)

    isRemovingSpikes = false
end)

function DropSpikesOnGround() 
    local playerPed = GetPlayerPed(-1)
    
    TriggerAnimation(playerPed)

    Citizen.Wait(1000)

    local heading = GetEntityHeading(playerPed)

    for i = 1, 3 do
        local position = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, -1.5 + (3.5 * i), 0.15)

        TriggerServerEvent('crp-policespikes:setPikeLocation', { x = position['x'],  y = position['y'], z = position['z'], h = heading })
    end

    local position = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 2.5, 0.15)

    spikesBlip = AddBlipForCoord(position['x'], position['y'], position['z'])

    SetBlipSprite(spikesBlip, 238)
    SetBlipScale(spikesBlip, 1.2)
    SetBlipAsShortRange(spikesBlip, true)
    
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString('Tapete de pregos')
    EndTextCommandSetBlipName(spikesBlip)

    exports['crp-notifications']:SendAlert('success', 'Colocaste o tapete de pregos no chão com sucesso.')
end

function RenderSpike(k)
    if spikeCoords[k].palced == true or spikeCoords[k].object ~= nil then 
        return 
    end

    spikeCoords[k].palced = true
    
	local spike = GetHashKey('P_ld_stinger_s')

    RequestModel(spike)

    while not HasModelLoaded(spike) do
        Citizen.Wait(0)
    end

    local spikeObject = CreateObject(spike, spikeCoords[k].x, spikeCoords[k].y, spikeCoords[k].z, 0, 1, 1)
    
    PlaceObjectOnGroundProperly(spikeObject)
	SetEntityHeading(spikeObject, spikeCoords[k].h)
	FreezeEntityPosition(spikeObject, true)

	spikeCoords[k].object = spikeObject
end

function DeleteSpike(k)
    local spike = spikeCoords[k].object
    
    DeleteObject(spike)
    
  	if DoesEntityExist(spike) then
      	SetEntityAsNoLongerNeeded(spike)
        DeleteObject(spike)
    else
        spikeCoords[k].palced = false
		spikeCoords[k].object = nil
    end
end

function RemoveSpikes()
    for k, v in pairs(spikeCoords) do
        local distance = #(vector3(v['x'], v['y'], v['z']) - GetEntityCoords(GetPlayerPed(-1)))

        if distance < 15.0 then
            local spike = v.object

            DeleteObject(spike)

            TriggerAnimation(GetPlayerPed(-1))

            if DoesEntityExist(spike) then
                SetEntityAsNoLongerNeeded(spike)  
                DeleteObject(spike)
            else
                TriggerServerEvent('crp-policespikes:removeSpikes', k)
            end

            break
		end
    end
end

function TriggerAnimation(playerPed)
    local dictionary, animation = 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', 'plant_floor'

    if IsPedArmed(playerPed, 7) then
        SetCurrentPedWeapon(playerPed, 0xA2719263, true)
    end

    RequestAnimDict(dictionary)

    while not HasAnimDictLoaded(dictionary) do
        Citizen.Wait(0)
    end

    if IsEntityPlayingAnim(playerPed, dictionary, animation, 3) then
        ClearPedSecondaryTask(playerPed)
    else
        local animLength = GetAnimDuration(dictionary, animation)

        TaskPlayAnim(playerPed, dictionary, animation, 1.0, 1.0, -1, 48, -1, 0, 0, 0)
    end
end

Citizen.CreateThread(function()
  	while true do
        Citizen.Wait(0)
        
        local playerPed = GetPlayerPed(-1)

        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local vehicleCoords, vehicleDriver = GetEntityCoords(vehicle), GetPedInVehicleSeat(vehicle, -1)

            if #spikeCoords == 0 or vehicleDriver ~= playerPed then
                if vehicleDriver ~= playerPed then
                    Citizen.Wait(1500)
                else
                    Citizen.Wait(200)
                end
            else
                for i = 1, #spikeCoords do
                    local distance = #(vector3(spikeCoords[i]['x'], spikeCoords[i]['y'], spikeCoords[i]['z']) - GetEntityCoords(playerPed))

                    if distance < 15.0 and not spikeCoords[i]['watching'] then
                        spikeCoords[i]['watching'] = true

                        TriggerEvent('crp-policespikes:watchSpikes', i)
                    end
                end
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
  	while true do
        Citizen.Wait(1000)
           
        for k, v in pairs(spikeCoords) do
            local distance = #(vector3(v['x'], v['y'], v['z']) - GetEntityCoords(GetPlayerPed(-1)))
            
	    	if distance < 85.0 then
                if v['palced'] == false or v['object'] == nil then
					RenderSpike(k)
				end
			else
				if v['palced'] == true or v['object'] ~= nil then
					DeleteSpike(k)
				end
            end
            
			Wait(100)
	    end
    end
end)