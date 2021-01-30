CRP.Blips, CRP.BlipsType = {}, {
	[52]  = { name = 'Loja', scale = 0.75, color = 2 },             [60]  = { name = 'Departamento da polícia', scale = 0.75, color = 29 },
	[61]  = { name = 'Hospital', scale = 0.75, color = 2 },         [71]  = { name = 'Barbearia', scale = 0.75, color = 1 },
	[73]  = { name = 'Loja de roupa', scale = 0.65, color = 3 },    [75]  = { name = 'Loja de tatuagens', scale = 0.75, color = 1 },
	[108] = { name = 'Banco', scale = 0.75, color = 52 },           [110] = { name = 'Loja de armas', scale = 0.75, color = 35 },
	[225] = { name = 'Loja de veículos', scale = 0.75, color = 4 }
}

function createBlip(blipId, coords, type)
	local blip, blipData = AddBlipForCoord(coords), CRP.BlipsType[type]

	SetBlipSprite(blip, type)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, blipData.color)
	SetBlipScale(blip, blipData.scale)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(blipData.name)
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