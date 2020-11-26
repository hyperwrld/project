import { faceFeatures, headBlend } from './../../../utils/data.js';

const state = () => ({
	headBlend: headBlend, faceFeatures: faceFeatures
})

const getters = {
	getHeadBlend: state => {
		return state.headBlend;
	},
	getFaceFeatures: state => {
		return state.faceFeatures;
	}
}

const actions = {
    setData(state, data) {
        state.commit('setData', data);
    }
}

const mutations = {
	setData(state, data) {
		state.headBlend = headBlend;

		for (let i = 0; i < data.headBlend.length; i++) {
			state.headBlend[i].value = data.headBlend[i];
		}
    }
}

export default { namespaced: true, getters, state, actions, mutations }