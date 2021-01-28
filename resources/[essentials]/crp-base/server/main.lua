AddEventHandler('playerDropped', function()
	local _source, character = source, CRP.Characters[source]

	if CRP.Characters[_source] then
		TriggerEvent('crp-base:playerDisconnected', character)

		CRP.DB:SaveCharacterData(_source, character.getCharacterId(), character.getBank(), character.getPosition())

		CRP.Characters[_source] = nil

		Debug('Player disconnected | Character data saved successfully.')
	end
end)

RegisterNetEvent('crp-base:updatePosition')
AddEventHandler('crp-base:updatePosition', function(coords)
	local character = CRP.Characters[source]

	if character then
		character.setPosition(coords)

		Debug('Character current position saved.')
	end
end)

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