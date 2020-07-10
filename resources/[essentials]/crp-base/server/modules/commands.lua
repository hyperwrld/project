local function isEmpty(string)
	return string == nil or string == ''
end

CRP.Commands = {
    {'ooc', 'Apenas utilize este comando em casos "extremos".', {{ name = 'mensagem' }}, function(source, args)
        local user = GetCharacter(source)

        args = table.concat(args, ' ')

        if isEmpty(args) then
            return
        end

        TriggerClientEvent('chat:addMessage', -1, { color = {255, 255, 255}, templateId = 'blue', args = { user.getFullName(), args }})
    end},
    {'me', 'Envie uma mensagem.', {{ name = 'mensagem' }}, function(source, args)
        args = table.concat(args, ' ')

        if isEmpty(args) then
            return
        end

        TriggerClientEvent('crp-base:displayMe', -1, source, args)
    end},
    {'dinheiro', 'Utilize este comando para conseguir ver o seu dinheiro.', {}, function(source, args)
        TriggerClientEvent('crp-ui:setMoneyStatus', source, { status = true, time = 5000 })
    end},
    {'recrutar', 'Recrute uma pessoa para a sua organização.', {{ name = 'id do jogador' }, { name = 'cargo' }}, function(source, args)
        --- TODO: COMMAND
    end},
}

function CRP.Commands:RegisterCommands()
    for i = 1, #CRP.Commands do
        RegisterCommand(CRP.Commands[i][1], CRP.Commands[i][4], false)
    end
end

CRP.Commands:RegisterCommands()