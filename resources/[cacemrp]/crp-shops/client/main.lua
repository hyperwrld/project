local shopLocations = {
	[1]  = { ['x'] = 374.016,   ['y'] = 325.752,   ['z'] = 102.600, ['type'] = 'normalshop'  }, [2]  = { ['x'] = 1961.656,  ['y'] = 3740.457,  ['z'] = 31.373,  ['type'] = 'normalshop'  },
	[3]  = { ['x'] = 1392.031,  ['y'] = 3604.588,  ['z'] = 34.050,  ['type'] = 'normalshop'  }, [4]  = { ['x'] = 547.482,   ['y'] = 2671.089,  ['z'] = 41.207,  ['type'] = 'normalshop'  },
	[5]  = { ['x'] = 2557.637,  ['y'] = 382.383,   ['z'] = 107.673, ['type'] = 'normalshop'  }, [6]  = { ['x'] = -1820.613, ['y'] = 792.315,   ['z'] = 137.17,  ['type'] = 'normalshop'  },
	[7]  = { ['x'] = -1222.978, ['y'] = -906.819,  ['z'] = 11.376,  ['type'] = 'normalshop'  }, [8]  = { ['x'] = -707.749,  ['y'] = -914.615,  ['z'] = 18.266,  ['type'] = 'normalshop'  },
	[9]  = { ['x'] = 26.057,    ['y'] = -1347.581, ['z'] = 28.547,  ['type'] = 'normalshop'  }, [10] = { ['x'] = -48.689,   ['y'] = -1757.749, ['z'] = 28.471,  ['type'] = 'normalshop'  },
	[11] = { ['x'] = 1163.307,  ['y'] = -324.086,  ['z'] = 68.255,  ['type'] = 'normalshop'  }, [12] = { ['x'] = 2679.075,  ['y'] = 3280.623,  ['z'] = 54.291,  ['type'] = 'normalshop'  },
	[13] = { ['x'] = 1698.17,   ['y'] = 4924.784,  ['z'] = 41.114,  ['type'] = 'normalshop'  }, [14] = { ['x'] = 1729.135,  ['y'] = 6414.242,  ['z'] = 34.087,  ['type'] = 'normalshop'  },
	[15] = { ['x'] = -2968.207, ['y'] = 390.342,   ['z'] = 14.093,  ['type'] = 'normalshop'  }, [16] = { ['x'] = -1487.078, ['y'] = -379.677,  ['z'] = 39.213,  ['type'] = 'normalshop'  },
    [17] = { ['x'] = 1166.708,  ['y'] = 2709.031,  ['z'] = 37.218,  ['type'] = 'normalshop'  }, [18] = { ['x'] = -3241.826, ['y'] = 1001.522,  ['z'] = 11.891,  ['type'] = 'normalshop'  },
    [19] = { ['x'] = -3039.185, ['y'] = 586.153,   ['z'] = 6.969,   ['type'] = 'normalshop'  }, [20] = { ['x'] = 22.269,    ['y'] = -1106.985, ['z'] = 28.847,  ['type'] = 'weaponshop'  },
	[21] = { ['x'] = -662.017,  ['y'] = -935.074,  ['z'] = 20.879,  ['type'] = 'weaponshop'  }, [22] = { ['x'] = -1305.603, ['y'] = -394.556,  ['z'] = 35.746,  ['type'] = 'weaponshop'  },
	[23] = { ['x'] = 252.367,   ['y'] = -50.223,   ['z'] = 68.991,  ['type'] = 'weaponshop'  }, [24] = { ['x'] = 809.956,   ['y'] = -2157.509, ['z'] = 28.669,  ['type'] = 'weaponshop'  },
	[25] = { ['x'] = 842.094,   ['y'] = -1033.815, ['z'] = 27.245,  ['type'] = 'weaponshop'  }, [26] = { ['x'] = -1117.759, ['y'] = 2698.803,  ['z'] = 17.604,  ['type'] = 'weaponshop'  },
	[27] = { ['x'] = -3172.099, ['y'] = 1088.034,  ['z'] = 19.889,  ['type'] = 'weaponshop'  }, [28] = { ['x'] = 1693.51,   ['y'] = 3760.129,  ['z'] = 33.755,  ['type'] = 'weaponshop'  },
    [29] = { ['x'] = -330.373,  ['y'] = 6084.121,  ['z'] = 30.505,  ['type'] = 'weaponshop'  }, [30] = { ['x'] = 75.643,    ['y'] = -1392.841, ['z'] = 28.400,  ['type'] = 'clothesmenu' },
    [31] = { ['x'] = -822.06,   ['y'] = -1073.754, ['z'] = 10.352,  ['type'] = 'clothesmenu' }, [32] = { ['x'] = 425.248,   ['y'] = -806.5,    ['z'] = 28.515,  ['type'] = 'clothesmenu' },
    [33] = { ['x'] = -1192.044, ['y'] = -767.571,  ['z'] = 16.343,  ['type'] = 'clothesmenu' }, [34] = { ['x'] = -163.381,  ['y'] = -303.624,  ['z'] = 38.757,  ['type'] = 'clothesmenu' },
    [35] = { ['x'] = 125.185,   ['y'] = -224.674,  ['z'] = 53.582,  ['type'] = 'clothesmenu' }, [36] = { ['x'] = -710.384,  ['y'] = -152.602,  ['z'] = 36.439,  ['type'] = 'clothesmenu' },
    [37] = { ['x'] = -1450.246, ['y'] = -237.025,  ['z'] = 48.834,  ['type'] = 'clothesmenu' }, [38] = { ['x'] = -3171.236, ['y'] = 1042.866,  ['z'] = 19.887,  ['type'] = 'clothesmenu' },
    [39] = { ['x'] = 1196.774,  ['y'] = 2709.862,  ['z'] = 37.247,  ['type'] = 'clothesmenu' }, [40] = { ['x'] = 614.44,    ['y'] = 2763.788,  ['z'] = 41.112,  ['type'] = 'clothesmenu' },
    [41] = { ['x'] = -1101.088, ['y'] = 2710.478,  ['z'] = 18.132,  ['type'] = 'clothesmenu' }, [42] = { ['x'] = 1693.659,  ['y'] = 4822.568,  ['z'] = 41.087,  ['type'] = 'clothesmenu' },
    [43] = { ['x'] = 4.504,     ['y'] = 6512.537,  ['z'] = 30.902,  ['type'] = 'clothesmenu' }, [44] = { ['x'] = 137.034,   ['y'] = -1707.488, ['z'] = 28.316,  ['type'] = 'barbermenu'  },
    [45] = { ['x'] = -1282.113, ['y'] = -1116.666, ['z'] = 6.014,   ['type'] = 'barbermenu'  }, [46] = { ['x'] = 1213.103,  ['y'] = -472.599,  ['z'] = 65.232,  ['type'] = 'barbermenu'  },
    [47] = { ['x'] = -32.887,   ['y'] = -153.152,  ['z'] = 56.101,  ['type'] = 'barbermenu'  }, [48] = { ['x'] = -814.428,  ['y'] = -184.034,  ['z'] = 36.593,  ['type'] = 'barbermenu'  },
    [49] = { ['x'] = 1931.077,  ['y'] = 3730.735,  ['z'] = 31.868,  ['type'] = 'barbermenu'  }, [50] = { ['x'] = -277.51,   ['y'] = 6227.918,  ['z'] = 30.72,   ['type'] = 'barbermenu'  },
    [51] = { ['x'] = 1321.568,  ['y'] = -1652.798, ['z'] = 51.299,  ['type'] = 'tattoomenu'  }, [52] = { ['x'] = -1155.435, ['y'] = -1426.154, ['z'] = 3.978,   ['type'] = 'tattoomenu'  },
    [53] = { ['x'] = 323.611,   ['y'] = 179.666,   ['z'] = 102.61,  ['type'] = 'tattoomenu'  }, [54] = { ['x'] = -3169.012, ['y'] = 1076.71,   ['z'] = 19.853,  ['type'] = 'tattoomenu'  },
    [55] = { ['x'] = 1864.106,  ['y'] = 3748.159,  ['z'] = 32.056,  ['type'] = 'tattoomenu'  }, [56] = { ['x'] = -293.637,  ['y'] = 6199.787,  ['z'] = 30.512,  ['type'] = 'tattoomenu'  },
    [57] = { ['x'] = 454.543,   ['y'] = -990.63,   ['z'] = 29.714,  ['type'] = 'clothesmenu' }, [58] = { ['x'] = 301.116,   ['y'] = -596.436,  ['z'] = 42.308,  ['type'] = 'clothesmenu' } -- Polícia & Médicos
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
        local isInMarker, letSleep = false, true

        for k, v in pairs(shopLocations) do
            local distance = GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true)

            if distance < 10.0 then
                DrawMarker(27, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 44, 130, 201, 100, false, false, 2, false, nil, nil, false)

                letSleep = false

				if distance < 1.5 then
					local currentName, shopType = 'loja de conveniência', 1

					if (v.type == 'weaponshop') then
						currentName, shopType = 'loja de armas', 2

						DisplayHelpText('Pressiona ~INPUT_CONTEXT~ para abrir a ~g~loja de armas~s~.')
					else
						DisplayHelpText('Pressiona ~INPUT_CONTEXT~ para abrir a ~g~loja~s~.')
					end

                    if IsControlJustReleased(0, 38) then
                        if (v.type == 'clothesmenu' or v.type == 'barbermenu' or v.type == 'tattoomenu') then
                            TriggerEvent('crp-skincreator:openMenu', v.type, false)
                        else
                            TriggerEvent('crp-inventory:openCustom', { type = 2, name = currentName, shopType = shopType })
                        end
					end
                end
            end
		end

		if letSleep then
			Citizen.Wait(1500)
        end
	end
end)

function DisplayHelpText(string)
    SetTextComponentFormat('STRING')
    AddTextComponentString(string)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end