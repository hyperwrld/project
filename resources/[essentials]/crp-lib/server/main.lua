local resourceName, promises, functions = GetCurrentResourceName(), {}, {}

RPC = {}

function ClearPromise(callId)
    Citizen.SetTimeout(5000, function()
        promises[callId] = nil
    end)
end

function RPC:execute(name, target, ...)
    local callId, isSolved = GetRandomString(12), false

    promises[callId] = promise:new()

    TriggerClientEvent('rpc:request', target, resourceName, name, callId, {...})

    Citizen.SetTimeout(1000, function()
        if not isSolved then
            promises[callId]:resolve({nil})

            TriggerEvent('rpc:client:timeout', resourceName, name, target)
        end
    end)

    local response = Citizen.Await(promises[callId])

    isSolved = true

    ClearPromise(callId)

    return table.unpack(response)
end

function RPC:executeLatent(name, target, ...)
    local callId, isSolved = GetRandomString(12), false

    promises[callId] = promise:new()

    TriggerLatentClientEvent('rpc:lantent:request', target, 50000, resourceName, name, callId, {...})

    Citizen.SetTimeout(5000, function()
        if not isSolved then
            promises[callId]:resolve({nil})

            TriggerEvent('rpc:client:timeout', resourceName, name, target)
        end
    end)

    local response = Citizen.Await(promises[callId])

    isSolved = true

    ClearPromise(callId)

    return table.unpack(response)
end

RegisterNetEvent('rpc:response')
AddEventHandler('rpc:response', function(callId, response)
    if promises[callId] then
        promises[callId]:resolve(response)
    end
end)

function RPC:register(name, func)
    functions[name] = func
end

function RPC:remove(name)
    functions[name] = nil
end

RegisterNetEvent('rpc:request')
AddEventHandler('rpc:request', function(origin, name, callId, params)
    local serverId, response = source

    if functions[name] == nil then
        return
    end

    local success, error = pcall(function()
        response = table.pack(functions[name](serverId, table.unpack(params)))
    end)

    if not success then
        TriggerEvent('rpc:server:error', resourceName, origin, name, serverId, error)
    end

    if response == nil then
        response = {}
    end

    TriggerClientEvent('rpc:response', serverId, callId, response)
end)

RegisterNetEvent('rpc:latent:request')
AddEventHandler('rpc:latent:request', function(origin, name, callId, params)
    local serverId, response = source

    if functions[name] == nil then
        return
    end

    local success, error = pcall(function()
        response = table.pack(functions[name](serverId, table.unpack(params)))
    end)

    if not success then
        TriggerEvent('rpc:server:error', resourceName, origin, name, serverId, error)
    end

    if response == nil then
        response = {}
    end

    TriggerLatentClientEvent('rpc:response', serverId, callId, response)
end)

function GetRandomString(length)
    local chars, randomString, stringLength, charTable = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', '', length or 10, {}

    for char in chars:gmatch'.' do
        charTable[#charTable + 1] = char
    end

    for i = 1, stringLength do
        randomString = randomString .. charTable[math.random(1, #charTable)]
    end

    return randomString
end