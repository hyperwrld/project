<template>
    <v-container>
        <v-dialog content-class='dialog' v-model='dialogsData["deleteCharacter"].status' max-width='350'>
            <v-card>
                <v-card-title class='headline'>Tens a certeza que desejas apagar esta personagem?</v-card-title>

                <v-card-actions>
                    <v-spacer></v-spacer>

                    <v-btn color='green darken-1' text @click='$store.dispatch("dialogs/setDialogStatus", { name: "deleteCharacter", status: false })'>
                        Não
                    </v-btn>
                    <v-btn color='green darken-1' text @click='handleCharacterDeletion'>
                        Sim
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
        <v-dialog content-class='dialog' v-model='dialogsData["createCharacter"].status' max-width='500'>
            <v-card>
                <v-card-title>
                    Criação de Personagem
                </v-card-title>
                <v-divider></v-divider>
                <v-card-text>
                    <v-container>
                        <v-row>
                            <v-col cols='12' sm='6'>
                                <v-text-field v-model='dialogsData["createCharacter"].data.firstname' label='Primeiro nome' counter='10' filled></v-text-field>
                            </v-col>
                            <v-col cols='12' sm='6'>
                                <v-text-field v-model='dialogsData["createCharacter"].data.lastname' label='Último nome' counter='10' filled></v-text-field>
                            </v-col>
                            <v-col cols='12' sm='6'>
                                <v-menu
                                    ref='datePicker'
                                    v-model='dialogsData["createCharacter"].datePicker'
                                    :close-on-content-click='false'
                                    transition='scale-transition'
                                    offset-y
                                    min-width='290px'
                                >
                                    <template v-slot:activator='{ on, attrs }'>
                                        <v-text-field
                                            v-model='computedFormatDate'
                                            label='Data de nascimento'
                                            readonly
                                            filled
                                            v-bind='attrs'
                                            v-on='on'
                                        ></v-text-field>
                                    </template>
                                    <v-date-picker v-model='dialogsData["createCharacter"].data.dob' no-title locale='pt-pt' min='1920-01-01' max='2002-01-01' scrollable>
                                        <v-spacer></v-spacer>
                                        <v-btn text color='primary' @click='dialogsData["createCharacter"].datePicker = false'>Cancelar</v-btn>
                                        <v-btn text color='primary' @click='dialogsData["createCharacter"].datePicker = false'>Salvar</v-btn>
                                    </v-date-picker>
                                </v-menu>
                            </v-col>
                            <v-col cols='12' sm='6'>
                                <v-select :items='["Masculino", "Feminino"]' v-model='dialogsData["createCharacter"].data.gender' filled label='Sexo'></v-select>
                            </v-col>
                            <v-col cols='12'>
                                <v-textarea filled no-resize counter='500' label='História' v-model='dialogsData["createCharacter"].data.story'></v-textarea>
                            </v-col>
                        </v-row>
                    </v-container>
                </v-card-text>
                <v-divider></v-divider>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color='error' text @click='$store.dispatch("dialogs/setDialogStatus", { name: "createCharacter", status: false })'>Fechar</v-btn>
                    <v-btn text @click='handleCharacterCreation'>Salvar</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-container>
</template>

<script>
    import nui from '../utils/nui';
    import { mapState } from 'vuex';

    export default {
        name: 'dialogs',
        computed: {
            ...mapState({
                dialogsData: state => state.dialogs.dialogsData,
            }),
            computedFormatDate() {
                return this.formatDate(this.dialogsData["createCharacter"].data.dob)
            }
        },
        methods: {
            handleCharacterDeletion: function() {
                this.$store.dispatch('dialogs/setDialogStatus', { name: 'deleteCharacter', status: false });
                this.$store.dispatch('character/removeCharacter');
            },
            formatDate: function(date) {
                if (!date) return null

                const [year, month, day] = date.split('-')

                return `${day}/${month}/${year}`
            },
            handleCharacterCreation: function() {
                let errorMessage = '', data = this.dialogsData["createCharacter"].data;

                if (!data.firstname || (data.firstname.length > 10 || data.firstname.length == 0)) {
                    errorMessage = 'Escolha um primeiro nome entre 1 a 10 caracteres.';
                } else if (!data.lastname || (data.lastname.length > 10 || data.lastname.length == 0)) {
                    errorMessage = 'Escolha um segundo nome entre 1 a 10 caracteres.';
                } else if (!data.dob || data.dob.length == 0) {
                    errorMessage = 'Selecione uma data de nascimento para o seupersonagem.';
                } else if (data.gender != 'Masculino' && data.gender != 'Feminino') {
                    errorMessage = 'Selecione o sexo do seu personagem.';
                } else if (!data.story || (data.story.length > 500 || data.story.length < 100)) {
                    errorMessage = 'A história do seu personagem pode ter no mínimo 100 caracteres e no máximo 500 caracteres.';
                }

                if (errorMessage.length > 0) {
                    nui.send('error', errorMessage);
                } else {
                    nui.send('createCharacter', {
                        firstname: data.firstname, lastname: data.lastname,
                        dob: this.formatDate(data.dob), gender: data.gender, story: data.story
                    }).then(_data => {
                        if (_data.status) {
                            this.$store.dispatch('dialogs/setDialogStatus', { name: 'createCharacter', status: false, reset: true });
                            this.$store.dispatch('character/addCharacter', _data.characterData);
                        }
                    });
                }
            }
        }
    }
</script>