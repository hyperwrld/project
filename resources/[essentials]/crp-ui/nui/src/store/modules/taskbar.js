const state = () => ({
    taskbarInfo: { status: false, text: '...', progress: 0, interval: null }
})

const actions = {
    setTaskbar(state, data) {
        state.commit('setTaskbar', data);
    }
}

const mutations = {
    setTaskbar(state, data) {
        if (state.taskbarInfo.status) {
            return;
        }

        state.taskbarInfo.status = true, state.taskbarInfo.progress = 0, state.taskbarInfo.text = data.text;

        state.taskbarInfo.interval = setInterval(() => {
            state.taskbarInfo.progress++;

            if (state.taskbarInfo.progress == 100) {
                clearInterval(state.taskbarInfo.interval);

                state.taskbarInfo.status = false;
            }
        }, data.time);
    }
}

export default { namespaced: true, state, actions, mutations }