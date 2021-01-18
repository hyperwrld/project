local weatherTransitions = {
	['EXTRASUNNY'] = { 'CLEAR', 'SMOG' },
	['SMOG']       = { 'CLEAR', 'CLEARING', 'OVERCAST', 'CLOUDS', 'EXTRASUNNY' },
	['CLEAR']      = { 'CLOUDS', 'EXTRASUNNY', 'CLEARING', 'SMOG', 'OVERCAST' },
	['CLOUDS']     = { 'CLEAR', 'SMOG', 'CLEARING', 'OVERCAST' },
	['OVERCAST']   = { 'CLEAR', 'CLOUDS', 'SMOG', 'CLEARING', 'THUNDER' },
	['THUNDER']    = { 'OVERCAST' },
	['CLEARING']   = { 'CLEAR', 'CLOUDS', 'OVERCAST', 'SMOG' },
	['SNOW']       = { 'SNOW', 'SNOWLIGHT' },
    ['SNOWLIGHT']  = { 'SNOW', 'SNOWLIGHT' },
	['BLIZZARD']   = { 'BLIZZARD' },
	['XMAS']       = { 'XMAS' },
    ['HALLOWEEN']  = { 'HALLOWEEN' }
}

local currentWeather, baseTime, timeOffset, weatherTimer = 'CLEAR', 8, 0, 30

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

        baseTime = os.time(os.date('!*t')) / 2 + 360
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

        if newWeatherTimer == 0 then
			newWeatherTimer = 30

			selectNextWeather()
        end
    end
end)

RPC:register('requestSync', function(source)
	return {
		weather = currentWeather,
		baseTime = baseTime,
		timeOffset = timeOffset
	}
end)

function selectNextWeather()
	local currentOptions = weatherTransitions[currentWeather]

	currentWeather = currentOptions[GetRandomNumber(1, #currentOptions)]

	for k, v in ipairs(currentOptions) do
		if v == 'THUNDER' or v == 'CLEARING' then
			currentWeather = currentOptions[GetRandomNumber(1, #currentOptions)]
		end
	end

	Debug('Changed weather to: ' .. currentWeather:lower())

	TriggerClientEvent('crp-weather:updateWeather', -1, currentWeather)
end