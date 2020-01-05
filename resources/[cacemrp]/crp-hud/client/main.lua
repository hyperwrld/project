local _lastHealth, _lastArmour, _lastBreath, _lastStress = 0, 0, 0, 0
local hunger, thirst, stress = 100, 100, 0

RegisterNetEvent('crp-hud:setmeta')
AddEventHandler('crp-hud:setmeta', function(meta)
	if meta == nil then
	 	return 
	end

	local playerPed = GetPlayerPed(-1)

	if meta.hunger == nil then hunger = 100 else hunger = meta.hunger end
	if meta.thirst == nil then thirst = 100 else thirst = meta.thirst end
	if meta.stress == nil then stress = 0   else stress = meta.stress end

	if meta.health < 10.0 then
		SetEntityHealth(playerPed, 10.0)
	else
		SetEntityHealth(playerPed, meta.health)
	end

	SetPedArmour(playerPed, meta.armour)

	StartFunction()
end)

RegisterNetEvent('crp-hud:changemeta')
AddEventHandler('crp-hud:changemeta', function(data)
	if data.hunger then
		hunger = hunger + 25

		if hunger < 0 then hunger = 0 end
		if hunger > 100 then hunger = 100 end
	elseif data.thirst then
		thirst = thirst + 25

		if thirst < 0 then thirst = 0 end
		if thirst > 100 then thirst = 100 end
    end

    SendNUIMessage({ eventName = 'updateStatus', hunger = hunger, thirst = thirst, stress = stress })
	TriggerServerEvent('crp-hud:update', GetEntityHealth(GetPlayerPed(-1)), GetPedArmour(GetPlayerPed(-1)), hunger, thirst, stress)
end)

RegisterNetEvent('crp-hud:changestress')
AddEventHandler('crp-hud:changestress', function(status, value)
    if status then
        stress = stress + value

        if stress > 100 then stress = 100 end

        exports['crp-notifications']:SendAlert('inform', 'Ganhaste stress.')
    else
        stress = stress - value

        if stress < 0 then stress = 0 end

        exports['crp-notifications']:SendAlert('inform', 'Perdeste stress.')
    end

    SendNUIMessage({ eventName = 'updateStatus', hunger = hunger, thirst = thirst, stress = stress })
	TriggerServerEvent('crp-hud:update', GetEntityHealth(GetPlayerPed(-1)), GetPedArmour(GetPlayerPed(-1)), hunger, thirst, stress)
end)

function StartFunction()
	local playerPed = GetPlayerPed(-1)

	Citizen.CreateThread(function()
	    while true do
	    	if hunger > 0 then
				hunger = hunger - math.random(3)
				
				if hunger < 0 then 
					hunger = 0 
				end
	    	end

	    	if thirst > 0 then
	    		thirst = thirst - 1
	    	end

	    	SetScriptGfxAlign(string.byte('L'), string.byte('B'))

	    	local _topX, _topY = GetScriptGfxPosition(-0.0045, 0.002 + (-0.188888))

	    	ResetScriptGfxAlign()

	    	SendNUIMessage({ eventName = 'hudPosition', topX = _topX, topY = _topY })

	    	TriggerServerEvent('crp-hud:update', GetEntityHealth(playerPed), GetPedArmour(playerPed), hunger, thirst, stress)

	    	SendNUIMessage({ eventName = 'updateStatus', hunger = hunger, thirst = thirst })

	    	Citizen.Wait(30000)

	    	if hunger < 20 or thirst < 20 then
	    		local newHealth = GetEntityHealth(playerPed) - math.random(10)

				SetEntityHealth(playerPed, newHealth)
	    	end
		end
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(100)

			local health, armour, breath = GetEntityHealth(playerPed), GetPedArmour(playerPed), GetPlayerUnderwaterTimeRemaining(PlayerId())

			playerPed = GetPlayerPed(-1)

			if CheckUpdate(health, armour, breath, stress) then
				SendNUIMessage({ eventName = 'updateHud', health = health, armour = armour, breath = breath, isUnderWater = IsPedSwimmingUnderWater(PlayerPedId()), stress = stress })
			end
		end
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(2000)

			if stress >= 75 then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
			elseif stress >= 45 then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.07)
			elseif stress >= 20 then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.02)
			end
		end
	end)
end

function CheckUpdate(health, armour, breath, stress)
	if _lastHealth == health and _lastArmour == armour and _lastBreath == breath and _lastStress == stress then
		return false
	end

	_lastHealth = health
	_lastArmour = armour
	_lastBreath = breath
	_lastStress = stress

	return true
end