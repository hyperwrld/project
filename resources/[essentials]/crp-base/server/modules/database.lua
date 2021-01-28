CRP.DB = {}

function CRP.DB.FetchCharacters(source)
	local identifier = CRP.Util:GetPlayerIdentifier(source)

    if not identifier or identifier == '' then return false end

	local query = [[SELECT id, firstname, lastname, gender, dateofbirth, job, bank, skin FROM characters WHERE identifier = ?;]]

    return Citizen.Await(DB:Execute(query, identifier))
end

RPC:register('fetchCharacters', CRP.DB.FetchCharacters)

function CRP.DB.DoesCharacterExist(firstname, lastname)
    if not firstname or type(firstname) ~= 'string' then return false end
    if not lastname or type(lastname) ~= 'string' then return false end

    local query = [[SELECT 1 FROM characters WHERE firstname = ? AND lastname = ?;]]
    local result = Citizen.Await(DB:Execute(query, firstname, lastname))

    if result[1] then
        return true
    end

    return false
end

function CRP.DB.CreateCharacter(source, data)
	local identifier = CRP.Util:GetPlayerIdentifier(source)

	if not identifier or identifier == '' then return false end

	if not data.firstName or type(data.firstName) ~= 'string' then return false end
	if not data.lastName or type(data.lastName) ~= 'string' then return false end
	if not data.dateOfBirth or type(data.dateOfBirth) ~= 'string' then return false end
	if data.gender == nil or type(data.gender) ~= 'boolean' then return false end

	local characterExist = CRP.DB.DoesCharacterExist(data.firstName, data.lastName)

	if characterExist then
		return false
	end

	local numCharacters = CRP.DB.GetCharactersTotal(identifier)

	if numCharacters >= 5 then
		return false
	end

	local query, phoneNumber = [[INSERT INTO characters (identifier, firstname, lastname, dateofbirth, gender, phone) VALUES (?, ?, ?, date_format(?, '%d/%m/%Y'), ?, ?);]], CRP.Util:GeneratePhoneNumber()
    local result = Citizen.Await(DB:Execute(query, identifier, data.firstName, data.lastName, data.dateOfBirth, data.gender, phoneNumber))

	if not result.changedRows then
		return false
	end

	addLicenses(result.insertId)

	return true, {
		id = result.insertId,
		money = 500, bank = 5000
	}
end

RPC:register('createCharacter', CRP.DB.CreateCharacter)

function CRP.DB.DeleteCharacter(source, data)
	local identifier = CRP.Util:GetPlayerIdentifier(source)

    if not identifier or identifier == '' then return false end
    if not data.characterId or type(data.characterId) ~= 'number' then return false end

    local query = [[DELETE FROM characters WHERE identifier = ? AND id = ?;]]
    local result = Citizen.Await(DB:Execute(query, identifier, data.characterId))

    if not result.changedRows then
        return false
    end

    return true
end

RPC:register('deleteCharacter', CRP.DB.DeleteCharacter)

function CRP.DB.RetrieveCharacter(source, characterId)
	local identifier = CRP.Util:GetPlayerIdentifier(source)

    if not identifier or identifier == '' then return false end
	if not characterId or type(characterId) ~= 'number' then return false end

    local query = [[SELECT id, identifier, firstname, lastname, bank, job, grade, phone, dateofbirth, gender, skin, position FROM characters WHERE identifier = ? AND id = ?;]]
    local result = Citizen.Await(DB:Execute(query, identifier, characterId))

	if #result == 0 then
        return false
	end

	CRP.Player:LoadCharacter(source, result[1])

    return true, result[1]
end

RPC:register('selectCharacter', CRP.DB.RetrieveCharacter)

function CRP.DB:SaveCharacterData(source, characterId, bank, position)
	local identifier = CRP.Util:GetPlayerIdentifier(source)

    if not identifier or identifier == '' then return false end
	if not characterId or type(characterId) ~= 'number' then return false end

	local query = [[UPDATE characters SET bank = ?, position = ? WHERE identifier = ? AND id = ?;]]

	DB:Execute(query, bank, position, identifier, characterId)
end

function CRP.DB.GetCharactersTotal(identifier)
    local query = [[SELECT COUNT(1) AS count FROM characters WHERE identifier = ?;]]
	local result = Citizen.Await(DB:Execute(query, identifier))

	return result[1].count
end