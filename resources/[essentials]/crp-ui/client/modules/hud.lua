local isHudActive, isCompassOn, playerPed = false, false, PlayerPedId()
local south, west = (-100), (-100 * 2)
local north, east, south2 = (-100 * 3), (-100 * 4), (-100 * 5)

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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)

        if isCompassOn or IsVehicleEngineOn(GetVehiclePedIsUsing(playerPed)) then
            if not isCompassOn and not isHudActive then
                DisplayRadar(true)

                isHudActive = true
            end

            SendNUIMessage({ eventName = 'updateCompassInfo', vehicleData = { time = currentTime, direction = GetDirectionHeading() }})
        elseif isHudActive then
            isHudActive = false

            DisplayRadar(false)
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)

        playerPed = PlayerPedId()

        local vehicle = GetVehiclePedIsUsing(playerPed)

        if IsVehicleEngineOn(vehicle) then
            local position = GetEntityCoords(playerPed)
            local zoneName = zoneNames[GetNameOfZone(position.x, position.y, position.z)]
            local currentStreetHash, crossingRoadHash = GetStreetNameAtCoord(position.x, position.y, position.z)
            local streetName, crossingRoadName = GetStreetNameFromHashKey(currentStreetHash), GetStreetNameFromHashKey(crossingRoadHash)
            local speed = math.ceil(GetEntitySpeed(vehicle) * 3.6)

            if crossingRoadName ~= '' then
                streetName = streetName .. ' | ' .. crossingRoadName
            end

            if zoneName then
                streetName = streetName .. ' | [' .. zoneName .. ']'
            end

            SendNUIMessage({ eventName = 'updateVehicleInfo', vehicleData = { location = streetName, speed = speed, fuel = fuel }})
        end
    end
end)

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

AddEventHandler('crp-ui:setHudPosition', function(topX, topY)
    SendNUIMessage({ eventName = 'setHudPosition', topX = topX, topY = topY })
end)

AddEventHandler('crp-ui:updateData', function(data)
    SendNUIMessage({ eventName = 'updateData', status = data })
end)