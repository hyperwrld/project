<template>
	<div v-if="canShow" id="app">
		<div id="container">
            <menuBuilder :menuType="menuType" :menuList="menuList"/>
		</div>
	</div>
</template>

<script>
    import menuBuilder from './components/menuBuilder';

    export default {
        name: 'app',
        components: {
            'menuBuilder': menuBuilder
        },
        data() {
            return {
                canShow: false,
                menuType: 'mainMenu',
                menuList: [{ name: 'Guardar Veículo', option: 'storeVehicle' }, { name: 'Lista de veículos', option: 'vehicleList' }, { name: 'Fechar', option: 'closeMenu' }]
            };
        },
        destroyed() {
            window.removeEventListener('message', this.listener);
        },
        mounted() {
            this.listener = window.addEventListener('message', (event) => {
                switch (event.data.eventName) {
                    case 'toggleMenu':
                        this.canShow = event.data.status;
                        break;
                    default:
                        break;
                }
            }, false);
        },
    };
</script>

<style lang='scss'>
    @import 'assets/materialize.min.css';

    html, body {
        height: 100%;
        font-family: 'Open Sans', sans-serif;
        overflow: hidden;
    }

    #container {
        height: 100%;
        width: 30%;
        margin-left: 2.725%;
        margin-top: 15%;
    }

    .title {
        font-size: 16px;
        background-color: rgba(122, 120, 120, 0.70);
        text-align: center;
        padding: 1.8%;
        color: #FFFFFF;
        border-radius: 2px;
        font-weight: bold;
        width: 40%;
        text-shadow: 0px 0px 3px rgba(0, 0, 0, 1.0);
    }

    .button {
        .buttonInfo {
            width: 40%;
            align-items: center;
            background-color: rgba(5, 5, 5, 0.65);
            height: 3.25vh;
            margin-bottom: 1%;
            line-height: 3.25vh;
            text-align: center;
            justify-content: space-between;
            border-radius: 2px;

            p {
                margin: 0;
                color: white;
                font-size: 11px;
                text-align: center;
            }
        }
    }

    .vehicle {
        display: flex;
        flex-direction: row;
        height: 3.25vh;
        margin-bottom: 1%;

        .vehicleInfo {
            display: flex;
            flex-direction: row;
            width: 50%;

            align-items: center;
            font-size: 11px;
            background-color: rgba(5, 5, 5, 0.65);
            line-height: 3.25vh;
            text-align: center;
            justify-content: space-between;
            border-radius: 2px;

            p {
                font-size: 11px !important;
                margin: 0 0 0 5%;
                width: 50%;
                text-align: left;

                color: white;
                font-size: 16px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            p:last-child {
                width: 40%;
                text-align: right;
                margin: 0 5% 0 5%;
            }
        }

        .vehicleStatus {
            display: flex;
            flex-direction: row;
            width: 46%;

            align-items: center !important;
            background-color: rgba(255, 255, 255, 0.65);
            margin-left: 1.5%;
            border-radius: 2px;

            p {
                font-size: 11px !important;
                margin: 0;
                text-align: center;
            }

            p:first-child {
                margin: 0 5% 0 5%;
                text-align: left;
            }

            p:last-child {
                margin: 0 5% 0 5%;
                text-align: right;
            }
        }
    }

    .pagination {
        width: 50%;
        display: flex;
        flex-direction: row;
        color: white;
        text-shadow: 0px 0px 3px rgba(0, 0, 0, 1.0);

        button {
            all: unset;
            margin: 0;
            text-align: center;
            width: 33%;
        }

        p {
            margin: 0;
            text-align: center;
            width: 33%;
        }

        button:first-child {
            text-align: left;
        }

        button:last-child {
            text-align: right;
        }
    }

    .active-item {
        background-color: rgb(5, 5, 5, 0.85) !important;
    }

    .active-status {
        background-color: rgba(255, 255, 255, 0.85) !important;
    }

    @font-face {
        font-family: 'Material Icons';
        font-style: normal;
        font-weight: 400;
        src: url(https://fonts.gstatic.com/s/materialicons/v51/flUhRq6tzZclQEJ-Vdg-IuiaDsNc.woff2) format('woff2');
    }

    .material-icons {
        font-family: 'Material Icons';
        font-weight: normal;
        font-style: normal;
        font-size: 24px;
        line-height: 1;
        letter-spacing: normal;
        text-transform: none;
        display: inline-block;
        white-space: nowrap;
        word-wrap: normal;
        direction: ltr;
        -webkit-font-feature-settings: 'liga';
        -webkit-font-smoothing: antialiased;
    }
</style>