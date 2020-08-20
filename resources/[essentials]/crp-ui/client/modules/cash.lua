RegisterNetEvent('crp-ui:setMoneyStatus')
AddEventHandler('crp-ui:setMoneyStatus', function(data)
	SendNUIMessage({ eventName = 'setMoneyStatus', data = data })
end)

RegisterNetEvent('crp-ui:setMoney')
AddEventHandler('crp-ui:setMoney', function(money)
    SendNUIMessage({ eventName = 'setMoney', money = money })
end)

RegisterNetEvent('crp-ui:addMoney')
AddEventHandler('crp-ui:addMoney', function(quantity)
    SendNUIMessage({ eventName = 'addMoney', quantity = quantity })
end)

RegisterNetEvent('crp-ui:removeMoney')
AddEventHandler('crp-ui:removeMoney', function(quantity)
    SendNUIMessage({ eventName = 'removeMoney', quantity = quantity })
end)