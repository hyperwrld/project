import Vue from 'vue';
import Dialog from './dialog.vue';

export default {
	createDialog(propsData = {}) {
		return new Promise((resolve, reject) => {
			let dialog = new (Vue.extend(Dialog)) ({
				el: document.createElement('div'), propsData
			});

			document.querySelector('.skincreator').querySelector('.container').appendChild(dialog.$el);

			dialog.$on('submit', (data) => {
				resolve(data);

				dialog.$el.parentNode.removeChild(dialog.$el);
				dialog.$destroy();
			});

			dialog.$on('cancel', () => {
				reject();

				dialog.$el.parentNode.removeChild(dialog.$el);
				dialog.$destroy();
			});
		})
	}
}