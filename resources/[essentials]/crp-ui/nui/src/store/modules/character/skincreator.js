import { bodyHair, faceFeatures, headBlend, headOverlays } from './../../../utils/data.js';

const state = () => ({
	headBlend: headBlend, faceFeatures: faceFeatures, headOverlays: headOverlays, bodyHair: bodyHair
})

const getters = {
	getHeadBlend: state => {
		return state.headBlend;
	},
	getFaceFeatures: state => {
		return state.faceFeatures;
	},
	getHeadOverlays: state => {
		return state.headOverlays;
	}
}

const actions = {
    setData(state, data) {
        state.commit('setData', data);
    }
}

const mutations = {
	setData(state, data) {
		state.headBlend = headBlend, state.faceFeatures = faceFeatures, state.headOverlays = headOverlays;

		for (let i = 0; i < state.headBlend.length; i++) {
			state.headBlend[i].value = data.headBlend[i];
		}

		for (let i = 0; i < state.faceFeatures.length; i++) {
			state.faceFeatures[i].value = data.faceFeatures[i];
		}

		for (let i = 0; i < state.headOverlays.length; i += 2) {
			const id = state.headOverlays[i].id;

			if (data.headOverlays[id]) {
				let value = data.headOverlays[id].overlayValue == 255 ? 0 : data.headOverlays[id].overlayValue;

				state.headOverlays[i].value = value, state.headOverlays[i + 1].value = data.headOverlays[id].opacity;
			}
		}
    }
}

export default { namespaced: true, getters, state, actions, mutations }