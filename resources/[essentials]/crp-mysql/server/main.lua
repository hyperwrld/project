AddEventHandler('crp-db:fetchplayercharacters', function(source, data, callback)
	local identifier = GetPlayerIdentifiers(source)[1]

	exports.ghmattimysql:execute('SELECT * FROM users WHERE `identifier` = @identifier;', { ['identifier'] = identifier }, function(characters)
		if characters[1] then
			callback(characters)
		else
			callback(nil)
		end
	end)
end)

AddEventHandler('crp-db:createcharacter', function(data, identifier, license, cash, bank, callback)
	local user  = { identifier = identifier, money = 5000, bank = 3333, license = license, firstname = data.firstname, lastname = data.lastname, sex = data.sex, dateofbirth = data.dateofbirth, history = data.history }
	local error = { error = true, message = 'Ocorreu um erro ao criar a sua personagem, contacte um administrador se isto continuar.' }

	if isEmpty(data.firstname) or isEmpty(data.lastname) or isEmpty(data.sex) or isEmpty(data.dateofbirth) or isEmpty(data.sex) or isEmpty(data.history) then callback(error) end

	exports.ghmattimysql:execute('INSERT INTO users (identifier, license, money, bank, firstname, lastname, dateofbirth, sex, history) VALUES (@identifier, @license, @money, @bank, @firstname, @lastname, @dateofbirth, @sex, @history);', {
		['@identifier'] = user.identifier, ['@license'] = user.license, ['@money'] = user.money, ['@bank'] = user.bank, ['@firstname'] = user.firstname, ['@lastname'] = user.lastname, ['@dateofbirth'] = user.dateofbirth, ['@sex'] = user.sex, ['@history'] = user.history
	}, function(done)
		if callback then
			callback(done)
		end
	end)
end)

AddEventHandler('crp-db:deletecharacter', function(source, data, callback)
	local identifier = GetPlayerIdentifiers(source)[1]

	exports.ghmattimysql:execute('DELETE FROM users  WHERE id = @id AND identifier = @identifier;', { id = data.id, identifier = identifier }, function(done)
		if callback then
			callback(done)
		end
	end)
end)

AddEventHandler('crp-db:retrievecharacter', function(identifier, id, callback)
	exports.ghmattimysql:execute('SELECT * FROM users WHERE identifier = @identifier AND id = @id;', { identifier = identifier, id = id }, function(users)
		if users[1] then
			callback(users[1])
		else
			callback(false)
		end
	end)
end)

AddEventHandler('crp-db:doescharacterexist', function(firstname, lastname, callback)
	exports.ghmattimysql:execute('SELECT * FROM users WHERE firstname = @firstname AND lastname = @lastname;', { firstname = firstname, lastname = lastname }, function(users)
		if users[1] then
			callback(true)
		else
			callback(false)
		end
	end)
end)

AddEventHandler('crp-db:checkcharacter', function(identifier, id, callback)
	exports.ghmattimysql:execute('SELECT * FROM users WHERE identifier = @identifier AND id = @id;', { identifier = identifier, id = id }, function(users)
		if users[1] then
			callback(true)
		else
			callback(false)
		end
	end)
end)

AddEventHandler('crp-db:updatecharacter', function(id, identifier, status, new, callback)
	Citizen.CreateThread(function()
		local updateString, length, cLength = "", tLength(new), 1

		for k, v in pairs(new) do
			if cLength < length then
				if (type(v) == 'number') then
					updateString = updateString .. '`' .. k .. '`=' .. v .. ','
				else
					updateString = updateString .. '`' .. k .. "`='" .. v .. "',"
				end
			else
				if (type(v) == 'number') then
					updateString = updateString .. '`' .. k .. '`=' .. v .. ''
				else
					updateString = updateString .. '`' .. k .. "`='" .. v .. "'"
				end
			end
			cLength = cLength + 1
		end

		exports.ghmattimysql:execute('UPDATE users SET ' .. updateString .. ', status = @status WHERE identifier = @identifier AND id = @id;', { id = id, identifier = identifier, status = status }, function(done)
			if callback then
				callback(true)
			end
		end)
	end)
end)

function isEmpty(string)
  	return string == nil or string == ''
end

function tLength(t)
	local l = 0

	for k, v in pairs(t) do
		l = l + 1
	end

	return l
end