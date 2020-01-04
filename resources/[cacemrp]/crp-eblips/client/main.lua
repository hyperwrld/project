Citizen.CreateThread(function()
	while true do
		if NetworkIsSessionStarted() then
			DecorRegister('EmergencyType', 3)
			DecorSetInt(GetPlayerPed(-1), 'EmergencyType', 0)
			return
		end
	end
end)

RegisterNetEvent('crp-userinfo:updateService')
AddEventHandler('crp-userinfo:updateService', function(jobName, status)
    if jobName == 'police' and status then 
        DecorSetInt(GetPlayerPed(-1), 'EmergencyType', 2)
    elseif jobName == 'medic' and status then
        DecorSetInt(GetPlayerPed(-1), 'EmergencyType', 1)
    else 
        DecorSetInt(GetPlayerPed(-1), 'EmergencyType', 0) 
    end
end)

local function setDecor()
    local type = 0
    
    TriggerEvent('crp-userinfo:isPolice', function(isPolice)
        TriggerEvent('crp-userinfo:isMedic', function(isMedic)
            type = isPolice and 2 or 0
            type = (type == 0 and isMedic) and 1 or type
		    DecorSetInt(GetPlayerPed(-1), 'EmergencyType', type)
        end)
    end)
end

function StandardBlip(playerPed, id) 
    local blip = AddBlipForEntity(playerPed)
    
	SetBlipAsShortRange(blip, true)
	SetBlipSprite(blip, 1)

	if DecorGetInt(playerPed, 'EmergencyType') == 2 then
		SetBlipColour(blip, 3)
		ShowHeadingIndicatorOnBlip(blip, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString('Polícia')
	end

	if DecorGetInt(playerPed, 'EmergencyType') == 1 then
		SetBlipColour(blip, 23)
		ShowHeadingIndicatorOnBlip(blip, true)
		BeginTextCommandSetBlipName('STRING')		
		AddTextComponentString('Paramédico')
	end
	
	EndTextCommandSetBlipName(blip)
end

Citizen.CreateThread(function()
	local function createBlip(id)
		local userPed, playerPed = GetPlayerPed(id), GetPlayerPed(-1)
		local blip = GetBlipFromEntity(userPed)
		
        if not DecorExistOn(userPed, 'EmergencyType') then 
            return 
        end

        if not DecorExistOn(playerPed, 'EmergencyType') then 
            return 
        end

		local blipExist = DoesBlipExist(blip)

        if blipExist and DecorGetInt(userPed, 'EmergencyType') <= 0 then 
            RemoveBlip(blip) 
            return 
        end

        if blipExist and DecorGetInt(playerPed, 'EmergencyType') <= 0 then 
            RemoveBlip(blip) 
            return 
        end

        if DecorGetInt(userPed, 'EmergencyType') <= 0 or DecorGetInt(playerPed, 'EmergencyType') <= 0 then 
            return 
        end

        if blipExist then 
            return 
        end
		
		StandardBlip(userPed, id)
	end

	while true do
        Citizen.Wait(2000)

        if not DecorExistOn(GetPlayerPed(-1), 'EmergencyType') then 
            setDecor() 
        end

        for _, player in ipairs(GetActivePlayers()) do
            createBlip(player)
        end
	end
end)