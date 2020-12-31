CRP.Gameplay = {}

playerPed, playerId = PlayerPedId(), PlayerId()

function CRP.Gameplay:InitializeNatives()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(5000)

			playerPed, playerId = PlayerPedId(), PlayerId()
		end
	end)

	Citizen.CreateThread(function()
		for i = 1, 15 do
            EnableDispatchService(i, false)
		end

		DisplayRadar(false)
        NetworkSetFriendlyFireOption(true)
		SetCanAttackFriendly(playerId, true, true)
		SetMaxWantedLevel(0)
		SetFlyThroughWindscreenParams(100.0, 105.0, 17.0, 50.0)

		while true do
			Citizen.Wait(0)

			SetPlayerHealthRechargeMultiplier(playerId, 0.0) -- Disable Health Regenerate
            DisablePlayerVehicleRewards(playerId) -- Disable Vehicle Rewards
			SetPedSuffersCriticalHits(playerPed, false) -- Disable Headshot Damage
		end
	end)
end

AddEventHandler('crp-base:setPedConfigFlag', function()
	playerPed = PlayerPedId()

	SetPedConfigFlag(playerPed, 35, false)
	SetPedConfigFlag(playerPed, 184, true)
end)