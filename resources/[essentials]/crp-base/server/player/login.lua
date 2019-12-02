-- Loads the character when called, only ever needs to get called once

function LoadCharacter(source, identifier, charid)
	local _source, chardata = source, {}

	TriggerEvent('crp-db:retrievecharacter', identifier, charid, function(data, isJson)
		if isJson then
			data = json.decode(data)
		end
		
		chardata = data
	end)

	while next(chardata) == nil do
		Citizen.Wait(0)
	end

	if chardata.license then
		users[_source] = CreateCharacter(_source, chardata)
		users[_source].displayMoney(users[_source].getMoney())

		-- Tells other resources that a player has loaded
		TriggerEvent('crp:playerloaded', _source, users[_source])

		-- Sends the command suggestions to the client, this creates a neat autocomplete
		for k, v in pairs(commandSuggestions) do
			TriggerClientEvent('chat:addSuggestion', _source, '/' .. k, v.help, v.params)
		end

		return users[_source]
	else
		local license

		for k, v in ipairs(GetPlayerIdentifiers(_source)) do
			if string.sub(v, 1, string.len('license:')) == 'license:' then
				license = v
				break
			end
		end

		if license then
			TriggerEvent('crp-db:updatecharacter', chardata.identifier, chardata.id, license, function(done)
				if done then
					return false
				end
			end)
		else
			return false
		end
	end
end

function GetCharacter(source)
	return users[source]
end