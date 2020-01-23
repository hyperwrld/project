items, jobs = {
    -- ! (Weapons)

    ['1737195953']  = { weight = 10, nonStack = true, weapon = true, meta = { serial = true, ammo = 1 } },
    ['911657153']   = { weight = 10, nonStack = true, weapon = true, meta = { serial = true, ammo = 1 } },
    ['453432689']   = { weight = 10, nonStack = true, weapon = true, meta = { serial = true, ammo = 1 } },
    ['-1076751822'] = { weight = 10, nonStack = true, weapon = true, meta = { serial = true, ammo = 1 } },
    ['137902532']   = { weight = 10, nonStack = true, weapon = true, meta = { serial = true, ammo = 1 } },
    ['-771403250']  = { weight = 10, nonStack = true, weapon = true, meta = { serial = true, ammo = 1 } },
    ['1593441988']  = { weight = 10, nonStack = true, weapon = true, meta = { serial = true, ammo = 1 } },
    ['-619010992']  = { weight = 10, nonStack = true, weapon = true, meta = { serial = true, ammo = 1 } },
    ['-1121678507'] = { weight = 10, nonStack = true, weapon = true, meta = { serial = true, ammo = 1 } },
    ['324215364']   = { weight = 10, nonStack = true, weapon = true, meta = { serial = true, ammo = 1 } },
    ['736523883']   = { weight = 10, nonStack = true, weapon = true, meta = { serial = true, ammo = 1 } },
    ['1649403952']  = { weight = 10, nonStack = true, weapon = true, meta = { serial = true, ammo = 1 } },
    ['-1074790547'] = { weight = 10, nonStack = true, weapon = true, meta = { serial = true, ammo = 1 } },
    ['-2084633992'] = { weight = 10, nonStack = true, weapon = true, meta = { serial = true, ammo = 1 } },

    -- ! (Normal Items)

    ['156805094'] = { weight = 10, nonStack = false, weapon = false },
    ['130895348'] = { weight = 10, nonStack = false, weapon = false },
    ['196068078'] = { weight = 10, nonStack = false, weapon = false },
    ['129942349'] = { weight = 10, nonStack = false, weapon = false },
}, {}

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