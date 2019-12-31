local standardVolumeOutput = 1.0;

-- ! play on one client.

RegisterNetEvent('interact-sound:playOne')
AddEventHandler('interact-sound:playOne', function(fileName, volume)
    SendNUIMessage({
        transactionType     = 'playSound',
        transactionFile     = fileName,
        transactionVolume   = volume
    })
end)

-- ! play on all the players.

RegisterNetEvent('interact-sound:playAll')
AddEventHandler('interact-sound:playAll', function(fileName, volume)
    SendNUIMessage({
        transactionType     = 'playSound',
        transactionFile     = fileName,
        transactionVolume   = volume
    })
end)

-- ! play to close players.

RegisterNetEvent('interact-sound:playWithinDistance')
AddEventHandler('interact-sound:playWithinDistance', function(playerNetId, maxDistance, fileName, volume)
    local lCoords = GetEntityCoords(GetPlayerPed(-1))
    local eCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerNetId)))
    local distIs  = Vdist(lCoords.x, lCoords.y, lCoords.z, eCoords.x, eCoords.y, eCoords.z)

    if (distIs <= maxDistance) then
        SendNUIMessage({
            transactionType     = 'playSound',
            transactionFile     = fileName,
            transactionVolume   = volume
        })
    end
end)
