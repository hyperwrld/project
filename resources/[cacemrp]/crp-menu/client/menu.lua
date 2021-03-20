local isOpen, hasWait = false, false

function toggleMenu()
	if hasWait then
		return
	end

	if isOpen then
		hasWait = true

		exports['crp-ui']:closeApp('menu')
		return
	end

	isOpen = not isOpen

	local data = {}

	for k, v in ipairs(menuList) do
		if v:enableSector() then
			local elements, hasSubMenu = {}, false

			if v.subMenus and #v.subMenus > 0 then
				local previous, element = elements, {}

				hasSubMenu = true

				for i = 1, #v.subMenus do
					element[#element + 1] = v.subMenus[i]

					if i % 5 == 0 and i < (#v.subMenus - 1) then
						previous[6] = {
							id = 'more',
							label = 'Mais...',
							icon = 'ellipsis-h',
							items = element
						}

						previous, element = element, {}
					end
				end

				if #element > 0 then
					previous[6] = {
						id = 'more',
						label = 'Mais...',
						icon = 'ellipsis-h',
						items = element
					}
				end

				elements = elements[6].items
			end

			data[#data + 1] = {
				id = v.id,
				label = v.label,
				icon = v.icon,
				functionName = v.functionName
			}

			if hasSubMenu then
				data[#data].items = elements
			end
		end
	end

	exports['crp-ui']:openApp('menu', data, true, true, true, true)

	PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', 1)
end

RegisterUICallback('clickedItem', function(data, cb)
	TriggerEvent(data.functionName, data.parameters)

	cb({ state = true })
end)

AddEventHandler('crp-ui:closedMenu', function(name, data)
	if name ~= 'menu' and not isOpen then
		return
	end

	isOpen = false

	Debug('Radial menu closed.')

	PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', 1)

	Citizen.Wait(250)

	hasWait = false
end)

RegisterCommand('+toggleMenu', toggleMenu, false)
RegisterCommand('-toggleMenu', toggleMenu, false)
RegisterKeyMapping('+toggleMenu', 'Abrir/Fechar o menu', 'keyboard', 'f1')