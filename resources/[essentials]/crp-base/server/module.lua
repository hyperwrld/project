exports('getModule', function(module)
    if not CRP[module] then
        log("Couldn't find the module " .. tostring(module))
        return false
    end

	return CRP[module]
end)

exports('addModule', function(module, table)
    if CRP[module] then
        log('Module (' .. tostring(module) .. ') is being overridden')
    else
        log('Successfully added the module ' .. tostring(module))
    end

	CRP[module] = table
end)