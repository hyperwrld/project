local tweets = {}

function getTweets()
	return tweets
end

function sendTweet(source, message)
	if not message or type(message) ~= 'string' then return false end

	local character = exports['crp-base']:GetCharacter(source)
	local tweetData = {
		id = #tweets + 1, name = character.getFullName(), message = message, time = generateTime()
	}

	tweets[#tweets + 1] = tweetData

	return true, tweetData
end

function sendRetweet(source, tweetId)
	if not tweetId or type(tweetId) ~= 'number' then return false end

	local character = exports['crp-base']:GetCharacter(source)
	local tweetData = {
		id = #tweets + 1, retweeter = character.getFullName(), name = tweets[tweetId].name, message = tweets[tweetId].message, time = tweets[tweetId].time
	}

	tweets[#tweets + 1] = tweetData

	return true, tweetData
end