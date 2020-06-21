<template>
    <v-container class='fill-height' fluid>
        <v-row align='center' justify='center' style='height: fit-content;'>
            <v-card class='mainMenu'>
                <v-card-text class='mainDiv'>
                    <div class='loading' v-if='loadingData.status'>
                        <div class='multi-ripple'>
                            <div></div>
                            <div></div>
                        </div>
                        <p>{{ loadingData.message }}</p>
                    </div>
                    <div class='characterList' v-else>
                        <v-hover v-for='(character, index) in charactersData' :item='character' :key='index'>
                            <v-card v-if='!character.option' :ripple='false' class='character' slot-scope='{ hover }' :class='[ { "active": currentItem == index }, hover ? "on-hover" : "not-hover"]' @click='handleChangeItem(index)'>
                                <v-card-text class='characterName'>
                                    {{ character.firstname + ' ' + character.lastname }}
                                </v-card-text>
                                <v-card-actions v-if='currentItem === index'>
                                    <v-spacer></v-spacer>
                                    <v-btn :ripple='false' icon @click='isShowingInfo = !isShowingInfo'>
                                        <font-awesome-icon icon='angle-up' v-if='isShowingInfo'></font-awesome-icon>
                                        <font-awesome-icon icon='angle-down' v-else></font-awesome-icon>
                                    </v-btn>
                                </v-card-actions>
                            </v-card>
                            <v-card v-else :ripple='false' class='character' slot-scope='{ hover }' :class='[ { "active": currentItem == index }, hover ? "on-hover" : "not-hover"]' @click='handleChangeItem(index)'>
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
                            <p><b>Profissão:</b> {{ JSON.parse(charactersData[currentItem].job).name }}</p>
                            <p><b>Dinheiro:</b> {{ charactersData[currentItem].money + '€' }}</p>
                            <p><b>Banco:</b> {{ charactersData[currentItem].bank + '€' }}</p>
                        </div>
                        <div style='width:50%; float:right;'>
                            <p><b>História:</b> {{ charactersData[currentItem].story }}</p>
                            <p><b>Número de telemóvel:</b> {{ charactersData[currentItem].phone }}</p>
                        </div>
                    </div>
                </v-card-text>
                <v-card-actions class='buttons'>
                    <v-btn depressed class='disconnect' @click='handleDisconnect'>Desconectar</v-btn>
                    <v-spacer></v-spacer>
                    <div v-if='!loadingData.status && (charactersData[currentItem] && !charactersData[currentItem].option)'>
                        <v-btn depressed class='select' @click='handleCharacterSelection'>Selecionar</v-btn>
                        <v-btn depressed class='delete' @click='$store.dispatch("dialogs/setDialogStatus", { name: "deleteCharacter", status: true })'>Apagar</v-btn>
                    </div>
                    <div v-else-if='!loadingData.status'>
                        <v-btn depressed class='create' @click='$store.dispatch("dialogs/setDialogStatus", { name: "createCharacter", status: true })'>Criar</v-btn>
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
    </v-container>
</template>

<script>
    import { mapState } from 'vuex'
    import nui from '../../utils/nui';

    export default {
        name: 'character',
        computed: {
            ...mapState({
                charactersData: state => state.character.userCharacters,
                currentItem: state => state.character.currentItem,
                loadingData: state => state.character.loading
            }),
        },
        methods: {
            handleDisconnect: function() {
                nui.send({ disconnect: true });
            },
            handleChangeItem: function(index) {
                if (this.currentItem != index) {
                    this.isShowingInfo = false;

                    this.$store.dispatch('character/setCurrentItem', index);
                }
            },
            handleCharacterSelection: function() {
                this.$store.dispatch('character/selectCharacter');
            }
        },
        data() {
            return {
                isShowingInfo: false
            }
        }
    };
</script>

<style scoped lang='scss'>
    @import url('./character.scss');
</style>