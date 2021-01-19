function addLicenses(characterId)
	local query = [[INSERT INTO licenses (id, driver, weapons, hunting, law, fishing) VALUES (?, ?, ?, ?, ?, ?);]]
	local result = Citizen.Await(DB:Execute(query, characterId, true, false, false, false, false))

	if result.changedRows then
		Debug('Added license to characterId: ' .. characterId)
	end
end

function editLicense(source, type, state)
	local character = getCharacter(source)
	local characterId = character.getCharacterId()

	local query = [[UPDATE licenses SET ]] .. type .. [[ = ? WHERE id = ?;]]
	local result = Citizen.Await(DB:Execute(query, state, characterId))

	if not result.changedRows then
		return false
	end

	Debug('Edited license (' .. type .. ') to state: ' .. state)

	return true
end

exports('editLicense', editLicense)