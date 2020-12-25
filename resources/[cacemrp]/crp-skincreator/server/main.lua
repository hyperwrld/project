RegisterServerEvent('crp-skincreator:saveSkin')
AddEventHandler('crp-skincreator:saveSkin', function(skin)
	local character = exports['crp-base']:getCharacter(source)

	if character and skin then
		DB:Execute([[UPDATE users SET skin = ? WHERE id = ?;]], json.encode(skin), character.getCharacterId())
	end
end)