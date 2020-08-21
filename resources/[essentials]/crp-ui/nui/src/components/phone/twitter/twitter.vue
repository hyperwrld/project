<template>
    <v-container fluid>
        <div class='top-bar'>
            <div class='search-wrapper'>
                <input type='text' v-model='searchInput' placeholder='Procurar...'/>
                <font-awesome-icon :icon='["fas", "search"]'></font-awesome-icon>
            </div>
            <font-awesome-icon :icon='["fas", "user-plus"]'></font-awesome-icon>
        </div>
        <div class='tweets-list'>
            <div v-if='filterItems().length >= 0'>
				<div class='tweet' v-for='tweet in filterItems()' :key='tweet.message'>
					<tweet :tweet='tweet' :getTime='getTime'/>
				</div>
            </div>
        	<div v-else class='empty-list'>
				<font-awesome-icon :icon='["fas", "sad-tear"]'></font-awesome-icon>
				<span>Não foi encontrado nenhum tweet.</span>
			</div>
        </div>
    </v-container>
</template>

<script>
	import { mapGetters } from 'vuex';
	import { convertTime } from './../../../utils/time.js';
	import dialogs from './../dialogs/dialogs.js';

	const tweet = {
		components: {
			tweetImages
		},
		props: ['tweet', 'getTime'],
		render (h) {
			const matches = this.tweet.message.match(/https:\/\/\S*?(\.png|\.gif)(.*?\s|.*)/g);
			const images = matches ? matches.map(element => element.trim()) : [];

			let message = this.tweet.message
			images.forEach(element => message = message.replace(element, ''));

			return (
				<div class='tweet-square'>
					<div class='account-info'>
						<div class='name'>{ this.tweet.owner }</div>
						<div class='username'>{ '@' + (this.tweet.owner).replace(/\s/g, '') }</div>
					</div>
					<div class='content'>
						<div class='text'>{ message }</div>
						{ images.length > 0 && (
							<tweetImages images={images}/>
						)}
					</div>
					<div class='bottom-bar'>
						<font-awesome-icon icon={["fas", "reply"]}></font-awesome-icon>
						<font-awesome-icon icon={["fas", "retweet"]}></font-awesome-icon>
						<div class='time'>{ this.getTime(this.tweet.time) }</div>
					</div>
				</div>
			);
		}
	};

	const tweetImages = {
		props: ['images'],
		data() {
            return {
				showImage: false
            }
        },
		render (h) {
			return (
				<div class='info-container'>
					Imagens anexadas: {this.images.length}

					<div class='image-container'>
						{!this.showImage && (
							<div class='placeholder' onClick={() => this.showImage = true}>
								<font-awesome-icon icon={["fas", "eye"]}></font-awesome-icon>
								<p class='text'>Clica para ver</p>
							</div>
						)}
						{this.images.map((image, i) => (
							<div key={i} class={`image ${this.showImage ? '' : 'image-with-blur'}`} style={{ backgroundImage: `url(${image})` }}></div>
						))}
					</div>
				</div>
			);
		}
	};

    export default {
		name: 'twitter',
		components: {
            tweet, tweetImages
        },
        data() {
            return {
				searchInput: ''
            }
        },
        computed: {
            ...mapGetters('phone', {
				tweets: 'getTweets'
            })
        },
        methods: {
			getTime: function(time) {
				return convertTime(time);
			},
			filterItems: function() {
				const search = this.searchInput.toLowerCase().trim()

				if (!search) {
					return this.tweets;
				}

				if (isNaN(this.searchInput)) {
					return this.tweets.filter(c => c.name.toLowerCase().indexOf(search) > -1);
				} else {
					return this.tweets.filter(c => c.name.toString().toLowerCase().indexOf(search) > -1);
				}
			},
			getContactColor: function(string) {
				var hash = 0;

    			for (var i = 0; i < string.length; i++) {
      				hash = string.charCodeAt(i) + ((hash << 5) - hash);
				}

    			return 'hsl(' + hash % 360 + ', 30%, 70%)';
			}
        },
    };
</script>

<style scoped lang='scss'>
    @import './twitter.scss';
</style>