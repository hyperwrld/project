local isShowingMenu = false

function toggleMenu()
	isShowingMenu = not isShowingMenu

	if not isShowingMenu then
		exports['crp-ui']:closeApp('menu')
		return
	end

    local menu = {}

    for i = 1, #menuItems do
		local sector = menuItems[i]

		if sector.enableFunction ~= nil and not sector.enableFunction then
			return
		end

		local subMenus = {}

		if sector.subMenus then
			for i = 1, #sector.subMenus do
				if sector.subMenus[i].enableFunction ~= nil and not sector.subMenus[i].enableFunction then
					return
				end

				subMenus[#subMenus + 1] = {
					id = sector.subMenus[i].id,
					label = sector.subMenus[i].label,
					icon = sector.subMenus[i].icon,
					enableFunction = sector.subMenus[i].enableFunction
				}
			end
		end

		menu[#menu + 1] = {
			id = sector.id,
			label = sector.label,
			icon = sector.icon,
			enableFunction = sector.enableFunction,
			items = subMenus
		}
    end

	exports['crp-ui']:openApp('menu', menu)
end

RegisterCommand('+showMenu', toggleMenu, false)
RegisterKeyMapping('+showMenu', 'Abrir o menu', 'keyboard', 'Caps')