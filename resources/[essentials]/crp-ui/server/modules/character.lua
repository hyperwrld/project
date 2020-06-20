CRP.RPC:register('FetchCharacters', function(source)
    local charactersPromise = promise:new()

    CRP.DB:FetchCharacters(CRP.Util:GetPlayerIdentifier(source), charactersPromise)

    return Citizen.Await(charactersPromise)
end)

CRP.RPC:register('CreateCharacter', function(source, data)
    local characterPromise = promise:new()

    CRP.DB:CreateCharacter(CRP.Util:GetPlayerIdentifier(source), data, characterPromise)

    return Citizen.Await(characterPromise)
end)

CRP.RPC:register('DeleteCharacter', function(source, data)
    local characterPromise = promise:new()

    CRP.DB:DeleteCharacter(CRP.Util:GetPlayerIdentifier(source), data, characterPromise)

    return Citizen.Await(characterPromise)
end)

CRP.RPC:register('SelectCharacter', function(source, data)
    local characterPromise = promise:new()

    CRP.DB:RetrieveCharacter(CRP.Util:GetPlayerIdentifier(source), { source = source, characterId = data }, characterPromise)

    return Citizen.Await(characterPromise)
end)