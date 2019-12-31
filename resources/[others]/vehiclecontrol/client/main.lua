local count_bcast_timer, delay_bcast_timer, count_sndclean_timer, delay_sndclean_timer = 0, 200, 0, 400
local actv_ind_timer, count_ind_timer, delay_ind_timer, actv_lxsrnmute_temp = false, 0, 180, false
local srntone_temp, dsrn_mute, state_indic, state_lxsiren, state_pwrcall = 0, true, {}, {}, {}
local state_airmanu, ind_state_o, ind_state_l, ind_state_r, ind_state_h = {}, 0, 1, 2, 3
local snd_lxsiren, snd_pwrcall, snd_airmanu = {}, {}, {}


-- models listed below will use AMBULANCE_WARNING as auxiliary siren
-- unlisted models will instead use the default wail as the auxiliary siren

local eModelsWithPcall = { 'AMBULANCE', 'FIRETRUK', 'LGUARD' }

function usePowercallAuxSrn(vehicle)
    local model = GetEntityModel(vehicle)
    
	for i = 1, #eModelsWithPcall, 1 do
		if model == GetHashKey(eModelsWithPcall[i]) then
			return true
		end
    end
    
	return false
end

function CleanupSounds()
	if count_sndclean_timer > delay_sndclean_timer then
        count_sndclean_timer = 0
        
		for k, v in pairs(state_lxsiren) do
			if v > 0 then
				if not DoesEntityExist(k) or IsEntityDead(k) then
					if snd_lxsiren[k] ~= nil then
						StopSound(snd_lxsiren[k])
                        ReleaseSoundId(snd_lxsiren[k])
                        
						snd_lxsiren[k], state_lxsiren[k] = nil, nil
					end
				end
			end
        end
        
		for k, v in pairs(state_pwrcall) do
			if v == true then
				if not DoesEntityExist(k) or IsEntityDead(k) then
					if snd_pwrcall[k] ~= nil then
						StopSound(snd_pwrcall[k])
                        ReleaseSoundId(snd_pwrcall[k])
                        
						snd_pwrcall[k], state_pwrcall[k] = nil, nil
					end
				end
			end
        end
        
		for k, v in pairs(state_airmanu) do
			if v == true then
				if not DoesEntityExist(k) or IsEntityDead(k) or IsVehicleSeatFree(k, -1) then
					if snd_airmanu[k] ~= nil then
						StopSound(snd_airmanu[k])
                        ReleaseSoundId(snd_airmanu[k])
                        
						snd_airmanu[k], state_airmanu[k] = nil, nil
					end
				end
			end
		end
	else
		count_sndclean_timer = count_sndclean_timer + 1
	end
end

function TogIndicStateForVeh(vehicle, newstate)
	if DoesEntityExist(vehicle) and not IsEntityDead(vehicle) then
		if newstate == ind_state_o then
			SetVehicleIndicatorLights(vehicle, 0, false)
			SetVehicleIndicatorLights(vehicle, 1, false)
		elseif newstate == ind_state_l then
			SetVehicleIndicatorLights(vehicle, 0, false)
			SetVehicleIndicatorLights(vehicle, 1, true)
		elseif newstate == ind_state_r then
			SetVehicleIndicatorLights(vehicle, 0, true)
			SetVehicleIndicatorLights(vehicle, 1, false)
		elseif newstate == ind_state_h then
			SetVehicleIndicatorLights(vehicle, 0, true)
			SetVehicleIndicatorLights(vehicle, 1, true)
        end
        
		state_indic[vehicle] = newstate
	end
end

function TogMuteDfltSrnForVeh(vehicle, toggle)
	if DoesEntityExist(vehicle) and not IsEntityDead(vehicle) then
		DisableVehicleImpactExplosionActivation(vehicle, toggle)
	end
end

function SetLxSirenStateForVeh(vehicle, newstate)
	if DoesEntityExist(vehicle) and not IsEntityDead(vehicle) then
		if newstate ~= state_lxsiren[vehicle] then
				
			if snd_lxsiren[vehicle] ~= nil then
				StopSound(snd_lxsiren[vehicle])
				ReleaseSoundId(snd_lxsiren[vehicle])
				snd_lxsiren[vehicle] = nil
			end
						
			if newstate == 1 then
                snd_lxsiren[vehicle] = GetSoundId()	
                PlaySoundFromEntity(snd_lxsiren[vehicle], 'VEHICLES_HORNS_SIREN_1', vehicle, 0, 0, 0)
                TogMuteDfltSrnForVeh(vehicle, true)
			elseif newstate == 2 then
				snd_lxsiren[vehicle] = GetSoundId()
				PlaySoundFromEntity(snd_lxsiren[vehicle], 'VEHICLES_HORNS_SIREN_2', vehicle, 0, 0, 0)
				TogMuteDfltSrnForVeh(vehicle, true)
			
			elseif newstate == 3 then
                snd_lxsiren[vehicle] = GetSoundId()
                
				PlaySoundFromEntity(snd_lxsiren[vehicle], 'VEHICLES_HORNS_POLICE_WARNING', vehicle, 0, 0, 0)
				TogMuteDfltSrnForVeh(vehicle, true)
			else
				TogMuteDfltSrnForVeh(vehicle, true)
			end				
				
			state_lxsiren[vehicle] = newstate
		end
	end
end

function TogPowercallStateForVeh(vehicle, toggle)
	if DoesEntityExist(vehicle) and not IsEntityDead(vehicle) then
		if toggle == true then
			if snd_pwrcall[vehicle] == nil then
                snd_pwrcall[vehicle] = GetSoundId()
                
				if usePowercallAuxSrn(vehicle) then
					PlaySoundFromEntity(snd_pwrcall[vehicle], 'VEHICLES_HORNS_AMBULANCE_WARNING', vehicle, 0, 0, 0)
				else
					PlaySoundFromEntity(snd_pwrcall[vehicle], 'VEHICLES_HORNS_SIREN_1', vehicle, 0, 0, 0)
				end
			end
		else
			if snd_pwrcall[vehicle] ~= nil then
				StopSound(snd_pwrcall[vehicle])
                ReleaseSoundId(snd_pwrcall[vehicle])
                
				snd_pwrcall[vehicle] = nil
			end
        end
        
		state_pwrcall[vehicle] = toggle
	end
end

function SetAirManuStateForVeh(vehicle, newstate)
	if DoesEntityExist(vehicle) and not IsEntityDead(vehicle) then
		if newstate ~= state_airmanu[vehicle] then
				
			if snd_airmanu[vehicle] ~= nil then
				StopSound(snd_airmanu[vehicle])
				ReleaseSoundId(snd_airmanu[vehicle])
				snd_airmanu[vehicle] = nil
			end
						
			if newstate == 1 then
				snd_airmanu[vehicle] = GetSoundId()
					PlaySoundFromEntity(snd_airmanu[vehicle], 'SIRENS_AIRHORN', vehicle, 0, 0, 0)
				
			elseif newstate == 2 then
				snd_airmanu[vehicle] = GetSoundId()
				PlaySoundFromEntity(snd_airmanu[vehicle], 'VEHICLES_HORNS_SIREN_1', vehicle, 0, 0, 0)
			
			elseif newstate == 3 then
				snd_airmanu[vehicle] = GetSoundId()
				PlaySoundFromEntity(snd_airmanu[vehicle], 'VEHICLES_HORNS_SIREN_2', vehicle, 0, 0, 0)
				
			end				
				
			state_airmanu[vehicle] = newstate
		end
	end
end

RegisterNetEvent('lvc_TogIndicState_c')
AddEventHandler('lvc_TogIndicState_c', function(sender, newstate)
	local player_s, ped_s = GetPlayerFromServerId(sender), GetPlayerPed(player_s)
    
	if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
		if ped_s ~= GetPlayerPed(-1) then
			if IsPedInAnyVehicle(ped_s, false) then
                local vehicle = GetVehiclePedIsUsing(ped_s)
                
				TogIndicStateForVeh(vehicle, newstate)
			end
		end
	end
end)

RegisterNetEvent('lvc_TogDfltSrnMuted_c')
AddEventHandler('lvc_TogDfltSrnMuted_c', function(sender, toggle)
    local player_s, ped_s = GetPlayerFromServerId(sender), GetPlayerPed(player_s)
    
	if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
		if ped_s ~= GetPlayerPed(-1) then
			if IsPedInAnyVehicle(ped_s, false) then
                local vehicle = GetVehiclePedIsUsing(ped_s)
                
				TogMuteDfltSrnForVeh(vehicle, toggle)
			end
		end
	end
end)

RegisterNetEvent('lvc_SetLxSirenState_c')
AddEventHandler('lvc_SetLxSirenState_c', function(sender, newstate)
    local player_s, ped_s = GetPlayerFromServerId(sender), GetPlayerPed(player_s)
    
	if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
		if ped_s ~= GetPlayerPed(-1) then
			if IsPedInAnyVehicle(ped_s, false) then
                local vehicle = GetVehiclePedIsUsing(ped_s)
                
				SetLxSirenStateForVeh(vehicle, newstate)
			end
		end
	end
end)

RegisterNetEvent('lvc_TogPwrcallState_c')
AddEventHandler('lvc_TogPwrcallState_c', function(sender, toggle)
    local player_s, ped_s = GetPlayerFromServerId(sender), GetPlayerPed(player_s)
    
	if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
		if ped_s ~= GetPlayerPed(-1) then
			if IsPedInAnyVehicle(ped_s, false) then
                local vehicle = GetVehiclePedIsUsing(ped_s)
                
				TogPowercallStateForVeh(vehicle, toggle)
			end
		end
	end
end)

RegisterNetEvent('lvc_SetAirManuState_c')
AddEventHandler('lvc_SetAirManuState_c', function(sender, newstate)
    local player_s, ped_s = GetPlayerFromServerId(sender), GetPlayerPed(player_s)
    
	if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
		if ped_s ~= GetPlayerPed(-1) then
			if IsPedInAnyVehicle(ped_s, false) then
                local vehicle = GetVehiclePedIsUsing(ped_s)
                
				SetAirManuStateForVeh(vehicle, newstate)
			end
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
		CleanupSounds()
			
        local playerPed = GetPlayerPed(-1)		
        
		if IsPedInAnyVehicle(playerPed, false) then	
            local vehicle = GetVehiclePedIsUsing(playerPed)	
            
			if GetPedInVehicleSeat(vehicle, -1) == playerPed then
				DisableControlAction(0, 84, true)  
				DisableControlAction(0, 83, true)
					
				if state_indic[vehicle] ~= ind_state_o and state_indic[vehicle] ~= ind_state_l and state_indic[vehicle] ~= ind_state_r and state_indic[vehicle] ~= ind_state_h then
					state_indic[vehicle] = ind_state_o
				end
					
                if actv_ind_timer == true then	
                    if state_indic[vehicle] == ind_state_l or state_indic[vehicle] == ind_state_r then
                        if GetEntitySpeed(vehicle) < 6 then
                            count_ind_timer = 0
                        else
                            if count_ind_timer > delay_ind_timer then
                                count_ind_timer, actv_ind_timer, state_indic[vehicle] = 0, false, ind_state_o
                                    
                                PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
                                TogIndicStateForVeh(vehicle, state_indic[vehicle])
                                    
                                count_bcast_timer = delay_bcast_timer
                            else
                                count_ind_timer = count_ind_timer + 1
                            end
                        end
                    end
                end
					
                if GetVehicleClass(vehicle) == 18 then
                    local actv_manu, actv_horn = false, false
                    
                    DisableControlAction(0, 86, true)
                    DisableControlAction(0, 172, true)
                    DisableControlAction(0, 81, true)
                    DisableControlAction(0, 82, true)
                    DisableControlAction(0, 19, true)
                    DisableControlAction(0, 85, true)
                    DisableControlAction(0, 80, true)
                
                    SetVehRadioStation(vehicle, 'OFF')
                    SetVehicleRadioEnabled(vehicle, false)
                        
                    if state_lxsiren[vehicle] ~= 1 and state_lxsiren[vehicle] ~= 2 and state_lxsiren[vehicle] ~= 3 then
                        state_lxsiren[vehicle] = 0
                    end
                        
                    if state_pwrcall[vehicle] ~= true then
                        state_pwrcall[vehicle] = false
                    end
                    
                    if state_airmanu[vehicle] ~= 1 and state_airmanu[vehicle] ~= 2 and state_airmanu[vehicle] ~= 3 then
                        state_airmanu[vehicle] = 0
                    end
                            
                    TogMuteDfltSrnForVeh(vehicle, true)
                    dsrn_mute = true
                        
                    if not IsVehicleSirenOn(vehicle) and state_lxsiren[vehicle] > 0 then
                        PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
                        SetLxSirenStateForVeh(vehicle, 0)
                        
                        count_bcast_timer = delay_bcast_timer
                    end
                        
                    if not IsVehicleSirenOn(vehicle) and state_pwrcall[vehicle] == true then
                        PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
                        TogPowercallStateForVeh(vehicle, false)
                        
                        count_bcast_timer = delay_bcast_timer
                    end
                        
                    if not IsPauseMenuActive() then
                        if IsDisabledControlJustReleased(0, 85) or IsDisabledControlJustReleased(0, 246) then
                            if IsVehicleSirenOn(vehicle) then
                                PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
                                SetVehicleSiren(vehicle, false)
                            else
                                PlaySoundFrontend(-1, 'NAV_LEFT_RIGHT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
                                SetVehicleSiren(vehicle, true)
                                
                                count_bcast_timer = delay_bcast_timer
                            end		
                        elseif IsDisabledControlJustReleased(0, 19) or IsDisabledControlJustReleased(0, 82) then
                            local cstate = state_lxsiren[vehicle]
                                
                            if cstate == 0 then
                                if IsVehicleSirenOn(vehicle) then
                                    PlaySoundFrontend(-1, 'NAV_LEFT_RIGHT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1) -- on
                                    SetLxSirenStateForVeh(vehicle, 1)
                                    
                                    count_bcast_timer = delay_bcast_timer
                                end
                            else
                                PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1) -- off
                                SetLxSirenStateForVeh(vehicle, 0)
                                
                                count_bcast_timer = delay_bcast_timer
                            end
                        elseif IsDisabledControlJustReleased(0, 172) then
                            if state_pwrcall[vehicle] == true then
                                PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
                                TogPowercallStateForVeh(vehicle, false)
                                
                                count_bcast_timer = delay_bcast_timer
                            else
                                if IsVehicleSirenOn(vehicle) then
                                    PlaySoundFrontend(-1, 'NAV_LEFT_RIGHT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
                                    TogPowercallStateForVeh(vehicle, true)

                                    count_bcast_timer = delay_bcast_timer
                                end
                            end	
                        end
                                
                        if state_lxsiren[vehicle] > 0 then
                            if IsDisabledControlJustReleased(0, 80) or IsDisabledControlJustReleased(0, 81) then
                                if IsVehicleSirenOn(vehicle) then
                                    local cstate, nstate = state_lxsiren[vehicle], 1
                                    
                                    PlaySoundFrontend(-1, 'NAV_LEFT_RIGHT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
                                    
                                    if cstate == 1 then
                                        nstate = 2
                                    elseif cstate == 2 then
                                        nstate = 3
                                    else	
                                        nstate = 1
                                    end
                                    
                                    SetLxSirenStateForVeh(vehicle, nstate)
                                    
                                    count_bcast_timer = delay_bcast_timer
                                end
                            end
                        end
                            
                        if state_lxsiren[vehicle] < 1 then
                            if IsDisabledControlPressed(0, 80) or IsDisabledControlPressed(0, 81) then
                                actv_manu = true
                            else
                                actv_manu = false
                            end
                        else
                            actv_manu = false
                        end
                                
                        if IsDisabledControlPressed(0, 86) then
                            actv_horn = true
                        else
                            actv_horn = false
                        end	
                    end
						
                    local hmanu_state_new = 0
                    
                    if actv_horn == true and actv_manu == false then
                        hmanu_state_new = 1
                    elseif actv_horn == false and actv_manu == true then
                        hmanu_state_new = 2
                    elseif actv_horn == true and actv_manu == true then
                        hmanu_state_new = 3
                    end
                    
                    if hmanu_state_new == 1 then
                        if state_lxsiren[vehicle] > 0 and actv_lxsrnmute_temp == false then
                            srntone_temp = state_lxsiren[vehicle]
                            
                            SetLxSirenStateForVeh(vehicle, 0)
                            
                            actv_lxsrnmute_temp = true
                        end
                    else
                        if actv_lxsrnmute_temp == true then
                            SetLxSirenStateForVeh(vehicle, srntone_temp)
                            
                            actv_lxsrnmute_temp = false
                        end
                    end

                    if state_airmanu[vehicle] ~= hmanu_state_new then
                        SetAirManuStateForVeh(vehicle, hmanu_state_new)
                            
                        count_bcast_timer = delay_bcast_timer
                    end
					
                    if GetVehicleClass(vehicle) ~= 14 and GetVehicleClass(vehicle) ~= 15 and GetVehicleClass(vehicle) ~= 16 and GetVehicleClass(vehicle) ~= 21 then
                        if not IsPauseMenuActive() then
                            if IsDisabledControlJustReleased(0, 84) then
                                local cstate = state_indic[vehicle]
                                    
                                if cstate == ind_state_l then
                                    state_indic[vehicle], actv_ind_timer = ind_state_o, false
                                        
                                    PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
                                else
                                    state_indic[vehicle], actv_ind_timer = ind_state_l, true
                                        
                                    PlaySoundFrontend(-1, 'NAV_LEFT_RIGHT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
                                end
                                    
                                TogIndicStateForVeh(vehicle, state_indic[vehicle])
                                    
                                count_ind_timer, count_bcast_timer = 0, delay_bcast_timer		
                            elseif IsDisabledControlJustReleased(0, 83) then -- INPUT_VEH_NEXT_RADIO_TRACK
                                local cstate = state_indic[vehicle]
                                    
                                if cstate == ind_state_r then
                                    state_indic[vehicle], actv_ind_timer = ind_state_o, false
                                        
                                    PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
                                else
                                    state_indic[vehicle], actv_ind_timer = ind_state_r, true
                                        
                                    PlaySoundFrontend(-1, 'NAV_LEFT_RIGHT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
                                end
                                    
                                TogIndicStateForVeh(vehicle, state_indic[vehicle])
                                    
                                count_ind_timer, count_bcast_timer = 0, delay_bcast_timer
                            elseif IsControlJustReleased(0, 202) then
                                if GetLastInputMethod(0) then
                                    local cstate = state_indic[vehicle]
                                        
                                    if cstate == ind_state_h then
                                        state_indic[vehicle] = ind_state_o
                                            
                                        PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
                                    else
                                        state_indic[vehicle] = ind_state_h
                                            
                                        PlaySoundFrontend(-1, 'NAV_LEFT_RIGHT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
                                    end
                                        
                                    TogIndicStateForVeh(vehicle, state_indic[vehicle])
                                        
                                    actv_ind_timer, count_ind_timer, count_bcast_timer = false, 0, delay_bcast_timer
                                end
                            end
                        end
                            
                        if count_bcast_timer > delay_bcast_timer then
                            count_bcast_timer = 0
                            
                            if GetVehicleClass(vehicle) == 18 then
                                TriggerServerEvent('lvc_TogDfltSrnMuted_s', dsrn_mute)
                                TriggerServerEvent('lvc_SetLxSirenState_s', state_lxsiren[vehicle])
                                TriggerServerEvent('lvc_TogPwrcallState_s', state_pwrcall[vehicle])
                                TriggerServerEvent('lvc_SetAirManuState_s', state_airmanu[vehicle])
                            end
                                
                            TriggerServerEvent('lvc_TogIndicState_s', state_indic[vehicle])
                        else
                            count_bcast_timer = count_bcast_timer + 1
                        end
                    end
				end
			end
		end	
	end
end)