local history = {}

history = {
	[5] = {
		{
			number = 966831664,
			time = 1584110467,
			incoming = true
		},
		{
			number = 967301022,
			time = 1584110467,
			incoming = false
		}
	}
}

function getHistory(source)
	local character = exports['crp-base']:GetCharacter(source)

	return history[character:getCharacterID()]
end

function addCall(source, number, incoming)
	local character = exports['crp-base']:GetCharacter(source)

	history[character:getCharacterID()][#history[character:getCharacterID()] + 1] = { number = number, time = generateTime(), incoming = incoming }

	return true
end