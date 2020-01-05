local storeLocations = {
    [1]  = { ['name'] = 'Loja 1',  ['recent'] = false, ['lastRobbed'] = 0, ['robber'] = nil, ['city'] = true  },
    [2]  = { ['name'] = 'Loja 2',  ['recent'] = false, ['lastRobbed'] = 0, ['robber'] = nil, ['city'] = false },
    [3]  = { ['name'] = 'Loja 3',  ['recent'] = false, ['lastRobbed'] = 0, ['robber'] = nil, ['city'] = false },
	[4]  = { ['name'] = 'Loja 4',  ['recent'] = false, ['lastRobbed'] = 0, ['robber'] = nil, ['city'] = false },
	[5]  = { ['name'] = 'Loja 5',  ['recent'] = false, ['lastRobbed'] = 0, ['robber'] = nil, ['city'] = false },
	[6]  = { ['name'] = 'Loja 6',  ['recent'] = false, ['lastRobbed'] = 0, ['robber'] = nil, ['city'] = false },
	[7]  = { ['name'] = 'Loja 7',  ['recent'] = false, ['lastRobbed'] = 0, ['robber'] = nil, ['city'] = true  },
	[8]  = { ['name'] = 'Loja 8',  ['recent'] = false, ['lastRobbed'] = 0, ['robber'] = nil, ['city'] = true  },
	[9]  = { ['name'] = 'Loja 9',  ['recent'] = false, ['lastRobbed'] = 0, ['robber'] = nil, ['city'] = true  },
	[10] = { ['name'] = 'Loja 10', ['recent'] = false, ['lastRobbed'] = 0, ['robber'] = nil, ['city'] = true  },
	[11] = { ['name'] = 'Loja 11', ['recent'] = false, ['lastRobbed'] = 0, ['robber'] = nil, ['city'] = true  },
	[12] = { ['name'] = 'Loja 12', ['recent'] = false, ['lastRobbed'] = 0, ['robber'] = nil, ['city'] = false },
	[13] = { ['name'] = 'Loja 13', ['recent'] = false, ['lastRobbed'] = 0, ['robber'] = nil, ['city'] = false },
	[14] = { ['name'] = 'Loja 14', ['recent'] = false, ['lastRobbed'] = 0, ['robber'] = nil, ['city'] = false },
	[15] = { ['name'] = 'Loja 15', ['recent'] = false, ['lastRobbed'] = 0, ['robber'] = nil, ['city'] = false },
    [16] = { ['name'] = 'Loja 16', ['recent'] = false, ['lastRobbed'] = 0, ['robber'] = nil, ['city'] = false },
    [17] = { ['name'] = 'Loja 17', ['recent'] = false, ['lastRobbed'] = 0, ['robber'] = nil, ['city'] = false },
    [18] = { ['name'] = 'Loja 18', ['recent'] = false, ['lastRobbed'] = 0, ['robber'] = nil, ['city'] = false },
    [19] = { ['name'] = 'Loja 19', ['recent'] = false, ['lastRobbed'] = 0, ['robber'] = nil, ['city'] = false },
}

RegisterServerEvent('crp-robbery:robbedShop')
AddEventHandler('crp-robbery:robbedShop', function(isPrimeTime, store)
    local user, money = exports['crp-base']:GetCharacter(source), GetRandomNumber(100, 150)

    if storeLocations[store]['robber'] ~= nil and storeLocations[store]['robber'] ~= source then
        return
    end

    storeLocations[store]['robber'] = source

    if ((os.time() - storeLocations[store]['lastRobbed']) > 1800) then
        TriggerEvent('crp-robbery:setRobbed', store, false)
    end

    if not storeLocations[store]['recent'] then
        if GetRandomNumber(100) > 60 and storeLocations[store]['city'] then
            money = money * GetRandomNumber(1, 2)
        end

        if isPrimeTime then
            money = money * (GetRandomNumber(20, 26) / 10)
        end
    else
        if GetRandomNumber(100) > 80 and storeLocations[store]['city'] then
            money = money * (GetRandomNumber(10, 12) / 10)
        end

        if isPrimeTime then
            money = money * (GetRandomNumber(12, 14) / 10)
        end

        if ((os.time() - storeLocations[store]['lastRobbed']) < 600) then
            money = money / 2
        end
    end

    user.addMoney(math.ceil(money))
end)

RegisterServerEvent('crp-robbery:robbedPerson')
AddEventHandler('crp-robbery:robbedPerson', function()
    local user, money = exports['crp-base']:GetCharacter(source), GetRandomNumber(15, 25)

    if GetRandomNumber(100) > 80 then
        money = money * (GetRandomNumber(13, 18) / 10)
    end

    user.addMoney(math.ceil(money))
end)

RegisterServerEvent('crp-robbery:robbedSafe')
AddEventHandler('crp-robbery:robbedSafe', function(isPrimeTime, store)
    local user, money = exports['crp-base']:GetCharacter(source), GetRandomNumber(550, 850)

    if storeLocations[store]['robber'] ~= nil and storeLocations[store]['robber'] ~= source then
        TriggerClientEvent('crp-notifications:SendAlert', source, { type = 'inform', text = 'O cofre da loja estava vazio.' })
        return
    end

    if not storeLocations[store]['recent'] then
        if GetRandomNumber(100) > 60 and storeLocations[store]['city'] then
            money = money * GetRandomNumber(1, 2)
        end

        if isPrimeTime then
            money = money * (GetRandomNumber(20, 26) / 10)
        end

        user.addMoney(math.ceil(money))
    else
        TriggerClientEvent('crp-notifications:SendAlert', source, { type = 'inform', text = 'O cofre da loja estava vazio.' })
    end
end)

RegisterServerEvent('crp-robbery:endedRobbery')
AddEventHandler('crp-robbery:endedRobbery', function(store)
    if storeLocations[store]['robber'] ~= nil and storeLocations[store]['robber'] == source then
        storeLocations[store]['robber'], storeLocations[store]['lastRobbed'] = nil, os.time()
        
        TriggerEvent('crp-robbery:setRobbed', store, true)
    end
end)

RegisterServerEvent('crp-robbery:setRobbed')
AddEventHandler('crp-robbery:setRobbed', function(store, state)
    if storeLocations[store] then
        storeLocations[store]['recent'] = state
    end

    TriggerClientEvent('crp-robbery:setRobbed', -1, store, state)
end)

function GetRandomNumber(firstNumber, secondNumber)
    math.randomseed(os.time())

    if secondNumber then
        return math.random(firstNumber, secondNumber)
    else
        return math.random(firstNumber)
    end
end