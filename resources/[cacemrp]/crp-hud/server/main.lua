AddEventHandler('crp-base:playerLoaded', function(source, character)
	local status = character.getStatus()

	if status == nil then
		status = { health = 200, armour = 0, hunger = 100, thirst = 100, stress = 0 }

		character.setStatus(status)
	end

	Citizen.Wait(10000)

	TriggerClientEvent('crp-hud:setMeta', source, status)
end)

RegisterNetEvent('crp-hud:updateData')
AddEventHandler('crp-hud:updateData', function(health, armour, hunger, thirst, stress)
    local _source, status = source, {}
	local character = exports['crp-base']:GetCharacter(_source)

	status = { health = health, armour = armour, hunger = hunger, thirst = thirst, stress = stress }

	character.setStatus(status)
end)