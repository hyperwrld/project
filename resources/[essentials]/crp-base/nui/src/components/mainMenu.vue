<template>
    <v-row align='center' justify='center' style='height: fit-content;'>
        <v-card class='mainMenu'>
            <v-card-text class='mainDiv'>
                <div class='loading' v-if='isLoading'>
                    <div class='multi-ripple'>
                        <div></div>
                        <div></div>
                    </div>
                    <p>Aguarde enquanto carregamos os seus personagens...</p>
                </div>
                <div class='characterList'>
                    <v-hover v-for='(character, index) in charactersData' :item='character' :key='index'>
                        <v-card v-if='!character.option' :ripple='false' class='character' slot-scope='{ hover }' :class='[ { "active": currentItem == index }, hover ? "on-hover" : "not-hover"]' @click='currentItem = index'>
                            <v-card-text class='characterName'>
                                {{ character.firstname + ' ' + character.lastname }}
                            </v-card-text>
                            <v-card-actions v-if='currentItem === index'>
                                <v-spacer></v-spacer>
                                <v-btn :ripple='false' icon @click='isShowingInfo = !isShowingInfo'>
                                    <v-icon>{{ isShowingInfo ? 'fa-angle-up' : 'fa-angle-down' }}</v-icon>
                                </v-btn>
                            </v-card-actions>
                        </v-card>
                        <v-card v-else :ripple='false' class='character' slot-scope='{ hover }' :class='[ { "active": currentItem == index }, hover ? "on-hover" : "not-hover"]' @click='currentItem = index'>
                            <v-card-text class='characterName'>
                                {{ character.name }}
                            </v-card-text>
                        </v-card>
                    </v-hover>
                </div>
            </v-card-text>
            <v-card-text class='characterInfo' v-if='isShowingInfo'>
                <div class='textBox'>
                    <div style='width:50%; float:left;'>
                        <p><b>Nome:</b> {{ charactersData[currentItem].firstname + ' ' + charactersData[currentItem].lastname }}</p>
                        <p><b>Data de nascimento:</b> {{ charactersData[currentItem].dob }}</p>
                        <p><b>Sexo:</b> {{ charactersData[currentItem].gender }}</p>
                        <p><b>Profissão:</b> {{ charactersData[currentItem].job }}</p>
                        <p><b>Dinheiro:</b> {{ charactersData[currentItem].money }}</p>
                        <p><b>Banco:</b> {{ charactersData[currentItem].bank }}</p>
                    </div>
                    <div style='width:50%; float:right;'>
                        <p><b>História:</b> {{ charactersData[currentItem].story }}</p>
                        <p><b>Número de telemóvel:</b> {{ charactersData[currentItem].phone }}</p>
                    </div>
                </div>
            </v-card-text>
            <v-card-actions class='buttons'>
                <v-btn depressed class='disconnect'>Desconectar</v-btn>
                <v-spacer></v-spacer>
                <div v-if='!isLoading && (charactersData[currentItem] && !charactersData[currentItem].option)'>
                    <v-btn depressed class='select'>Selecionar</v-btn>
                    <v-btn depressed class='delete'>Apagar</v-btn>
                </div>
                <div v-else-if='!isLoading'>
                    <v-dialog v-model='dialogVisible' persistent max-width="500px">
                        <template v-slot:activator="{ on, attrs }">
                            <v-btn depressed v-bind="attrs" v-on="on" class='create'>Criar</v-btn>
                        </template>
                        <v-card>
                            <v-card-title>
                                Criação de Personagem
                            </v-card-title>
                            <v-divider></v-divider>
                            <v-card-text>
                                <v-container>
                                    <v-row>
                                        <v-col cols='12' sm='6'>
                                            <v-text-field v-model='dialogData.firstname' label='Primeiro nome' filled></v-text-field>
                                        </v-col>
                                        <v-col cols='12' sm='6'>
                                            <v-text-field v-model='dialogData.lastname' label='Último nome' filled></v-text-field>
                                        </v-col>
                                        <v-col cols='12' sm='6'>
                                            <v-menu
                                                ref='datePicker'
                                                v-model='datePicker'
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
                                                <v-date-picker v-model='dialogData.dob' no-title locale='pt-pt' min='1920-01-01' max='2002-01-01' scrollable>
                                                    <v-spacer></v-spacer>
                                                    <v-btn text color='primary' @click='datePicker = false'>Cancelar</v-btn>
                                                    <v-btn text color='primary' @click='datePicker = false'>Salvar</v-btn>
                                                </v-date-picker>
                                            </v-menu>
                                        </v-col>
                                        <v-col cols='12' sm='6'>
                                            <v-select :items='["Masculino", "Feminino"]' v-model='dialogData.gender' filled label='Sexo'></v-select>
                                        </v-col>
                                        <v-col cols='12'>
                                            <v-textarea filled label='História' v-model='dialogData.story'></v-textarea>
                                        </v-col>
                                    </v-row>
                                </v-container>
                            </v-card-text>
                            <v-divider></v-divider>
                            <v-card-actions>
                                <v-spacer></v-spacer>
                                <v-btn color='error' text @click='dialogVisible = false'>Fechar</v-btn>
                                <v-btn text @click='handleSave'>Salvar</v-btn>
                            </v-card-actions>
                        </v-card>
                    </v-dialog>
                </div>
            </v-card-actions>
        </v-card>
        <v-card class='serverInfo' :class='isShowingInfo ? "bigger" : "normal"'>
            <v-card-text>
                <div class='post'>
                    <h3>Update 14/06/2020</h3>
                    <v-divider></v-divider>
                    <p>[RENDERING]<br>– Texture streaming now loads textures flagged with no mip maps or no lod at full initial resolution.</p>
                    <p>[MAPS]<br>Chlorine<br>-Added missing glowy eyes texture</p>
                    <p>Anubis
                        <br>-Fixed many minor issues such as z fighting, prop reflections and invisible faces
                        <br>-Improved player readability at canal
                        <br>-Improved performance
                        <br>-Redesigned B main path &amp; entrance
                        <br>-Moved up CT spawn</p>
                </div>
                <div class='post'>
                    <h3>Update 13/06/2020</h3>
                    <v-divider></v-divider>
                    <p>[GAMEPLAY]<br>– Added the ‘Boost Player Contrast’ advanced video setting, which improves the legibility of players in low contrast situations.</p>
                    <p>[AGENTS]<br>– Adjusted some agent textures for improved visibility.</p>
                    <p>[MISC]<br>– Adjusted dropped C4 collision geometry.
                    <br>– Fixed Danger Zone drone pilot camera getting stuck when drone received burn damage.
                    <br>– Added Desert Eagle shell eject event for last bullet fired.</p>
                </div>
            </v-card-text>
        </v-card>
    </v-row>
</template>

<script>
    import nui from '../utils/nui';

    export default {
        name: 'mainMenu',
        props: {
            isLoading: Boolean,
            currentComponent: String,
            charactersData: Array,
        },
        computed: {
            computedFormatDate() {
                return this.formatDate(this.dialogData.dob)
            }
        },
        data() {
            return {
                currentItem: 0,
                isShowingInfo: false,
                dialogVisible: false,
                dialogData: {},
                datePicker: false,
            }
        },
        methods: {
            handleSave: function() {
                let errorMessage = '';

                if (!this.dialogData.firstname || (this.dialogData.firstname.length > 10 || this.dialogData.firstname.length == 0)) {
                    errorMessage = 'Escolha um primeiro nome entre 1 a 10 caracteres.';
                } else if (!this.dialogData.lastname || (this.dialogData.lastname.length > 10 || this.dialogData.lastname.length == 0)) {
                    errorMessage = 'Escolha um segundo nome entre 1 a 10 caracteres.';
                } else if (!this.dialogData.dob || this.dialogData.dob.length == 0) {
                    errorMessage = 'Selecione uma this.dialogData de nascimento para o seupersonagem.';
                } else if (this.dialogData.gender != 'Masculino' && this.dialogData.gender != 'Feminino') {
                    errorMessage = 'Selecione o sexo do seu personagem.';
                } else if (!this.dialogData.story || (this.dialogData.story.length > 500 || this.dialogData.story.length < 100)) {
                    errorMessage = 'A história do seu personagem pode ter no mínimo 100 caracteres e no máximo 500 caracteres.';
                }

                if (errorMessage.length > 0) {
                    nui.send({ error: true, errorMessage: errorMessage });
                } else {
                    nui.send({ createCharacter: true, character: {
                        firstname: this.dialogData.firstname, lastname: this.dialogData.lastname,
                        dob: this.formatDate(this.dialogData.dob), gender: this.dialogData.gender, story: this.dialogData.story
                    }}).then(data => {
                        if (data.status) {
                            this.dialogVisible = false;
                        }
                    });
                }
            },
            formatDate (date) {
                if (!date) return null

                const [year, month, day] = date.split('-')

                return `${day}/${month}/${year}`
            },
        }
    };
</script>

<style scoped lang='scss'>
    @import url('https://fonts.googleapis.com/css2?family=Quantico&display=swap');

    .mainMenu {
        border-radius: 0% !important;
        height: 100%;
        width: 40%;
        background-color: black;
        font-family: 'Quantico', sans-serif;

        .mainDiv {
            display: flex;
            flex-direction: row;
            width: 100%;
            height: 22vh;
            background-color: rgb(12, 12, 12);
            bottom: 2%;

            .characterList {
                display: flex;
                flex-direction: row;
                width: 100%;
                height: 100%;
                background-color: rgb(12, 12, 12);
                bottom: 2%;
                overflow-x: auto;
                overflow-y: hidden;

                .character {
                    height: 98% !important;
                    width: 22%;
                    padding: 1% !important;
                    margin-left: 2%;
                    border: 1px solid #272727 !important;
                    border-radius: 2px !important;
                    box-shadow: 0px 0px 5px 0px black;
                    color: white !important;
                    background: transparent;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    background-color: transparent !important;

                    .v-card__actions {
                        width: 100%;
                        bottom: 0;
                        padding: 0;
                        height: 15%;
                        position: absolute;

                        .v-btn:before, .v-btn:after {
                            background-color: transparent;
                        }

                        button > span > i {
                            font-size: 20px;
                        }
                    }

                    & > *, & > .v-card__actions > button {
                        color: rgb(166, 166, 166) !important;
                    }

                    &:first-child {
                        margin-left: 0%;
                    }

                    .characterName {
                        text-align: center;
                        word-spacing: 100vw;
                    }
                }

                .not-hover {
                    border-color: #272727 !important;
                }

                .active {
                    border-color: white !important;
                }

                .on-hover {
                    border-color: #2577fa !important;
                }

                &::-webkit-scrollbar {
                    height: 2%
                }

                &::-webkit-scrollbar-thumb {
                    background-color: rgb(27, 27, 27);
                    border-radius: 1px;
                }

                &::-webkit-scrollbar-button {
                    display: none
                }
            }

            .loading {
                text-align: center;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                width: 100%;

                p {
                    color: white;
                }

                .multi-ripple {
                    width: 2.6rem;
                    height: 2.6rem;
                    margin: 2rem;

                    div {
                        position: absolute;
                        width: 2rem;
                        height: 2rem;
                        border-radius: 50%;
                        border: 0.3rem solid #979fd0;
                        animation: 1.5s ripple infinite;

                        &:nth-child(2) {
                            animation-delay: 0.5s;
                        }
                    }
                }

                @keyframes ripple {
                    from {
                        transform: scale(0);
                        opacity: 1;
                    }

                    to {
                        transform: scale(1);
                        opacity: 0;
                    }
                }
            }
        }

        .characterInfo {
            flex-shrink: 0;
            width: 100%;
            overflow-y: hidden;
            background-color: rgb(166, 166, 166);
            padding: 1.5%;
            border-radius: 2px;
            height: 22vh;

            .textBox {
                overflow: auto;
                max-height: 100%;
                height: 100%;
                color: rgb(12, 12, 12);

                &::-webkit-scrollbar {
                    width: 0.5%
                }

                &::-webkit-scrollbar-thumb {
                    background-color: rgb(12, 12, 12);
                    border-radius: 1px;
                }

                &::-webkit-scrollbar-button {
                    display: none
                }
            }
        }

        .buttons {
            background-color: rgb(27, 27, 27);
            height: fit-content;

            button {
                border-radius: 2px;
                background-color: rgb(12, 12, 12) !important;
                color: rgb(166, 166, 166) !important;
                height: 28px !important;
                margin-left: 5px;

                &:hover {
                    color: white !important;
                }
            }

            .disconnect {
                color: white !important;
                background-color: #B71C1C !important;
                margin-left: 0;

                &:hover {
                    color: rgb(166, 166, 166) !important;
                }
            }
        }
    }

    .serverInfo {
        border-radius: 0% !important;
        width: 20%;
        margin-left: 1%;
        font-family: 'Quantico', sans-serif;
        background-color: rgb(12, 12, 12) !important;
        color: #a6a6a6 !important;
        height: 26.073518518518515vh; // 30.052721451440767

        .v-card__text {
            overflow-y: auto;
            height: 100%;

            .post {
                color: #a6a6a6;

                h3 {
                    text-align: center;
                }

                p {
                    font-size: 0.575rem;
                }

                .v-divider {
                    background-color: #a6a6a6 !important;
                    margin-bottom: 1px;
                }
            }

            &::-webkit-scrollbar {
                width: 1%
            }

            &::-webkit-scrollbar-thumb {
                background-color: #a6a6a6;
                border-radius: 1px;
            }

            &:-webkit-scrollbar-button {
                display: none
            }
        }
    }

    .normal {
        height: 26.073518518518515vh;
    }

    .bigger {
        height: 48.073518518518515vh;
    }
</style>