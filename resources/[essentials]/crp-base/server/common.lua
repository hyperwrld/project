jobs = {}

function GetAllJobs()
    exports.ghmattimysql:execute('SELECT * FROM jobs;', {}, function(result)
        for i = 1, #result do
            jobs[result[i].name] = { label = tostring(result[i].label), mingrade = result[i].mingrade, maxgrade = result[i].maxgrade, salary = result[i].salary }
        end
    end)
end

GetAllJobs()

RegisterServerEvent('crp-events:listenEvent')
AddEventHandler('crp-events:listenEvent', function(id, event, args)
	local _source = source

	if args == nil then
		args = _source
	end

	TriggerEvent(event, _source, args, function(data)
		TriggerClientEvent('crp-events:listenEvent', _source, id, data)
	end)
end)