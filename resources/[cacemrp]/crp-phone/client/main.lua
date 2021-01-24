function openPhone()
	local success = exports['crp-inventory']:hasItem('CRP_TELEMOVEL', 1)

	if success then
		exports['crp-ui']:openApp('phone')
	end
end

RegisterNetEvent('crp-phone:updatePhone')
AddEventHandler('crp-phone:updatePhone', function(data)
	exports['crp-ui']:setAppData('phone', data)
end)

RegisterCommand('+openPhone', openPhone, false)
RegisterKeyMapping('+openPhone', 'Abrir o telemóvel', 'keyboard', 'f5')