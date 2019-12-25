users, commands, commandSuggestions = {}, {}, {}

settings = { ['startingCash'] = '5000', ['startingBank'] = '55000' }

function SplitString(inputString, seperator)
	if seperator == nil then
		seperator = "%s"
	end

	local t = {} ; i = 1

	for string in string.gmatch(inputString, '([^' .. seperator .. ']+)') do
		t[i] = string
		i = i + 1
	end

	return t
end

function StringStartsWith(string, start)
	return string.sub(string, 1, string.len(start)) == start
end

function SanitizePlayerName(string)
    local replacements = { ['<'] = '', ['>'] = '' }

    return string:gsub('[<>]', replacements)
end

function MathRound(value, decimalplaces)
	if decimalplaces then
		return math.floor((value * 10 ^ decimalplaces) + 0.5) / (10 ^ decimalplaces)
	else
		return math.floor(value + 0.5)
	end
end

exports('getCharacter', function(source)
	return users[source]
end)