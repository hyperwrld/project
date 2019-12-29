local charset, numbercharset = {}, {}

for i = 48, 57 do 
    table.insert(numbercharset, string.char(i)) 
end

for i = 65, 90 do 
    table.insert(charset, string.char(i)) 
end

for i = 97, 122 do 
    table.insert(charset, string.char(i)) 
end

function GeneratePlate()
	local doBreak, generatedPlate = false

	while true do
        Citizen.Wait(2)
        
        math.randomseed(GetGameTimer())
        
        generatedPlate = string.upper(GetRandomLetter(4) .. GetRandomNumber(4))
        
        local events = exports['crp-base']:getModule('Events')

        events:Trigger('crp-vehicleshop:isPlateTaken', generatedPlate, function(isPlateTaken)
            if not isPlateTaken then
				doBreak = true
			end
        end)

		if doBreak then
			break
		end
	end

	return generatedPlate
end

function GetRandomNumber(length)
    Citizen.Wait(1)
    
    math.randomseed(GetGameTimer())
    
	if length > 0 then
		return GetRandomNumber(length - 1) .. numbercharset[math.random(1, #numbercharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
    Citizen.Wait(1)
    
    math.randomseed(GetGameTimer())
    
	if length > 0 then
		return GetRandomLetter(length - 1) .. charset[math.random(1, #charset)]
	else
		return ''
	end
end

function GetVehicleProperties(vehicle)
    local primary, secondary = GetVehicleColours(vehicle)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)

    local extras = {}
    
    for i = 0, 12 do
		if DoesExtraExist(vehicle, i) then
            local state = IsVehicleExtraTurnedOn(vehicle, i) == 1
            
			extras[tostring(i)] = state
		end
	end

    return {
        model             = GetEntityModel(vehicle),

        plate             = GetVehicleNumberPlateText(vehicle),
		plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),
        
		primary           = primary,
		secondary         = secondary,

		pearlescentColor  = pearlescentColor,
		wheelColor        = wheelColor,

		wheels            = GetVehicleWheelType(vehicle),
		windowTint        = GetVehicleWindowTint(vehicle),

		neonEnabled       = {
			IsVehicleNeonLightEnabled(vehicle, 0),
			IsVehicleNeonLightEnabled(vehicle, 1),
			IsVehicleNeonLightEnabled(vehicle, 2),
			IsVehicleNeonLightEnabled(vehicle, 3)
		},

		extras            = extras,

		neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
		tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

		modSpoilers       = GetVehicleMod(vehicle, 0),
		modFrontBumper    = GetVehicleMod(vehicle, 1),
		modRearBumper     = GetVehicleMod(vehicle, 2),
		modSideSkirt      = GetVehicleMod(vehicle, 3),
		modExhaust        = GetVehicleMod(vehicle, 4),
		modFrame          = GetVehicleMod(vehicle, 5),
		modGrille         = GetVehicleMod(vehicle, 6),
		modHood           = GetVehicleMod(vehicle, 7),
		modFender         = GetVehicleMod(vehicle, 8),
		modRightFender    = GetVehicleMod(vehicle, 9),
		modRoof           = GetVehicleMod(vehicle, 10),

		modEngine         = GetVehicleMod(vehicle, 11),
		modBrakes         = GetVehicleMod(vehicle, 12),
		modTransmission   = GetVehicleMod(vehicle, 13),
		modHorns          = GetVehicleMod(vehicle, 14),
		modSuspension     = GetVehicleMod(vehicle, 15),
		modArmor          = GetVehicleMod(vehicle, 16),

		modTurbo          = IsToggleModOn(vehicle, 18),
		modSmokeEnabled   = IsToggleModOn(vehicle, 20),
		modXenon          = IsToggleModOn(vehicle, 22),

		modFrontWheels    = GetVehicleMod(vehicle, 23),
        modBackWheels     = GetVehicleMod(vehicle, 24),
        
		modPlateHolder    = GetVehicleMod(vehicle, 25),
		modVanityPlate    = GetVehicleMod(vehicle, 26),
		modTrimA          = GetVehicleMod(vehicle, 27),
		modOrnaments      = GetVehicleMod(vehicle, 28),
		modDashboard      = GetVehicleMod(vehicle, 29),
		modDial           = GetVehicleMod(vehicle, 30),
		modDoorSpeaker    = GetVehicleMod(vehicle, 31),
		modSeats          = GetVehicleMod(vehicle, 32),
		modSteeringWheel  = GetVehicleMod(vehicle, 33),
		modShifterLeavers = GetVehicleMod(vehicle, 34),
		modAPlate         = GetVehicleMod(vehicle, 35),
		modSpeakers       = GetVehicleMod(vehicle, 36),
		modTrunk          = GetVehicleMod(vehicle, 37),
		modHydrolic       = GetVehicleMod(vehicle, 38),
		modEngineBlock    = GetVehicleMod(vehicle, 39),
		modAirFilter      = GetVehicleMod(vehicle, 40),
		modStruts         = GetVehicleMod(vehicle, 41),
		modArchCover      = GetVehicleMod(vehicle, 42),
		modAerials        = GetVehicleMod(vehicle, 43),
		modTrimB          = GetVehicleMod(vehicle, 44),
		modTank           = GetVehicleMod(vehicle, 45),
        modWindows        = GetVehicleMod(vehicle, 46),
        
		modLivery         = GetVehicleLivery(vehicle)
	}
end

function SetVehicleProperties(vehicle, vehicleProperties)
	SetVehicleModKit(vehicle, 0)

	if vehicleProperties.plate then
		SetVehicleNumberPlateText(vehicle, vehicleProperties.plate)
	end

	if vehicleProperties.plateIndex then
		SetVehicleNumberPlateTextIndex(vehicle, vehicleProperties.plateIndex)
	end

	if vehicleProperties.primary then
		local primary, secondary = GetVehicleColours(vehicle)
		SetVehicleColours(vehicle, vehicleProperties.primary, secondary)
	end

	if vehicleProperties.secondary then
		local primary, secondary = GetVehicleColours(vehicle)
		SetVehicleColours(vehicle, primary, vehicleProperties.secondary)
	end

	if vehicleProperties.pearlescentColor then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleExtraColours(vehicle, vehicleProperties.pearlescentColor, wheelColor)
	end

	if vehicleProperties.wheelColor then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleExtraColours(vehicle, pearlescentColor, vehicleProperties.wheelColor)
	end

	if vehicleProperties.wheels then
		SetVehicleWheelType(vehicle, vehicleProperties.wheels)
	end

	if vehicleProperties.windowTint then
		SetVehicleWindowTint(vehicle, vehicleProperties.windowTint)
	end

	if vehicleProperties.neonEnabled then
		SetVehicleNeonLightEnabled(vehicle, 0, vehicleProperties.neonEnabled[1])
		SetVehicleNeonLightEnabled(vehicle, 1, vehicleProperties.neonEnabled[2])
		SetVehicleNeonLightEnabled(vehicle, 2, vehicleProperties.neonEnabled[3])
		SetVehicleNeonLightEnabled(vehicle, 3, vehicleProperties.neonEnabled[4])
	end

	if vehicleProperties.extras then
		for id,enabled in pairs(vehicleProperties.extras) do
			if enabled then
				SetVehicleExtra(vehicle, tonumber(id), 0)
			else
				SetVehicleExtra(vehicle, tonumber(id), 1)
			end
		end
	end

	if vehicleProperties.neonColor then
		SetVehicleNeonLightsColour(vehicle, vehicleProperties.neonColor[1], vehicleProperties.neonColor[2], vehicleProperties.neonColor[3])
	end

	if vehicleProperties.modSmokeEnabled then
		ToggleVehicleMod(vehicle, 20, true)
	end

	if vehicleProperties.tyreSmokeColor then
		SetVehicleTyreSmokeColor(vehicle, vehicleProperties.tyreSmokeColor[1], vehicleProperties.tyreSmokeColor[2], vehicleProperties.tyreSmokeColor[3])
	end

	if vehicleProperties.modSpoilers then
		SetVehicleMod(vehicle, 0, vehicleProperties.modSpoilers, false)
	end

	if vehicleProperties.modFrontBumper then
		SetVehicleMod(vehicle, 1, vehicleProperties.modFrontBumper, false)
	end

	if vehicleProperties.modRearBumper then
		SetVehicleMod(vehicle, 2, vehicleProperties.modRearBumper, false)
	end

	if vehicleProperties.modSideSkirt then
		SetVehicleMod(vehicle, 3, vehicleProperties.modSideSkirt, false)
	end

	if vehicleProperties.modExhaust then
		SetVehicleMod(vehicle, 4, vehicleProperties.modExhaust, false)
	end

	if vehicleProperties.modFrame then
		SetVehicleMod(vehicle, 5, vehicleProperties.modFrame, false)
	end

	if vehicleProperties.modGrille then
		SetVehicleMod(vehicle, 6, vehicleProperties.modGrille, false)
	end

	if vehicleProperties.modHood then
		SetVehicleMod(vehicle, 7, vehicleProperties.modHood, false)
	end

	if vehicleProperties.modFender then
		SetVehicleMod(vehicle, 8, vehicleProperties.modFender, false)
	end

	if vehicleProperties.modRightFender then
		SetVehicleMod(vehicle, 9, vehicleProperties.modRightFender, false)
	end

	if vehicleProperties.modRoof then
		SetVehicleMod(vehicle, 10, vehicleProperties.modRoof, false)
	end

	if vehicleProperties.modEngine then
		SetVehicleMod(vehicle, 11, vehicleProperties.modEngine, false)
	end

	if vehicleProperties.modBrakes then
		SetVehicleMod(vehicle, 12, vehicleProperties.modBrakes, false)
	end

	if vehicleProperties.modTransmission then
		SetVehicleMod(vehicle, 13, vehicleProperties.modTransmission, false)
	end

	if vehicleProperties.modHorns then
		SetVehicleMod(vehicle, 14, vehicleProperties.modHorns, false)
	end

	if vehicleProperties.modSuspension then
		SetVehicleMod(vehicle, 15, vehicleProperties.modSuspension, false)
	end

	if vehicleProperties.modArmor then
		SetVehicleMod(vehicle, 16, vehicleProperties.modArmor, false)
	end

	if vehicleProperties.modTurbo then
		ToggleVehicleMod(vehicle,  18, vehicleProperties.modTurbo)
	end

	if vehicleProperties.modXenon then
		ToggleVehicleMod(vehicle,  22, vehicleProperties.modXenon)
	end

	if vehicleProperties.modFrontWheels then
		SetVehicleMod(vehicle, 23, vehicleProperties.modFrontWheels, false)
	end

	if vehicleProperties.modBackWheels then
		SetVehicleMod(vehicle, 24, vehicleProperties.modBackWheels, false)
	end

	if vehicleProperties.modPlateHolder then
		SetVehicleMod(vehicle, 25, vehicleProperties.modPlateHolder, false)
	end

	if vehicleProperties.modVanityPlate then
		SetVehicleMod(vehicle, 26, vehicleProperties.modVanityPlate, false)
	end

	if vehicleProperties.modTrimA then
		SetVehicleMod(vehicle, 27, vehicleProperties.modTrimA, false)
	end

	if vehicleProperties.modOrnaments then
		SetVehicleMod(vehicle, 28, vehicleProperties.modOrnaments, false)
	end

	if vehicleProperties.modDashboard then
		SetVehicleMod(vehicle, 29, vehicleProperties.modDashboard, false)
	end

	if vehicleProperties.modDial then
		SetVehicleMod(vehicle, 30, vehicleProperties.modDial, false)
	end

	if vehicleProperties.modDoorSpeaker then
		SetVehicleMod(vehicle, 31, vehicleProperties.modDoorSpeaker, false)
	end

	if vehicleProperties.modSeats then
		SetVehicleMod(vehicle, 32, vehicleProperties.modSeats, false)
	end

	if vehicleProperties.modSteeringWheel then
		SetVehicleMod(vehicle, 33, vehicleProperties.modSteeringWheel, false)
	end

	if vehicleProperties.modShifterLeavers then
		SetVehicleMod(vehicle, 34, vehicleProperties.modShifterLeavers, false)
	end

	if vehicleProperties.modAPlate then
		SetVehicleMod(vehicle, 35, vehicleProperties.modAPlate, false)
	end

	if vehicleProperties.modSpeakers then
		SetVehicleMod(vehicle, 36, vehicleProperties.modSpeakers, false)
	end

	if vehicleProperties.modTrunk then
		SetVehicleMod(vehicle, 37, vehicleProperties.modTrunk, false)
	end

	if vehicleProperties.modHydrolic then
		SetVehicleMod(vehicle, 38, vehicleProperties.modHydrolic, false)
	end

	if vehicleProperties.modEngineBlock then
		SetVehicleMod(vehicle, 39, vehicleProperties.modEngineBlock, false)
	end

	if vehicleProperties.modAirFilter then
		SetVehicleMod(vehicle, 40, vehicleProperties.modAirFilter, false)
	end

	if vehicleProperties.modStruts then
		SetVehicleMod(vehicle, 41, vehicleProperties.modStruts, false)
	end

	if vehicleProperties.modArchCover then
		SetVehicleMod(vehicle, 42, vehicleProperties.modArchCover, false)
	end

	if vehicleProperties.modAerials then
		SetVehicleMod(vehicle, 43, vehicleProperties.modAerials, false)
	end

	if vehicleProperties.modTrimB then
		SetVehicleMod(vehicle, 44, vehicleProperties.modTrimB, false)
	end

	if vehicleProperties.modTank then
		SetVehicleMod(vehicle, 45, vehicleProperties.modTank, false)
	end

	if vehicleProperties.modWindows then
		SetVehicleMod(vehicle, 46, vehicleProperties.modWindows, false)
	end

	if vehicleProperties.modLivery then
		SetVehicleMod(vehicle, 48, vehicleProperties.modLivery, false)
		SetVehicleLivery(vehicle, vehicleProperties.modLivery)
	end
end