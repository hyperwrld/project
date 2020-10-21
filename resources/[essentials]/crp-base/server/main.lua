RegisterNetEvent('crp-base:disconnectUser')
AddEventHandler('crp-base:disconnectUser', function()
	DropPlayer(source, 'Foste desconectado do servidor.')
end)

function getAllCharacters(source)
	return CRP.Characters
end

function getCharacter(source)
	return CRP.Characters[source]
end

function getCharacterByPhone(number)
	for i = 1, #CRP.Characters do
		if tonumber(CRP.Characters[i].getPhone()) == tonumber(number) then
			return CRP.Characters[i]
		end
	end

	return false
end

RPC:register('fetchCharacters', function(source) return CRP.DB:FetchCharacters(source) end)
RPC:register('createCharacter', function(source, data) return CRP.DB:CreateCharacter(source, data) end)
RPC:register('deleteCharacter', function(source, data) return CRP.DB:DeleteCharacter(source, data) end)
RPC:register('selectCharacter', function(source, characterId) return CRP.DB:RetrieveCharacter(source, characterId) end)

exports('getAllCharacters', getAllCharacters)
exports('getCharacter', getCharacter)
exports('getCharacterByPhone', getCharacterByPhone)