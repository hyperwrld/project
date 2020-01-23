AddEventHandler('playerDropped', function()
	local _source = source

 	if users[_source] then
		TriggerEvent('crp:playerDropped', users[_source])

		TriggerEvent('crp-db:updatecharacter', users[_source].get('id'), users[_source].get('identifier'), json.encode(users[_source].getStatus()), { money = users[_source].GetMoney(), bank = users[_source].GetBank(), position = users[_source].GetPosition() })

		users[_source] = nil
	end
end)

RegisterServerEvent('playerConnecting')
AddEventHandler('playerConnecting', function(name, setKickReason)
	local sanitizedName, invalidChars = SanitizePlayerName(name)
	local steamid

	for k, v in ipairs(GetPlayerIdentifiers(source)) do
		if string.sub(v, 1, string.len('steam:')) == 'steam:' then
			steamid = v
			break
		end
	end

	if not steamid then
		setKickReason('Não foi possível encontrar o seu SteamID, renicie o FiveM com a Steam aberta ou renicie o FiveM e a Steam se ela estiver aberta.')
		CancelEvent()
	elseif name ~= sanitizedName then
		setKickReason('Não foi possível entrar no servidor, devido ao seu nome na Steam conter caracteres que não são permitidos, por favor altere o seu nome.')
		CancelEvent()
	end
end)

RegisterServerEvent('crp-base:playerSessionStarted')
AddEventHandler('crp-base:playerSessionStarted', function()
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

RegisterServerEvent('crp-base:createcharacter')
AddEventHandler('crp-base:createcharacter', function(source, data, callback)
	local _source, firstname, lastname = source, data.firstname, data.lastname

	TriggerEvent('crp-db:doescharacterexist', firstname, lastname, function(exists)
		if exists then
			local error = { error = true, message = 'O nome que escolheu já está em uso.' }

			callback(error)
		else
			local steamid, license

    		for k, v in pairs(GetPlayerIdentifiers(_source)) do
			    if string.sub(v, 1, string.len('steam:')) == 'steam:' then
			        steamid = v
			    elseif string.sub(v, 1, string.len('license:')) == 'license:' then
			    	license = v
			    end

			    if steamid ~= nil and license ~= nil then break end
    		end

    		TriggerEvent('crp-db:createcharacter', data, steamid, license, tonumber(settings.startingCash), tonumber(settings.startingBank), function(done)
    			callback(done)
    		end)
		end
	end)
end)

RegisterServerEvent('crp-base:selectcharacter')
AddEventHandler('crp-base:selectcharacter', function(source, character, callback)
	local _source, identifier, loggedIn = source, nil, false

	for k, v in ipairs(GetPlayerIdentifiers(_source)) do
		if string.sub(v, 1, string.len('steam:')) == 'steam:' then
			identifier = v
			break
		end
	end

	if identifier == nil then
		callback({ loggedin = loggedIn})
	else
		TriggerEvent('crp-db:checkcharacter', identifier, character, function(exists)
			if exists then
				local data = LoadCharacter(_source, identifier, character)

                if data then loggedIn = true end

				callback({ loggedin = loggedIn, character = character })
			else
				callback({ loggedin = loggedIn })
			end
		end)
	end
end)

RegisterServerEvent('crp-base:updateposition')
AddEventHandler('crp-base:updateposition', function(x, y, z)
	if users[source] then
		local _x, _y, _z = MathRound(x), MathRound(y), MathRound(z)

		users[source].setPosition(_x, _y, _z)
	end
end)

RegisterServerEvent('crp-base:disconnect')
AddEventHandler('crp-base:disconnect', function()
	DropPlayer(source, 'Foste desconectado da cidade, até um dia!')
end)

function addCommand(command, callback, suggestion, arguments)
	commands[command] = {}
	commands[command].cmd = callback
	commands[command].arguments = arguments or -1

	if suggestion then
		if not suggestion.params or not type(suggestion.params) == 'table' then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == 'string' then suggestion.help = '' end

		commandSuggestions[command] = suggestion
	end

	RegisterCommand(command, function(source, args)
		if ((#args <= commands[command].arguments and #args == commands[command].arguments) or commands[command].arguments == -1) then
			callback(source, args, users[source])
		end
	end, false)
end

AddEventHandler('crp-base:addCommand', function(command, callback, suggestion, arguments)
	addCommand(command, callback, suggestion, arguments)
end)

StartPayChecks()
StartSavingPlayers()