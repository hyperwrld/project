local isOpen, hasWait = false, false

function openMenu()
	if hasWait then
		return
	end

	isOpen = not isOpen

	if not isOpen then
		exports['crp-ui']:closeApp('menu')

		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', 1)
		return
	end

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

AddEventHandler('crp-ui:closedMenu', function(name, data)
	if name ~= 'menu' and not isOpen then
		return
	end

	isOpen, hasWait = false, true

	Citizen.Wait(500)

	hasWait = false

	Debug('Radial menu closed.')

	PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', 1)
end)

RegisterCommand('+openMenu', openMenu, false)
RegisterCommand('-openMenu', openMenu, false)
RegisterKeyMapping('+openMenu', 'Abrir o menu', 'keyboard', 'f1')