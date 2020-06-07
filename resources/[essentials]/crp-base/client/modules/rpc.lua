local resourceName, promises, functions, callIdentifier = GetCurrentResourceName(), {}, {}, 0

CRP.RPC = {}

function ClearPromise(callId)
    Citizen.SetTimeout(5000, function()
        promises[callId] = nil
    end)
end

function CRP.RPC.execute(self, name, ...)
    local callId, isSolved = callIdentifier, false

    callIdentifier = callIdentifier + 1

    promises[callId] = promise:new()

    TriggerServerEvent('rpc:request', resourceName, name, callId, {...})

    Citizen.SetTimeout(1000, function()
        if not isSolved then
            promises[callId]:resolve({nil})

            TriggerEvent('rpc:server:timeout', resourceName, name)
        end
    end)

    local response = Citizen.Await(promises[callId])

    isSolved = true

    ClearPromise(callId)

    return table.unpack(response)
end

function CRP.RPC.executeLatent(self, name, timeout, ...)
    local callId, isSolved = callIdentifier, false

    callIdentifier = callIdentifier + 1

    promises[callId] = promise:new()

    TriggerLatentClientEvent('rpc:lantent:request', 50000, resourceName, name, callId, {...})

    Citizen.SetTimeout(timeout, function()
        if not isSolved then
            promises[callId]:resolve({nil})

            TriggerEvent('rpc:server:timeout', resourceName, name)
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

function CRP.RPC.register(self, name, func)
    functions[name] = func
end

function CRP.RPC.remove(self, name)
    functions[name] = nil
end

RegisterNetEvent('rpc:request')
AddEventHandler('rpc:request', function(origin, name, callId, params)
    local response

    if functions[name] == nil then
        return
    end

    local success, error = pcall(function()
        response = table.pack(functions[name](table.unpack(params)))
    end)

    if not success then
        TriggerEvent('rpc:client:error', resourceName, origin, name, error)
    end

    if response == nil then
        response = {}
    end

    TriggerClientEvent('rpc:response', callId, response)
end)

RegisterNetEvent('rpc:latent:request')
AddEventHandler('rpc:latent:request', function(origin, name, callId, params)
    local response

    if functions[name] == nil then
        return
    end

    local success, error = pcall(function()
        response = table.pack(functions[name](table.unpack(params)))
    end)

    if not success then
        TriggerEvent('rpc:client:error', resourceName, origin, name, error)
    end

    if response == nil then
        response = {}
    end

    TriggerLatentClientEvent('rpc:response', callId, response)
end)