const state = () => ({
    taskbarInfo: { status: false, text: '...', progress: 0, interval: null },
    skillbarInfo: {
        status: false, left: 0, skillbarWidth: 0, interval: null, counter: 0,
        rectangle: {
            width: 0, left: 0
        },
        difficulty: {
            state: 1, percentage: 0.2, movement: 0.1
        }
    }
})

const actions = {
    setTaskbar(state, data) {
        state.commit('setTaskbar', data);
    },
    setSkillbar(state, data) {
        state.commit('setSkillbar', data);
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
        state.skillbarInfo.status = true, state.skillbarInfo.difficulty.status = data.difficulty, state.skillbarInfo.skillbarWidth = window.innerWidth * 0.125;

        switch (data.difficulty) {
            case 1:
                state.skillbarInfo.difficulty.percentage = 0.2, state.skillbarInfo.difficulty.movement = 0.10;
                state.skillbarInfo.rectangle.width = state.skillbarInfo.skillbarWidth * 0.30, state.skillbarInfo.rectangle.left = Math.random() * ((state.skillbarInfo.skillbarWidth - state.skillbarInfo.rectangle.width) - 0) + 0;
                break;
            case 2:
                state.skillbarInfo.difficulty.percentage = 0.5, state.skillbarInfo.difficulty.movement = 0.25;
                state.skillbarInfo.rectangle.width = state.skillbarInfo.skillbarWidth * 0.15, state.skillbarInfo.rectangle.left = Math.random() * ((state.skillbarInfo.skillbarWidth - state.skillbarInfo.rectangle.width) - 0) + 0;
                break;
            case 3:
                state.skillbarInfo.difficulty.percentage = 0.8, state.skillbarInfo.difficulty.movement = 0.40;
                state.skillbarInfo.rectangle.width = state.skillbarInfo.skillbarWidth * 0.05, state.skillbarInfo.rectangle.left = Math.random() * ((state.skillbarInfo.skillbarWidth - state.skillbarInfo.rectangle.width) - 0) + 0;
                break;
            default:
                break;
        }

        let timer = 0;

        state.skillbarInfo.interval = setInterval(() => {
            const randomValue = (Math.random() * (state.skillbarInfo.difficulty.percentage - 0.0) + 0.0) * state.skillbarInfo.rectangle.width;
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

            if (state.skillbarInfo.left >= state.skillbarInfo.rectangle.left && state.skillbarInfo.left <= (state.skillbarInfo.rectangle.left + state.skillbarInfo.rectangle.width)) {
                state.skillbarInfo.counter++;

                if (state.skillbarInfo.counter / 10 == data.maxSeconds) {
                    console.log('ganhaste: ' + state.skillbarInfo.counter++)
                    state.skillbarInfo.status = false;

                    clearInterval(state.skillbarInfo.interval);
                }
            } else if (state.skillbarInfo.counter != 0) {
                state.skillbarInfo.counter = 0;
            }
        }, 100);
    },
    moveStick(state, data) {
        const randomValue = state.skillbarInfo.difficulty.movement * state.skillbarInfo.rectangle.width;
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