AddEventHandler('crp-base:playerLoaded', function(source, character)
	local status = character.getStatus()

	if status == nil then
		status = { health = 200, armour = 0, hunger = 100, thirst = 100, stress = 0 }

		character.setStatus(status)
	end

	Citizen.Wait(10000)

	TriggerClientEvent('crp-hud:setMeta', source, status)
end)

RegisterNetEvent('crp-hud:updateMeta')
AddEventHandler('crp-hud:updateMeta', function(health, armour, hunger, thirst, stress)
	local character = exports['crp-base']:GetCharacter(source)

	character.setStatus({ health = health, armour = armour, hunger = hunger, thirst = thirst, stress = stress })
end)