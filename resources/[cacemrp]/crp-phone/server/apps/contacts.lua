function getContacts(source)
	local query = [[
		SELECT id, name, number FROM contacts WHERE character_id = ?;
	]]

	local characterId = exports['crp-base']:GetCharacter(source).getCharacterID()

	return Citizen.Await(CRP.DB:Execute(query, characterId))
end

function addContact(source, contactName, contactNumber)
	if not contactName or type(contactName) ~= 'string' then return false end
	if not contactNumber or type(contactNumber) ~= 'string' then return false end

	local query = [[
		INSERT INTO contacts (character_id, name, number) VALUES (?, ?, ?);
	]]

	local characterId = exports['crp-base']:GetCharacter(source).getCharacterID()
	local result = Citizen.Await(CRP.DB:Execute(query, characterId, contactName, contactNumber))

	if result and result.affectedRows > 0 then
		return true, result.insertId
	else
		return false
	end
end

function deleteContact(source, contactId)
	if not contactId or type(contactId) ~= 'number' then return false end

	local query = [[
		DELETE FROM contacts WHERE id = ?;
	]]

	local result = Citizen.Await(CRP.DB:Execute(query, contactId))

	if result and result.affectedRows > 0 then
		return true
	else
		return false
	end
end

function editContact(source, contactId, contactName, contactNumber)
	if not contactId or type(contactId) ~= 'number' then return false end
	if not contactName or type(contactName) ~= 'string' then return false end
	if not contactNumber or type(contactNumber) ~= 'number' then return false end

	local query = [[
		UPDATE contacts SET name = ?, number = ? WHERE id = ? AND character_id = ?;
	]]

	local characterId = exports['crp-base']:GetCharacter(source).getCharacterID()
	local result = Citizen.Await(CRP.DB:Execute(query, contactName, contactNumber, contactId, characterId))

	if result and result.affectedRows > 0 then
		return true
	else
		return false
	end
end