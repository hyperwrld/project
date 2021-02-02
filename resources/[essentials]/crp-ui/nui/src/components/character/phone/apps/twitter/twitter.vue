<script>
	import { mapGetters } from 'vuex';

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faFeatherAlt, faReply, faRetweet, faSadTear } from '@fortawesome/free-solid-svg-icons';
	import { faTwitter } from '@fortawesome/free-brands-svg-icons';

	import { fragment, convertTime, processMessage } from './../../../../../utils/lib.js';

	import dialogs from './../../dialogs/dialogs.js';
	import images from './../../images/images.vue';

	library.add(faTwitter, faFeatherAlt, faSadTear, faRetweet, faReply);

	export default {
		name: 'twitter',
		components: {
			images
		},
		computed: {
			...mapGetters('twitter', {
				tweets: 'getTweets'
			})
		},
		methods: {
			sendTweet: function() {
				dialogs.createDialog({
					attach: '.list', title: 'Envie um tweet',
					choices: [
						{ key: 'message', placeholder: 'Mensagem', errorText: 'Escolha uma mensagem para colocar no seu tweet.' }
					],
					sendText: 'Enviar', nuiType: 'sendTweet'
				});
			},
			replyTweet: function(name) {
				dialogs.createDialog({
					attach: '.tweets-list', title: 'Envie um tweet',
					choices: [
						{ key: 'message', value: '@' + name + ' ', placeholder: 'Mensagem', errorText: 'Escolha uma mensagem para colocar no seu tweet.' }
					],
					sendText: 'Enviar', nuiType: 'sendTweet'
				});
			},
			sendRetweet: function(tweetId) {
				dialogs.createDialog({
					attach: '.tweets-list', title: 'Tens a certeza que queres retweetar?',
					sendText: 'Retweetar', nuiType: 'sendRetweet', data: { tweetId: tweetId }
				});
			}
		},
		render() {
			return (
				<div class='twitter'>
					<div class='top'>
						<font-awesome-icon icon={ ['fab', 'twitter'] }/>
						<span>Twitter</span>
					</div>
					<div class={`list ${ this.tweets.length > 0 ? '' : 'empty'}`}>
						{ this.tweets.length > 0 ?
							<fragment>
								{ this.tweets.map((tweet) => {
									let { message: message, imgs } = processMessage(tweet.message);
									const matches = message.match(/(^|\s)(#[a-z\d-_]+)/ig);

									if (matches) {
										matches.forEach(element => message = message.replace(element, `<span class='hashtag'>${ element }</span>`));
									}

									return (
										<div class='tweet'>
											{ tweet.retweeter &&
												<div class='retweet'>
													<font-awesome-icon icon={ ['fas', 'retweet'] }/><span>{ tweet.retweeter + ' retweetou' }</span>
												</div>
											}
											<div class='information'>
												{ tweet.name } <span>@{ (tweet.name).replace(/\s/g, '') }</span>
											</div>
											<div class='content'>
												<div domPropsInnerHTML={ message }/>
												{ imgs.length > 0 &&
													<images images={ imgs }/>
												}
											</div>
											<div class='bottom'>
												<font-awesome-icon icon={ ['fas', 'reply'] } onClick={ () => this.replyTweet(tweet.name) }/>
												<font-awesome-icon icon={ ['fas', 'retweet'] } onClick={ () => this.sendRetweet(tweet.id) }/>
												<div>{ convertTime(tweet.time) }</div>
											</div>
										</div>
									)
								})}
							</fragment>
							:
							<fragment>
								<font-awesome-icon icon={ ['fas', 'sad-tear'] }/>
								<span>Não foi encontrado nenhum tweet.</span>
							</fragment>
						}
						<font-awesome-icon class='button' icon={ ['fas', 'feather-alt'] } onClick={ this.sendTweet }/>
					</div>
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './twitter.scss';
</style>