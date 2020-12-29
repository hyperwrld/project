CRP.Util = {}

function CRP.Util:GetPlayerIdentifier(source)
    local identifier

    for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.match(v, 'discord:') then
            identifier = string.sub(v, 9)
            break
        end
    end

    return identifier
end

function CRP.Util:GeneratePhoneNumber()
	local phoneNumber

	while true do
		phoneNumber = '96' .. GetRandomNumber(1111111, 9999999)

		local query = [[SELECT 1 FROM characters WHERE phone = ?;]]
		local result = Citizen.Await(DB:Execute(query, phoneNumber))

		if not result[1] then
			return phoneNumber
		end
	end
end