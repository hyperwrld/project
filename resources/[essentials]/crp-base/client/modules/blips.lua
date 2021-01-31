CRP.Blips = {}

function createBlip(blipId, coords, type, color, scale, name)
	if CRP.Blips[blipId] then
		return
	end

	local blip = AddBlipForCoord(coords)

	SetBlipSprite(blip, type)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, color)
	SetBlipScale(blip, scale)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(name)
	EndTextCommandSetBlipName(blip)

	CRP.Blips[blipId] = blip
end

exports('createBlip', createBlip)

function removeBlip(blipId)
	if CRP.Blips[blipId] then
		RemoveBlip(CRP.Blips[blipId])
	end

	CRP.Blips[blipId] = nil
end

exports('removeBlip', removeBlip)