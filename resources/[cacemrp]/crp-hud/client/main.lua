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

local _lastHealth, _lastArmour, _lastBreath, _lastStress, isOnVehicle, isCompassOn = 0, 0, 0, 0, false, false
local south, west, north, east, south2 = (-100), (-100 * 2), (-100 * 3), (-100 * 4), (-100 * 5)

hunger, thirst, stress, playerPed, vehicle = 100, 100, 0, PlayerPedId(), 0

Citizen.CreateThread(function()
	updateMinimap()

	while true do
		Citizen.Wait(100)

		local health, armour, breath = GetEntityHealth(playerPed), GetPedArmour(playerPed), GetPlayerUnderwaterTimeRemaining(PlayerId())

		if checkUpdate(health, armour, breath, stress) then
			exports['crp-ui']:setCharacterData({ health = health / 2, armour = armour, breath = breath, stress = stress })
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)

		if isCompassOn or IsVehicleEngineOn(vehicle) then
			exports['crp-ui']:setCompassDirection(GetDirectionHeading())
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)

		vehicle = GetVehiclePedIsUsing(playerPed)

		if vehicle ~= 0 and IsVehicleEngineOn(vehicle) then
			local position = GetEntityCoords(playerPed)
			local zoneName = zoneNames[GetNameOfZone(position.x, position.y, position.z)]
			local currentStreetHash, crossingRoadHash = GetStreetNameAtCoord(position.x, position.y, position.z)
            local streetName, crossingRoadName = GetStreetNameFromHashKey(currentStreetHash), GetStreetNameFromHashKey(crossingRoadHash)
			local speed = math.ceil(GetEntitySpeed(vehicle) * 3.6)

			if not isOnVehicle then
				DisplayRadar(true)

				isOnVehicle = true

				exports['crp-ui']:setVehicleStatus(true)
			end

            if crossingRoadName ~= '' then
                streetName = streetName .. ' | ' .. crossingRoadName
            end

            if zoneName then
                streetName = streetName .. ' | [' .. zoneName .. ']'
			end

			exports['crp-ui']:setVehicleData(streetName, speed, DecorGetInt(vehicle, 'currentFuel'), GetCurrentTime())
		else
			if isOnVehicle then
				DisplayRadar(false)

				isOnVehicle = false

				exports['crp-ui']:setVehicleStatus(false)
			end

			Citizen.Wait(1000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(36000)

		if hunger > 0 then
			hunger = hunger - math.random(4)

			if hunger < 0 then
				hunger = 0
			end
		end

		if thirst > 0 then
			thirst = thirst - 1
		end

		if hunger < 5 or thirst < 5 then
	    	local newHealth = GetEntityHealth(playerPed) - math.random(10)

			SetEntityHealth(playerPed, newHealth)
		end

		exports['crp-ui']:setCharacterData({ hunger = hunger, thirst = thirst })
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)

		playerPed = PlayerPedId()

		if stress >= 75 then
			ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
		elseif stress >= 45 then
			ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.07)
		elseif stress >= 20 then
			ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.02)
		end
	end
end)

RegisterNetEvent('crp-hud:setMeta')
AddEventHandler('crp-hud:setMeta', function(data)
	if not data then
		return
	end

	if data.hunger == nil then hunger = 100 else hunger = data.hunger end
	if data.thirst == nil then thirst = 100 else thirst = data.thirst end
	if data.stress == nil then stress = 0   else stress = data.stress end

	if data.health < 10.0 then
		SetEntityHealth(playerPed, 10.0)
	else
		SetEntityHealth(playerPed, data.health)
	end

    SetPedArmour(playerPed, data.armour)
end)

RegisterNetEvent('crp-hud:updateMeta')
AddEventHandler('crp-hud:updateMeta', function(name, state)
	if state then
		_G[name] = _G[name] + value
	else
		_G[name] = _G[name] - value
	end

	if name == 'stress' then
		if state then
			-- TODO: Ganhaste stress.
		else
			-- TODO: Perdeste stress.
		end
	end

	if _G[name] < 0 then _G[name] = 0 end
	if _G[name] > 100 then _G[name] = 100 end

	TriggerServerEvent('crp-updateMeta', _lastHealth, _lastArmour, hunger, thirst, stress)

	exports['crp-ui']:setCharacterData({ health = _lastHealth / 2, armour = _lastArmour, breath = breath, stress = stress })
end)

function updateMinimap()
	SetScriptGfxAlign(string.byte('L'), string.byte('B'))

	local topX, topY = GetScriptGfxPosition(-0.0045, 0.002 + (-0.188888))

	ResetScriptGfxAlign()

	exports['crp-ui']:updateMinimap(topX, topY)
end

function checkUpdate(health, armour, breath, stress)
	if _lastHealth == health and _lastArmour == armour and _lastBreath == breath and _lastStress == stress then
		return false
	end

	_lastHealth = health
	_lastArmour = armour
	_lastBreath = breath
	_lastStress = stress

	return true
end

function GetDirectionHeading()
    local camRot = GetGameplayCamRot(0)
	local heading = 360.0 - ((camRot.z + 360.0) % 360.0)

    if (heading < 90) then
        local rangePercent = heading / 90

        return math.floor((1 - rangePercent) * north + rangePercent * east)
    elseif (heading < 180) then
        local rangePercent = CalculateRangePercent(90, 180, heading)

        return math.floor((1 - rangePercent) * east + rangePercent * south2)
    elseif (heading < 270) then
        local rangePercent = CalculateRangePercent(180, 270, heading)

        return math.floor((1 - rangePercent) * south + rangePercent * west)
    elseif (heading <= 360) then
        local rangePercent = CalculateRangePercent(270, 360, heading)

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

RegisterCommand('hud', function(source, args)
	updateMinimap()
end)