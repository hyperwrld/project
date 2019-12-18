RegisterNetEvent("CoordSaver:GetCoords")
AddEventHandler("CoordSaver:GetCoords", function(Comment)
	local X, Y, Z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	TriggerServerEvent("CoordSaver:SaveCoords", GetPlayerName(PlayerId()), round(X, 3), round(Y, 3), round(Z, 3), round(GetEntityHeading(PlayerPedId()), 3), Comment)			
end)

function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

RegisterCommand('tp', function(source, args)
	local x = tonumber(args[1])
	local y = tonumber(args[2])
    local z = tonumber(args[3])
    
    if x and y and z then
        x = x + 0.0
	    y = y + 0.0
	    z = z + 0.0

        RequestCollisionAtCoord(x, y, z)

        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
            RequestCollisionAtCoord(x, y, z)
            Citizen.Wait(1)
        end

        SetEntityCoords(PlayerPedId(), x, y, z)
    end
end, false)