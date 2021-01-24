function getLastMessages(source)
	local query = [[
        SELECT sender, receiver, message, time FROM (SELECT MAX(id) AS id FROM messages WHERE ? IN (sender, receiver) GROUP BY IF (? = sender, receiver, sender)) AS latest LEFT JOIN messages USING(id) ORDER BY id DESC;
    ]]

    local characterPhone = exports['crp-base']:getCharacter(source).getPhone()
	local result = Citizen.Await(DB:Execute(query, characterPhone, characterPhone))

	return result
end

function getMessages(source, targetNumber)
	if not targetNumber or type(targetNumber) ~= 'number' then return false end

	local query = [[
        SELECT sender, receiver, message, time FROM messages WHERE (sender = ? OR receiver = ?) AND (sender = ? or receiver = ?) AND sender != receiver ORDER BY id ASC;
    ]]

	local characterPhone = exports['crp-base']:getCharacter(source).getPhone()
	local result = Citizen.Await(DB:Execute(query, characterPhone, characterPhone, targetNumber, targetNumber))

	return true, result
end

RPC:register('getMessages', getMessages)

function sendMessage(source, targetNumber, message)
    if not targetNumber or type(targetNumber) ~= 'number' then return false end
	if not message or type(message) ~= 'string' then return false end

    local query = [[
        INSERT INTO messages (sender, receiver, message, time) VALUES (?, ?, ?, ?);
    ]]

	local characterPhone, time = exports['crp-base']:getCharacter(source).getPhone(), GetCurrentTime()
	local result = Citizen.Await(DB:Execute(query, characterPhone, targetNumber, message, time))

	if result and result.affectedRows > 0 then
		local target, data = exports['crp-base']:getCharacterByPhone(targetNumber), {
			sender = characterPhone, receiver = targetNumber, message = message, time = time
		}

		if target then
			TriggerClientEvent('crp-phone:receiveMessage', target.source, data)
		end

		return true, data
	end

	return false
end

RPC:register('sendMessage', sendMessage)