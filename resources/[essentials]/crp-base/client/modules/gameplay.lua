CRP.Gameplay = {}

function CRP.Gameplay:InitializeNatives()
	Citizen.CreateThread(function()
		for i = 1, 15 do
            EnableDispatchService(i, false)
		end

		DisplayRadar(false)
        NetworkSetFriendlyFireOption(true)
		SetCanAttackFriendly(PlayerId(), true, true)
		SetMaxWantedLevel(0)

		while true do
			Citizen.Wait(0)

			local playerId = PlayerId()

			SetPlayerHealthRechargeMultiplier(playerId, 0.0) -- Disable Health Regenerate
            DisablePlayerVehicleRewards(playerId) -- Disable Vehicle Rewards
			SetPedSuffersCriticalHits(PlayerPedId(), false) -- Disable Headshot Damage
		end
	end)
end