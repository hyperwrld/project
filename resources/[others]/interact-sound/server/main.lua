RegisterServerEvent('interact-sound:playOne')
AddEventHandler('interact-sound:playOne', function(clientNetId, soundFile, soundVolume)
    TriggerClientEvent('interact-sound:playOne', clientNetId, soundFile, soundVolume)
end)

RegisterServerEvent('interact-sound:playOnSource')
AddEventHandler('interact-sound:playOnSource', function(soundFile, soundVolume)
    TriggerClientEvent('interact-sound:playOne', source, soundFile, soundVolume)
end)

RegisterServerEvent('interact-sound:playAll')
AddEventHandler('interact-sound:playAll', function(soundFile, soundVolume)
    TriggerClientEvent('interact-sound:playAll', -1, soundFile, soundVolume)
end)

RegisterServerEvent('interact-sound:playWithinDistance')
AddEventHandler('interact-sound:playWithinDistance', function(maxDistance, soundFile, soundVolume)
    TriggerClientEvent('interact-sound:playWithinDistance', -1, source, maxDistance, soundFile, soundVolume)
end)