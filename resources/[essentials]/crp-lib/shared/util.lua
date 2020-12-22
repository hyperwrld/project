local resourceName, debugActivated = GetCurrentResourceName(), true

function Debug(string)
	if debugActivated then
		print('^4[' .. resourceName .. ']^0 ' .. string)
	end
end

function GetRandomNumber(firstNumber, secondNumber)
	math.randomseed(GetGameTimer())

	if secondNumber then
		return math.random(firstNumber, secondNumber)
	else
        return math.random(firstNumber)
    end
end

function RoundNumber(number, decimalPlaces)
	local multiplier = 10 ^ (decimalPlaces or 0)

	return math.floor(number * multiplier + 0.5) / multiplier
end

AddEventHandler('onResourceStart', function(resource)
	if (GetCurrentResourceName() ~= resource) then
	  	return
	end

	local numMetaData = GetNumResourceMetadata(resourceName, 'dependencie')

	for i = 0, numMetaData - 1 do
		local dependencyName = GetResourceMetadata(resourceName, 'dependencie', i)
		local dependencyState = GetResourceState(dependencyName)

		if (dependencyState == 'stopped' or dependencyState == 'stopping') then
			StartResource(dependencyName)
		end
	end
end)