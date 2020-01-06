local function isEmpty(string)
	return string == nil or string == ''
end

TriggerEvent('crp-base:addCommand', 'ooc', function(source, args, user)
    local user = exports['crp-base']:GetCharacter(source)

    args = table.concat(args, ' ')

	if isEmpty(args) then
		return
    end

    TriggerClientEvent('chat:addMessage', -1, { color = {255, 255, 255}, templateId = 'blue', args = { user.getFullName(), args }})
end, { help = 'Apenas utilize este comando em casos "extremos".', params = {{ name = 'mensagem' }}})