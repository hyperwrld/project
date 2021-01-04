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

local _lastHealth, _lastArmour, _lastBreath, playerPed, playerId = 0, 0, 0, PlayerPedId(), PlayerId()
local isLoggedIn, isDevModeOn, isVehicleEngineOn, isWatchOn = false, false, false, false

AddEventHandler('crp-base:characterSpawned', function()
	exports['crp-ui']:setHudHideState(false)

	startThreads()
end)

function startThreads()
	if isLoggedIn then
		return
	end

	isLoggedIn = true

	playerPed, playerId = PlayerPedId(), PlayerId()

	Citizen.CreateThread(function()
		while isLoggedIn do
			Citizen.Wait(5000)

			playerPed, playerId = PlayerPedId(), PlayerId()
		end
	end)

	Citizen.CreateThread(function()
		updateMinimap()

		while isLoggedIn do
			Citizen.Wait(100)

			local health, armour, breath = GetEntityHealth(playerPed), GetPedArmour(playerPed), GetPlayerUnderwaterTimeRemaining(playerId)

			if checkUpdate(health, armour, breath) then
				exports['crp-ui']:setData({ health = health / 2, armour = armour, breath = breath })
			end
		end
	end)
end

AddEventHandler('crp-vehicles:startedEngine', function(state, vehicle)
	isVehicleEngineOn = state

	if state then
		Citizen.CreateThread(function()
			while isVehicleEngineOn do
				Citizen.Wait(1000)

				local position, speed = GetEntityCoords(playerPed), RoundNumber(GetEntitySpeed(vehicle) * 3.6)
				local zoneName = zoneNames[GetNameOfZone(position.x, position.y, position.z)]
				local currentStreetHash, crossingRoadHash = GetStreetNameAtCoord(position.x, position.y, position.z)
				local streetName, crossingRoadName = GetStreetNameFromHashKey(currentStreetHash), GetStreetNameFromHashKey(crossingRoadHash)

				if #crossingRoadName > 0 then
					streetName = streetName .. ' [' .. crossingRoadName .. ']'
				end

				exports['crp-ui']:setData({ zoneName = zoneName, streetName = streetName, speed = speed })
			end
		end)

		Citizen.CreateThread(function()
			while isWatchOn or isVehicleEngineOn do
				Citizen.Wait(60)

				exports['crp-ui']:setData({ direction = getDirectionHeading() })
			end
		end)

		Citizen.CreateThread(function()
			while isWatchOn or isVehicleEngineOn do
				Citizen.Wait(2000)

				exports['crp-ui']:setData({ time = getCurrentTime() })
			end
		end)
	end

	exports['crp-ui']:setData({ isOnVehicle = state })
end)

function updateMinimap()
	SetScriptGfxAlign(string.byte('L'), string.byte('B'))

	local topX, topY = GetScriptGfxPosition(-0.0045, 0.002 + (-0.188888))

	ResetScriptGfxAlign()

	exports['crp-ui']:updateMinimap(topX, topY)
end

function checkUpdate(health, armour, breath)
	if _lastHealth == health and _lastArmour == armour and _lastBreath == breath then
		return false
	end

	_lastHealth, _lastArmour, _lastBreath = health, armour, breath

	return true
end

local function calculateRangePercent(min, max, amt)
	return (((amt - min) * 100) / (max - min)) / 100
end

function getDirectionHeading()
    local camRot = GetGameplayCamRot(0)
	local heading = 360.0 - ((camRot.z + 360.0) % 360.0)

    if (heading < 90) then
        local rangePercent = heading / 90

        return math.floor((1 - rangePercent) * (-100 * 3) + rangePercent * (-100 * 4))
    elseif (heading < 180) then
        local rangePercent = calculateRangePercent(90, 180, heading)

        return math.floor((1 - rangePercent) * (-100 * 4) + rangePercent * (-100 * 5))
    elseif (heading < 270) then
        local rangePercent = calculateRangePercent(180, 270, heading)

        return math.floor((1 - rangePercent) * (-100) + rangePercent * (-100 * 2))
    elseif (heading <= 360) then
        local rangePercent = calculateRangePercent(270, 360, heading)

        return math.floor((1 - rangePercent) * (-100 * 2) + rangePercent * (-100 * 3))
    end
end

function getCurrentTime()
	local hours, minutes = GetClockHours(), GetClockMinutes()

    if hours >= 0 and hours < 10 then
        hours = '0' .. hours
    end

    if minutes >= 0 and minutes < 10 then
        minutes = '0' .. minutes
	end

    return hours .. ':' .. minutes
end