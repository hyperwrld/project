RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('chat:clear')

RegisterServerEvent('__cfx_internal:commandFallback')
AddEventHandler('__cfx_internal:commandFallback', function(command)
    local commandArgs = splitString(command, ' ')

    TriggerClientEvent('chat:addMessage', source, { templateId = 'orange', args = { '^*Comando inválido^r' , ' /' .. commandArgs[1]:lower() }, color = { 255, 255, 255 } })

    CancelEvent()
end)

local function refreshCommands(player)
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()

        local suggestions = {}

        for _, command in ipairs(registeredCommands) do
            if IsPlayerAceAllowed(player, ('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
        end

        TriggerClientEvent('chat:addSuggestions', player, suggestions)
    end
end

function splitString(inputString, seperator)
    local t = {} ; i = 1

    if seperator == nil then seperator = '%s' end
    
	for string in string.gmatch(inputString, '([^' .. seperator .. ']+)') do
        t[i] = string
        
		i = i + 1
    end
    
	return t
end

RegisterServerEvent('chat:init')
AddEventHandler('chat:init', function()
    refreshCommands(source)
end)

AddEventHandler('onServerResourceStart', function(resName)
    Wait(500)

    for _, player in ipairs(GetPlayers()) do
        refreshCommands(player)
    end
end)
