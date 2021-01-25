CRP.BlipsManager = {}

local blipsType = {
	[52]  = { name = 'Loja', scale = 0.75, color = 2 }, [60]  = { name = 'Departamento da polícia', scale = 0.75, color = 29 },
	[61]  = { name = 'Hospital', scale = 0.75, color = 2 }, [71]  = { name = 'Barbearia', scale = 0.75, color = 1 },
	[73]  = { name = 'Loja de roupa', scale = 0.65, color = 3 }, [75]  = { name = 'Loja de tatuagens', scale = 0.75, color = 1 },
	[108] = { name = 'Banco', scale = 0.75, color = 52 }, [110] = { name = 'Loja de armas', scale = 0.75, color = 35 },
	[225] = { name = 'Loja de veículos', scale = 0.75, color = 4 }, [361] = { name = 'Posto de combustível', scale = 0.75, color = 6 }
}

local blips = {
	{ type = 52, coords = vector3(374.016, 325.752, 102.60)    }, { type = 52, coords = vector3(1961.656, 3740.457, 31.373)   },
	{ type = 52, coords = vector3(1392.031, 3604.588, 34.050)  }, { type = 52, coords = vector3(547.482, 2671.089, 41.207)    },
	{ type = 52, coords = vector3(2557.637, 382.383, 107.67)   }, { type = 52, coords = vector3(-1820.613, 792.315, 137.17)   },
	{ type = 52, coords = vector3(-1222.978, -906.819, 11.376) }, { type = 52, coords = vector3(-707.749, -914.615, 18.266)   },
    { type = 52, coords = vector3(26.057, -1347.581, 28.547)   }, { type = 52, coords = vector3(-48.689, -1757.749, 28.471)   },
    { type = 52, coords = vector3(1163.307, -324.086, 68.255)  }, { type = 52, coords = vector3(2679.075, 3280.623, 54.291)   },
    { type = 52, coords = vector3(1698.17, 4924.784, 41.114)   }, { type = 52, coords = vector3(1729.135, 6414.242, 34.087)   },
    { type = 52, coords = vector3(-2968.207, 390.342, 14.093)  }, { type = 52, coords = vector3(-1487.078, -379.677, 39.213)  },
    { type = 52, coords = vector3(1166.708, 2709.031, 37.218)  }, { type = 52, coords = vector3(-3241.826, 1001.522, 11.891)  },
	{ type = 52, coords = vector3(-3039.185, 586.153, 6.9699)  },

	{ type = 60, coords = vector3(-442.202, 6017.446, 31.688)  }, { type = 60, coords = vector3(433.398, -981.87, 30.711)     },
	{ type = 60, coords = vector3(1855.819, 3682.377, 34.268)  }, { type = 61, coords = vector3(298.758, -584.594, 43.261)    },

    { type = 71, coords = vector3(137.034, -1707.488, 28.316)  }, { type = 71, coords = vector3(-1282.113, -1116.666, 6.0144) },
    { type = 71, coords = vector3(1213.103, -472.599, 65.232)  }, { type = 71, coords = vector3(-32.887, -153.152, 56.101)    },
    { type = 71, coords = vector3(-814.428, -184.034, 36.593)  }, { type = 71, coords = vector3(1931.077, 3730.735, 31.868)   },
	{ type = 71, coords = vector3(-277.51, 6227.918, 30.722)   },

	{ type = 73, coords = vector3(75.643, -1392.841, 28.400)   }, { type = 73, coords = vector3(-822.06, -1073.754, 10.352)   },
	{ type = 73, coords = vector3(425.248, -806.5, 28.515)     }, { type = 73, coords = vector3(-1192.044, -767.571, 16.343)  },
    { type = 73, coords = vector3(-163.381, -303.624, 38.757)  }, { type = 73, coords = vector3(125.185, -224.674, 53.582)    },
    { type = 73, coords = vector3(-710.384, -152.602, 36.439)  }, { type = 73, coords = vector3(-1450.246, -237.025, 48.834)  },
    { type = 73, coords = vector3(-3171.236, 1042.866, 19.887) }, { type = 73, coords = vector3(1196.774, 2709.862, 37.247)   },
    { type = 73, coords = vector3(614.44, 2763.788, 41.112)    }, { type = 73, coords = vector3(-1101.088, 2710.478, 18.132)  },
	{ type = 73, coords = vector3(1693.659, 4822.568, 41.087)  }, { type = 73, coords = vector3(4.504, 6512.537, 30.902)      },

	{ type = 75, coords = vector3(1321.568, -1652.798, 51.299) }, { type = 75, coords = vector3(-1155.435, -1426.154, 3.9788) },
    { type = 75, coords = vector3(323.611, 179.666, 102.61)    }, { type = 75, coords = vector3(-3169.012, 1076.71, 19.853)   },
	{ type = 75, coords = vector3(1864.106, 3748.159, 32.056)  }, { type = 75, coords = vector3(-293.637, 6199.787, 30.512)   },

    { type = 108, coords = vector3(149.825, -1040.409, 29.374) }, { type = 108, coords = vector3(-1212.895, -330.483, 37.787) },
    { type = 108, coords = vector3(-2962.861, 482.823, 15.703) }, { type = 108, coords = vector3(-112.285, 6468.836, 31.627)  },
    { type = 108, coords = vector3(314.133, -278.859, 54.171)  }, { type = 108, coords = vector3(-351.054, -49.573, 49.043)   },
	{ type = 108, coords = vector3(247.347, 222.737, 106.28)   }, { type = 108, coords = vector3(1175.234, 2706.608, 38.094)  },

	{ type = 110, coords = vector3(22.269, -1106.985, 28.847)   }, { type = 110, coords = vector3(-662.017, -935.074, 20.879)  },
    { type = 110, coords = vector3(-1305.603, -394.556, 35.746) }, { type = 110, coords = vector3(252.367, -50.223, 68.991)    },
    { type = 110, coords = vector3(809.956, -2157.509, 28.669)  }, { type = 110, coords = vector3(842.094, -1033.815, 27.245)  },
    { type = 110, coords = vector3(-1117.759, 2698.803, 17.604) }, { type = 110, coords = vector3(-3172.099, 1088.034, 19.889) },
	{ type = 110, coords = vector3(1693.51, 3760.129, 33.755)   }, { type = 110, coords = vector3(-330.373, 6084.121, 30.505)  },

	{ type = 225, coords = vector3(-32.715, -1102.192, 25.472)  }, { type = 361, coords = vector3(49.4187, 2778.793, 58.043)   },
	{ type = 361, coords = vector3(263.894, 2606.463, 44.983)   }, { type = 361, coords = vector3(1784.324, 3330.55, 41.253)   },
    { type = 361, coords = vector3(1039.958, 2671.134, 39.550)  }, { type = 361, coords = vector3(1207.260, 2660.175, 37.899)  },
    { type = 361, coords = vector3(2539.685, 2594.192, 37.944)  }, { type = 361, coords = vector3(2679.858, 3263.946, 55.240)  },
    { type = 361, coords = vector3(2005.055, 3773.887, 32.403)  }, { type = 361, coords = vector3(1687.156, 4929.392, 42.078)  },
    { type = 361, coords = vector3(1701.314, 6416.028, 32.763)  }, { type = 361, coords = vector3(179.857, 6602.839, 31.868)   },
    { type = 361, coords = vector3(-94.4619, 6419.594, 31.489)  }, { type = 361, coords = vector3(-2554.996, 2334.40, 33.078)  },
    { type = 361, coords = vector3(-1800.375, 803.661, 138.651) }, { type = 361, coords = vector3(-1437.622, -276.747, 46.207) },
    { type = 361, coords = vector3(-2096.243, -320.286, 13.168) }, { type = 361, coords = vector3(-724.619, -935.1631, 19.213) },
    { type = 361, coords = vector3(-526.019, -1211.003, 18.184) }, { type = 361, coords = vector3(-70.2148, -1761.792, 29.534) },
    { type = 361, coords = vector3(265.648, -1261.309, 29.292)  }, { type = 361, coords = vector3(819.653, -1028.846, 26.403)  },
    { type = 361, coords = vector3(1208.951, -1402.567, 35.224) }, { type = 361, coords = vector3(1181.381, -330.847, 69.316)  },
    { type = 361, coords = vector3(620.843, 269.100, 103.089)   }, { type = 361, coords = vector3(2581.321, 362.039, 108.468)  },
    { type = 361, coords = vector3(176.631, -1562.025, 29.263)  }, { type = 361, coords = vector3(-319.292, -1471.715, 30.549) }
}

function createBlip(data)
	local blip, blipData = AddBlipForCoord(data.coords), blipsType[data.type]

	SetBlipSprite(blip, data.type)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, blipData.color)
	SetBlipScale(blip, blipData.scale)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(blipData.name)
	EndTextCommandSetBlipName(blip)

	blips[#blips + 1] = data
end

exports('createBlip', createBlip)

Citizen.CreateThread(function()
	for i = 1, #blips do
		createBlip(blips[i])
	end
end)