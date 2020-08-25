local adverts = {}

function getAdverts()
	return adverts
end

function postAdvert(source, message)
	if not message or type(message) ~= 'string' then return false end

	local character = exports['crp-base']:GetCharacter(source)
	local advertData = {
		id = #adverts + 1, name = character.getFullName(), number = character.getPhoneNumber(), message = message
	}

	adverts[#adverts + 1] = advertData

	return true, advertData
end

function removeAdvert(source, advertId)
	if not advertId or type(advertId) ~= 'number' then return false end

	local character = exports['crp-base']:GetCharacter(source)

	if not adverts[advertId + 1] or adverts[advertId + 1].number ~= character.getPhoneNumber() then
		return false
	end

	adverts[advertId + 1] = nil

	return true
end