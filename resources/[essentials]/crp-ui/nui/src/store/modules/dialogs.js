const state = () => ({
    dialogsData: {
        'deleteCharacter': { status: false },
        'createCharacter': { status: false, data: {}, datePicker: false },
    }
})

const getters = {
    getDeleteCharacterStatus: state => {
        return state.dialogsData['deleteCharacter'].status;
    },
    getCreateCharacterStatus: state => {
        return state.dialogsData['createCharacter'].status;
    },
    getCreateCharacter: state => {
        return state.dialogsData['createCharacter'];
    }
}

const actions = {
    setDialogStatus(state, data) {
        state.commit('setDialogStatus', data);
    }
}

const mutations = {
    setDialogStatus(state, data) {
        if (state.dialogsData[data.name]) {
            state.dialogsData[data.name].status = data.status;
        } else {
            state.dialogsData[data.name] = { status: data.status };
        }

        if (data.reset) {
            state.dialogsData[data.name].data = {};
        }
    }
}

export default { namespaced: true, state, getters, actions, mutations }