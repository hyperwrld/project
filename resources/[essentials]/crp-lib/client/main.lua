local registeredEvents = {}

function SendUIMessage(data)
	exports['crp-ui']:SendUIMessage(data)
end

function RegisterUICallback(name, cb)
	AddEventHandler(('crp-ui:%s'):format(name), cb)

	registeredEvents[#registeredEvents + 1] = name
end

AddEventHandler('crp-ui:isReady', function()
	for k, name in ipairs(registeredEvents) do
		exports['crp-ui']:RegisterUIEvent(name)
	end
end)

function LoadDictionary(dictionary)
	RequestAnimDict(dictionary)

    while not HasAnimDictLoaded(dictionary) do
        Citizen.Wait(0)
	end
end

function LoadModel(modelHash)
	RequestModel(modelHash)

	while not HasModelLoaded(modelHash) do
		Citizen.Wait(0)
	end
end

function CreateEntity(type, modelHash, coords, isNetwork, netMissionEntity, pedType)
	if not HasModelLoaded(modelHash) then
		LoadModel(modelHash)
	end

	local entity = 0

	if type == 1 then
		entity = CreatePed(pedType, modelHash, coords, isNetwork, netMissionEntity)
	end

	SetModelAsNoLongerNeeded(modelHash)

	return entity
end

function GetVehicleInDirection(fromEntity, fromCoords, toCoords)
	local rayHandle = StartShapeTestCapsule(fromEntity.x, fromEntity.y, fromEntity.z, toCoords.x, toCoords.y, toCoords.z, 5.0, 10, fromEntity, 7)
	local retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

	return entityHit
end

function GetClosestPlayer()
    local players, closestDistance, closestPlayer, playerPed = GetPlayers(), -1, -1, PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    for i = 1, #players do
        local targetPed = GetPlayerPed(players[i])

        if targetPed ~= playerPed then
            local _coords = GetEntityCoords(targetPed)
            local distance = #(_coords - coords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer, closestDistance = players[i], distance
            end
        end
    end

    return closestPlayer, closestDistance
end