CRP = CRP or {}
CRP.DB = {}

function CRP.DB:FetchCharacters(identifier)
    if not identifier or identifier == '' then return false end

    local query = [[SELECT id, firstname, lastname, gender, dob, job, bank, money, story, phone FROM users WHERE identifier = ?;]]

    return Citizen.Await(CRP.DB:Execute(query, identifier))
end

function CRP.DB:DoesCharacterExist(firstname, lastname)
    if not firstname or type(firstname) ~= 'string' then return false end
    if not lastname or type(lastname) ~= 'string' then return false end

    local query = [[SELECT * FROM users WHERE firstname = ? AND lastname = ?;]]

    return Citizen.Await(CRP.DB:Scalar(query, firstname, lastname))
end

function CRP.DB:CreateCharacter(identifier, data)
    if not identifier or identifier == '' then return { status = false } end

    if not data.firstname or type(data.firstname) ~= 'string' then return { status = false } end
    if not data.lastname or type(data.lastname) ~= 'string' then return { status = false } end
    if not data.dob or type(data.dob) ~= 'string' then return { status = false } end
    if not data.story or type(data.story) ~= 'string' then return { status = false } end
    if not data.gender or type(data.gender) ~= 'string' then return { status = false } end

    local doesCharacterExist = CRP.DB:DoesCharacterExist(data.firstname, data.lastname)

    if doesCharacterExist then
        return { status = false, message = 'O nome que escolheu já está a ser utilizado.' }
    else
        local query = [[INSERT INTO users (identifier, firstname, lastname, dob, gender, story, phone) VALUES (?, ?, ?, ?, ?, ?, ?);]]
        local result = Citizen.Await(CRP.DB:Execute(query, identifier, data.firstname, data.lastname, data.dob, data.gender, data.story, CRP.Util:GeneratePhoneNumber()))

        if not result.changedRows then
            return { status = false, message = 'Ocorreu um erro ao criar a sua personagem, contacte um administrador, caso o problema continue.' }
        end

        local query = [[SELECT id, firstname, lastname, gender, dob, job, bank, money, story, phone FROM users WHERE identifier = ? AND firstname = ? AND lastname = ?;]]
        local characterData = Citizen.Await(CRP.DB:Execute(query, identifier, data.firstname, data.lastname))

        return { status = true, characterData = characterData[1] }
    end
end

function CRP.DB:DeleteCharacter(identifier, characterId)
    if not identifier or identifier == '' then return { status = false } end
    if not characterId or type(characterId) ~= 'number' then return { status = false } end

    local query = [[DELETE FROM users WHERE identifier = ? AND id = ?;]]
    local result = Citizen.Await(CRP.DB:Execute(query, identifier, characterId))

    if not result.changedRows then
        return { status = false }
    end

    return { status = true }
end

function CRP.DB:RetrieveCharacter(identifier, data)
    if not identifier or identifier == '' then return false end
    if not data.characterId or type(data.characterId) ~= 'number' then return false end

    local query = [[SELECT * FROM users WHERE identifier = ? AND id = ?;]]
    local result = Citizen.Await(CRP.DB:Execute(query, identifier, data.characterId))

    if result == 0 then
        return false
    end

    CRP.Player:LoadCharacter(data.source, result[1])

    return result[1].skin
end

function CRP.DB:Execute(query, ...)
    local executePromise = promise:new()

    exports.ghmattimysql:execute(query, { ... }, function(result) executePromise:resolve(result) end)

    return executePromise
end

function CRP.DB:Scalar(query, ...)
    local scalarPromise = promise:new()

    exports.ghmattimysql:scalar(query, { ... }, function(result) scalarPromise:resolve(result) end)

    return scalarPromise
end