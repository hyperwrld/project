function getContacts(source)
	local query = [[
		SELECT id, name, number FROM contacts WHERE character_id = ?;
	]]

	local character = exports['crp-base']:getCharacter(source)

	return Citizen.Await(DB:Execute(query, character.getCharacterId()))
end

function addContact(source, contactName, contactNumber)
	if not contactName or type(contactName) ~= 'string' then return false end
	if not contactNumber or type(contactNumber) ~= 'string' then return false end

	local query = [[
		INSERT INTO contacts (character_id, name, number) VALUES (?, ?, ?);
	]]

	local character = exports['crp-base']:getCharacter(source)
	local result = Citizen.Await(DB:Execute(query, character.getCharacterId(), contactName, contactNumber))

	if result and result.affectedRows > 0 then
		return true, result.insertId
	end

	return false
end

RPC:register('addContact', addContact)

function deleteContact(source, contactId)
	if not contactId or type(contactId) ~= 'number' then return false end

	local query = [[
		DELETE FROM contacts WHERE id = ?;
	]]

	local result = Citizen.Await(DB:Execute(query, contactId))

	if result and result.affectedRows > 0 then
		return true
	end

	return false
end

RPC:register('deleteContact', deleteContact)

function editContact(source, contactId, contactName, contactNumber)
	if not contactId or type(contactId) ~= 'number' then return false end
	if not contactName or type(contactName) ~= 'string' then return false end
	if not contactNumber or type(contactNumber) ~= 'number' then return false end

	local query = [[
		UPDATE contacts SET name = ?, number = ? WHERE id = ? AND character_id = ?;
	]]

	local character = exports['crp-base']:getCharacter(source)
	local result = Citizen.Await(DB:Execute(query, contactName, contactNumber, contactId, character.getCharacterId()))

	if result and result.affectedRows > 0 then
		return true
	end

	return false
end

RPC:register('editContact', editContact)