-- Loads the character when called, only ever needs to get called once

function LoadCharacter(source, identifier, charid)
	local _source, data = source, {}

	TriggerEvent('crp-db:retrievecharacter', identifier, charid, function(_data)
		data = _data
	end)

    while next(data) == nil do
		Citizen.Wait(0)
    end

    if data.license then
		users[_source] = CreateCharacter(_source, data)
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
			TriggerEvent('crp-db:updatecharacter', data.identifier, data.id, license, function(done)
				if done then
					return false
				end
			end)
		else
			return false
		end
	end
end

AddEventHandler('crp-base:setPlayerData', function(user, k, v, cb)
	if (users[user]) then
		if (users[user].get(k)) then
			if (k ~= 'money') then
				users[user].set(k, v)

				TriggerEvent('crp-db:updatecharacter', users[user].get('identifier'), { [k] = v }, function(status)
					if status then
						cb('Player data was successfully edited', true)
					else
						cb(status, false)
					end
				end)
			end
		else
			cb('Column does not exist!', false)
		end
	else
		cb('User could not be found!', false)
	end
end)

function GetCharacter(source)
	return users[source]
end