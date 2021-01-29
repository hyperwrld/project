itemsList = {
	{
		identifier = 'CRP_CACETETE',
		name = 'Cacetete',
		image = 'crp-cacetete.png',
		hash = 1737195953,
		weight = 1.5,
		decayRate = 0.3,
		canStack = false
	},
	{
		identifier = 'CRP_TASER',
		name = 'Taser',
		image = 'crp-stungun.png',
		hash = 911657153,
		weight = 1.5,
		decayRate = 0.0,
		canStack = false
	},
	{
		identifier = 'CRP_PISTOLA',
		name = 'Pistola',
		image = 'crp-pistol.png',
		hash = 453432689,
		weight = 10,
		decayRate = 0.0,
		canStack = false
	},
	{
		identifier = 'CRP_PISTOLA_SNS',
		name = 'Pistola SNS',
		image = 'crp-snspistol.png',
		hash = -1076751822,
		weight = 10,
		decayRate = 0.0,
		canStack = false
	},
	{
		identifier = 'CRP_PISTOLA_VINTAGE',
		name = 'Pistola Vintage',
		image = 'crp-vintagepistol.png',
		hash = 137902532,
		weight = 10,
		decayRate = 0.0,
		canStack = false
	},
	{
		identifier = 'CRP_PISTOLA_PESADA',
		name = 'Pistola Pesada',
		image = 'crp-heavypistol.png',
		hash = -771403250,
		weight = 10,
		decayRate = 0.0,
		canStack = false
	},
	{
		identifier = 'CRP_PISTOLA_COMBATE',
		name = 'Pistola de Combate',
		image = 'crp-combatpistol.png',
		hash = 1593441988,
		weight = 10,
		decayRate = 0.0,
		canStack = false
	},
	{
		identifier = 'CRP_PISTOLA_METRALHADORA',
		name = 'Pistola-Metralhadora',
		image = 'crp-machinepistol.png',
		hash = -619010992,
		weight = 10,
		decayRate = 0.0,
		canStack = false
	},
	{
		identifier = 'CRP_MINI_SMG',
		name = 'Mini Submetralhadora',
		image = 'crp-minismg.png',
		hash = -1121678507,
		weight = 15,
		decayRate = 0.0,
		canStack = false
	},
	{
		identifier = 'CRP_MICRO_SMG',
		name = 'Micro Submetralhadora',
		image = 'crp-microsmg.png',
		hash = 324215364,
		weight = 15,
		decayRate = 0.0,
		canStack = false
	},
	{
		identifier = 'CRP_SMG',
		name = 'Submetralhadora',
		image = 'crp-smg.png',
		hash = 736523883,
		weight = 15,
		decayRate = 0.0,
		canStack = false
	},
	{
		identifier = 'CRP_RIFLE_COMPACTO',
		name = 'Rifle Compacto',
		image = 'crp-compactrifle.png',
		hash = 1649403952,
		weight = 20,
		decayRate = 0.0,
		canStack = false
	},
	{
		identifier = 'CRP_RIFLE_ASSALTO',
		name = 'Rifle de Assalto',
		image = 'crp-assaultrifle.png',
		hash = -1074790547,
		weight = 20,
		decayRate = 0.3,
		canStack = false
	},
	{
		identifier = 'CRP_CARABINA_MK2',
		name = 'Carabina MK2',
		image = 'crp-carbinerifle.png',
		hash = 4208062921,
		weight = 20,
		decayRate = 0.0,
		canStack = false
	},
	{
		identifier = 'CRP_COLETE',
		name = 'Colete',
		image = 'crp-colete.png',
		weight = 14,
		decayRate = 0.8,
		canStack = true
	},
	{
		identifier = 'CRP_LIGADURA',
		name = 'Ligadura',
		image = 'crp-ligadura.png',
		weight = 0.75,
		decayRate = 0.0,
		canStack = true
	},
	{
		identifier = 'CRP_COCACOLA',
		name = 'Coca-Cola',
		image = 'crp-coca.png',
		weight = 0.75,
		decayRate = 0.0,
		canStack = true
	},
	{
		identifier = 'CRP_BATATAS',
		name = 'Batatas',
		image = 'crp-batatas.png',

		weight = 0.75,
		decayRate = 0.0,
		canStack = true
	},
	{
		identifier = 'CRP_GAZUA',
		name = 'Gazua',
		image = 'crp-lockpick.png',
		weight = 3,
		decayRate = 0.0,
		canStack = true
	},
	{
		identifier = 'CRP_DINHEIRO',
		name = 'Dinheiro',
		description = '',
		image = 'crp-dinheiro.png',
		weight = 0,
		decayRate = 0.0,
		canStack = true
	},
	{
		identifier = 'CRP_RELOGIO',
		name = 'Relógio',
		description = '',
		image = 'crp-relogio.png',
		weight = 0,
		decayRate = 0.0,
		canStack = false,
		eventName = 'crp-hud:usedWatch'
	},
	{
		identifier = 'CRP_TELEMOVEL',
		name = 'Telemóvel',
		description = '',
		image = 'crp-relogio.png',
		weight = 0,
		decayRate = 0.0,
		canStack = false
	}
}

function getItemData(identifier)
	for i = 1, #itemsList, 1 do
		if itemsList[i].identifier == identifier then
			return itemsList[i]
		end
	end

	return false
end