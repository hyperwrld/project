AddEventHandler('crp-ui:setHudPosition', function(topX, topY)
    SendNUIMessage({ eventName = 'setHudPosition', topX = topX, topY = topY })
end)

AddEventHandler('crp-ui:updateData', function(data)
    SendNUIMessage({ eventName = 'updateData', status = data })
end)