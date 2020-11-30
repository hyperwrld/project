<script>
	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faAngleLeft, faAngleRight } from '@fortawesome/free-solid-svg-icons';

	library.add(faAngleLeft, faAngleRight);

	export default {
		name: 'inputOption',
		props: {
			data: Object, click: Function
		},
		methods: {
			canChange: function(newValue) {
				const data = this.data;

				if (newValue >= data.minValue && newValue <= data.maxValue) {
					return true;
				}

				return false;
			},
			changeValue: function(boolean) {
				let value = this.data.value;

				boolean ? value++ : value--;

				if (this.canChange(value)) {
					this.data.value = value;
				}
			},
			updateValue: function(event) {
				if (event.target.value === '') {
					this.data.value = 0;
				}
			}
		},
		watch: {
			'data.value': function(newValue, oldValue) {
				if (!this.canChange(newValue)) {
					this.data.value = oldValue;
				} else {
					this.click(this.data.id);
				}
			}
    	},
		render (h) {
			const data = this.data;

			return (
				<div class='option'>
					<div class='label-container'>
						<span class='label'>{ data.title }</span>
						<span>{ data.value + ' | ' + data.maxValue }</span>
					</div>
					<div class='controls'>
						<button class='arrowLeft' onClick={ () => this.changeValue(false) }>&#8249;</button>
							<input type='number' v-model={ data.value } onChange={ this.updateValue }/>
						<button class='arrowRight' onClick={ () => this.changeValue(true) }>&#8250;</button>
					</div>
				</div>
			);
		}
	}
</script>