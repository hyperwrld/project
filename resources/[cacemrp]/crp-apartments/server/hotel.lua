local apartments = {
	[1]  = { ['owner'] = nil, ['state'] = true },
	[2]  = { ['owner'] = nil, ['state'] = true },
	[3]  = { ['owner'] = nil, ['state'] = true }, 
	[4]  = { ['owner'] = nil, ['state'] = true }, 
	[5]  = { ['owner'] = nil, ['state'] = true },
	[6]  = { ['owner'] = nil, ['state'] = true }, 
	[7]  = { ['owner'] = nil, ['state'] = true },
	[8]  = { ['owner'] = nil, ['state'] = true },
	[9]  = { ['owner'] = nil, ['state'] = true },
	[10] = { ['owner'] = nil, ['state'] = true },
	[11] = { ['owner'] = nil, ['state'] = true },
	[12] = { ['owner'] = nil, ['state'] = true },
	[13] = { ['owner'] = nil, ['state'] = true },
	[14] = { ['owner'] = nil, ['state'] = true },
	[15] = { ['owner'] = nil, ['state'] = true },
	[16] = { ['owner'] = nil, ['state'] = true },
	[17] = { ['owner'] = nil, ['state'] = true },
	[18] = { ['owner'] = nil, ['state'] = true },
	[19] = { ['owner'] = nil, ['state'] = true },
	[20] = { ['owner'] = nil, ['state'] = true },
	[21] = { ['owner'] = nil, ['state'] = true },
	[22] = { ['owner'] = nil, ['state'] = true },
	[23] = { ['owner'] = nil, ['state'] = true },
	[24] = { ['owner'] = nil, ['state'] = true },
	[25] = { ['owner'] = nil, ['state'] = true },
	[26] = { ['owner'] = nil, ['state'] = true },
	[27] = { ['owner'] = nil, ['state'] = true },
	[28] = { ['owner'] = nil, ['state'] = true },
	[29] = { ['owner'] = nil, ['state'] = true },
	[30] = { ['owner'] = nil, ['state'] = true }, 
	[31] = { ['owner'] = nil, ['state'] = true }, 
	[32] = { ['owner'] = nil, ['state'] = true },
	[33] = { ['owner'] = nil, ['state'] = true }, 
	[34] = { ['owner'] = nil, ['state'] = true },
	[35] = { ['owner'] = nil, ['state'] = true },
	[36] = { ['owner'] = nil, ['state'] = true },
	[37] = { ['owner'] = nil, ['state'] = true },
	[38] = { ['owner'] = nil, ['state'] = true }, 	
}

RegisterNetEvent('crp-apartments:returnhouses')
AddEventHandler('crp-apartments:returnhouses', function()
	for key, value in pairs(apartments) do 
		if apartments[key]['owner'] == nil then
			apartments[key]['owner'] = source

			TriggerClientEvent('crp-apartments:showui', source, key, 1)
			print('found a apartment: (' .. key .. ')')
			return
		end
	end
end)