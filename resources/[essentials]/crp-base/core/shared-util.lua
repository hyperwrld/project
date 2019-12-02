CRP.Util = CRP.Util or {}

function CRP.Util.GetSteamID(self, source)
	for k, v in ipairs(GetPlayerIdentifiers(source)) do
		if string.sub(v, 1, 5) == 'steam' then
			return v
		end
	end
	return false
end

function CRP.Util.GetLicense(self, source)
    for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, 7) == 'license' then
            return v
        end
    end
    return false
end