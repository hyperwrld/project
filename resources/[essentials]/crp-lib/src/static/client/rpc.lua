local resourceName, promises = GetCurrentResourceName(), {}

RPC = {}

function RPC:execute(name, ...)
    local callId, isSolved = GetRandomId(), false

    promises[callId] = promise:new()

    TriggerServerEvent('crp-lib:request', resourceName, name, callId, {...})

    Citizen.SetTimeout(1000, function()
		if not isSolved then
            promises[callId]:resolve({ nil })
        end
    end)

    local response = Citizen.Await(promises[callId])

    isSolved = true

	Citizen.SetTimeout(5000, function()
        promises[callId] = nil
    end)

    return table.unpack(response)
end

RegisterNetEvent('crp-lib:response')
AddEventHandler('crp-lib:response', function(callId, response)
    if promises[callId] then
        promises[callId]:resolve(response)
    end
end)

function GetRandomId(length)
    local chars, randomString = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', ''
	local charTable, unixTime = {}, math.floor(exports['crp-lib']:getUnixTime() + 0.5)

    for char in chars:gmatch'.' do
        charTable[#charTable + 1] = char
    end

	math.randomseed(tonumber(tostring(unixTime):reverse():sub(1, 6)))

	for i = 1, 12 do
        randomString = randomString .. charTable[math.random(1, #charTable)]
    end

    return randomString
end