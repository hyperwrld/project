CRP.DB = {}

function CRP.DB:FetchCharacters(identifier, callback)
    if not identifier or identifier == '' then callback(false) return end

    local query = [[SELECT id, firstname, lastname, gender, dob, job, bank, money, story, phone FROM users WHERE identifier = @identifier;]]

    exports.ghmattimysql:execute(query, { ['@identifier'] = identifier }, function(result)
        callback:resolve(result)
    end)
end

function CRP.DB:DoesCharacterExist(firstname, lastname, callback)
    if not firstname or type(firstname) ~= 'string' then callback(false, true) return end
    if not lastname or type(lastname) ~= 'string' then callback(false, true) return end

    local query = [[SELECT * FROM users WHERE firstname = @firstname AND lastname = @lastname;]]
    local parameters = { ['@firstname'] = firstname, ['@lastname'] = lastname }

    exports.ghmattimysql:scalar(query, parameters, function(result)
        if result then
            callback(true)
        else
            callback(false)
        end
	end)
end

function CRP.DB:CreateCharacter(identifier, data, callback)
    if not identifier or identifier == '' then callback:resolve({ status = false }) return end

    if not data.firstname or type(data.firstname) ~= 'string' then callback:resolve({ status = false }) return end
    if not data.lastname or type(data.lastname) ~= 'string' then callback:resolve({ status = false }) return end
    if not data.dob or type(data.dob) ~= 'string' then callback:resolve({ status = false }) return end
    if not data.story or type(data.story) ~= 'string' then callback:resolve({ status = false }) return end
    if not data.gender or type(data.gender) ~= 'string' then callback:resolve({ status = false }) return end

    CRP.DB:DoesCharacterExist(data.firstname, data.lastname, function(status)
        if status then
            callback:resolve({ status = false, message = 'O nome que escolheu já está a ser utilizado.' })
        else
            local query = [[INSERT INTO users (identifier, firstname, lastname, dob, gender, story, phone) VALUES (@identifier, @firstname, @lastname, @dob, @gender, @story, @phone);]]
            local parameters = {
                ['@identifier'] = identifier,
                ['@firstname'] = data.firstname,
                ['@lastname'] = data.lastname,
                ['@dob'] = data.dob,
                ['@sex'] = data.gender,
                ['@story'] = data.story,
                ['@phone'] = CRP.Util:GeneratePhoneNumber()
            }

            exports.ghmattimysql:execute(query, parameters, function(result)
                if not result.changedRows then
                    callback:resolve({ status = false, message = 'Ocorreu um erro ao criar a sua personagem, contacte um administrador, caso o problema continue.' })
                    return
                end

                print(json.encode(result))

                callback:resolve({ status = true, data = result })
            end)
        end
    end)
end

function CRP.DB:DeleteCharacter(identifier, characterId, callback)
    if not identifier or identifier == '' then callback(false, true) return end
    if not characterId or type(characterId) ~= 'number' then callback(false, true) return end

    local query = [[DELETE FROM users  WHERE id = @id AND identifier = @identifier;]]
    local parameters = {
        ['@id'] = characterId,
        ['@identifier'] = identifier
    }

    exports.ghmattimysql:execute(query, parameters, function(result)
        if not result.changedRows then callback(false, true) return end

        callback((result and true or false))
    end)
end

function CRP.DB:RetrieveCharacter(identifier, characterId, callback)
    if not identifier or identifier == '' then callback(false, true) return end
    if not characterId or type(characterId) ~= 'number' then callback(false, true) return end

    local query = [[SELECT * FROM users WHERE identifier = @identifier AND id = @id;]]
    local parameters = {
        ['@id'] = characterId,
        ['@identifier'] = identifier
    }

    exports.ghmattimysql:execute(query, parameters, function(result)
        if #result > 0 then
            callback(result)
        else
            callback(false)
        end
    end)
end