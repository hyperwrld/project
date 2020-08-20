<template>
    <v-container>
        <div class='vehicle-shop'>
            <div class='menu-title'>COMPRA DE VEÍCULOS</div>

            <!-- <div class='vehicle-class'>
                <div class='button' v-for='(vehicleClass, index) in categoryList' :item='vehicleClass' :key='index'>{{ vehicleClass.name }}</div>

                <div class='close'>SAIR</div>
            </div> -->
            <div class='vehicle-list'>
                <div class='class'>DESPORTIVOS</div>
                    <v-list-item-group class='list'>
                        <v-list-item v-for="(item, i) in vehicleList" :key="i">
                            <v-list-item-content>
                                {{ item.name }}
                            </v-list-item-content>
                        </v-list-item>
                    </v-list-item-group>
                <div class='button-back'>VOLTAR</div>
            </div>
        </div>
        <div class='vehicle-stats'>
            <div class='stats-title'>ESTATÍSTICAS</div>

            <div class='speed'>
                <div class='name'>VELOCIDADE</div>
                <div class='percentage'>90%</div>
            </div>
            <div class='aceleration'>
                <div class='name'>ACELERAÇÃO</div>
                <div class='percentage'>70%</div>
            </div>
            <div class='brakes'>
                <div class='name'>TRAVÃO</div>
                <div class='percentage'>65%</div>
            </div>
            <div class='control'>
                <div class='name'>CONTROLO</div>
                <div class='percentage'>80%</div>
            </div>

            <div class='vehicle-info'>
                <div class='traction'>
                    <div class='name'>TRAÇÃO</div>
                    <div class='text'>RWD</div>
                </div>
                <div class='stock'>
                    <div class='name'>STOCK</div>
                    <div class='text'>INDISPONÍVEL</div>
                </div>
                <div class='price'>
                    <div class='name'>PREÇO</div>
                    <div class='text'>1.000.000€</div>
                </div>
            </div>
        </div>
    </v-container>
</template>

<script>
    import { mapState } from 'vuex';

    export default {
        name: 'vehicleshop',
        computed: {
            ...mapState({
                vehicleClasses: state => state.vehicleshop.vehicleClasses,
                vehicleList: state => state.vehicleshop.vehicleList
            })
        },
        data() {
            return {
                categoryList: {
                    [1]: 'COMPACTOS', [2]: 'COUPES', [3]: 'BICICLETAS', [4]: 'MOTOS',
                    [5]: 'MUSCLE', [6]: 'OFF-ROAD', [7]: 'SEDANS', [8]: 'DESPORTIVOS',
                    [9]: 'DESPORTIVOS CLÁSSICOS', [10]: 'SUPER', [11]: 'SUV', [12]: 'VANS'
                }
            }
        }
    };
</script>

<style scoped lang='scss'>
    @import './vehicleshop.scss';
</style>