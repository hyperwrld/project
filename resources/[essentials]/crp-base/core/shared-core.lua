CRP.Core = CRP.Core or {}

function getModule(module)
	if not CRP[module] then print('Warning: (' .. tostring(module) .. ') module doesnt exist') return false end

	return CRP[module]
end

function addModule(module, table)
	if CRP[module] then print('Warning: (' .. tostring(module) .. ') module is being overridden') end

	CRP[module] = table
end