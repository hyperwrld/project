menuList = {
	{
		id = 'general',
		label = 'Geral',
		icon = 'globe-europe',
		enableSector = function()
			return true
		end,
		subMenus = {
			{
				id = 'animations',
				label = 'Animações',
				icon = 'meh-blank',
				functionName = ''
			},
			{
				id = 'give-keys',
				label = 'Dar chaves',
				icon = 'car',
				functionName = ''
			},
			{
				id = 'check-car',
				label = 'Examinar o veículo',
				icon = 'diagnoses',
				functionName = ''
			},
			{
				id = 'escort',
				label = 'Agarrar',
				icon = 'user-friends',
				functionName = ''
			},
			{
				id = 'put-in-vehicle',
				label = 'Colocar no veículo',
				icon = 'sign-in-alt',
				functionName = ''
			},
			{
				id = 'unseat-vehicle',
				label = 'Retirar do veículo',
				icon = 'fa-sign-out-alt',
				functionName = ''
			}
		}
	},
	{
		id = 'police-actions',
		label = 'Funções da polícia',
		icon = 'shield-alt',
		enableSector = function()
			return true
		end
	},
	{
		id = 'walking-style',
		label = 'Estilos de andar',
		icon = 'walking',
		enableSector = function()
			return true
		end
	},
	{
		id = 'expressions',
		label = 'Expressões',
		icon = 'theater-masks',
		enableSector = function()
			return true
		end
	},
	{
		id = 'vehicle',
		label = 'Veículo',
		icon = 'car',
		enableSector = function()
			return true
		end
	},
	{
		id = 'cuff',
		label = 'Algemar/Desalgemar',
		icon = 'link',
		enableSector = function()
			return true
		end,
		functionName = 'crp-police:cuff'
	},
	{
		id = 'garage',
		label = 'Garagem',
		icon = 'parking',
		enableSector = function()
			return true
		end,
		functionName = 'crp-garage:openGarage'
	}
}