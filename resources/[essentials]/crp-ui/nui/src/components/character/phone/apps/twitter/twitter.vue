<script>
	import { mapGetters } from 'vuex';

	import { library } from '@fortawesome/fontawesome-svg-core';
	import { faUser, faSearch, faEnvelope, faSadTear } from '@fortawesome/free-solid-svg-icons';

	import { fragment, convertTime, processMessage } from './../../../../../utils/lib.js';

	import dialogs from './../../dialogs/dialogs.js';

	library.add(faSearch, faEnvelope, faUser, faSadTear);

	export default {
		name: 'twitter',
		computed: {
			...mapGetters('phone', {
				tweets: 'getTweets'
			})
		},
		methods: {

		},
		render(h) {
			return (
				<div class='twitter'>
					<div class='top'>
						<font-awesome-icon icon={ ['fab', 'twitter'] }/>
						<span>Twitter</span>
					</div>
					<div class={`list ${ this.tweets.length > 0 ? '' : 'empty'}`}>
						{ this.tweets.length > 0 ?
							<fragment>
								{ this.tweets.map((tweet, index) => {
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
													<images imgs={ imgs }/>
												}
											</div>
											<div class='bottom'>
												<font-awesome-icon icon={ ['fas', 'reply'] } onClick={ (event) => this.sendTweet(tweet.name, event) }/>
												<font-awesome-icon icon={ ['fas', 'retweet'] } onClick={ (event) => this.sendRetweet(tweet.id, event) }/>
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
					</div>
				</div>
			);
		}
	}
</script>

<style scoped lang='scss'>
    @import './twitter.scss';
</style>