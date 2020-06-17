RegisterServerEvent('crp-base:onPlayerJoined')
AddEventHandler('crp-base:onPlayerJoined', function()
	local _source = source

	Citizen.CreateThread(function()
		local steamid

		for k, v in ipairs(GetPlayerIdentifiers(_source)) do
			if string.sub(v, 1, string.len('steam:')) == 'steam:' then
				steamid = v
				break
			end
		end

		if not steamid then
			DropPlayer(_source, 'Não foi possível encontrar o seu Steam ID, tente entrar com a Steam aberta.')
		end

		return
	end)
end)

CRP.RPC:register('FetchCharacters', function(source)
    local charactersPromise = promise:new()

    CRP.DB:FetchCharacters(CRP.Util:GetPlayerIdentifier(source), charactersPromise)

    return Citizen.Await(charactersPromise)
end)

CRP.RPC:register('CreateCharacter', function(source, data)
    local characterPromise = promise:new()

    print('estive aqui?')

    CRP.DB:CreateCharacter(CRP.Util:GetPlayerIdentifier(source), data, characterPromise)

    return Citizen.Await(characterPromise)
end)