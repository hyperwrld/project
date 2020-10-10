<template>
	<v-container fluid id='character'>
        <div class='menu animate__animated animate__fadeIn'>
            <div class='character-list'>
                <div class='character' v-for='(character, index) in charactersData' :item='character' :key='index' :class='{ active: (currentItem == index) }' @click='changeCurrentItem(index)'>
                    <characterSlot :data='character'/>
                </div>
            </div>
            <bottomButtons :data='charactersData[currentItem]' :index='currentItem'/>
        </div>
	</v-container>
</template>

<script>
    import { mapGetters } from 'vuex'
	import nui from '../../utils/nui';

	import dialogs from './dialogs/dialogs.vue';

	const characterSlot = {
		props: ['data'],
		render (h) {
			let slotText = this.data.option ? 'Slot Vazio' : `${ this.data.firstname + ' ' + this.data.lastname }<span>// ${ this.data.dob }</span>`

			return (
				<div>
					<h3 domPropsInnerHTML={ slotText }/>
					{ !this.data.option &&
						<span>
							Sexo: { this.data.gender } // Trabalho: { this.data.job }<br/>
							Dinheiro: { this.data.money + '€' } // Banco: { this.data.bank + '€' }<br/>
						</span>
					}
				</div>
			);
		}
	};

	const bottomButtons = {
		props: ['data', 'index'],
		methods: {
			handleDisconnect: function() {
				// nui.send('disconnect');
				console.log('caralho?')
				// this.$router.push({ name: 'dialogs' });
			},
			selectCharacter: function() {
				this.$store.dispatch('character/selectCharacter', this.index);
            },
            deleteCharacter: function() {
				this.$router.push({ name: 'dialogs' });
            }
		},
		render (h) {
			this.data.option = false;

			return (
				<div class='buttons'>
					{ this.data.option ?
						<button>Criar</button> :
						<Fragment>
							<button onClick='${ this.selectCharacter() }'>Selecionar</button>
							<button>Apagar</button>
						</Fragment>
					}
					<button onClick={ console.log('olaaaa') }></button>
				</div>
			);
		}
	};

    export default {
		name: 'character',
		components: {
			dialogs, characterSlot, bottomButtons
		},
		data() {
			return {
				currentItem: 0
			}
		},
        computed: {
			...mapGetters('character', {
				charactersData: 'getCharactersData'
			})
        },
        methods: {
            handleDisconnect: function() {
                nui.send('disconnect');
            },
            changeCurrentItem: function(index) {
				this.currentItem = index;
            },
            selectCharacter: function() {
                this.$store.dispatch('character/selectCharacter');
            }
        }
    };
</script>

<style scoped lang='scss'>
    @import './character.scss';
</style>