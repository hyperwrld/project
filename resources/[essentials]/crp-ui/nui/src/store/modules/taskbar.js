const state = () => ({
    taskbarInfo: { status: false, text: '...', progress: 0, interval: null },
    skillbarInfo: {
        status: false, left: 0, skillbarWidth: 0, rectangleWidth: 0, interval: null,
        difficulty: { state: 1, percentage: 0.2, movement: 0.1 }
    }
})

const actions = {
    setTaskbar(state, data) {
        state.commit('setTaskbar', data);
    },
    setSkillbar(state, data) {
        state.commit('setSkillbar', data);
    },
    setSkillbarWidth(state, data) {
        state.commit('setSkillbarWidth', data);
    },
    moveStick(state, data) {
        state.commit('moveStick', data);
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
    },
    setSkillbar(state, data) {
        state.skillbarInfo.status = true, state.skillbarInfo.difficulty.status = data.difficulty

        switch (data.difficulty) {
            case 1:
                state.skillbarInfo.difficulty.percentage = 0.2, state.skillbarInfo.difficulty.movement = 0.1;
                break;
            case 2:
                state.skillbarInfo.difficulty.percentage = 0.5, state.skillbarInfo.difficulty.movement = 0.25;
                break;
            case 3:
                state.skillbarInfo.difficulty.percentage = 0.8, state.skillbarInfo.difficulty.movement = 0.4;
                break;
            default:
                break;
        }

        let timer = 0

        state.skillbarInfo.interval = setInterval(() => {
            const randomValue = (Math.random() * (state.skillbarInfo.difficulty.percentage - 0.0) + 0.0) * state.skillbarInfo.rectangleWidth;
            const movementPrediction = Math.random() < 0.5 ? parseInt(state.skillbarInfo.left) - randomValue : parseInt(state.skillbarInfo.left) + randomValue;

            timer++;

            if (movementPrediction < 0 || movementPrediction > state.skillbarInfo.skillbarWidth - 2) {
                state.skillbarInfo.status = false;

                clearInterval(state.skillbarInfo.interval);
            } else {
                state.skillbarInfo.left = movementPrediction;

                if (timer == data.timer) {
                    state.skillbarInfo.status = false;

                    clearInterval(state.skillbarInfo.interval);
                }
            }
        }, 1000);
    },
    setSkillbarWidth(state, data) {
        state.skillbarInfo.skillbarWidth = data.skillbarWidth, state.skillbarInfo.rectangleWidth = data.rectangleWidth;
    },
    moveStick(state, data) {
        const randomValue = state.skillbarInfo.difficulty.movement * state.skillbarInfo.rectangleWidth;
        const movementPrediction = data == 'left' ? parseInt(state.skillbarInfo.left) - randomValue : parseInt(state.skillbarInfo.left) + randomValue;

        if (movementPrediction < 0 || movementPrediction > state.skillbarInfo.skillbarWidth - 2) {
            state.skillbarInfo.status = false;

            clearInterval(state.skillbarInfo.interval);
        } else {
            state.skillbarInfo.left = movementPrediction;
        }
    }
}

export default { namespaced: true, state, actions, mutations }