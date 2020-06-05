<template>
    <div v-if="menuType=='mainMenu'">
        <h5 class="title center-align">Garagem</h5>

        <div>
            <div class='button fadeIn animated slower' v-for='(menu, index) in menuList' :item='menu' :key='index'>
                <div class='buttonInfo' :class='{ "active-item": currentItem === index }'>
                    <p class='center-align'>{{ menu.name }}</p>
                </div>
            </div>
        </div>
    </div>
    <div v-else-if="menuType=='vehicleList'">
        <h5 style='width: 50%;' class="title center-align">Lista de veículos</h5>

        <div class="vehicleList">
            <div class="vehicle fadeIn animated slower" v-for="(vehicleInfo, index) in displayVehicles" :item="vehicleInfo" :key="index">
                <div v-if="vehicleInfo.option!='back'" class="vehicleInfo" :class="{ 'active-item': currentItem === index }">
                    <p>{{ JSON.parse(vehicleInfo.vehicle).label + ' [' + vehicleInfo.plate + ']' }}</p>
                    <p v-if="vehicleInfo.status==0">Fora</p>
                    <p style='color: rgb(39, 163, 66)' v-else-if="vehicleInfo.status==1">Dentro</p>
                    <p style='color: rgb(237, 172, 19)' v-else-if="vehicleInfo.status==2">Apreendido</p>
                    <p style='color: rgb(255, 0, 0)' v-else-if="vehicleInfo.status==3">Apreendido (Polícia)</p>
                </div>
                <div v-else class="vehicleInfo" :class="{ 'active-item': currentItem === index }">
                    <p style='text-align: center; width: 100%'>{{ vehicleInfo.label }}</p>
                </div>
                <div v-if="vehicleInfo.option!='back'" class="vehicleStatus" :class="{ 'active-status': currentItem === index }">
                    <p>{{ 'Motor: ' + JSON.parse(vehicleInfo.vehicle).engineDamage + '%' }}</p>
                    <p>{{ 'Chassi: ' + JSON.parse(vehicleInfo.vehicle).bodyDamage + '%' }}</p>
                    <p>{{ 'Gasolina: ' + JSON.parse(vehicleInfo.vehicle).fuel + '%' }}</p>
                </div>
            </div>
        </div>
        <div class='pagination'>
            <button class='left' @click="currentPage--"><i class="material-icons">navigate_before</i></button>
            <p>{{ this.currentPage + ' de ' + this.pages.length }}</p>
            <button class='right' @click="currentPage++"><i class="material-icons">navigate_next</i></button>
        </div>
    </div>
    <div v-else-if="menuType=='spawnVehicle'">
        <h5 class="title center-align">Spawnar</h5>

        <div>
            <div class='button fadeIn animated slower' v-for='(menu, index) in menuList' :item='menu' :key='index'>
                <div class='buttonInfo' :class='{ "active-item": currentItem === index }'>
                    <p class='center-align'>{{ menu.name }}</p>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import nui from '../utils/nui';

    export default {
        name: 'Menu',
        props: {
            menuType: String,
            menuList: Array
        },
        methods: {
            nextItem: function(control) {
                switch (control) {
                    case 13:
                        switch (this.menuType) {
                            case 'mainMenu':
                                switch(this.menuList[this.currentItem].option) {
                                    case 'storeVehicle':
                                        nui.send({ close: true, storeVehicle: true });
                                        break;
                                    case 'vehicleList':
                                        nui.send({ getVehicles: true }).then(data => {
                                            this.menuList = data, this.menuType = 'vehicleList';
                                        });
                                        break;
                                    case 'closeMenu':
                                        nui.send({ close: true });
                                        break;
                                    default:
                                        break;
                                }
                                break;
                            case 'vehicleList':
                                if (this.displayVehicles[this.currentItem].option) {
                                    this.menuList = [{ name: 'Guardar Veículo', option: 'storeVehicle' }, { name: 'Lista de veículos', option: 'vehicleList' }, { name: 'Fechar', option: 'closeMenu' }];
                                    this.menuType = 'mainMenu';
                                } else if (this.displayVehicles[this.currentItem].status == 1) {
                                    this.currentVehicleData = this.displayVehicles[this.currentItem];
                                    this.menuType = 'spawnVehicle', this.menuList = [{ name: 'Spawnar', option: 'spawnVehicle' }, { name: 'Voltar', option: 'back' }];
                                }
                                break;
                            case 'spawnVehicle':
                                if (this.menuList[this.currentItem].option == 'spawnVehicle') {
                                    nui.send({ close: true, spawnVehicle: true, vehicleInfo: this.currentVehicleData });
                                } else {
                                    nui.send({ getVehicles: true }).then(data => {
                                        this.menuList = data, this.menuType = 'vehicleList';
                                    });
                                }
                                break;
                            default:
                                break;
                        }
                        break;
                    case 27:
                        nui.send({ close: true });
                        break;
                    case 37:
                        this.currentPage--;
                        break;
                    case 38:
                        if (this.currentItem > 0) {
                            this.currentItem--;
                        }
                        break;
                    case 39:
                        this.currentPage++;
                        break;
                    case 40:
                        var table = this.menuType == 'vehicleList' ? this.displayVehicles.length : this.menuList.length;

                        if (this.currentItem < table - 1) {
                            this.currentItem++;
                        }
                        break;
                }
            },
            setPages: function() {
                this.pages = [];

                let numberPages = Math.ceil(this.menuList.length / 5);

                for (let i = 1; i <= numberPages; i++) {
                    this.pages.push(i);
                }
            },
            paginate: function() {
                this.currentItem = 0;

                if (this.currentPage < 1) {
                    this.currentPage = 1;
                } else if (this.currentPage > this.pages.length) {
                    this.currentPage = this.pages.length;
                }

                let from = (this.currentPage * 5) - 5;
                let to = (this.currentPage * 5);
                let slice = this.menuList.slice(from, to);

                slice.push({ option: 'back', label: 'Voltar' });

                return slice;
            }
        },
        data() {
            return {
                currentItem: 0,
                currentPage: 1,
                currentVehicleData: [],
                pages: [],
            };
        },
        computed: {
            displayVehicles: function() {
                return this.paginate()
            }
        },
        mounted() {
            document.addEventListener('keyup', this.nextItem);

            this.listener = window.addEventListener('message', (event) => {
                switch(event.data.eventName) {
                    case 'controlPressed':
                        this.nextItem(event.data.control)
                        break;
                }
			}, false);
        },
        watch: {
            'menuType': function() {
                this.currentItem = 0;

                if (this.menuType == 'vehicleList') {
                    this.setPages();
                }
            },
        },
    }
</script>