menuItems = {
	{
		id = 'general',
		label = 'Geral',
		icon = 'globe-europe'
	},
	{
		id = 'police-actions',
		label = 'Funções da polícia',
		icon = 'shield-alt',
		enableFunction = function()
			return true
		end,
		subMenus = {
			{
				id = 'test',
				label = 'test',
				icon = 'test'
			}
		}
	},
	{
		id = 'animations',
		label = 'Estilos de andar',
		icon = 'walking'
	},
	{
		id = 'expressions',
		label = 'Expressões',
		icon = 'theater-masks'
	}
}