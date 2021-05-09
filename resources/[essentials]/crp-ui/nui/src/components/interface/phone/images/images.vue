<script>
	export default {
		name: 'images',
		data() {
			return {
				showImage: false,
			};
		},
		props: {
			images: Array,
		},
		render() {
			let images = this.images;

			return (
				<div class='images'>
					Imagens anexadas: {images.length}
					<div class={`content ${this.showImage ? '' : 'max-height'}`}>
						{!this.showImage && (
							<div class='placeholder' onClick={() => (this.showImage = true)}>
								<q-icon name='fas fa-eye' />
								<p>Clica para ver</p>
							</div>
						)}
						{images.map((image) => (
							<div
								class={`image ${this.showImage ? '' : 'blur'}`}
								onClick={() => (this.showImage = false)}
							>
								<img src={image} />
							</div>
						))}
					</div>
				</div>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './images.scss';
</style>
