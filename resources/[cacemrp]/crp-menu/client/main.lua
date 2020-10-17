local isShowingMenu = false

function toggleMenu()
	isShowingMenu = not isShowingMenu

	if not isShowingMenu then
		exports['crp-ui']:closeApp('menu')
		return
	end

	exports['crp-ui']:openApp('menu', menuItems)
end

RegisterCommand('+showMenu', toggleMenu, false)
RegisterCommand('-showMenu', toggleMenu, false)
RegisterKeyMapping('+showMenu', 'Abrir o menu', 'keyboard', 'CapsLock')