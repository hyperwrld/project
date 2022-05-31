const development = () => ({
	isWaiting: false,
	characterId: 6302,
	firstName: 'Ricardo',
	lastName: 'Dias',
	money: 5620,
	accounts: [
		{
			money: 4980,
			permissions: true,
			name: 'Conta Pessoal',
			owner_name: 'Ricardo Dias',
			owner: 6302,
			type: 'Conta Pessoal',
			deposit: false,
			id: 6371710,
		},
		{
			money: 5020,
			permissions: false,
			name: 'Conta Pessoal',
			owner_name: 'Tim Almeida',
			owner: 91,
			type: 'Conta Pessoal',
			deposit: false,
			id: 6371708,
		},
	],
	transactions: [
		{
			money: 10,
			description: 'rrfgfd',
			sender_id: 6371710,
			receiver_name: 'Conta Pessoal',
			type_name: 'Transferência',
			sender_fullname: 'Ricardo Dias',
			sender_name: 'Conta Pessoal',
			time: 1623160217,
			receiver_id: 6371708,
			type: 3,
			id: '7eae73f0-2e50-4a1a-6a9c-0e0e55253643',
		},
		{
			money: 10,
			description: 'fg',
			sender_id: 6371710,
			receiver_name: 'Conta Pessoal',
			type_name: 'Levantamento',
			sender_fullname: 'Ricardo Dias',
			sender_name: 'Conta Pessoal',
			time: 1623160050,
			receiver_id: 6371708,
			type: 1,
			id: '0d87d132-edc9-4ae8-4c6f-2077739fdef5',
		},
	],
});

const production = () => ({
	isWaiting: false,
	characterId: 0,
	firstName: '',
	lastName: '',
	money: 0,
	accounts: [],
	transactions: [],
});

export { development, production };
