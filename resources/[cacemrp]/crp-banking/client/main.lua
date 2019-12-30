local atms = { [1] = -1126237515, [2] = 506770882, [3] = -870868698, [4] = 150237004, [5] = -239124254, [6] = -1364697528 }

local banks = {
    { x = 149.825,   y = -1040.409, z = 29.374,  closed = false },
    { x = -1212.895, y = -330.483,  z = 37.787,  closed = false },
    { x = -2962.861, y = 482.823,   z = 15.703,  closed = false }, 
    { x = -112.285,  y = 6468.836,  z = 31.627,  closed = false },
    { x = 314.133,   y = -278.859,  z = 54.171,  closed = false },
    { x = -351.054,  y = -49.573,   z = 49.043,  closed = false },
    { x = 247.347,   y = 222.737,   z = 106.287, closed = false },
    { x = 1175.234,  y = 2706.608,  z = 38.094,  closed = false }
}

local isBankOpen, isAtmOpen, isMenuOpen, isUsingBank = false, false, false, false

local function OpenMenu(type)
    if (type) then isBankOpen = true else isAtmOpen = true end

    TriggerBankAnimation(type)

    isMenuOpen = true
    
    SendNUIMessage({ event = 'open', type = type })

    TriggerServerEvent('crp-banking:updateInfo')

	SetNuiFocus(true, true)

	Citizen.CreateThread(function()
		while isMenuOpen do
			Citizen.Wait(0)

			HideHudAndRadarThisFrame()
			DisableAllControlActions(0)
		end
	end)
end

local function CloseMenu()
    isMenuOpen, isBankOpen, isAtmOpen = false, false, false
    
    TriggerBankAnimation(isBankOpen)

	EnableAllControlActions(0)
	SetNuiFocus(false, false)
end

RegisterNetEvent('crp-banking:checkTarget')
AddEventHandler('crp-banking:checkTarget', function(target, money)
    local _target = GetPlayerFromServerId(target)

    if not IsPlayerPlaying(_target) then
        exports['crp-notifications']:SendAlert('error', 'O jogador que inseriu não foi encontrado.')
        return
    end

    local playerPed, targetPed = GetPlayerPed(-1), GetPlayerPed(_target)
    local coords, targetCoords = GetEntityCoords(playerPed, 0), GetEntityCoords(targetPed, 0)
    local distance = Vdist2(coords, targetCoords)

    if distance <= 5 then
        local events = exports['crp-base']:getModule('Events')

        events:Trigger('crp-banking:giveMoney', { target = target, money = money }, function(finished)
            if finished then
                LoadAnimation('friends@laf@ig_5')

                TaskPlayAnim(playerPed,'friends@laf@ig_5', 'nephew', 5.0, 1.0, 5.0, 48, 0.0, 0, 0, 0)

                exports['crp-notifications']:SendAlert('success', 'Acabaste de dar ' .. money .. '€.')
            end
		end)
    else
        exports['crp-notifications']:SendAlert('error', 'O jogador não está por perto.')
    end
end)

RegisterNetEvent('crp-banking:checkATM')
AddEventHandler('crp-banking:checkATM', function()
    local found, playerPed = false, GetPlayerPed(-1)

    for i = 1, #atms do
        local objectFound = GetClosestObjectOfType(GetEntityCoords(playerPed), 0.75, atms[i], 0, 0, 0)

        if DoesEntityExist(objectFound) then
            TaskTurnPedToFaceEntity(playerPed, objectFound, 3.0)

            found = true
            break
        end
    end

    if found then
        OpenMenu(false)
    else
        exports['crp-notifications']:SendAlert('error', 'Não foi encontrado nenhum ATM.')
    end
end)

RegisterNetEvent('crp-banking:updateInfo')
AddEventHandler('crp-banking:updateInfo', function(balance, name)
    SendNUIMessage({ event = 'updateInfo', balance = balance, name = string.lower(name) })
end)

local function nuiCallBack(data, cb)
	local events = exports['crp-base']:getModule('Events')

	if data.close then CloseMenu() end

	if data.deposit then
        events:Trigger('crp-banking:deposit', tonumber(data.amount), function(data)
            TriggerServerEvent('crp-banking:updateInfo')

            exports['crp-notifications']:SendAlert(data.status, data.text)
		end)
    end

	if data.withdraw then
        events:Trigger('crp-banking:withdraw', tonumber(data.amount), function(data)
            TriggerServerEvent('crp-banking:updateInfo')

            exports['crp-notifications']:SendAlert(data.status, data.text)
		end)
	end

	if data.transfer then
        events:Trigger('crp-banking:transfer', data.target, tonumber(data.amount), function(data)
            TriggerServerEvent('crp-banking:updateInfo')

            exports['crp-notifications']:SendAlert(data.status, data.text)
		end)
	end
end

RegisterNUICallback('nuiMessage', nuiCallBack)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if isMenuOpen then
            Citizen.Wait(1500)

            goto continue
        end

        local coords, letSleep = GetEntityCoords(PlayerPedId()), true

        for i = 1, #banks do
            local distance = GetDistanceBetweenCoords(coords, banks[i].x, banks[i].y, banks[i].z, true)

            if distance < 5.0 then
                letSleep = false

                if (banks[i].closed) then
                    DrawText3D(banks[i].x, banks[i].y, banks[i].z, 'Este banco está fechado.')
                else 
                    DrawText3D(banks[i].x, banks[i].y, banks[i].z, '[E] para usar o banco.')   
                end
                
                if IsControlJustReleased(0, 38) then
                    OpenMenu(true)
				end
            end
        end

        if letSleep then
			Citizen.Wait(1500)
        end
        
        ::continue::
    end
end)

function TriggerBankAnimation(type)
    local playerPed = GetPlayerPed(-1)

    if (DoesEntityExist(playerPed) and not IsEntityDead(playerPed)) then 
        if (not type) then
            if (isUsingBank) then
                LoadAnimation('amb@prop_human_atm@male@exit')

                ClearPedTasks(playerPed)

                TaskPlayAnim(playerPed, 'amb@prop_human_atm@male@exit', 'exit', 1.0, 1.0, -1, 49, 0, 0, 0, 0)

                exports['crp-progressbar']:StartProgressBar({ duration = 3000, label = 'Retirar o cartão', combat = true, move = true }, function(finished)
                    ClearPedTasks(playerPed)
                end)
            else
                LoadAnimation('amb@prop_human_atm@male@idle_a')

                TaskPlayAnim(playerPed, 'amb@prop_human_atm@male@idle_a', 'idle_b', 1.0, 1.0, -1, 49, 0, 0, 0, 0)
            end
        else
            LoadAnimation('mp_common')

            if (isUsingBank) then
                ClearPedTasks(playerPed)

                TaskPlayAnim(playerPed, 'mp_common', 'givetake1_a', 1.0, 1.0, -1, 49, 0, 0, 0, 0)

                exports['crp-progressbar']:StartProgressBar({ duration = 1500, label = 'Retirar o cartão', combat = true, move = true }, function(finished)
                    ClearPedTasks(playerPed)
                end)
            else
                TaskPlayAnim(playerPed, 'mp_common', 'givetake1_a', 1.0, 1.0, -1, 49, 0, 0, 0, 0)

                Citizen.Wait(1000)

                ClearPedTasks(playerPed)
            end
        end

        isUsingBank = not isUsingBank
    end
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)

    DrawText(_x, _y)

    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

function LoadAnimation(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)

        Citizen.Wait(5)
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() and isMenuOpen then
        CloseMenu()
    end
end)