const state = () => ({
	notifications: [],
});

const getters = {
	getNotifications: (state) => {
		return state.notifications;
	},
};

const actions = {
	setAlert(state, data) {
		state.commit('setAlert', data);
	},
	setCustomAlert(state, data) {
		state.commit('setCustomAlert', data);
	},
};

const mutations = {
	setAlert(state, data) {
		const alertId = state.notifications.push({
			text: data.text,
			type: data.type,
		});

		setTimeout(
			() => {
				state.notifications.splice(alertId - 1, 1);
			},
			data.time != null ? data.time : 2500
		);
	},
	setCustomAlert(state, data) {
		const notificationsArray = state.notifications.map((element) => element.id);
		let isCreated = state.notifications[notificationsArray.indexOf(data.id)];

		if (data.action == 'create' || data.action == 'update') {
			if (isCreated == undefined) {
				state.notifications.push({
					id: data.id,
					text: data.text,
					type: data.type,
				});
			} else {
				(isCreated.text = data.text), (isCreated.type = data.type);
			}
		} else if (data.action == 'delete' && isCreated) {
			state.notifications.splice(notificationsArray.indexOf(data.id), 1);
		}
	},
};

export default { namespaced: true, getters, state, actions, mutations };
