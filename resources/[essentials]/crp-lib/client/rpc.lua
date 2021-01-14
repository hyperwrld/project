local resourceName, promises, callIdentifier = GetCurrentResourceName(), {}, 0

RPC = {}

function RPC:execute(name, ...)
    local callId, isSolved = callIdentifier, false

    callIdentifier = callIdentifier + 1

    promises[callId] = promise:new()

    TriggerServerEvent('crp-lib:request', resourceName, name, callId, { ... })

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