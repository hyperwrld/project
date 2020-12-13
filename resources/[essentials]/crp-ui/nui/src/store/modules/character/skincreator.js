import { bodyFeatures, faceFeatures, headBlend, headOverlays } from './../../../utils/data.js';

const state = () => ({
	headBlend: headBlend, faceFeatures: faceFeatures, headOverlays: headOverlays, bodyFeatures: bodyFeatures
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
	},
	getBodyFeatures: state => {
		return state.bodyFeatures;
	}
}

const actions = {
    setData(state, data) {
        state.commit('setData', data);
    }
}

const mutations = {
	setData(state, data) {
		state.headBlend = headBlend, state.faceFeatures = faceFeatures, state.headOverlays = headOverlays, state.bodyFeatures = bodyFeatures;

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

		for (let i = 0; i < state.bodyFeatures.length; i++) {
			let option = state.bodyFeatures[i]

			if (i >= 3 && i <= 5) {
                option.subOptions[1].items = data.colors.makeupColors;
			} else {
				option.subOptions[1].items = data.colors.hairColors;
            }

            switch (i) {
                case 0:
					option.value = data.drawables.drawables[2], option.maxValue = data.totals.drawablesTotals[2];
					option.subOptions[0].value = data.drawables.textures[2], option.subOptions[0].maxValue = data.totals.textureTotals[2];
					option.subOptions[1].value = data.colors.hairColor, option.subOptions[2].value = data.colors.hairHightlightColor, option.subOptions[2].items = data.colors.hairColors;
                    break;
                default:
					const headOverlay = data.headOverlays[option.id];

					option.value = (headOverlay.overlayValue == 255) ? -1 : headOverlay.overlayValue, option.subOptions[0].value = headOverlay.opacity;

					if (option.value != -1) {
						option.subOptions[1].value = headOverlay.firstColour;

						if (option.subOptions[2]) {
							option.subOptions[2].value = headOverlay.secondColour;
						}
					}

					if (option.subOptions[2]) {
						option.subOptions[2].items = data.colors.makeupColors;
					}

                    if (option.maxValue == 0) {
						option.maxValue = data.totals.drawablesTotals[option.id];
					}
                    break;
            }
		}
    }
}

export default { namespaced: true, getters, state, actions, mutations }