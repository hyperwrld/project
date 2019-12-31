CRP.BlipManager = CRP.BlipManager or {}
CRP.Blips = CRP.Blips or {}

function CRP.BlipManager.CreateBlip(self, id, data)
    local blip = AddBlipForCoord(data.x, data.y, data.z)

    if data.sprite then SetBlipSprite(blip, data.sprite) end
    if data.range then SetBlipAsShortRange(blip, data.range) else SetBlipAsShortRange(blip, true) end
    if data.color then SetBlipColour(blip, data.color) end
    if data.display then SetBlipDisplay(blip, data.display) end
    if data.playername then SetBlipNameToPlayerName(blip, data.playername) end
    if data.showcone then SetBlipShowCone(blip, data.showcone) end
    if data.secondarycolor then SetBlipSecondaryColour(blip, data.secondarycolor) end
    if data.friend then SetBlipFriend(blip, data.friend) end
    if data.mission then SetBlipAsMissionCreatorBlip(blip, data.mission) end
    if data.route then SetBlipRoute(blip, data.route) end
    if data.friendly then SetBlipAsFriendly(blip, data.friendly) end
    if data.routecolor then SetBlipRouteColour(blip, data.routecolor) end
    if data.scale then SetBlipScale(blip, data.scale) else SetBlipScale(blip, 0.8) end

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(data.name)
    EndTextCommandSetBlipName(blip)

    if (id ~= nil) then 
        CRP.Blips[id] = { blip = blip, data = data }
    end
end

function CRP.BlipManager.RemoveBlip(self, id)
    local blip = CRP.Blips[id]

    if blip then RemoveBlip(blip.blip) end

    CRP.Blips[id] = nil
end

function CRP.BlipManager.HideBlip(self, id, toggle)
    local blip = CRP.Blips[id]

    if not blip then return end

    if toggle then SetBlipAlpha(blip, 0) else SetBlipAlpha(blip, 255) end
end

function CRP.BlipManager.GetBlip(self, id)
    local blip = CRP.Blips[id]

    if not blip then return false end

    return blip
end

local blips = {
    { id = nil, name = 'Loja', scale = 0.75, color = 2, sprite = 52, x = 374.016,   y = 325.752,   z = 102.600 },
    { id = nil, name = 'Loja', scale = 0.75, color = 2, sprite = 52, x = 1961.656,  y = 3740.457,  z = 31.373  },
    { id = nil, name = 'Loja', scale = 0.75, color = 2, sprite = 52, x = 1392.031,  y = 3604.588,  z = 34.050  },
    { id = nil, name = 'Loja', scale = 0.75, color = 2, sprite = 52, x = 547.482,   y = 2671.089,  z = 41.207  },
    { id = nil, name = 'Loja', scale = 0.75, color = 2, sprite = 52, x = 2557.637,  y = 382.383,   z = 107.673 },
    { id = nil, name = 'Loja', scale = 0.75, color = 2, sprite = 52, x = -1820.613, y = 792.315,   z = 137.17  },
    { id = nil, name = 'Loja', scale = 0.75, color = 2, sprite = 52, x = -1222.978, y = -906.819,  z = 11.376  },
    { id = nil, name = 'Loja', scale = 0.75, color = 2, sprite = 52, x = -707.749,  y = -914.615,  z = 18.266  },
    { id = nil, name = 'Loja', scale = 0.75, color = 2, sprite = 52, x = 26.057,    y = -1347.581, z = 28.547  },
    { id = nil, name = 'Loja', scale = 0.75, color = 2, sprite = 52, x = -48.689,   y = -1757.749, z = 28.471  },
    { id = nil, name = 'Loja', scale = 0.75, color = 2, sprite = 52, x = 1163.307,  y = -324.086,  z = 68.255  },
    { id = nil, name = 'Loja', scale = 0.75, color = 2, sprite = 52, x = 2679.075,  y = 3280.623,  z = 54.291  },
    { id = nil, name = 'Loja', scale = 0.75, color = 2, sprite = 52, x = 1698.17,   y = 4924.784,  z = 41.114  },
    { id = nil, name = 'Loja', scale = 0.75, color = 2, sprite = 52, x = 1729.135,  y = 6414.242,  z = 34.087  },
    { id = nil, name = 'Loja', scale = 0.75, color = 2, sprite = 52, x = -2968.207, y = 390.342,   z = 14.093  },
    { id = nil, name = 'Loja', scale = 0.75, color = 2, sprite = 52, x = -1487.078, y = -379.677,  z = 39.213  },

    { id = nil, name = 'Loja de armas', scale = 0.75, color = 35, sprite = 110, x = 22.269,    y = -1106.985, z = 28.847 },
    { id = nil, name = 'Loja de armas', scale = 0.75, color = 35, sprite = 110, x = -662.017,  y = -935.074,  z = 20.879 },
    { id = nil, name = 'Loja de armas', scale = 0.75, color = 35, sprite = 110, x = -1305.603, y = -394.556,  z = 35.746 },
    { id = nil, name = 'Loja de armas', scale = 0.75, color = 35, sprite = 110, x = 252.367,   y = -50.223,   z = 68.991 },
    { id = nil, name = 'Loja de armas', scale = 0.75, color = 35, sprite = 110, x = 809.956,   y = -2157.509, z = 28.669 },
    { id = nil, name = 'Loja de armas', scale = 0.75, color = 35, sprite = 110, x = 842.094,   y = -1033.815, z = 27.245 },
    { id = nil, name = 'Loja de armas', scale = 0.75, color = 35, sprite = 110, x = -1117.759, y = 2698.803,  z = 17.604 },
    { id = nil, name = 'Loja de armas', scale = 0.75, color = 35, sprite = 110, x = -3172.099, y = 1088.034,  z = 19.889 },
    { id = nil, name = 'Loja de armas', scale = 0.75, color = 35, sprite = 110, x = 1693.51,   y = 3760.129,  z = 33.755 },
    { id = nil, name = 'Loja de armas', scale = 0.75, color = 35, sprite = 110, x = -330.373,  y = 6084.121,  z = 30.505 },

    { id = nil, name = 'Banco', scale = 0.75, color = 52, sprite = 108, x = 149.825,   y = -1040.409, z = 29.374  },
    { id = nil, name = 'Banco', scale = 0.75, color = 52, sprite = 108, x = -1212.895, y = -330.483,  z = 37.787  },
    { id = nil, name = 'Banco', scale = 0.75, color = 52, sprite = 108, x = -2962.861, y = 482.823,   z = 15.703  },
    { id = nil, name = 'Banco', scale = 0.75, color = 52, sprite = 108, x = -112.285,  y = 6468.836,  z = 31.627  },
    { id = nil, name = 'Banco', scale = 0.75, color = 52, sprite = 108, x = 314.133,   y = -278.859,  z = 54.171  },
    { id = nil, name = 'Banco', scale = 0.75, color = 52, sprite = 108, x = -351.054,  y = -49.573,   z = 49.043  },
    { id = nil, name = 'Banco', scale = 0.75, color = 52, sprite = 108, x = 247.347,   y = 222.737,   z = 106.287 },
    { id = nil, name = 'Banco', scale = 0.75, color = 52, sprite = 108, x = 1175.234,  y = 2706.608,  z = 38.094  },

    { id = nil, name = 'Loja de veículos', scale = 0.75, color = 4, sprite = 225, x = -32.715, y = -1102.192, z = 25.472 },

    { id = nil, name = 'Departamento da polícia', scale = 0.75, color = 29, sprite = 60, x = 433.398, y = -981.87,   z = 30.71  },
    { id = nil, name = 'Departamento da polícia', scale = 0.75, color = 29, sprite = 60, x = -442.202, y = 6017.446, z = 31.688 },
    { id = nil, name = 'Departamento da polícia', scale = 0.75, color = 29, sprite = 60, x = 1855.819, y = 3682.377, z = 34.268 },
}

AddEventHandler('crp-base:playerSessionStarted', function()
    Citizen.CreateThread(function()
        for k, v in ipairs(blips) do
            CRP.BlipManager:CreateBlip(v.id, v)
        end
    end)
end)