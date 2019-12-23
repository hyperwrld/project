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

TriggerEvent('crp-base:addCommand', 'atm', function(source, args, user)
    TriggerClientEvent('crp-banking:checkATM', source)
end, { help = 'Ter acesso ao ATM.'} )