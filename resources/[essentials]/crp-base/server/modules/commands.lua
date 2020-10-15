CRP.Commands, CRP.CommandsList = {}, {
	{'ooc', 'Apenas utilize este comando em casos "extremos".', nil, function(source, args)
        local user = GetCharacter(source)

        args = table.concat(args, ' ')

        if isEmpty(args) then
            return
        end

        TriggerClientEvent('chat:addMessage', -1, { color = {255, 255, 255}, templateId = 'blue', args = { user.getFullName(), args }})
	end, {{ name = 'mensagem' }}},
	{'me', 'Envie uma mensagem.', nil, function(source, args)
        args = table.concat(args, ' ')

        if isEmpty(args) then
            return
        end

        TriggerClientEvent('crp-base:displayMe', -1, source, args)
    end, {{ name = 'mensagem' }}},
    {'dinheiro', 'Utilize este comando para conseguir ver o seu dinheiro.', nil, function(source, args)
        TriggerClientEvent('crp-ui:setMoneyStatus', source, { status = true, time = 5000 })
    end, {}},
    {'recrutar', 'Recrute uma pessoa para a sua organização.', nil, function(source, args)
        --- TODO: COMMAND
    end, {{ name = 'id do jogador' }, { name = 'cargo' }}}
}

function CRP.Commands:RegisterCommands()
	for i = 1, #CRP.CommandsList do
		RegisterCommand(CRP.CommandsList[i][1], CRP.CommandsList[i][4], false)
	end
end

CRP.Commands:RegisterCommands()