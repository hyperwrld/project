
<script>
	export default {
  		data () {
    		return {
      			showImage: false
    		}
  		},
		props: {
			imgs: Array
		},
		render (h) {
			return (
				<div class='info-container'>
					Imagens anexadas: {this.imgs.length}
					<div class={`image-container ${this.showImage ? '' : 'max-height'}`}>
						{!this.showImage && (
							<div class='placeholder' onClick={() => this.showImage = true}>
								<font-awesome-icon icon={["fas", "eye"]}></font-awesome-icon>
								<p class='text'>Clica para ver</p>
							</div>
						)}
						{this.imgs.map((image, i) => (
							<div key={i} class={`image ${this.showImage ? '' : 'image-with-blur'}`} style={{ backgroundImage: `url(${image})` }} onClick={() => this.showImage = false}></div>
						))}
					</div>
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './images.scss';
</style>