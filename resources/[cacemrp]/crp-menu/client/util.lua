menuList = {
	{
		id: 'general',
		label: 'Geral',
		icon: 'globe-europe'
	},
	{
		id: 'police-actions',
		label: 'Funções da polícia',
		icon: 'shield-alt'
	},
	{
		id: 'animations',
		label: 'Estilos de andar',
		icon: 'walking'
	},
	{
		id: 'expressions',
		label: 'Expressões',
		icon: 'theater-masks'
	},
	{
		id: 'cuff',
		label: 'Algemar/Desalgemar',
		icon: 'link',
		functionName: 'crp-police:cuff'
	}
}

eventList = {
	['mrpd_service'] = {
		type = 2,
		label = 'Entrar/Sair de serviço',
		eventName = 'crp-inventory:openShop',
		data = { 3 }
	},
    [`prop_vend_coffe_01`] = {
        eventName = 'crp-inventory:openShop', type = 1, label = 'Máquina de vendas', data = { 3 }
    }
}