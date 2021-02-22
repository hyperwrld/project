function openMenu()
	exports['crp-ui']:openApp('menu')
end

RegisterCommand('+openMenu', openMenu, false)
RegisterKeyMapping('+openMenu', 'Abrir o menu', 'keyboard', 'f1')