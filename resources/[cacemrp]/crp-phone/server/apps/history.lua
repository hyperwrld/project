local history = {
	[1] = {
		{
			number = 966831664,
			time = 1584110467,
			isIncoming = true
		},
		{
			number = 967301022,
			time = 1584110467,
			isIncoming = false
		}
	}
}

function getHistory(source)
	local character = exports['crp-base']:getCharacter(source)

	return history[character:getCharacterId()]
end

RPC:register('getHistory', getHistory)

function addCall(source, number, isIncoming)
	local character = exports['crp-base']:getCharacter(source)
	local characterId = character:getCharacterId()

	history[characterId][#history[characterId] + 1] = { number = number, time = GetCurrentTime(), isIncoming = isIncoming }

	return true
end

RPC:register('addCall', addCall)