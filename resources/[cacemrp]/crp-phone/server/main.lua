AddEventHandler('crp-base:characterLoaded', function(source, character)
	TriggerClientEvent('crp-phone:updatePhone', source, {
		currentNumber = character:getPhone(), history = getHistory(source), messages = getLastMessages(source),
		contacts = getContacts(source), twitter = getTweets()
	})
end)