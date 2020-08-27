<template>
	<v-dialog v-model='status' persistent max-width='290' :attach='attach' hide-overlay dark>
		<v-card>
			<div v-if='loader.state' class='loader' :class='loader.class'>
				<svg class='spinner' width='43px' height='43px' viewBox='0 0 44 44' xmlns='http://www.w3.org/2000/svg'>
					<circle class='path' fill='none' stroke-width='4' stroke-linecap='round' cx='22' cy='22' r='20'></circle>
				</svg>
			</div>

			<div v-else>
				<v-card-title class='headline'>{{ title }}</v-card-title>
				<v-card-text v-if='choices && choices.length > 0'>
					<div v-for='(choice, index) in choices' :key='index'>
						<input v-if='choice.type' :type='choice.type' v-model='choice.value' :placeholder='choice.placeholder' :maxlength='choice.max' required>
						<textarea v-else type='text' v-model='choice.value' :placeholder='choice.placeholder' required/>
					</div>
				</v-card-text>
				<v-card-actions>
					<v-btn color='red darken-1' text @click='cancelDialog'>Voltar</v-btn>
					<v-btn color='green darken-1' text @click='submitDialog'>{{ sendButton }}</v-btn>
				</v-card-actions>

				<div class='errors' v-if='choices'>
					<div id='error' v-for='error in errorsList' :key='error'>
						<span><font-awesome-icon :icon='["fas", "exclamation-circle"]'></font-awesome-icon>{{ error }}</span>
					</div>
				</div>
			</div>
		</v-card>
	</v-dialog>
</template>

<script>
	import Vue from 'vue';
	import nui from './../../../utils/nui';

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faExclamationCircle } from '@fortawesome/free-solid-svg-icons';

	library.add(faExclamationCircle);

    export default {
		name: 'Dialogs',
		data() {
			return {
				status: true,
				loader: { state: false, class: '' },
				errorsList: []
			}
		},
		props: {
			attach: {
				type: String,
				default: () => ''
			},
			title: {
				type: String,
				default: () => ''
			},
			choices: {
				type: Array,
				default: () => []
			},
			sendButton: {
				type: String,
				default: () => ''
			},
			nuiType: {
				type: String,
				default: () => ''
			},
			additionalData: {
				type: Object,
				default: () => {}
			}
		},
        methods: {
			cancelDialog: function() {
				this.$emit('cancel');
			},
			submitDialog: function() {
				const choiceData = typeof(this.additionalData) == 'object' ? this.additionalData : {};

				if (this.choices && this.choices.length > 0) {
					this.errorsList = [];

					for (let i = 0; i < this.choices.length; i++) {
						const choice = this.choices[i];

						if (choice.value == undefined || ((choice.max && choice.value.length > choice.max) || (choice.min && choice.value.length < choice.min))) {
							this.errorsList.push(choice.errorText);
						} else {
							choiceData[choice.key] = choice.value;
						}
					}
				}

				if (this.errorsList.length == 0) {
					this.loader.state = true, this.loader.class = 'loading';

					nui.send(this.nuiType, choiceData).then(data => {
						this.loader.class = data.state ? 'done' : 'failure';

						setTimeout(() => {
							if (data.state) {
								this.$emit('submit', { choiceData: choiceData, data: data });
							}

							this.loader.state = false;
						}, 1000);
					});
				}
			}
        },
    };
</script>

<style scoped lang='scss'>
    @import './dialogs.scss';
</style>