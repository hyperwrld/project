<script>
	import { mapGetters } from 'vuex';
	import {
		fragment,
		convertTime,
		processMessage,
	} from './../../../../../utils/lib.js';
	import dialogs from './../../dialogs/dialogs.js';
	import images from './../../images/images.vue';

	export default {
		name: 'twitter',
		components: {
			images,
		},
		computed: {
			...mapGetters('twitter', {
				tweets: 'getTweets',
			}),
		},
		methods: {
			sendTweet: function() {
				dialogs.createDialog({
					attach: '.list',
					title: 'Envie um tweet',
					choices: [
						{
							key: 'message',
							placeholder: 'Mensagem',
							errorText: 'Escolha uma mensagem para colocar no seu tweet.',
						},
					],
					sendText: 'Enviar',
					nuiType: 'sendTweet',
				});
			},
			replyTweet: function(name) {
				dialogs.createDialog({
					attach: '.tweets-list',
					title: 'Envie um tweet',
					choices: [
						{
							key: 'message',
							value: '@' + name + ' ',
							placeholder: 'Mensagem',
							errorText: 'Escolha uma mensagem para colocar no seu tweet.',
						},
					],
					sendText: 'Enviar',
					nuiType: 'sendTweet',
				});
			},
			sendRetweet: function(tweetId) {
				dialogs.createDialog({
					attach: '.tweets-list',
					title: 'Tens a certeza que queres retweetar?',
					sendText: 'Retweetar',
					nuiType: 'sendRetweet',
					data: { tweetId: tweetId },
				});
			},
		},
		render() {
			return (
				<div class='twitter'>
					<div class='top'>
						<q-icon name='fab fa-twitter' />
						<span>Twitter</span>
					</div>
					<div class={`list ${this.tweets.length > 0 ? '' : 'empty'}`}>
						{this.tweets.length > 0 ? (
							<fragment>
								{this.tweets.map((tweet) => {
									let { message: message, imgs } = processMessage(
										tweet.message
									);
									const matches = message.match(/(^|\s)(#[a-z\d-_]+)/gi);

									if (matches) {
										matches.forEach(
											(element) =>
												(message = message.replace(
													element,
													`<span class='hashtag'>${element}</span>`
												))
										);
									}

									return (
										<div class='tweet'>
											{tweet.retweeter && (
												<div class='retweet'>
													<q-icon name='fas fa-retweet' />
													<span>{tweet.retweeter + ' retweetou'}</span>
												</div>
											)}
											<div class='information'>
												{tweet.name}{' '}
												<span>@{tweet.name.replace(/\s/g, '')}</span>
											</div>
											<div class='content'>
												<div domPropsInnerHTML={message} />
												{imgs.length > 0 && <images images={imgs} />}
											</div>
											<div class='bottom'>
												<q-icon
													name='fas fa-reply'
													onClick={() => this.replyTweet(tweet.name)}
												/>
												<q-icon
													name='fas fa-retweet'
													onClick={() => this.sendRetweet(tweet.id)}
												/>
												<div>{convertTime(tweet.time)}</div>
											</div>
										</div>
									);
								})}
							</fragment>
						) : (
							<fragment>
								<q-icon name='fas fa-sad-tear' />
								<span>Não foi encontrado nenhum tweet.</span>
							</fragment>
						)}
						<q-icon name='fas fa-feather-alt' onClick={this.sendTweet} />
					</div>
				</div>
			);
		},
	};
</script>

<style scoped lang="scss">
	@import './twitter.scss';
</style>
