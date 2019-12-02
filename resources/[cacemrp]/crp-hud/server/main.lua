AddEventHandler('crp:playerloaded', function(source, user)
	local status = user.getStatus()

	if status == nil then
		status = { health = 200, armour = 0, hunger = 100, thirst = 100, stress = 0 }

		user.setStatus(status)
	end

	Citizen.Wait(10000)

	TriggerClientEvent('crp-hud:setmeta', source, status)
end)

RegisterNetEvent('crp-hud:update')
AddEventHandler('crp-hud:update', function(health, armour, hunger, thirst, stress)
	local _source, status = source, {}
	local user = exports['crp-base']:getCharacter(_source)

	status = { health = health, armour = armour, hunger = hunger, thirst = thirst, stress = stress }

	user.setStatus(status)
end)