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
			changeValue: function(event) {
				this.data.value = event.target.value;

				this.click();
			}
		},
		render (h) {
			const data = this.data;

			return (
				<div class='option'>
					<div class='label-container'>
						<span class='label'>{ data.title }</span>
						<span>{ parseFloat(data.value).toFixed(1) + ' | ' + parseFloat(data.maxValue).toFixed(1) }</span>
					</div>
					<div class='control'>
						<input type='range' min={ data.minValue } max={ data.maxValue } step='0.1' value={ data.value } onInput={ (event) => this.changeValue(event) }/>
					</div>
				</div>
			);
		}
	}
</script>