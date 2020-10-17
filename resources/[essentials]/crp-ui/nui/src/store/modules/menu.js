const state = () => ({
    menuItems: [
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
			icon: 'link'
		}
	]
})

const getters = {
    getMenuItems: state => {
        return state.menuItems;
    }
}

const actions = {
    setData(state, data) {
        state.commit('setData', data);
    }
}

const mutations = {
    setData(state, data) {
		state.menuItems = data;
    }
}

export default { namespaced: true, state, getters, actions, mutations }