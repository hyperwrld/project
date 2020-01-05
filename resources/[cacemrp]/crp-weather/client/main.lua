local currentWeather = 'EXTRASUNNY'
local lastWeather, isDayTime, isPrimeTime, isAllowedToSpawn, weatherDesync = currentWeather, false, false, true, false
local baseTime, timeOffset, timer, densityMultiplier, hour, minute = 0, 0, 0, 0.4, 0, 0

Citizen.CreateThread(function()
    while true do
        if lastWeather ~= currentWeather then
            lastWeather = currentWeather

            SetWeatherTypeOverTime(currentWeather, 15.0)

            Citizen.Wait(15000)
        end

        Citizen.Wait(100)

        ClearOverrideWeather()
        ClearWeatherTypePersist()

        SetWeatherTypePersist(lastWeather)
        SetWeatherTypeNow(lastWeather)
        SetWeatherTypeNowPersist(lastWeather)

        if lastWeather == 'XMAS' then
            SetForceVehicleTrails(true)
            SetForcePedFootstepsTracks(true)
        else
            SetForceVehicleTrails(false)
            SetForcePedFootstepsTracks(false)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local newBaseTime = baseTime

        if GetGameTimer() - 500 > timer then
            newBaseTime = newBaseTime + 0.25

            timer = GetGameTimer()
        end

        baseTime = newBaseTime

        hour = math.floor(((baseTime + timeOffset) / 60) % 24)
        minute = math.floor((baseTime + timeOffset) % 60)

        NetworkOverrideClockTime(hour, minute, 0)
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(60000)

        if (hour > 19 or hour < 7) and not isNightTime then
            isNightTime = true
            
            TriggerEvent('crp-weather:setCurrentTime', isNightTime)
        elseif (hour <= 19 or hour >= 7) and isNightTime then
            isNightTime = false

            TriggerEvent('crp-weather:setCurrentTime', isNightTime)
        end

        -- Make it so it, there's more systems that function like this.

        if (hour > 16 or hour < 20) and not isPrimeTime then
            isPrimeTime = true

            TriggerEvent('crp-userinfo:setPrimeTime', isPrimeTime)
        elseif (hour <= 16 or hour >= 20) and isPrimeTime then
            isPrimeTime = false
            
            TriggerEvent('crp-userinfo:setPrimeTime', isPrimeTime)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local playerPed = GetPlayerPed(-1)
        local coords, inVehicle = GetEntityCoords(playerPed), IsPedInAnyVehicle(playerPed, true)

        if inVehicle then
            local vehicle, isDriving = GetVehiclePedIsIn(playerPed, false), false
            local vehicleDriver = GetPedInVehicleSeat(vehicle, -1)

            if playerPed == vehicleDriver then isDriving = true end

            if not isDriving and isAllowedToSpawn then
                isAllowedToSpawn = false
            elseif isDriving and not isAllowedToSpawn then
                isAllowedToSpawn = true
            end
        else
            if not isAllowedToSpawn then isAllowedToSpawn = true end
        end

        if coords['z'] < -25 then isAllowedToSpawn = false end

        if isAllowedToSpawn then
            if isPrimeTime then
                densityMultiplier = 0.4
            else
                densityMultiplier = 0.2
            end
		else densityMultiplier = 0.0 end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        SetPedDensityMultiplierThisFrame(densityMultiplier)

        SetParkedVehicleDensityMultiplierThisFrame(1.0)
        SetVehicleDensityMultiplierThisFrame(densityMultiplier)
        SetRandomVehicleDensityMultiplierThisFrame(densityMultiplier)
    end
end)

RegisterNetEvent('crp-weather:updateWeather')
AddEventHandler('crp-weather:updateWeather', function(newWeather)
    if not weatherDesync then currentWeather = newWeather end
end)

RegisterNetEvent('crp-weather:updateTime')
AddEventHandler('crp-weather:updateTime', function(base, offset)
    baseTime, timeOffset = base, offset
end)

RegisterNetEvent('crp-weather:setDensityStatus')
AddEventHandler('crp-weather:setDensityStatus', function(boolean)
	isAllowedToSpawn = boolean
end)

RegisterNetEvent('crp-weather:desyncWeather')
AddEventHandler('crp-weather:desyncWeather', function(boolean)
    desyncWeather = boolean
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('crp-weather:requestSync')
end)