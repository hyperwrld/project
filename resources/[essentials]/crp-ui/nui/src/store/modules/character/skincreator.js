import { faceFeatures, headBlend, skinFeatures } from './../../../utils/data.js';

const state = () => ({
	headBlend: headBlend, faceFeatures: faceFeatures, skinFeatures: skinFeatures
})

const getters = {
	getHeadBlend: state => {
		return state.headBlend;
	},
	getFaceFeatures: state => {
		return state.faceFeatures;
	},
	getSkinFeatures: state => {
		return state.skinFeatures;
	}
}

const actions = {
    setData(state, data) {
        state.commit('setData', data);
    }
}

const mutations = {
	setData(state, data) {
		state.headBlend = headBlend, state.faceFeatures = faceFeatures, state.skinFeatures = skinFeatures;

		for (let i = 0; i < data.headBlend.length; i++) {
			state.headBlend[i].value = data.headBlend[i];
		}

		for (let i = 0; i < data.faceFeatures.length; i++) {
			state.faceFeatures[i].value = data.faceFeatures[i];
		}

		for (let i = 0; i < data.skinFeatures.length; i++) {
			state.skinFeatures[i].value = data.skinFeatures[i];
		}

		console.log(data)
    }
}

export default { namespaced: true, getters, state, actions, mutations }