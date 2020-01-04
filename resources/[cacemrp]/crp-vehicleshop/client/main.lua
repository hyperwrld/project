local vehiclesShop = {
    ['main'] = {
        { name = 'Bicicletas', id = 'bikes' },
        { name = 'Veículos de trabalho', id = 'jobs' }
    },
    ['bikes'] = {
        { name = 'elegy', price = 200, model = 'elegy' },
        { name = 'Cruiser', price = 200, model = 'cruiser' },
        { name = 'Fixter', price = 200, model = 'fixter' },
        { name = 'Scorcher', price = 200, model = 'scorcher' },
        { name = 'Whippet Race Bike', price = 200, model = 'tribike' },
        { name = 'Endurex Race Bike', price = 200, model = 'tribike2' },
        { name = 'Tri-Cycles Race Bike', price = 200, model = 'tribike3' },
    },
    ['jobs'] = {
        { name = 'BMX', price = 200, model = 'bmx' },
    }
}

local vehicleSpawnLocation = {
	[1] =  { ['x'] = -38.25, ['y'] = -1104.18, ['z'] = 26.43, ['h'] = 14.46  },
	[2] =  { ['x'] = -36.36, ['y'] = -1097.3,  ['z'] = 26.43, ['h'] = 109.4  },
	[3] =  { ['x'] = -43.11, ['y'] = -1095.02, ['z'] = 26.43, ['h'] = 67.77  },
	[4] =  { ['x'] = -50.45, ['y'] = -1092.66, ['z'] = 26.43, ['h'] = 116.33 },
	[5] =  { ['x'] = -56.24, ['y'] = -1094.33, ['z'] = 26.43, ['h'] = 157.08 },
	[6] =  { ['x'] = -49.73, ['y'] = -1098.63, ['z'] = 26.43, ['h'] = 240.99 },
	[7] =  { ['x'] = -45.58, ['y'] = -1101.4,  ['z'] = 26.43, ['h'] = 287.3  },
}

local vehicleTable = { 
    [1] = { ['model'] = 'flatbed', ['price'] = 200 }, [2] = { ['model'] = 'cruiser',  ['price'] = 600 }, 
    [3] = { ['model'] = 'fixter',   ['price'] = 300 }, [4] = { ['model'] = 'scorcher', ['price'] = 700 },
    [5] = { ['model'] = 'tribike',  ['price'] = 400 }, [6] = { ['model'] = 'tribike2', ['price'] = 800 },
    [7] = { ['model'] = 'tribike3', ['price'] = 500 },
}

local vehiclesSpawned, hasSpawned, isMenuOpen, currentVehicleLocation = false, false, false, nil
local fakeVehicle, spawnedVehicles = { model = '', entity = nil }, {}

RegisterNetEvent('crp-vehicleshop:updateVehicleTable')
AddEventHandler('crp-vehicleshop:updateVehicleTable', function(_vehicleTable, status)
    vehicleTable = _vehicleTable

    if status then DespawnVehicles() SpawnVehicles() end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed = GetPlayerPed(-1)
        local coords, letSleep = GetEntityCoords(playerPed), true
        local distance = GetDistanceBetweenCoords(-32.715, -1102.192, 25.472, coords)

        if distance < 100 then
            if not vehiclesSpawned then
                SpawnVehicles()
            end

            if distance < 25 and not isMenuOpen then
                letSleep = false

                for i = 1, #vehicleSpawnLocation do
                    local spawnDistance = GetDistanceBetweenCoords(vehicleSpawnLocation[i]['x'], vehicleSpawnLocation[i]['y'], vehicleSpawnLocation[i]['z'], coords)

                    if spawnDistance < 2.5 then
                        DrawText3D(vehicleSpawnLocation[i]['x'], vehicleSpawnLocation[i]['y'], vehicleSpawnLocation[i]['z'], '[E] para mudar | [G] para comprar o veículo por: ' .. vehicleTable[i]['price'] .. '€')
                    
                        if IsControlJustReleased(0, 47) then
                            exports['crp-notifications']:SendPersistantAlert('start', 'vehicleshop', 'inform', 'A tentar comprar o veículo.' )

                            Citizen.Wait(1500)
                            
                            AttemptBuyVehicle(i)
                        end
                        
                        if IsControlJustReleased(0, 38) then
                            currentVehicleLocation = i

                            OpenMenu()
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

function OpenMenu()
    local playerPed = GetPlayerPed(-1)

    FreezeEntityPosition(playerPed, true)

    SetEntityVisible(playerPed, false)

    local z = Citizen.InvokeNative(0xC906A7DAB05C8D2B, -60.939, -1108.265, 25.746, Citizen.PointerValueFloat(), 0)

    SetEntityCoords(playerPed, -60.939, -1108.265, z)
    SetEntityHeading(playerPed, 68.048)

    WarMenu.OpenMenu('vehicleshop')
end

Citizen.CreateThread(function()
    local function DrawShop()
        for k, v in ipairs(vehiclesShop['main']) do
            if WarMenu.MenuButton(v.name, v.id) then end
        end
    end

    local function DrawBikes()
        for k, v in ipairs(vehiclesShop['bikes']) do
            if WarMenu.Button(v.name, '~g~'.. v.price .. '€') then
                if fakeVehicle.model ~= v.model then
                    CheckVehicle(v.model)
                else
                    UpdateVehicleTable(v.model, v.price, v.name)

                    WarMenu.CloseMenu()
                end
            end
        end
    end

    local function DrawJobs()
        for k, v in ipairs(vehiclesShop['jobs']) do
            if WarMenu.Button(v.name, '~g~'.. v.price .. '€') then  end
        end
    end

    Menus = { 
        ['vehicleshop'] = DrawShop,
        ['bikes'] = DrawBikes,
        ['jobs'] = DrawJobs
    }

    local function CreateMenu()
        WarMenu.CreateMenu('vehicleshop', 'Veículos')
        WarMenu.SetSubTitle('vehicleshop', 'Categorias de veiculos')

        WarMenu.SetMenuX('vehicleshop', 0.05)
        WarMenu.SetMenuY('vehicleshop', 0.30)

        WarMenu.SetMenuMaxOptionCountOnScreen('vehicleshop', 15)
        WarMenu.SetTitleColor('vehicleshop', 255, 255, 255, 255)
        WarMenu.SetTitleBackgroundColor('vehicleshop', 46, 119, 171, 100)
        WarMenu.SetMenuSubTextColor('vehicleshop', 255, 255, 255, 255)

        WarMenu.CreateSubMenu('bikes', 'vehicleshop', 'Bicicletas')
        WarMenu.CreateSubMenu('jobs', 'vehicleshop', 'Veículos de trabalho')
    end

    CreateMenu()

    while true do
        Citizen.Wait(0)

        local found = false

        for k, v in pairs(Menus) do
            if WarMenu.IsMenuOpened(k) then
                WarMenu.Display()

                found = true

                v()
            end
        end

        if isMenuOpen then
            local playerPed = GetPlayerPed(-1)

            if not found then
                isMenuOpen = false 

                if DoesEntityExist(fakeVehicle.entity) then
                    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakeVehicle.entity))
                end

                fakeVehicle = { model = nil, entity = nil }

                FreezeEntityPosition(playerPed, false)

                SetEntityCoords(playerPed, -32.715, -1102.192, 25.472)

                SetEntityVisible(playerPed, true)
            end

            if DoesEntityExist(fakeVehicle.entity) then
                x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(playerPed, 5.0, -2.5, 10.0))

                DrawScaleformMovie_3d(scaleform, x, y, z, 20.0, 180.0, 45.0, 1.0, 1.0, 1.0, 10.0, 10.0, 10.0, 0)

                TaskWarpPedIntoVehicle(playerPed, fakeVehicle.entity, -1)
            end
        elseif found and not isMenuOpen then
            isMenuOpen = true
        else
            Citizen.Wait(1000)
        end
    end
end)

function CheckVehicle(model)
    if DoesEntityExist(fakeVehicle.entity) then
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakeVehicle.entity))
    end
    
    local position, vehicleHash, playerPed = { -60.939, -1108.265, 25.746, 68.048 }, GetHashKey(model), GetPlayerPed(-1)

    RequestModel(vehicleHash)

    while not HasModelLoaded(vehicleHash) do
        Citizen.Wait(0)
    end

    local vehicle = CreateVehicle(vehicleHash, position[1], position[2], position[3], position[4], false, false)

    SetModelAsNoLongerNeeded(vehicleHash)
    
    local timer = 9000
    
    while not DoesEntityExist(vehicle) and timer > 0 do
        Citizen.Wait(1)

        timer = timer - 1
    end

    FreezeEntityPosition(vehicle, true)
    SetEntityInvincible(vehicle, true)
    
    SetVehicleDoorsLocked(vehicle, 4)
    --SetEntityCollision(veh,false,false)
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    
    for i = 0, 24 do
        SetVehicleModKit(vehicle, 0)
        RemoveVehicleMod(vehicle, i)
    end
    
    fakeVehicle = { model = model, entity = vehicle }

    if fakeVehicle.model == 'rumpo' then
        SetVehicleLivery(vehicle, 2)
    end
    
    for i = 1, 5 do
        scaleform = ResetScaleForm('mp_car_stats_01', i)

        x, y, z = table.unpack(GetEntityCoords(playerPed, true))
        
        DrawScaleformMovie_3d(scaleform, x - 1, y + 1.8, z + 7.0, 0.0, 180.0, 90.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0)
    end
    
    scaleform = StartScaleForm('mp_car_stats_01', fakeVehicle.entity, fakeVehicle.model)
end

function SpawnVehicles()
    if not hasSpawned then
        TriggerServerEvent('crp-vehicleshop:requestVehicles')

        Citizen.Wait(1500)
    end
 
    DespawnVehicles()

    hasSpawned = true

    for i = 1, #vehicleTable do
        local vehicleModel = GetHashKey(vehicleTable[i]['model'])

        RequestModel(vehicleModel)

        while not HasModelLoaded(vehicleModel) do
            Citizen.Wait(0)
        end

        local vehicle = CreateVehicle(vehicleModel, vehicleSpawnLocation[i]['x'], vehicleSpawnLocation[i]['y'], vehicleSpawnLocation[i]['z'], false, false)

        SetModelAsNoLongerNeeded(vehicleModel)
        SetVehicleOnGroundProperly(vehicle)
		SetEntityInvincible(vehicle, true)
        FreezeEntityPosition(vehicle, true)
        
        SetVehicleNumberPlateText(vehicle, 'CARRO' .. i)

        spawnedVehicles[#spawnedVehicles + 1] = vehicle
    end

    vehiclesSpawned = true
end

function DespawnVehicles()
    for i = 1, #spawnedVehicles do
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(spawnedVehicles[i]))
    end

    vehiclesSpawned = false
end

function UpdateVehicleTable(model, price, name)
    vehicleTable[currentVehicleLocation]['model'] = model
    vehicleTable[currentVehicleLocation]['name'] = name
    vehicleTable[currentVehicleLocation]['price'] = price

    TriggerServerEvent('crp-vehicleshop:updateVehicleTable', vehicleTable)
end

function ResetScaleForm(scaleform, i)
    scaleform = RequestScaleformMovie(scaleform)

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    PushScaleformMovieFunction(scaleform, 'SET_VEHICLE_INFOR_AND_STATS')
    PushScaleformMovieFunctionParameterString('LOADING')
    PushScaleformMovieFunctionParameterString('Brand New Vehicle')
    PushScaleformMovieFunctionParameterString('MPCarHUD')
    PushScaleformMovieFunctionParameterString('Annis')
    PushScaleformMovieFunctionParameterString('Top Speed')
    PushScaleformMovieFunctionParameterString('Handling')
    PushScaleformMovieFunctionParameterString('Braking')
    PushScaleformMovieFunctionParameterString('Downforce')

	PushScaleformMovieFunctionParameterInt((20 * i) - 1)
	PushScaleformMovieFunctionParameterInt((20 * i) - 1)
	PushScaleformMovieFunctionParameterInt((20 * i) - 1)
    PushScaleformMovieFunctionParameterInt((20 * i) - 1)

	PopScaleformMovieFunctionVoid()
end

function StartScaleForm(scaleform, vehicle, vehicleName)
    scaleform = RequestScaleformMovie(scaleform)

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    PushScaleformMovieFunction(scaleform, 'SET_VEHICLE_INFOR_AND_STATS')
    PushScaleformMovieFunctionParameterString(GetLabelText(GetDisplayNameFromVehicleModel(vehicleName)))
    PushScaleformMovieFunctionParameterString('Veículo novo')
    PushScaleformMovieFunctionParameterString('MPCarHUD')
    PushScaleformMovieFunctionParameterString('Annis')
    PushScaleformMovieFunctionParameterString('Top Speed')
    PushScaleformMovieFunctionParameterString('Handling')
    PushScaleformMovieFunctionParameterString('Braking')
    PushScaleformMovieFunctionParameterString('Downforce')

	local topspeed = math.ceil(GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fInitialDriveMaxFlatVel') / 4)
    local handling = math.ceil(GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSteeringLock') * 2)
    local braking = math.ceil(GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fBrakeForce') * 100)
    local acceleration = math.ceil(GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fInitialDriveForce') * 100) 

    if topspeed > 100 then topspeed = 100 end
    if handling > 100 then handling = 100 end
    if braking > 100 then braking = 100 end
    if acceleration > 100 then acceleration = 100 end

    PushScaleformMovieFunctionParameterInt(topspeed)
    PushScaleformMovieFunctionParameterInt(handling)
    PushScaleformMovieFunctionParameterInt(braking)
    PushScaleformMovieFunctionParameterInt(acceleration)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function AttemptBuyVehicle(i)
    local vehicle = GetClosestVehicle(vehicleSpawnLocation[i]['x'], vehicleSpawnLocation[i]['y'], vehicleSpawnLocation[i]['z'], 3.000, 0, 70)
    
	if not DoesEntityExist(vehicle) then
        exports['crp-notifications']:SendPersistantAlert('end', 'vehicleshop')
        exports['crp-notifications']:SendAlert('error', 'Não foi encontrado o veículo.')
		return
    end

    local vehiclePlate, vehicleProperties = GeneratePlate(), GetVehicleProperties(vehicle)

    vehicleProperties.plate = vehiclePlate

    local events = exports['crp-base']:getModule('Events')

    events:Trigger('crp-vehicleshop:attemptBuyVehicle', vehicleProperties, function(data)
        if data.status then
            local vehicleModel = data.vehicle.model

            RequestModel(vehicleModel)

			while not HasModelLoaded(vehicleModel) do
				Citizen.Wait(0)
            end

            local vehicle = CreateVehicle(vehicleModel, -31.267, -1090.539, 26.049, 327.737, true, false)

            SetModelAsNoLongerNeeded(vehicleModel)

            SetVehicleOnGroundProperly(vehicle)
            SetVehicleHasBeenOwnedByPlayer(vehicle, true)
            SetVehicleProperties(vehicle, data.vehicle)

            local vehicleId = NetworkGetNetworkIdFromEntity(vehicle)

            SetNetworkIdCanMigrate(vehicleId, true)

            TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)

            exports['crp-notifications']:SendAlert('success', 'Veículo comprado.', 3500)
        else
            exports['crp-notifications']:SendAlert('error', 'Oops! ocorreu um erro ao tentar comprar o veículo.', 3500)
        end

        exports['crp-notifications']:SendPersistantAlert('end', 'vehicleshop')
	end)
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)

    DrawText(_x, _y)

    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

function DisplayHelpText(string)
    SetTextComponentFormat('STRING')
    AddTextComponentString(string)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end