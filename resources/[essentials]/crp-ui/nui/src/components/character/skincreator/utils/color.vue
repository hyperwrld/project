<script>
	export default {
		name: 'colorOption',
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
			return (
				<div class='option color'>
 					<div class='label-container'>
						<span class='label'>{ this.data.title }</span>
					</div>
					<div class='color-controls'>
						{ this.data.items.map((key, index) => {
							return (
								<input type='radio' name='color' value={ index } style={{ backgroundColor: key.color }}/>
							)
						})}
					</div>
				</div>
			);
		}
	}
</script>