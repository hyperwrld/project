local avaiableWeatherTypes = { 'EXTRASUNNY', 'CLEAR', 'NEUTRAL', 'SMOG', 'FOGGY', 'OVERCAST', 'CLOUDS', 'CLEARING', 'RAIN', 'THUNDER', 'SNOW', 'BLIZZARD' }

local currentWeather = 'EXTRASUNNY'
local baseTime, timeOffset, weatherTimer = 0, 0, 20

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local newBaseTime = os.time(os.date('!*t')) / 2 + 360

        baseTime = newBaseTime
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)

        TriggerClientEvent('crp-weather:updateTime', -1, baseTime, timeOffset)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)

        TriggerClientEvent('crp-weather:updateWeather', -1, currentWeather)
    end
end)

Citizen.CreateThread(function()
    while true do
        weatherTimer = weatherTimer - 1

        Citizen.Wait(60000)

        if weatherTimer == 0 then
            ChooseNextWeatherStage()

            weatherTimer = 20
        end
    end
end)

function ChooseNextWeatherStage()
    if currentWeather == 'CLEAR' or currentWeather == 'CLOUDS' or currentWeather == 'EXTRASUNNY'  then
        local number = math.random(1, 2)

        if number == 1 then
            currentWeather = 'CLEARING'
        else
            currentWeather = 'OVERCAST'
        end
    elseif currentWeather == 'CLEARING' or currentWeather == 'OVERCAST' then
        local number = math.random(1, 6)

        if number == 1 then
            if currentWeather == 'CLEARING' then
                currentWeather = 'FOGGY'
            else
                local random = math.random(1, 10)

                if random <= 8 then
                    currentWeather = 'CLEARING'
                else
                    currentWeather = 'RAIN'
                end
            end
        elseif number == 2 then
            currentWeather = 'CLOUDS'
        elseif number == 3 then
            currentWeather = 'CLEAR'
        elseif number == 4 then
            currentWeather = 'EXTRASUNNY'
        elseif number == 5 then
            currentWeather = 'SMOG'
        else
            currentWeather = 'FOGGY'
        end
    elseif currentWeather == 'THUNDER' or currentWeather == 'RAIN' then
        currentWeather = 'CLEARING'
    elseif currentWeather == 'SMOG' or currentWeather == 'FOGGY' then
        currentWeather = 'CLEAR'
    end

    TriggerEvent('crp-weather:requestSync')
end

RegisterServerEvent('crp-weather:requestSync')
AddEventHandler('crp-weather:requestSync', function()
    TriggerClientEvent('crp-weather:updateWeather', -1, currentWeather)
    TriggerClientEvent('crp-weather:updateTime', -1, baseTime, timeOffset)
end)