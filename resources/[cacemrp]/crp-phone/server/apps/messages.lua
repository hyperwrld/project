function getConversations(source)
	local query = [[
        SELECT sender, receiver, message, time FROM (SELECT MAX(id) AS id FROM messages WHERE ? IN (sender, receiver) GROUP BY IF (? = sender, receiver, sender)) AS latest LEFT JOIN messages USING(id) ORDER BY id DESC;
    ]]

    local characterPhone = exports['crp-base']:GetCharacter(source).getPhoneNumber()
	local result = Citizen.Await(CRP.DB:Execute(query, characterPhone, characterPhone))

	return result
end

function getMessages(targetNumber)
	if not targetNumber or type(targetNumber) ~= 'number' then return false end

	local query = [[
        SELECT sender, receiver, message, time FROM messages WHERE (sender = ? OR receiver = ?) AND (sender = ? or receiver = ?) AND sender != receiver ORDER BY id ASC;
    ]]

	local characterPhone = exports['crp-base']:GetCharacter(source).getPhoneNumber()
	local result = Citizen.Await(CRP.DB:Execute(query, characterPhone, characterPhone, targetNumber, targetNumber))

	return true, result
end

function sendMessage(targetNumber, message)
    if not targetNumber or type(targetNumber) ~= 'number' then return false end
    if not message or type(message) ~= 'string' then return false end

    local query = [[
        INSERT INTO messages (sender, receiver, message, time) VALUES (?, ?, ?, ?);
    ]]

	local characterPhone = exports['crp-base']:GetCharacter(source).getPhoneNumber()
	local result = Citizen.Await(CRP.DB:Execute(query, characterPhone, targetNumber, message, generateTime()))

	if result and result.affectedRows > 0 then
		local characters = exports['crp-base']:GetAllCharacters()

		for i = 1, #characters, 1 do
			local character = characters[i]

			if character:getPhoneNumber() == targetNumber then
				TriggerClientEvent('crp-phone:receiveMessage', character.source, { characterPhone, message })
				break
			end
		end

		return true
	else
		return false
	end
end