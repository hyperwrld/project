<script>
	export default {
		name: 'rangeOption',
		props: {
			data: Object, click: Function
		},
		methods: {
			changeValue: function(event) {
				this.data.value = event.target.value;

				this.click(this.data.id);
			}
		},
		render (h) {
			const data = this.data;

			if (!data.step) {
				data.step = 0.1;
			}

			return (
				<div class='option range'>
					<div class='label-container'>
						<span>{ data.title }</span>
						<span class='counter'>{ parseFloat(data.value).toFixed(1) + ' | ' + parseFloat(data.maxValue).toFixed(1) }</span>
					</div>
					<div class='control'>
						<input type='range' min={ data.minValue } max={ data.maxValue } step={ data.step } value={ data.value } onInput={ (event) => this.changeValue(event) }/>
					</div>
				</div>
			);
		}
	}
</script>