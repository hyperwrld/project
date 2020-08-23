RegisterNetEvent('crp-ui:setMoneyStatus')
AddEventHandler('crp-ui:setMoneyStatus', function(data)
	SendNUIMessage({ eventName = 'cash/setMoneyStatus', eventData = data })
end)

RegisterNetEvent('crp-ui:setMoney')
AddEventHandler('crp-ui:setMoney', function(money)
    SendNUIMessage({ eventName = 'cash/setMoney', eventData = money })
end)

RegisterNetEvent('crp-ui:addMoney')
AddEventHandler('crp-ui:addMoney', function(quantity)
    SendNUIMessage({ eventName = 'cash/addMoney', eventData = quantity })
end)

RegisterNetEvent('crp-ui:removeMoney')
AddEventHandler('crp-ui:removeMoney', function(quantity)
    SendNUIMessage({ eventName = 'cash/removeMoney', eventData = quantity })
end)