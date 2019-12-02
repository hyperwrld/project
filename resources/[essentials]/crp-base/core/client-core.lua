function CRP.Core.Initialize(self)
    Citizen.CreateThread(function()
        while true do
            if NetworkIsSessionStarted() then
				TriggerServerEvent('crp-base:playerSessionStarted')
				TriggerEvent('crp-base:playerSessionStarted')
                break
            end
        end
    end)
end

CRP.Core.Initialize()

AddEventHandler('crp-base:playerSessionStarted', function()
	CRP.SpawnManager.Initialize()
end)