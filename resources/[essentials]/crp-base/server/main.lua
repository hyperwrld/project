RegisterServerEvent('crp-base:disconnect')
AddEventHandler('crp-base:disconnect', function()
	DropPlayer(source, 'Foste desconectado do servidor.')
end)

RegisterServerEvent('crp-base:logClientError')
AddEventHandler('crp-base:logClientError', function(resourceName, ...)
    CRP.Util:Print('Error in resource: ' .. resourceName .. ' (' .. CRP.Util:GetPlayerIdentifier(source) .. ')', 'error')
    print(...)
    CRP.Util:Print('End of the error', 'error')
end)

AddEventHandler('crp-base:loadCharacter', function(data, callback)
    callback(CRP.Player:LoadCharacter(data.source, data.characterData))
end)

exports('GetModule', function(module)
    if not CRP[module] then
        CRP.Util:Print("Couldn't find the module " .. tostring(module))
        return false
    end

	return CRP[module]
end)

exports('AddModule', function(module, table)
    if CRP[module] then
        CRP.Util:Print('Module (' .. tostring(module) .. ') is being overridden')
    else
        CRP.Util:Print('Successfully added the module ' .. tostring(module))
    end

	CRP[module] = table
end)