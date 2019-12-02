local hasShutdownHappend = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if not hasShutdownHappend and NetworkIsSessionStarted() then
			ShutdownLoadingScreenNui()

			hasShutdownHappend = true
			return
		end
	end
end)