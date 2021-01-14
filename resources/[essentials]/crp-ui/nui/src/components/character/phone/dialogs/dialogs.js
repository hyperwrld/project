import Vue from 'vue';
import Dialogs from './dialogs.vue';

export default {
	createDialog(propsData = {}) {
		return new Promise((resolve, reject) => {
			let dialog = new (Vue.extend(Dialogs)) ({
				el: document.createElement('div'), propsData
			});

			document.querySelector('#app').appendChild(dialog.$el);

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