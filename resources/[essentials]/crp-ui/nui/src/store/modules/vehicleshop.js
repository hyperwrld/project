const state = () => ({
    vehicleClasses: [
        { name: 'BICICLETAS' }, { name: 'COMERCIAL' }, { name: 'COMPACTOS' }, { name: 'COUPES' }, { name: 'DESPORTIVOS' }, { name: 'DESPORTIVOS CLÁSSICOS' },
        { name: 'MOTOS' }, { name: 'OFF ROAD' }, { name: 'POTENTES' }, { name: 'SEDANS' }, { name: 'SUPER' }, { name: 'SUV' }, { name: 'VANS' }
    ],
    vehicleList: [{ name: 'Buffalo'}, { name: 'teste'}]
})

const actions = {
    setInventory(state, data) {
        state.commit('setInventory', data);
    }
}

const mutations = {
    setInventory(state, data) {

    }
}

export default { namespaced: true, state, actions, mutations }