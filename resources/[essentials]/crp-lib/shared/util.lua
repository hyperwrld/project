local resourceName = GetCurrentResourceName()

function Debug(string)
	print('[' .. resourceName .. '] ' .. string)
end

function GetRandomNumber(firstNumber, secondNumber)
    math.randomseed(GetGameTimer())

    if secondNumber then
        return math.random(firstNumber, secondNumber)
    else
        return math.random(firstNumber)
    end
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