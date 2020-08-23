AddEventHandler('crp-base:playerLoaded',function(source, character)
	TriggerClientEvent('crp-phone:updatePhone', source, {
		phoneNumber = character:getPhoneNumber(),
		history = getHistory(source),
		conversations = getConversations(source),
		contacts = getContacts(source),
		tweets = getTweets()
	})
end)

CRP.RPC:register('crp-phone:getHistory', function(source, data)
    return getHistory(source)
end)

CRP.RPC:register('crp-phone:getConversations', function(source, data)
    return getConversations(source)
end)

CRP.RPC:register('crp-phone:getMessages', function(source, data)
    return getMessages(source, data)
end)

CRP.RPC:register('crp-phone:sendMessage', function(source, data)
    return sendMessage(source, data.number, data.message)
end)

CRP.RPC:register('crp-phone:getContacts', function(source, data)
    return getContacts(source)
end)

CRP.RPC:register('crp-phone:addContact', function(source, data)
    return addContact(source, data.name, data.number)
end)

CRP.RPC:register('crp-phone:deleteContact', function(source, data)
    return deleteContact(source, data.id)
end)

CRP.RPC:register('crp-phone:editContact', function(source, data)
    return editContact(source, data.id, data.name, data.number)
end)

CRP.RPC:register('crp-phone:getTweets', function(source, data)
    return getTweets()
end)

CRP.RPC:register('crp-phone:sendTweet', function(source, data)
    return sendTweet(source, data.message)
end)

CRP.RPC:register('crp-phone:sendRetweet', function(source, data)
    return sendRetweet(source, data.tweetId)
end)

function generateTime()
	return os.time(os.date("!*t"))
end