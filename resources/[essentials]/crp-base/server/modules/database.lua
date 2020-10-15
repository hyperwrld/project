CRP.DB = {}

function CRP.DB:FetchCharacters(source)
	local identifier = CRP.Util:GetPlayerIdentifier(source)

    if not identifier or identifier == '' then return false end

	local query = [[SELECT id, firstname, lastname, gender, dateofbirth, job, bank, money FROM users WHERE identifier = ?;]]

    return Citizen.Await(DB:Execute(query, identifier))
end

function CRP.DB:DoesCharacterExist(firstname, lastname)
    if not firstname or type(firstname) ~= 'string' then return false end
    if not lastname or type(lastname) ~= 'string' then return false end

    local query = [[SELECT 1 FROM users WHERE firstname = ? AND lastname = ?;]]
    local result = Citizen.Await(DB:Execute(query, firstname, lastname))

    if result[1] then
        return true
    end

    return false
end

function CRP.DB:CreateCharacter(source, data)
	local identifier = CRP.Util:GetPlayerIdentifier(source)

	if not identifier or identifier == '' then return false end

	if not data.firstName or type(data.firstName) ~= 'string' then return false end
	if not data.lastName or type(data.lastName) ~= 'string' then return false end
	if not data.dateOfBirth or type(data.dateOfBirth) ~= 'string' then return false end
	if not data.history or type(data.history) ~= 'string' then return false end
	if data.gender == nil or type(data.gender) ~= 'boolean' then return false end

	local characterExist = CRP.DB:DoesCharacterExist(data.firstName, data.lastName)

	if characterExist then
		return false, 'O nome que escolheu já está a ser utilizado.'
	end

	local numCharacters = CRP.DB:GetCharactersTotal(identifier)

	if numCharacters >= 5 then
		return false, 'Já tens o máximo de personagens possível.'
	end

	local query, phoneNumber = [[INSERT INTO users (identifier, firstname, lastname, dateofbirth, gender, story, phone) VALUES (?, ?, ?, ?, ?, ?, ?);]], CRP.Util:GeneratePhoneNumber()
    local result = Citizen.Await(DB:Execute(query, identifier, data.firstName, data.lastName, data.dateOfBirth, data.gender, data.history, phoneNumber))

	if not result.changedRows then
		return false, 'Ocorreu um erro ao criar a sua personagem, contacte um administrador, caso o problema continue.'
	end

	return true, {
		id = result.insertId,
		money = 500, bank = 5000
	}
end

function CRP.DB:DeleteCharacter(source, data)
	local identifier = CRP.Util:GetPlayerIdentifier(source)

    if not identifier or identifier == '' then return false end
    if not data.characterId or type(data.characterId) ~= 'number' then return false end

    local query = [[DELETE FROM users WHERE identifier = ? AND id = ?;]]
    local result = Citizen.Await(DB:Execute(query, identifier, data.characterId))

    if not result.changedRows then
        return false
    end

    return true
end

function CRP.DB:RetrieveCharacter(source, characterId)
	local identifier = CRP.Util:GetPlayerIdentifier(source)

    if not identifier or identifier == '' then return false end
	if not characterId or type(characterId) ~= 'number' then return false end

    local query = [[SELECT id, identifier, firstname, lastname, money, bank, job, phone, dateofbirth, gender, skin FROM users WHERE identifier = ? AND id = ?;]]
    local result = Citizen.Await(DB:Execute(query, identifier, characterId))

	if #result == 0 then
        return false
	end

	CRP.Player:LoadCharacter(source, result[1])

    return true, result[1]
end

function CRP.DB:GetCharactersTotal(identifier)
    local query = [[SELECT COUNT(1) AS count FROM users WHERE identifier = ?;]]
	local result = Citizen.Await(DB:Execute(query, identifier))

	return result[1].count
end