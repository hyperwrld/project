local _lastHealth, _lastArmour, _lastBreath, _lastStress = 0, 0, 0, 0
local hunger, thirst, stress, isHudActive, isCompassOn = 100, 100, 0, false, false

local zoneNames = {
    AIRP = 'Los Santos International Airport', ALAMO = 'Alamo Sea', ALTA = 'Alta', ARMYB = 'Fort Zancudo', BANHAMC = 'Banham Canyon Dr', BANNING = 'Banning',
    BAYTRE = 'Baytree Canyon', BEACH = 'Vespucci Beach', BHAMCA = 'Banham Canyon', BRADP = 'Braddock Pass', BRADT = 'Braddock Tunnel', BURTON = 'Burton',
    CALAFB = 'Calafia Bridge', CANNY = 'Raton Canyon', CCREAK = 'Cassidy Creek', CHAMH = 'Chamberlain Hills', CHIL = 'Vinewood Hills', CHU = 'Chumash',
    CMSW = 'Chiliad Mountain State Wilderness', CYPRE = 'Cypress Flats', DAVIS = 'Davis', DELBE = 'Del Perro Beach', DELPE = 'Del Perro', DELSOL = 'La Puerta',
    DESRT = 'Grand Senora Desert', DOWNT = 'Downtown', DTVINE = 'Downtown Vinewood', EAST_V = 'East Vinewood', EBURO = 'El Burro Heights', ELGORL = 'El Gordo Lighthouse',
    ELYSIAN = 'Elysian Island', GALFISH = 'Galilee', GALLI = 'Galileo Park', golf = 'GWC and Golfing Society', GRAPES = 'Grapeseed', GREATC = 'Great Chaparral',
    HARMO = 'Harmony', HAWICK = 'Hawick', HORS = 'Vinewood Racetrack', HUMLAB = 'Humane Labs and Research', JAIL = 'Bolingbroke Penitentiary', KOREAT = 'Little Seoul',
    LACT = 'Land Act Reservoir', LAGO = 'Lago Zancudo', LDAM = 'Land Act Dam', LEGSQU = 'Legion Square', LMESA = 'La Mesa', LOSPUER = 'La Puerta', MIRR = 'Mirror Park',
    MORN = 'Morningwood', MOVIE = 'Richards Majestic', MTCHIL = 'Mount Chiliad', MTGORDO = 'Mount Gordo', MTJOSE = 'Mount Josiah', MURRI = 'Murrieta Heights',
    NCHU = 'North Chumash', NOOSE = 'N.O.O.S.E', OCEANA = 'Pacific Ocean', PALCOV = 'Paleto Cove', PALETO = 'Paleto Bay', PALFOR = 'Paleto Forest',
    PALHIGH = 'Palomino Highlands', PALMPOW = 'Palmer-Taylor Power Station', PBLUFF = 'Pacific Bluffs', PBOX = 'Pillbox Hill', PROCOB = 'Procopio Beach', RANCHO = 'Rancho',
    RGLEN = 'Richman Glen', RICHM = 'Richman', ROCKF = 'Rockford Hills', RTRAK = 'Redwood Lights Track', SanAnd = 'San Andreas', SANCHIA = 'San Chianski Mountain Range',
    SANDY = 'Sandy Shores', SKID = 'Mission Row', SLAB = 'Stab City', STAD = 'Maze Bank Arena', STRAW = 'Strawberry', TATAMO = 'Tataviam Mountains', TERMINA = 'Terminal',
    TEXTI = 'Textile City', TONGVAH = 'Tongva Hills', TONGVAV = 'Tongva Valley', VCANA = 'Vespucci Canals', VESP = 'Vespucci', VINE = 'Vinewood',
    WINDF = 'Ron Alternates Wind Farm', WVINE = 'West Vinewood', ZANCUDO = 'Zancudo River', ZP_ORT = 'Port of South Los Santos', ZQ_UAR = 'Davis Quartz'
}

RegisterNetEvent('crp-hud:setMeta')
AddEventHandler('crp-hud:setMeta', function(data)
	if data == nil then
	 	return
	end

	local playerPed = GetPlayerPed(-1)

	if data.hunger == nil then hunger = 100 else hunger = data.hunger end
	if data.thirst == nil then thirst = 100 else thirst = data.thirst end
	if data.stress == nil then stress = 0   else stress = data.stress end

	if data.health < 10.0 then
		SetEntityHealth(playerPed, 10.0)
	else
		SetEntityHealth(playerPed, data.health)
	end

    SetPedArmour(playerPed, data.armour)

	StartFunction()
end)

RegisterNetEvent('crp-hud:changeMeta')
AddEventHandler('crp-hud:changeMeta', function(data)
    local playerPed = GetPlayerPed(-1)

	if data.hunger then
		hunger = hunger + 25

		if hunger < 0 then hunger = 0 end
		if hunger > 100 then hunger = 100 end
	elseif data.thirst then
		thirst = thirst + 25

		if thirst < 0 then thirst = 0 end
		if thirst > 100 then thirst = 100 end
    end

    TriggerEvent('crp-ui:updateData', { ['hunger'] = hunger, ['thirst'] = thirst, ['stress'] = stress })
	TriggerServerEvent('crp-hud:updateData', GetEntityHealth(playerPed), GetPedArmour(playerPed), hunger, thirst, stress)
end)

RegisterNetEvent('crp-hud:changeStress')
AddEventHandler('crp-hud:changeStress', function(status, value)
    local playerPed = GetPlayerPed(-1)

    if status then
        stress = stress + value

        if stress > 100 then
            stress = 100
        end

        exports['crp-notifications']:SendAlert('inform', 'Ganhaste stress.')
    else
        stress = stress - value

        if stress < 0 then
            stress = 0
        end

        exports['crp-notifications']:SendAlert('inform', 'Perdeste stress.')
    end

    TriggerEvent('crp-ui:updateData', { ['hunger'] = hunger, ['thirst'] = thirst, ['stress'] = stress })
	TriggerServerEvent('crp-hud:updateData', GetEntityHealth(playerPed), GetPedArmour(playerPed), hunger, thirst, stress)
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

	    	local topX, topY = GetScriptGfxPosition(-0.0045, 0.002 + (-0.188888))

            ResetScriptGfxAlign()

            TriggerEvent('crp-ui:setHudPosition', topX, topY)

            TriggerServerEvent('crp-hud:updateData', GetEntityHealth(playerPed), GetPedArmour(playerPed), hunger, thirst, stress)

            TriggerEvent('crp-ui:updateData', { ['hunger'] = hunger, ['thirst'] = thirst })

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
                TriggerEvent('crp-ui:updateData', { ['health'] = health / 2, ['armour'] = armour, ['breath'] = breath * 2.5, ['stress'] = stress  })
            end
		end
    end)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(100)

            local playerPed = PlayerPedId()

            if IsVehicleEngineOn(GetVehiclePedIsIn(playerPed)) then
                local position = GetEntityCoords(playerPed)
                local zoneName = zoneNames[GetNameOfZone(position.x, position.y, position.z)]
                local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(position.x, position.y, position.z))
                local speed = math.ceil(GetEntitySpeed(GetVehiclePedIsIn(playerPed, false)) * 3.6)
                local locationString, currentTime = streetName, GetCurrentTime()

                if zoneName then
                    locationString = streetName .. ' | ' .. zoneName
                end

                if not isHudActive then
                    DisplayRadar(true)

                    isHudActive = true
                end

                TriggerEvent('crp-ui:updateVehicleInfo', { status = isHudActive, data = { location = locationString, speed = speed, fuel = fuel, time = currentTime }})
            elseif isCompassOn then
                isHudActive = false

                DisplayRadar(false)

                TriggerEvent('crp-ui:updateCompassInfo', { time = currentTime, direction = 0 })
            elseif not isHudActive then
                isHudActive = false

                DisplayRadar(false)

                TriggerEvent('crp-ui:updateVehicleInfo', { status = isHudActive })
            end
        end
    end)

    -- Citizen.CreateThread(function()
    --     while true do
    --         Citizen.Wait(500)

    --         if IsPedInAnyVehicle(PlayerPedId(), true) then
    --             local position = GetEntityCoords(playerPed)
    --             local zoneName = zoneNames[GetNameOfZone(position.x, position.y, position.z)]
    --             local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(position.x, position.y, position.z))
    --             local speed = math.ceil(GetEntitySpeed(GetVehiclePedIsIn(playerPed, false)) * 3.6)
    --             local locationString, currentTime = streetName, GetCurrentTime()

    --             if zoneName then
    --                 locationString = streetName .. ' | ' .. zoneName
    --             end

    --             if not isHudActive then
    --                 DisplayRadar(true)

    --                 isHudActive = true

    --                 SendNUIMessage({
    --                     eventName = 'updateGps',
    --                     show = true,
    --                     locationName = GetDirectionHeading(playerPed) .. ' | ' .. locationString,
    --                     speed = speed,
    --                     fuel = 0,
    --                     time = currentTime
    --                 })
    --             else
    --                 SendNUIMessage({
    --                     eventName = 'updateGps',
    --                     locationName = GetDirectionHeading(playerPed) .. ' | ' .. locationString,
    --                     speed = speed,
    --                     fuel = 0,
    --                     time = currentTime
    --                 })
    --             end
    --         elseif isHudActive then
    --             isHudActive = false

    --             DisplayRadar(false)

    --             SendNUIMessage({ eventName = 'updateGps', hide = true })
    --         end
    --     end
    -- end)

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

local width = 0;
local south, west = (-100) + width, (-100 * 2) + width
local north, east, south2 = (-100 * 3) + width, (-100 * 4) + width, (-100 * 5) + width

function GetDirectionHeading(playerPed)
    local heading = -GetEntityHeading(player) % 360

    if (heading < 90) then
        local rangePercent = heading / 90

        return math.floor((1 - rangePercent) * north + rangePercent * east)
    elseif (direction < 180) then
        local rangePercent = CalculateRangePercent(90, 180, direction)

        return math.floor((1 - rangePercent) * east + rangePercent * south2)
    elseif (direction < 270) then
        local rangePercent = CalculateRangePercent(180, 270, direction)

        return math.floor((1 - rangePercent) * south + rangePercent * west)
    elseif (direction <= 360) then
        local rangePercent = CalculateRangePercent(270, 360, direction)

        return math.floor((1 - rangePercent) * west + rangePercent * north)
    end
end

function CalculateRangePercent(min, max, amt)
    return (((amt - min) * 100) / (max - min)) / 100
end

function GetCurrentTime()
	local hours, minutes = GetClockHours(), GetClockMinutes()

    if hours >= 0 and hours < 10 then
        hours = '0' .. hours
    end

    if minutes >= 0 and minutes < 10 then
        minutes = '0' .. minutes
    end

    return hours .. ':' .. minutes
end