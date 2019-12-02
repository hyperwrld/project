local function SetGamePlayVars()
    Citizen.CreateThread(function()
        -- Disable Dispatch Services
        
        for i = 1, 25 do
            EnableDispatchService(i, false)
        end
        
        while true do
            Citizen.Wait(0)
            local playerPed = GetPlayerPed(-1)
            local position  = GetEntityCoords(playerPed, false)
            local playerID  = PlayerId()
            local vehicle   = GetVehiclePedIsIn(playerPed, false)

            -- Remove AI Cops
            SetPlayerWantedLevel(playerID, 0, false)
            SetPlayerWantedLevelNow(playerID, false)
            ClearAreaOfCops(position, 400.0)

            -- Enable PVP
            NetworkSetFriendlyFireOption(true)
            SetCanAttackFriendly(playerID, true, true)

            -- Disable Health Regenerate 
            SetPlayerHealthRechargeMultiplier(playerID, 0.0)

            -- Disable Vehicle Rewards
            DisablePlayerVehicleRewards(playerID)

            -- Disable Radar
            DisplayRadar(false)

            if IsPedInAnyVehicle(playerPed, false) then
                if GetPedInVehicleSeat(GetVehiclePedIsIn(playerPed, false), 0) == playerPed then
                    if GetIsTaskActive(playerPed, 165) then
                    	SetPedIntoVehicle(playerPed, GetVehiclePedIsIn(playerPed, false), 0)
                    end
                end
            end

            if IsPedWearingHelmet(playerPed) and not IsPedInAnyVehicle(playerPed, true) then
                Citizen.CreateThread(function()
                    Citizen.Wait(5000)
                    if not IsPedInAnyVehicle(playerPed, true) then
                        RemovePedHelmet(playerPed, false)
                    end
                end)
            end
        end
    end)
end

local function ActivatePlayerPosition()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000)
			local position = GetEntityCoords(PlayerPedId())

			if oldposition ~= position then
				TriggerServerEvent('crp-base:updateposition', position.x, position.y, position.z)
				oldposition = position
			end
		end
	end)
end

local hasGamePlayStarted, oldposition = false

AddEventHandler('crp-base:playerSessionStarted', function()
    if hasGamePlayStarted then 
        return 
    end

    hasGamePlayStarted = true

    SetGamePlayVars()
end)