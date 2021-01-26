RegisterNetEvent('crp-base:disconnectUser')
AddEventHandler('crp-base:disconnectUser', function()
	DropPlayer(source, 'Foste desconectado do servidor.')
end)

function getCharacter(source)
	return CRP.Characters[source]
end

exports('getCharacter', getCharacter)

function getCharacterByPhone(number)
	for i = 1, #CRP.Characters do
		if tonumber(CRP.Characters[i].getPhone()) == tonumber(number) then
			return CRP.Characters[i]
		end
	end

	return false
end

exports('getCharacterByPhone', getCharacterByPhone)

function getAllCharacters(source)
	return CRP.Characters
end

exports('getAllCharacters', getAllCharacters)