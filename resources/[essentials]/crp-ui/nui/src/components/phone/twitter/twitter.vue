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
					<tweet :tweet='tweet'/>
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
	import { processMessage, convertTime } from './../../../utils/lib.js';

	import dialogs from './../dialogs/dialogs.js';
	import images from './../images/images.vue';

	const tweet = {
		components: {
			images
		},
		props: ['tweet'],
		render (h) {
			const { message: message, imgs } = processMessage(this.tweet.message);

			return (
				<div class='tweet-square'>
					<div class='account-info'>
						<div class='name'>{ this.tweet.owner }</div>
						<div class='username'>{ '@' + (this.tweet.owner).replace(/\s/g, '') }</div>
					</div>
					<div class='content'>
						<div class='text'>{ message }</div>
						{imgs.length > 0 && (
							<images imgs={imgs}/>
						)}
					</div>
					<div class='bottom-bar'>
						<font-awesome-icon icon={["fas", "reply"]}></font-awesome-icon>
						<font-awesome-icon icon={["fas", "retweet"]}></font-awesome-icon>
						<div class='time'>{ convertTime(this.tweet.time) }</div>
					</div>
				</div>
			);
		}
	};

    export default {
		name: 'twitter',
		components: {
            tweet, images
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
			}
        },
    };
</script>

<style scoped lang='scss'>
    @import './twitter.scss';
</style>