<template>
    <v-container fluid>
        <div class='top-bar'>
			<font-awesome-icon :icon='["fab", "twitter"]'></font-awesome-icon>
			<span class='brand-name'>Twitter</span>
        </div>
        <div class='tweets-list'>
            <div v-if='this.tweets.length > 0'>
				<font-awesome-icon class='button' :icon='["fas", "feather-alt"]' @click='sendTweet'></font-awesome-icon>
				<div class='tweet' v-for='tweet in this.tweets'>
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

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faFeatherAlt, faSadTear, faRetweet, faReply } from '@fortawesome/free-solid-svg-icons';
	import { faTwitter } from '@fortawesome/free-brands-svg-icons';

	import dialogs from './../dialogs/dialogs.js';
	import images from './../images/images.vue';

	library.add(faTwitter, faFeatherAlt, faSadTear, faRetweet, faReply);

	const tweet = {
		components: {
			images
		},
		props: ['tweet'],
		methods: {
			sendTweet: function(name) {
				dialogs.createDialog({
					attach: '.tweets-list', title: 'Envie um tweet',
					choices: [
						{ key: 'message', value: '@' + name + ' ', placeholder: 'Mensagem', errorText: 'Escolha uma mensagem para colocar no seu tweet.' }
					],
					sendButton: 'Enviar', nuiType: 'sendTweet'
				});
			},
			sendRetweet: function(tweetId) {
				dialogs.createDialog({
					attach: '.tweets-list', title: 'Tens a certeza que queres retweetar?',
					sendButton: 'Retweetar', nuiType: 'sendRetweet', additionalData: { tweetId: tweetId }
				});
			}
		},
		render (h) {
			let {message: message, imgs} = processMessage(this.tweet.message);
			const matches = message.match(/\B#(\d*[A-Za-z_]+\w*)\b(?!;)/g);

			if (matches) {
				matches.forEach(element => message = message.replace(element, `<span class='hashtag'>${element}</span>`));
			}

			return (
				<div class='tweet-square'>
					{this.tweet.retweeter && (
						<div class='retweet-info'>
							<font-awesome-icon icon={['fas', 'retweet']}></font-awesome-icon>
							<span class='name'>{this.tweet.retweeter + ' retweetou'}</span>
						</div>
					)}
					<div class='account-info'>
						<div class='name'>{this.tweet.name}</div>
						<div class='username'>@{(this.tweet.name).replace(/\s/g, '')}</div>
					</div>
					<div class='content'>
						<div class='text' domPropsInnerHTML={message}></div>
						{imgs.length > 0 && (
							<images imgs={imgs}/>
						)}
					</div>
					<div class='bottom-bar'>
						<font-awesome-icon icon={['fas', 'reply']} onClick={(e) => this.sendTweet(this.tweet.name, e)}></font-awesome-icon>
						<font-awesome-icon icon={['fas', 'retweet']} onClick={(e) => this.sendRetweet(this.tweet.id, e)}></font-awesome-icon>
						<div class='time'>{convertTime(this.tweet.time)}</div>
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
			sendTweet: function() {
				dialogs.createDialog({
					attach: '.tweets-list', title: 'Envie um tweet',
					choices: [
						{ key: 'message', placeholder: 'Mensagem', errorText: 'Escolha uma mensagem para colocar no seu tweet.' }
					],
					sendButton: 'Enviar', nuiType: 'sendTweet'
				});
			}
        },
    };
</script>

<style scoped lang='scss'>
    @import './twitter.scss';
</style>