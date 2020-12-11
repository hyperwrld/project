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
			},
			toggleColors: function() {
				this.canShow = this.canShow ? false : true;
			}
		},
		data() {
			return {
				canShow: false
			}
		},
		render (h) {
			return (
				<div class='option color'>
 					<div class='label-container' onClick={ () => this.toggleColors() }>
						<span class='label'>{ this.data.title }</span>
					</div>
					{ this.canShow &&
						<div class='color-controls'>
							{ this.data.items.map((key, index) => {
								return (
									<input type='radio' name={ this.data.name } value={ index } style={{ backgroundColor: 'rgb(' + key[0] + ',' + key[1] + ',' + key[2] + ')' }} checked={ (this.data.value === index) } onClick={ this.changeValue }/>
								)
							})}
						</div>
					}
				</div>
			);
		}
	}
</script>