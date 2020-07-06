RegisterServerEvent('crp-base:disconnect')
AddEventHandler('crp-base:disconnect', function()
	DropPlayer(source, 'Foste desconectado do servidor.')
end)

RegisterServerEvent('crp-base:clientError')
AddEventHandler('crp-base:clientError', function(resourceName, ...)
    CRP.Util:Print('Error in resource: ' .. resourceName .. ' (' .. CRP.Util:GetPlayerIdentifier(source) .. ')', 'error')
    print(...)
    CRP.Util:Print('End of the error', 'error')
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

CRP.RPC:register('FetchCharacters', function(source)
    return CRP.DB:FetchCharacters(CRP.Util:GetPlayerIdentifier(source))
end)

CRP.RPC:register('CreateCharacter', function(source, data)
    return CRP.DB:CreateCharacter(CRP.Util:GetPlayerIdentifier(source), data)
end)

CRP.RPC:register('DeleteCharacter', function(source, data)
    return CRP.DB:DeleteCharacter(CRP.Util:GetPlayerIdentifier(source), data)
end)

CRP.RPC:register('SelectCharacter', function(source, data)
    return CRP.DB:RetrieveCharacter(CRP.Util:GetPlayerIdentifier(source), { source = source, characterId = data })
end)