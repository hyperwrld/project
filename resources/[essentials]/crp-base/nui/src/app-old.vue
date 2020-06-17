<template>
    <div id='app'>
        <v-app id='inspire'>
            <v-content>
                <v-container class='fill-height' fluid>
                    <v-row align='center' justify='center' style='height: fit-content;'>
                        <transition name="fade">
                            <v-card class='mainMenu'>
                                <v-card-text class='mainDiv'>
                                    <div class='loading' v-if='isLoading'>
                                        <div class='multi-ripple'>
                                            <div></div>
                                            <div></div>
                                        </div>
                                        <p>Aguarde enquanto carregamos os seus personagens...</p>
                                    </div>
                                    <div class='characterList' v-else>
                                        <v-hover>
                                            <v-card class='character active' slot-scope='{ hover }' :class="`${ hover ? 'on-hover': 'not-hover'}`">
                                                <v-card-text class='characterName'>
                                                    Lewis Hamilton
                                                </v-card-text>
                                                <v-card-actions>
                                                    <v-spacer></v-spacer>
                                                    <v-btn icon @click='show = !show'>
                                                        <v-icon>{{ 'fa-angle-down' }}</v-icon>
                                                    </v-btn>
                                                </v-card-actions>
                                            </v-card>
                                        </v-hover>
                                        <v-card class='character'>
                                            <v-card-text class='characterName'>
                                                João Teixeira
                                            </v-card-text>
                                        </v-card>
                                        <v-card class='character'>
                                            <v-card-text class='characterName'>
                                                Rui Oliveira
                                            </v-card-text>
                                        </v-card>
                                        <v-card class='character'>
                                            <v-card-text class='characterName'>
                                                Miguel Teixeira
                                            </v-card-text>
                                        </v-card>
                                        <v-card class='character'>
                                            <v-card-text class='characterName'>
                                                Joana Almeida
                                            </v-card-text>
                                        </v-card>
                                    </div>
                                </v-card-text>
                                <v-card-text class='characterInfo'>
                                    <div class='textBox'>
                                        <div style='width:50%; float:left;'>
                                            <p><b>Nome:</b> Lewis Hamilton</p>
                                            <p><b>Data de nascimento:</b> 08/03/1999</p>
                                            <p><b>Sexo:</b> Masculino</p>
                                            <p><b>Profissão:</b> Polícia</p>
                                            </div>
                                        <div style='width:50%; float:right;'>
                                            <p><b>História:</b> História (do grego antigo ἱστορία, transl.: historía, que significa 'pesquisa', 'conhecimento advindo da investigação')[1] é a ciência que estuda o ser humano e sua ação no tempo e no espaço concomitantemente à análise de processos e eventos ocorridos no passado. O termo 'História' também pode significar toda a informação do passado arquivada em todas as línguas por todo o mundo, por intermédio de registos históricos.
                                            História (do grego antigo ἱστορία, transl.: historía, que significa 'pesquisa', 'conhecimento advindo da investigação')[1] é a ciência que estuda o ser humano e sua ação no tempo e no espaço concomitantemente à análise de processos e eventos ocorridos no passado. O termo 'História' também pode significar toda a informação do passado arquivada em todas as línguas por todo o mundo, por intermédio de registos históricos.</p>
                                            <p><b>Carteira:</b> ...</p>
                                        </div>
                                    </div>
                                </v-card-text>
                                <v-card-actions class='buttons'>
                                    <v-btn depressed class='disconnect'>Desconectar</v-btn>
                                    <v-spacer></v-spacer>
                                    <v-btn depressed class='select' v-if='!isLoading'>Selecionar</v-btn>
                                    <v-btn depressed class='delete' v-if='!isLoading'>Apagar</v-btn>
                                </v-card-actions>
                            </v-card>
                        </transition>
                        <v-card class='serverInfo'>
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
                </v-container>
            </v-content>
        </v-app>
    </div>
</template>

<script>
    export default {
        name: 'App',
        components: {
        },
        data() {
            return {
                isLoading: true,
                loadingText: 'Aguarde enquanto carregamos os personagens...',
            }
        },
    };
</script>

<style lang='scss'>
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
            display: none;
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

                &:hover {
                    color: white !important;
                }
            }

            .disconnect {
                color: white !important;
                background-color: #B71C1C !important;

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
        height: 26.695vh;

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
</style>