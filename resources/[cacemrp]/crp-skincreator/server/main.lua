RegisterServerEvent('crp-skincreator:saveSkin')
AddEventHandler('crp-skincreator:saveSkin', function(data)
    local user = exports['crp-base']:GetCharacter(source)

    exports.ghmattimysql:execute('UPDATE users SET skin = @skin WHERE id = @id;', { ['@skin'] = data, ['@id'] = user.getCharacterID() })
end)

RegisterServerEvent('crp-skincreator:payClothes')
AddEventHandler('crp-skincreator:payClothes', function()
    local user = exports['crp-base']:GetCharacter(source)

    user.removeMoney(100)
end)