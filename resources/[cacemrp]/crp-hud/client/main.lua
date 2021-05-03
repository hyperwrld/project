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

_lastHealth, _lastArmour, _lastBreath, playerPed, playerId = 0, 0, 0, PlayerPedId(), PlayerId()
isLoggedIn, isDevModeOn, isVehicleEngineOn, isWatchOn = false, false, false, false

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

AddEventHandler('crp-hud:usedWatch', function(data)
	isWatchOn = not isWatchOn

	if isWatchOn and not isVehicleEngineOn then
		startVehicleThreads()
	end

	exports['crp-ui']:setData({ isWatchOn = isWatchOn })

	TriggerEvent('crp-inventory:usedItem')
end)

AddEventHandler('crp-vehicles:toggledEngine', function(state, vehicle)
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

		if not isWatchOn then
			startVehicleThreads()
		end
	end

	exports['crp-ui']:setData({ isOnVehicle = state })
end)

AddEventHandler('crp-vehicles:leftVehicle', function()
	if isVehicleEngineOn then
		isVehicleEngineOn = false
	end
end)

AddEventHandler('crp-hud:receiveArmor', function(data)
	local playerPed = PlayerPedId()

	TaskPlayAnimation(playerPed, 'clothingtie', 'try_tie_negative_a', -1, -1, -1, 49, 0.0)

	local success = exports['crp-ui']:setTaskbar('Colocar colete', 5, true, true)

	if success then
		SetPedArmour(playerPed, 100)
	end

	StopAnimTask(playerPed, 'clothingtie', 'try_tie_negative_a', 1.0)

	TriggerEvent('crp-inventory:usedItem', success, data.item)
end)

function startVehicleThreads()
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