<template>
	<v-app>
		<userInterface/>
		<router-view :closeMenu='closeMenu'/>
    </v-app>
</template>

<script>
	import { mapState } from 'vuex';

	import userInterface from './components/interface/interface.vue';

	import { send } from './utils/lib.js';

    export default {
		name: 'app',
		components: {
			userInterface
		},
		methods: {
			closeMenu: function(appName) {
				this.changeRouter({ path: '/' });

                send('closeMenu', appName);
			},
			changeRouter: function(data) {
				this.$router.push(data).catch(error => {
					if (error.name !== 'NavigationDuplicated' && !error.message.includes('Avoided redundant navigation to current location')) {
						console.log(error);
					}
				});
			}
		},
        destroyed() {
            window.removeEventListener('message', this.listener);
        },
        mounted() {
            this.listener = window.addEventListener('message', (event) => {
				const info = event.data;

				if (info.event != undefined) {
					this.$store.dispatch(info.app + '/' + info.event, info.data);
				}

				if (info.state != undefined) {
					if (!info.state) {
						this.closeMenu(info.app);
					} else {
						this.changeRouter({ path: info.app });
					}
				}
			});
        }
    };
</script>

<style lang='scss'>
	@import './plugins/vue2-animate.min.css';
    @import 'https://fonts.googleapis.com/css2?family=Quantico&display=swap';

    html, body {
        background-color: transparent;
        user-select: none;
        overflow: hidden;
        height: 100%;
    }

    #app {
        background-color: transparent;
	}

	.v-application .error {
		background-color: transparent !important;
		border-color: #ff5252 !important;
	}

	.errors {
		padding: 0 5% 5%;

		#error {
			display: flex;
			align-items: center;
			justify-content: center;
			span {
				display: flex;
				width: 85%;
				font-size: 0.6rem;
				align-items: center;
				color: #fc9403;
				svg {
					margin-right: 5%;
					font-size: 0.9rem;
					width: 10%;
				}
			}
			margin-bottom: 2%;
		}

		& > :last-child {
			margin-bottom: 0 !important;
		}
	}
</style>