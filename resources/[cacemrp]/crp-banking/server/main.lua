AddEventHandler('crp-banking:deposit', function(source, amount, callback)
    local _source = source
    local user = exports['crp-base']:getCharacter(_source)

    if amount == nil or amount <= 0 or amount > user.getMoney() then
        callback({ status = 'error', text = 'Montante inválido.' })
	else
        user.removeMoney(amount)

        user.addBank(tonumber(amount))

        callback({ status = 'success', text = 'Depósito efetuado.' })
	end
end)

AddEventHandler('crp-banking:withdraw', function(source, amount, callback)
    local _source, base = source, 0
    local user = exports['crp-base']:getCharacter(_source)

	amount, bank = tonumber(amount), user.getBank()

    if amount == nil or amount <= 0 or amount > bank then
        callback({ status = 'error', text = 'Montante inválido.' })
    else
        user.removeBank(amount)

        user.addMoney(amount)

        callback({ status = 'success', text = 'Levantamento efetuado.' })
	end
end)

AddEventHandler('esx-banking:transfer', function(source, target, amount, callback)
    local _source = source
    local user, target, balance = exports['crp-base']:getCharacter(_source), exports['crp-base']:getCharacter(target), 0

    amount = tonumber(amount)

    if (target == nil or target == -1) then
        callback({ status = 'error', text = 'Destinário inválido.' })
    else
        balance = user.getBank()

        if tonumber(_source) == tonumber(target) then
            callback({ status = 'error', text = 'Não é possível transferir para contas próprias.' })
        else
            if balance <= 0 or balance < amount or amount <= 0 then
                callback({ status = 'error', text = 'Você não possui dinheiro suficiente na sua conta bancária.' })
            else
                user.removeBank(amount)

                target.addBank(amount)

                TriggerClientEvent('crp-notifications:SendAlert', target, {
                    type = 'success', text = user.getFullName() .. ' acabou de te transferir ' .. amount .. '€.', length = 4000
                })

                callback({ status = 'success', text = 'Transferência efetuada com sucesso.' })
            end
        end
    end
end)

RegisterServerEvent('crp-banking:updateInfo')
AddEventHandler('crp-banking:updateInfo', function()
	local _source = source
    local user = exports['crp-base']:getCharacter(_source)

	TriggerClientEvent('crp-banking:updateInfo', _source, user.getBank(), user.getFullName())
end)

AddEventHandler('crp-banking:giveMoney', function(source, data, callback)
    local _source, _target, money = source, tonumber(data.target), tonumber(data.money)

    if data.target and data.money then
        if source == data.target then
            callback(false)
        else
            local user, target = exports['crp-base']:getCharacter(_source), exports['crp-base']:getCharacter(_target)

            if target then
                balance = user.getMoney()

                if balance <= 0 or balance < money or money <= 0 then
                    TriggerClientEvent('crp-notifications:SendAlert', _source, { type = 'error', text = 'Você não possui dinheiro suficiente.' })

                    callback(false)
                else
                    user.removeMoney(money)
                    target.addMoney(money)

                    TriggerClientEvent('crp-notifications:SendAlert', _target, { type = 'success', text = 'Acabaste de receber ' .. money .. '€.' })

                    callback(true)
                end
            else
                TriggerClientEvent('crp-notifications:SendAlert', _source, { type = 'error', text = 'O jogador que inseriu não foi encontrado.' })

                callback(false)
            end
        end
    end
end)

TriggerEvent('crp-base:addCommand', 'dardinheiro', function(source, args, user)
    TriggerClientEvent('crp-banking:checkTarget', source, tonumber(args[1]), tonumber(args[2]))
end, { help = 'Envie dinheiro a uma pessoa.', params = {{ name = 'id do jogador' }, { name = 'quantia de dinheiro' }}})

TriggerEvent('crp-base:addCommand', 'atm', function(source, args, user)
    TriggerClientEvent('crp-banking:checkATM', source)
end, { help = 'Ter acesso ao ATM.'} )