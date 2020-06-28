import nui from '../../utils/nui';

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
    stopTaskbar(state) {
        state.commit('stopTaskbar');
    },
    setSkillbar(state, data) {
        state.commit('setSkillbar', data);
    },
    moveStick(state, data) {
        state.commit('moveStick', data);
    },
    stopIntervals(state) {
        state.commit('stopIntervals');
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

                nui.send('finishedTask');
            }
        }, data.time);
    },
    stopTaskbar(state) {
        clearInterval(state.taskbarInfo.interval);

        state.taskbarInfo.status = false;
    },
    setSkillbar(state, data) {
        state.skillbarInfo.status = true, state.skillbarInfo.difficulty.status = data.difficulty, state.skillbarInfo.skillbarWidth = window.innerWidth * 0.125;

        switch (data.difficulty) {
            case 1:
                state.skillbarInfo.difficulty.percentage = 0.2, state.skillbarInfo.difficulty.movement = 0.10;
                state.skillbarInfo.rectangle.width = state.skillbarInfo.skillbarWidth * 0.30, state.skillbarInfo.rectangle.left = Math.random() * (((state.skillbarInfo.skillbarWidth - state.skillbarInfo.rectangle.width) - 15) - 15) + 15;
                break;
            case 2:
                state.skillbarInfo.difficulty.percentage = 0.5, state.skillbarInfo.difficulty.movement = 0.20;
                state.skillbarInfo.rectangle.width = state.skillbarInfo.skillbarWidth * 0.20, state.skillbarInfo.rectangle.left = Math.random() * (((state.skillbarInfo.skillbarWidth - state.skillbarInfo.rectangle.width) - 15) - 15) + 15;
                break;
            case 3:
                state.skillbarInfo.difficulty.percentage = 0.8, state.skillbarInfo.difficulty.movement = 0.40;
                state.skillbarInfo.rectangle.width = state.skillbarInfo.skillbarWidth * 0.10, state.skillbarInfo.rectangle.left = Math.random() * (((state.skillbarInfo.skillbarWidth - state.skillbarInfo.rectangle.width) - 15) - 15) + 15;
                break;
            default:
                break;
        }

        state.skillbarInfo.mainInterval = setInterval(() => {
            const randomValue = (Math.random() * (state.skillbarInfo.difficulty.percentage - 0.0) + 0.0) * state.skillbarInfo.rectangle.width;
            let movementPrediction = Math.random() < 0.5 ? parseInt(state.skillbarInfo.left) - randomValue : parseInt(state.skillbarInfo.left) + randomValue;

            if (movementPrediction < 0 && state.skillbarInfo.left > 0) {
                movementPrediction = 0;
            } else if (movementPrediction > state.skillbarInfo.skillbarWidth - 8 && state.skillbarInfo.left < state.skillbarInfo.skillbarWidth - 8) {
                movementPrediction = state.skillbarInfo.skillbarWidth - 8;
            }

            if (movementPrediction >= 0 && movementPrediction <= state.skillbarInfo.skillbarWidth - 8) {
                state.skillbarInfo.left = movementPrediction;
            }
        }, 750);

        let timer = 0;

        state.skillbarInfo.timerInterval = setInterval(() => {
            timer++;

            if (state.skillbarInfo.left >= state.skillbarInfo.rectangle.left && state.skillbarInfo.left <= (state.skillbarInfo.rectangle.left + state.skillbarInfo.rectangle.width)) {
                state.skillbarInfo.counter++;

                if (state.skillbarInfo.counter == data.maxSeconds) {
                    console.log('ganhaste: ' + state.skillbarInfo.counter++)
                    state.skillbarInfo.status = false;

                    clearInterval(state.skillbarInfo.interval);
                }
            } else if (state.skillbarInfo.counter != 0) {
                state.skillbarInfo.counter = 0;
            }

            if (timer == data.timer) {
                state.commit('stopIntervals');
            }
        }, 1000);
    },
    moveStick(state, data) {
        const randomValue = state.skillbarInfo.difficulty.movement * state.skillbarInfo.rectangle.width;
        let movementPrediction = data == 'left' ? Math.floor(parseInt(state.skillbarInfo.left) - randomValue) : Math.floor(parseInt(state.skillbarInfo.left) + randomValue);

        if (movementPrediction < 0 && state.skillbarInfo.left > 0) {
            movementPrediction = 0;
        } else if (movementPrediction > state.skillbarInfo.skillbarWidth - 8 && state.skillbarInfo.left < state.skillbarInfo.skillbarWidth - 8) {
            movementPrediction = state.skillbarInfo.skillbarWidth - 8;
        }

        if (movementPrediction >= 0 && movementPrediction <= state.skillbarInfo.skillbarWidth - 8) {
            state.skillbarInfo.left = movementPrediction;
        }
    },
    stopIntervals(state) {
        state.skillbarInfo.status = false;

        clearInterval(state.skillbarInfo.mainInterval);
        clearInterval(state.skillbarInfo.timerInterval);
    }
}

export default { namespaced: true, state, actions, mutations }