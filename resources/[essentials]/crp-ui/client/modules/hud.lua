AddEventHandler('crp-ui:setHudPosition', function()
    SendNUIMessage({ eventName = 'setHudPosition', topX = _topX, topY = _topY })
end)

AddEventHandler('crp-ui:updateData', function(data)
    SendNUIMessage({ eventName = 'updateData', status = data })
end)