RegisterServerEvent('interact-sound:PlayOnOne')
AddEventHandler('interact-sound:PlayOnOne', function(clientNetId, soundFile, soundVolume)
    TriggerClientEvent('interact-sound:PlayOnOne', clientNetId, soundFile, soundVolume)
end)

RegisterServerEvent('interact-sound:PlayOnSource')
AddEventHandler('interact-sound:PlayOnSource', function(soundFile, soundVolume)
    TriggerClientEvent('interact-sound:PlayOnOne', source, soundFile, soundVolume)
end)

RegisterServerEvent('interact-sound:PlayOnAll')
AddEventHandler('interact-sound:PlayOnAll', function(soundFile, soundVolume)
    TriggerClientEvent('interact-sound:PlayOnAll', -1, soundFile, soundVolume)
end)

RegisterServerEvent('interact-sound:PlayWithinDistance')
AddEventHandler('interact-sound:PlayWithinDistance', function(maxDistance, soundFile, soundVolume)
    TriggerClientEvent('interact-sound:PlayWithinDistance', -1, source, maxDistance, soundFile, soundVolume)
end)
