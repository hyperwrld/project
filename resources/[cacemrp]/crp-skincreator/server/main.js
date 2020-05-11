onNet('crp-skincreator:saveSkin', (data) => {
    var user = exports['crp-base'].GetCharacter(source);

    exports.ghmattimysql.execute('UPDATE users SET skin = @skin WHERE id = @id;', { ['@skin']: data, ['@id']: user.getCharacterID() });
});

onNet('crp-skincreator:payClothes', (data) => {
    var user = exports['crp-base'].GetCharacter(source);

    user.removeMoney(100);
});