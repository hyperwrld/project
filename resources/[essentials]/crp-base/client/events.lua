CRP.Events = CRP.Events or {}
CRP.Events.Total  = 0
CRP.Events.Active = {}

function CRP.Events.Trigger(self, event, args, callback)
	local id = CRP.Events.Total + 1

	CRP.Events.Total = id

	id = event .. ':' .. id

	if CRP.Events.Active[id] then return end

	CRP.Events.Active[id] = { cb = callback }

	TriggerServerEvent('crp-events:listenEvent', id, event, args)
end

RegisterNetEvent('crp-events:listenEvent')
AddEventHandler('crp-events:listenEvent', function(id, data)
	local event = CRP.Events.Active[id]

	if event then
		event.cb(data)

		CRP.Events.Active[id] = nil
	end
end)