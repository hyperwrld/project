local functions = {}

RPC = {}

function RPC:register(name, func)
    functions[name] = func
end

function RPC:remove(name)
    functions[name] = nil
end

RegisterNetEvent('crp-lib:request')
AddEventHandler('crp-lib:request', function(origin, name, callId, params)
    local serverId, response = source

    if functions[name] == nil then
        return
    end

    local success, error = pcall(function()
        response = table.pack(functions[name](serverId, table.unpack(params)))
    end)

    if response == nil then
        response = {}
    end

    TriggerClientEvent('crp-lib:response', serverId, callId, response)
end)