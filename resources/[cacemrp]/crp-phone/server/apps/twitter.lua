local tweets = {}

function getTweets()
	return tweets
end

function sendTweet(source, message)
	if not message or type(message) ~= 'string' then return false end

	local character = exports['crp-base']:getCharacter(source)
	local tweetData = {
		id = #tweets + 1, name = character.getFullName(), message = message, time = GetCurrentTime()
	}

	tweets[#tweets + 1] = tweetData

	TriggerClientEvent('crp-phone:receiveTweet', -1, tweetData)

	return true
end

RPC:register('sendTweet', sendTweet)

function sendRetweet(source, tweetId)
	if not tweetId or type(tweetId) ~= 'number' then return false end

	local character = exports['crp-base']:getCharacter(source)
	local tweetData = {
		id = #tweets + 1, retweeter = character.getFullName(), name = tweets[tweetId].name, message = tweets[tweetId].message, time = tweets[tweetId].time
	}

	tweets[#tweets + 1] = tweetData

	TriggerClientEvent('crp-phone:receiveTweet', -1, tweetData)

	return true
end

RPC:register('sendRetweet', sendRetweet)