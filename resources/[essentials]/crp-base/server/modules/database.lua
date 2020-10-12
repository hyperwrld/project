CRP.DB = {}

function CRP.DB:FetchCharacters(source)
	local identifier = CRP.Util:GetPlayerIdentifier(source)

    if not identifier or identifier == '' then return false end

	local query = [[SELECT id, firstname, lastname, gender, dateofbirth, job, bank, money, story, phone FROM users WHERE identifier = ?;]]

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

    if not data.firstname or type(data.firstname) ~= 'string' then return false end
    if not data.lastname or type(data.lastname) ~= 'string' then return false end
    if not data.dob or type(data.dob) ~= 'string' then return false end
    if not data.story or type(data.story) ~= 'string' then return false end
	if not data.gender or type(data.gender) ~= 'string' then return false end

	local characterExist = CRP.DB:DoesCharacterExist(data.firstname, data.lastname)

	if characterExist then
		return false, 'O nome que escolheu já está a ser utilizado.'
	end

	local numCharacters = CRP.DB:GetCharactersTotal(identifier)

	if numCharacters >= 5 then
		return false, 'Já tens o máximo de personagens possível.'
    end

	local query, phoneNumber = [[INSERT INTO users (identifier, firstname, lastname, dob, gender, story, phone) VALUES (?, ?, ?, ?, ?, ?, ?);]], CRP.Util:GeneratePhoneNumber()
    local result = Citizen.Await(DB:Execute(query, identifier, data.firstname, data.lastname, data.dob, data.gender, data.story, phoneNumber))

	if not result.changedRows then
		return false, 'Ocorreu um erro ao criar a sua personagem, contacte um administrador, caso o problema continue.'
	end

	return true, {
		id = result.insertId,
		firstname = data.firstname,
		lastname = data.lastname,
		dob = data.dob,
		gender = data.gender,
		story = data.story,
		phone = phoneNumber
	}
end

function CRP.DB:DeleteCharacter(source, characterId)
	local identifier = CRP.Util:GetPlayerIdentifier(source)

    if not identifier or identifier == '' then return false end
    if not characterId or type(characterId) ~= 'number' then return false end

    local query = [[DELETE FROM users WHERE identifier = ? AND id = ?;]]
    local result = Citizen.Await(DB:Execute(query, identifier, characterId))

    if not result.changedRows then
        return false
    end

    return true
end

function CRP.DB:RetrieveCharacter(source, characterId)
	local identifier = CRP.Util:GetPlayerIdentifier(source)

    if not identifier or identifier == '' then return false end
    if not characterId or type(characterId) ~= 'number' then return false end

    local query = [[SELECT * FROM users WHERE identifier = ? AND id = ?;]]
    local result = Citizen.Await(DB:Execute(query, identifier, characterId))

	if #result == 0 then
        return false
    end

    CRP.Player:LoadCharacter(source, result[1])

    return result[1].skin
end

function CRP.DB:GetCharactersTotal(identifier)
    local query = [[SELECT COUNT(1) AS count FROM users WHERE identifier = ?;]]
	local result = Citizen.Await(DB:Execute(query, identifier))

	return result[1].count
end