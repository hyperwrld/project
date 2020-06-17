function GetCharacter(source)
	return users[source]
end

function GetCharacterByPhone(number)
    for k, v in ipairs(users) do
        if tonumber(v.getPhoneNumber()) == tonumber(number) then
            return v
        end
    end
    return false
end

function GetAllCharacters()
    return users
end