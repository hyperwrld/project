RegisterServerEvent('crp-base:disconnect')
AddEventHandler('crp-base:disconnect', function()
	DropPlayer(source, 'Foste desconectado do servidor.')
end)

AddEventHandler('crp-base:loadCharacter', function(data, callback)
    callback(CRP.Player:LoadCharacter(data.source, data.characterData))
end)

exports('GetModule', function(module)
    if not CRP[module] then
        log("Couldn't find the module " .. tostring(module))
        return false
    end

	return CRP[module]
end)

exports('AddModule', function(module, table)
    if CRP[module] then
        log('Module (' .. tostring(module) .. ') is being overridden')
    else
        log('Successfully added the module ' .. tostring(module))
    end

	CRP[module] = table
end)