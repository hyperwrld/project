Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)

		if NetworkIsPlayerActive(PlayerId()) then
			exports['spawnmanager']:spawnPlayer(vector4(409.8483, -1001.0, -100.0, 5.39))
			break
		end
	end
end)

AddEventHandler('playerSpawned', function()
    CRP.Spawn:InitializeMenu()
end)

AddEventHandler('crp-ui:closedMenu', function(name, data)
	if name ~= 'selection' then
		return
	end

	Debug('Character selection closed.')

	CRP.Spawn:SpawnCharacter(data.characterData)
end)

RegisterUICallback('disconnectUser', function(data, cb)
	TriggerServerEvent('crp-base:disconnectUser')

	cb({ status = true })
end)

RegisterUICallback('changedCharacter', function(data, cb)
	CRP.Spawn:ChangeCharacter(data)

	cb('ok')
end)

RegisterUICallback('selectCharacter', function(data, cb)
	local success, characterData = RPC:execute('selectCharacter', data)

	cb({ state = success, characterData = characterData })
end)

RegisterUICallback('deleteCharacter', function(data, cb)
	local success = RPC:execute('deleteCharacter', data)

	cb({ state = success })
end)

RegisterUICallback('createCharacter', function(data, cb)
	local success, characterData = RPC:execute('createCharacter', data)

	cb({ state = success, characterData = characterData })
end)