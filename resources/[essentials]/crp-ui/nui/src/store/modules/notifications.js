const state = () => ({
    notificationsList: []
})

const actions = {
    setAlert(state, data) {
        state.commit('setAlert', data);
    },
    setCustomAlert(state, data) {
        state.commit('setCustomAlert', data);
    }
}

const mutations = {
    setAlert(state, data) {
        const alertId = state.notificationsList.push({ text: data.text, type: data.type });

        setTimeout(() => {
            state.notificationsList.splice(alertId - 1, 1);
        }, data.time != null ? data.time : 2500);
    },
    setCustomAlert(state, data) {
        const notificationsArray = state.notificationsList.map(element => element.id);
        let isCreated = state.notificationsList[notificationsArray.indexOf(data.id)];

        if (data.action == 'create' || data.action == 'update') {
            if (isCreated == undefined) {
                state.notificationsList.push({ id: data.id, text: data.text, type: data.type });
            } else {
                isCreated.text = data.text, isCreated.type = data.type;
            }
        } else if (data.action == 'delete' && isCreated) {
            state.notificationsList.splice(notificationsArray.indexOf(data.id), 1);
        }
    }
}

export default { namespaced: true, state, actions, mutations }