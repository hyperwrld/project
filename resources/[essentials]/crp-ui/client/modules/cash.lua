AddEventHandler('crp-ui:setMoneyStatus', function(status)
    SendNUIMessage({ eventName = 'setMoneyStatus', status = status })
end)

AddEventHandler('crp-ui:setMoney', function(money)
    SendNUIMessage({ eventName = 'setMoney', money = money })
end)

AddEventHandler('crp-ui:addMoney', function(quantity)
    SendNUIMessage({ eventName = 'addMoney', quantity = quantity })
end)

AddEventHandler('crp-ui:removeMoney', function(quantity)
    SendNUIMessage({ eventName = 'removeMoney', quantity = quantity })
end)