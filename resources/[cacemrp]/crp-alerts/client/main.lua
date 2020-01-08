local vehicleColors = {
    [-1] = 'Desconhecido', [0] = 'Preto', [1] = 'Grafite', [2] = 'Aço preto', [3] = 'Aço negro', [4] = 'Prata', [5] = 'Prata-azulado', [6] = 'Aço laminado',
    [7] = 'Sombra prateada', [8] = 'Prata rocha', [9] = 'Prata da meia-noite', [10] = 'Ferro fundido prateado', [11] = 'Antracito', [12] = 'Preto', [13] = 'Cinza',
    [14] = 'Cinza-claro', [15] = 'Preto', [16] = 'Preto-carbono', [17] = 'Preto-antracito', [18] = 'Prata', [19] = 'Aço preto', [20] = 'Aço negro', [21] = 'Preto',
    [22] = 'Grafite', [23] = 'Cinza-claro', [24] = 'Prata', [25] = 'Prata-azulado', [26] = 'Sombra prateada', [27] = 'Vermelho', [28] = 'Vermelho-torino',
    [29] = 'Vermelho-corrida', [30] = 'Vermelho-chama', [31] = 'Vermelho-elegante', [32] = 'Vermelho-granada', [33] = 'Vermelho pôr do sol', [34] = 'Vermelho-cabernet',
    [35] = 'Vermelho-vinho', [36] = 'Laranja pôr do sol', [37] = 'Ouro', [38] = 'Laranja', [39] = 'Vermelho', [40] = 'Vermelho-escuro', [41] = 'Laranja', [42] = 'Amarelo',
    [43] = 'Vermelho-escuro', [44] = 'Vermelho', [45] = 'Vermelho-granada', [46] = 'Vermelho', [47] = 'Rosa-salmão', [48] = 'Vermelho-escuro', [49] = 'Verde-escuro',
    [50] = 'Verde-corrida', [51] = 'Verde-oceano', [52] = 'Verde-oliva', [53] = 'Verde-claro', [54] = 'Verde-gasolina', [55] = 'Verde-lima', [56] = 'Verde-escuro',
    [57] = 'Verde', [58] = 'Verde-escuro', [59] = 'Verde', [60] = 'Verde-oceano', [61] = 'Azul-galaxia', [62] = 'Azul-escuro', [63] = 'Azul-saxão', [64] = 'Azul',
    [65] = 'Azul-marinho', [66] = 'Azul do porto', [67] = 'Azul-diamante', [68] = 'Azul-surfe', [69] = 'Azul-náutico', [70] = 'Azul-ultra', [71] = 'Roxo Schafter',
    [72] = 'Roxo-bujarrona', [73] = 'Azul-corrida', [74] = 'Azul-claro', [75] = 'Azul-escuro', [76] = 'Azul meia noite', [77] = 'Azul-saxão', [78] = 'Azul-náutico',
    [79] = 'Azul', [80] = 'Azul-real', [81] = 'Azul-brilhante', [82] = 'Azul-escuro', [83] = 'Azul', [84] = 'Azul meia noite', [85] = 'Azul-escuro', [86] = 'Azul',
    [87] = 'Azul-claro', [88] = 'Amarelo', [89] = 'Amarelo-corrida', [90] = 'Bronze', [91] = 'Amarelo-orvalho', [92] = 'Verde-lima', [93] = 'Castanho-palha',
    [94] = 'Castanho-bordô', [95] = 'Castanho-feltzer', [96] = 'Castanho-chocolate', [97] = 'Madeira-escura', [98] = 'Castanho-sela', [99] = 'Castalho-palha',
    [100] = 'Castanho-musgo', [101] = 'Castalho-bisão', [102] = 'Madeira-clara', [103] = 'Madeira-escura', [104] = 'Castanho-siena', [105] = 'Castanho-areia',
    [106] = 'Castanho-branqueado', [107] = 'Creme', [108] = 'Castanho-bordô', [109] = 'Castanho-musgo', [110] = 'Castanho-areia', [111] = 'Branco', [112] = 'Branco-geada',
    [113] = 'Castanho-areia', [114] = 'Castalho-bisão', [115] = 'Castanho-feltzer', [116] = 'Castanho-branqueado', [117] = 'Aço-escovado', [118] = 'Aço escuro escovado',
    [119] = 'Aluminio', [120] = 'Cromado', [121] = 'Branco-gasto', [122] = 'Branco-gasto', [123] = 'Laranja', [124] = 'Laranja pôr do sol', [125] = 'Verde-claro',
    [126] = 'Amarelo-taxi', [127] = 'Azul do porto', [128] = 'Verde', [129] = 'Verde-corrida', [130] = 'Laranja', [131] = 'Branco', [132] = 'Branco-geada',
    [133] = 'Verde-oliva', [134] = 'Branco-geada', [135] = 'Rosa-choque', [136] = 'Rosa-salmão', [137] = 'Rosa', [138] = 'Laranja-claro', [139] = 'Verde-lima',
    [140] = 'Azul-ultra', [141] = 'Azul meia noite', [142] = 'Roxo-escuro', [143] = 'Vermelho-vinho', [144] = 'Prata', [145] = 'Roxo-claro', [146] = 'Azul escuro',
    [147] = 'Grafite-escuro', [148] = 'Roxo', [149] = 'Roxo-claro', [150] = 'Vermelho-lava', [151] = 'Verde-natureza', [152] = 'Oliva', [153] = 'Terra-escura',
    [154] = 'Desértico', [155] = 'Verde-folhagem', [156] = 'Default', [157] = 'Azul-claro', [158] = 'Ouro-puro', [159] = 'Ouro-escovado',
}

local zoneNames = {
    AIRP = 'Los Santos International Airport', ALAMO = 'Alamo Sea', ALTA = 'Alta', ARMYB = 'Fort Zancudo', BANHAMC = 'Banham Canyon Dr', BANNING = 'Banning',
    BAYTRE = 'Baytree Canyon', BEACH = 'Vespucci Beach', BHAMCA = 'Banham Canyon', BRADP = 'Braddock Pass', BRADT = 'Braddock Tunnel', BURTON = 'Burton',
    CALAFB = 'Calafia Bridge', CANNY = 'Raton Canyon', CCREAK = 'Cassidy Creek', CHAMH = 'Chamberlain Hills', CHIL = 'Vinewood Hills', CHU = 'Chumash',
    CMSW = 'Chiliad Mountain State Wilderness', CYPRE = 'Cypress Flats', DAVIS = 'Davis', DELBE = 'Del Perro Beach', DELPE = 'Del Perro', DELSOL = 'La Puerta',
    DESRT = 'Grand Senora Desert', DOWNT = 'Downtown', DTVINE = 'Downtown Vinewood', EAST_V = 'East Vinewood', EBURO = 'El Burro Heights', ELGORL = 'El Gordo Lighthouse',
    ELYSIAN = 'Elysian Island', GALFISH = 'Galilee', GALLI = 'Galileo Park', golf = 'GWC and Golfing Society', GRAPES = 'Grapeseed', GREATC = 'Great Chaparral',
    HARMO = 'Harmony', HAWICK = 'Hawick', HORS = 'Vinewood Racetrack', HUMLAB = 'Humane Labs and Research', JAIL = 'Bolingbroke Penitentiary', KOREAT = 'Little Seoul',
    LACT = 'Land Act Reservoir', LAGO = 'Lago Zancudo', LDAM = 'Land Act Dam', LEGSQU = 'Legion Square', LMESA = 'La Mesa', LOSPUER = 'La Puerta', MIRR = 'Mirror Park',
    MORN = 'Morningwood', MOVIE = 'Richards Majestic', MTCHIL = 'Mount Chiliad', MTGORDO = 'Mount Gordo', MTJOSE = 'Mount Josiah', MURRI = 'Murrieta Heights',
    NCHU = 'North Chumash', NOOSE = 'N.O.O.S.E', OCEANA = 'Pacific Ocean', PALCOV = 'Paleto Cove', PALETO = 'Paleto Bay', PALFOR = 'Paleto Forest',
    PALHIGH = 'Palomino Highlands', PALMPOW = 'Palmer-Taylor Power Station', PBLUFF = 'Pacific Bluffs', PBOX = 'Pillbox Hill', PROCOB = 'Procopio Beach', RANCHO = 'Rancho',
    RGLEN = 'Richman Glen', RICHM = 'Richman', ROCKF = 'Rockford Hills', RTRAK = 'Redwood Lights Track', SanAnd = 'San Andreas', SANCHIA = 'San Chianski Mountain Range',
    SANDY = 'Sandy Shores', SKID = 'Mission Row', SLAB = 'Stab City', STAD = 'Maze Bank Arena', STRAW = 'Strawberry', TATAMO = 'Tataviam Mountains', TERMINA = 'Terminal',
    TEXTI = 'Textile City', TONGVAH = 'Tongva Hills', TONGVAV = 'Tongva Valley', VCANA = 'Vespucci Canals', VESP = 'Vespucci', VINE = 'Vinewood',
    WINDF = 'Ron Alternates Wind Farm', WVINE = 'West Vinewood', ZANCUDO = 'Zancudo River', ZP_ORT = 'Port of South Los Santos', ZQ_UAR = 'Davis Quartz'
}

local alerts = {
    ['RB'] = { ['sprite'] = 487, ['text'] = '112 - Civil Roubado Recentemente' },
    ['HR'] = { ['sprite'] = 487, ['text'] = '112 - Assalto' },
    ['GS'] = { ['sprite'] = 433, ['text'] = '112 - Disparos' },
    ['FI'] = { ['sprite'] = 126, ['text'] = '112 - Briga entre civis' },
    ['DW'] = { ['sprite'] = 126, ['text'] = '112 - Briga com arma branca entre civis' },
    ['DT'] = { ['sprite'] = 403, ['text'] = '112 - Civil incapacitado' },
    ['RD'] = { ['sprite'] = 147, ['text'] = '112 - Veículo em alta velocidade' },
    ['VC'] = { ['sprite'] = 488, ['text'] = '112 - Acidente de veículo' },
}

local alertsBlips = {}

RegisterNetEvent('crp-alerts:notification')
AddEventHandler('crp-alerts:notification',function(source, type, text)
    local isPolice = exports['crp-userinfo']:isPed('isPolice')

    if isPolice then
        TriggerEvent('chat:addMessage', { color = {255, 255, 255}, templateId = 'red', args = { '[DESPACHO]', text }})

        if type ~= 'default' then
            AddAlertBlip(source, type)
        end
    end
end)

function AddAlertBlip(source, type)
    local randomNumber = GetRandomNumber(2)

    local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(GetPlayerPed(GetPlayerFromServerId(tonumber(source))), 0.0, GetRandomNumber(25) + 0.0, 0.0))

    if randomNumber == 1 then
        x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(GetPlayerPed(GetPlayerFromServerId(tonumber(source))), GetRandomNumber(25) + 0.0, 0.0, 0.0))
    end

    local blip = AddBlipForCoord(x, y, z)

    SetBlipScale(blip, 2.5)

    if type == 'BK' or type == 'PB' then
        SetBlipFlashesAlternate(blip, true)
    end

    SetBlipSprite(blip, alerts[type]['sprite'])

    SetBlipAlpha(blip, 100)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(alerts[type]['text'])
    EndTextCommandSetBlipName(blip)

    if #alertsBlips >= 20 then
        for k, v in ipairs(alertsBlips) do
            RemoveBlip(v.blip)
        end
    end

    alertsBlips[#alertsBlips + 1] = { time = GetGameTimer(), blip = blip }

    PlaySound(-1, 'Lose_1st', 'GTAO_FM_Events_Soundset', 0, 0, 1)
end

RegisterNetEvent('crp-alerts:clean')
AddEventHandler('crp-alerts:clean',function()
    for k, v in ipairs(alertsBlips) do
        RemoveBlip(v.blip)
    end
end)

RegisterNetEvent('crp-alerts:alertPolice')
AddEventHandler('crp-alerts:alertPolice',function(distance, alertType, object, isGunshot)
    if GetRandomNumber(100) < 15 then
        return
    end

    local isPolice, isNightTime = exports['crp-userinfo']:isPed('isPolice'), exports['crp-userinfo']:isPed('nighttime')

    if isNightTime then
        distance = distance * 0.35
    else
        distance = distance * 1.0
    end

    if alertType == 'PersonRobbed' and not isPolice then
        AlertPersonRobbed(object)
    end

    local nearPed, _distance = GetRandomNPC(distance, isGunshot), 0

    if nearPed then
        _distance = #(GetEntityCoords(GetPlayerPed(-1), GetEntityCoords(nearPed)))
    end

    if alertType == 'lockpick' and math.random(100) > 90 and not isPolice then
        nearPed = true
    end

    if nearPed == nil and alertType ~= 'HouseRobbery' and not isPolice then
        return
    else
        if alertType ~= 'HouseRobbery' then
            RequestAnimDict('amb@code_human_wander_texting@male@base')

            while not HasAnimDictLoaded('amb@code_human_wander_texting@male@base') do
                Citizen.Wait(0)
            end

            Citizen.Wait(1000)

            if GetEntityHealth(nearPed) < GetEntityMaxHealth(nearPed) then
                return
            end

            if not DoesEntityExist(nearPed) or IsPedFatallyInjured(nearPed) or IsPedInMeleeCombat(nearPed) then
                return
            end

            ClearPedTasks(nearPed)

            TaskPlayAnim(nearPed, 'cellphone@', 'cellphone_call_listen_base', 1.0, 1.0, -1, 49, 0, 0, 0, 0)
        end

        local coords, isUnderground = GetEntityCoords(GetPlayerPed(-1)), false

        if coords['z'] < -25 then
            isUnderground = true
        end

        Citizen.Wait(GetRandomNumber(5000))

        if not isPolice then
            if alertType == 'RecklessDriver' then
                AlertReckless()
            end

            if alertType == 'Fight' and not isUnderground then
                AlertFight()
            end

            if alertType == 'GunShot' then
                AlertGunShot()
            end

            if alertType == 'GunShotVehicle' then
                AlertGunShotVehicle()
            end

            if alertType == 'HouseRobbery' then
                AlertHouseRobbery()
            end
        else
            if alertType == 'VehicleCrash' then
                VehicleCrash()
            end

            if alertType == 'Death' and not isUnderground then
                AlertDeath()
            end
        end
    end
end)

function AlertReckless()
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)

    if not DoesEntityExist(vehicle) then
        return
    end

    local vehiclePlate, vehicleModel = GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
    local streetName, isMale, playerSex = GetStreetAndZone(), IsPedMale(GetPlayerPed(-1)), 'Homem'
    local primaryColor, secondaryColor = GetVehicleColours(vehicle)

    if GetRandomNumber(100) > 15 then
        vehiclePlate = 'Desconhecido'
    end

    local direction = GetDirectionHeading()

    TriggerServerEvent('crp-alerts:notification', 'RD', 'Veículo em alta velocidade (' .. playerSex .. ') em ' .. streetName .. ', direção: ' .. direction .. ' - Modelo:  ' .. vehicleModel .. ' | Matrícula: ' .. vehiclePlate .. ' | Cores: ' .. vehicleColors[primaryColor] .. ' / ' .. vehicleColors[secondaryColor] .. '.')
end

function VehicleCrash()
    local streetName, isMale, playerSex = GetStreetAndZone(), IsPedMale(GetPlayerPed(-1)), 'Homem'

    if not isMale then
        playerSex = 'Mulher'
    end

    TriggerServerEvent('crp-alerts:notification', 'VC', '10-47 (Acidente de veículo - ' .. playerSex .. ') em ' .. streetName .. '.')

    ReportCurrentVehicle()
end

function AlertDeath()
    local streetName, isMale, playerSex = GetStreetAndZone(), IsPedMale(GetPlayerPed(-1)), 'Homem'

    if not isMale then
        playerSex = 'Mulher'
    end

    TriggerServerEvent('crp-alerts:notification', 'DT', '10-47 (Cidadão incapacitado - ' .. playerSex .. ') em ' .. streetName .. '.')
end

function AlertFight()
    local streetName, isMale, playerSex, isArmed = GetStreetAndZone(), IsPedMale(GetPlayerPed(-1)), 'Homem', IsPedArmed(GetPlayerPed(-1), 7)

    if not isMale then
        playerSex = 'Mulher'
    end

    if isArmed then
        TriggerServerEvent('crp-alerts:notification', 'DW', '10-11 (Cidadão(s) envolvidas numa briga utilizando uma arma branca - ' .. playerSex .. ') em ' .. streetName .. '.')
    else
        TriggerServerEvent('crp-alerts:notification', 'FI', '10-10 (Cidadão(s) envolvidas numa briga - ' .. playerSex .. ') em ' .. streetName .. '.')
    end

    ReportCurrentVehicle()
end

function AlertGunShot()
    local streetName, isMale, playerSex = GetStreetAndZone(), IsPedMale(GetPlayerPed(-1)), 'Homem'

    if not isMale then
        playerSex = 'Mulher'
    end

    TriggerServerEvent('crp-alerts:notification', 'GS', '10-71 (Disparos efetuados por um/a ' .. playerSex .. ') em ' .. streetName .. '.')

    ReportCurrentVehicle()
end

function AlertGunShotVehicle()
    local streetName, isMale, playerSex = GetStreetAndZone(), IsPedMale(GetPlayerPed(-1)), 'Homem'

    if not isMale then
        playerSex = 'Mulher'
    end

    TriggerServerEvent('crp-alerts:notification', 'GS', '10-71 (Disparos efetuados num veículo por um/a ' .. playerSex .. ') em ' .. streetName .. '.')

    ReportCurrentVehicle()
end

function AlertHouseRobbery()
    local streetName, isMale, playerSex = GetStreetAndZone(), IsPedMale(GetPlayerPed(-1)), 'Homem'

    if not isMale then
        playerSex = 'Mulher'
    end

    TriggerServerEvent('crp-alerts:notification', 'HR', '10-31A (Assalto efetuado por um/a ' .. playerSex .. ') em ' .. streetName .. '.')

    ReportCurrentVehicle()
end

function AlertPersonRobbed(vehicle)
    if DoesEntityExist(vehicle) then
        local vehiclePlate, vehicleModel = GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
        local primaryColor, secondaryColor = GetVehicleColours(vehicle)

        TriggerServerEvent('crp-alerts:notification', 'default', 'Veículo roubado na zona do crime - Modelo:  ' .. vehicleModel .. ' | Matrícula: ' .. vehiclePlate .. ' | Cores: ' .. vehicleColors[primaryColor] .. ' / ' .. vehicleColors[secondaryColor] .. '.')
    end

    local streetName, isMale, playerSex = GetStreetAndZone(), IsPedMale(GetPlayerPed(-1)), 'Homem'

    if not isMale then
        playerSex = 'Mulher'
    end

    TriggerServerEvent('crp-alerts:notification', 'RB', '10-31B (Roubo efetuado por um/a ' .. playerSex .. ') em ' .. streetName .. '.')

    ReportCurrentVehicle()
end

function ReportCurrentVehicle()
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)

    if not DoesEntityExist(vehicle) then
        return
    end

    local vehiclePlate, vehicleModel = GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
    local primaryColor, secondaryColor = GetVehicleColours(vehicle)

    if GetRandomNumber(100) > 15 then
        vehiclePlate = 'Desconhecido'
    end

    local direction = GetDirectionHeading()

    TriggerServerEvent('crp-alerts:notification', 'default', 'Veículo a sair da zona de crime - Modelo:  ' .. vehicleModel .. ' | Matrícula: ' .. vehiclePlate .. ' | Cores: ' .. vehicleColors[primaryColor] .. ' / ' .. vehicleColors[secondaryColor] .. ' em direção a ' .. direction  .. '.')
end

function GetRandomNPC(distance, isGunshot)
    local distance, playerPed = distance, GetPlayerPed(-1)
    local coords, foundPed, success, distancePed = GetEntityCoords(playerPed), nil
    local handle, ped = FindFirstPed()

    repeat
        local _coords = GetEntityCoords(ped)
        local _distance = #(coords - _coords)

        if CanPedBeUsed(ped, isGunshot) and _distance < distance and _distance > 2.0 and (distancePed == nil or _distance < distancePed) then
            distancePed, foundPed = _distance, ped
        end

        success, ped = FindNextPed(handle)
    until not success

    EndFindPed(handle)

    return foundPed
end

function CanPedBeUsed(ped, isGunshot)
    if GetRandomNumber(100) > 15 then
        return false
    end

    local playerPed = GetPlayerPed(-1)

    if ped == nil or ped == playerPed then
        return false
    end

    if GetEntityHealth(ped) < GetEntityMaxHealth(ped) or GetHashKey('mp_f_deadhooker') == GetEntityModel(ped) then
        return false
    end

    local coords, _coords = GetEntityCoords(playerPed), GetEntityCoords(ped)

    if #(coords - _coords) < 10.0 then
        return false
    end

    if not HasEntityClearLosToEntity(playerPed, ped, 17) and not isGunshot then
        return false
    end

    if not DoesEntityExist(ped) or IsPedAPlayer(ped) or IsPedFatallyInjured(ped) then
        return false
    end

    if IsPedArmed(ped, 7) or IsPedInMeleeCombat(ped) or IsPedShooting(ped) then
        return false
    end

    if IsPedDucking(ped) or IsPedBeingJacked(ped) or IsPedSwimming(ped) then
        return false
    end

    if IsPedJumpingOutOfVehicle(ped) then
        return false
    end

    local pedType = GetPedType(ped)

    if pedType == 6 or pedType == 27 or pedType == 29 or pedType == 28 then
        return false
    end

    return true
end

function GetDirectionHeading()
    local heading = GetEntityHeading(GetPlayerPed(-1))

    if heading >= 315 or heading < 45 then
        return 'Sentido Norte'
    elseif heading >= 45 and heading < 135 then
        return 'Sentido Oeste'
    elseif heading >=135 and heading < 225 then
        return 'Sentido Sul'
    elseif heading >= 225 and heading < 315 then
        return 'Sentido Este'
    end
end

function GetStreetAndZone()
    local coords = GetEntityCoords(GetPlayerPed(-1),  true)
    local streetName, crossingRoad = GetStreetNameAtCoord(coords.x, coords.y, coords.z)

    local firstStreet = GetStreetNameFromHashKey(streetName)
    local zone = GetNameOfZone(coords.x, coords.y, coords.z)
    local zoneName = zoneNames[tostring(zone)]

    return firstStreet .. ', ' .. zoneName
end

function GetRandomNumber(firstNumber, secondNumber)
    math.randomseed(GetGameTimer())

    if secondNumber then
        return math.random(firstNumber, secondNumber)
    else
        return math.random(firstNumber)
    end
end