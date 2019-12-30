local spikeCoords = {}

RegisterNetEvent('crp-policespikes:setPikeLocation')
AddEventHandler('crp-policespikes:setPikeLocation', function(spikeLocation)
    spikeCoords[#spikeCoords + 1] = { id = source, x = spikeLocation.x, y = spikeLocation.y, z = spikeLocation.z, h = spikeLocation.h }

    TriggerClientEvent('crp-policespikes:addSpikes', -1, #spikeCoords, spikeCoords[#spikeCoords])
end)

RegisterNetEvent('crp-policespikes:removeSpikes')
AddEventHandler('crp-policespikes:removeSpikes', function(spike)
    table.remove(spikeCoords, spike)

    TriggerClientEvent('crp-policespikes:removeSpikes', -1, spike)
end)