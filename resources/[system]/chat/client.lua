local chatInputActive, chatInputActivating, chatHidden, chatLoaded = false, false, true, false

RegisterNetEvent('__cfx_internal:serverPrint')
RegisterNetEvent('_chat:messageEntered')

RegisterNetEvent('__cfx_internal:serverPrint')
AddEventHandler('__cfx_internal:serverPrint', function(message)
    print(message)

    SendNUIMessage({
        type = 'ON_MESSAGE',
        message = {
            templateId = 'print',
            multiline = true,
            args = { message }
        }
    })
end)

RegisterNetEvent('chat:addMessage')
AddEventHandler('chat:addMessage', function(message)
    SendNUIMessage({
        type = 'ON_MESSAGE',
        message = message
    })
end)

RegisterNetEvent('chat:addSuggestion')
AddEventHandler('chat:addSuggestion', function(name, help, params)
    SendNUIMessage({
        type = 'ON_SUGGESTION_ADD',
        suggestion = {
            name = name,
            help = help,
            params = params or nil
        }
    })
end)

RegisterNetEvent('chat:addSuggestions')
AddEventHandler('chat:addSuggestions', function(suggestions)
    for _, suggestion in ipairs(suggestions) do
        SendNUIMessage({
        type = 'ON_SUGGESTION_ADD',
        suggestion = suggestion
        })
    end
end)

RegisterNetEvent('chat:removeSuggestion')
AddEventHandler('chat:removeSuggestion', function(name)
    SendNUIMessage({
        type = 'ON_SUGGESTION_REMOVE',
        name = name
    })
end)

RegisterNetEvent('chat:addTemplate')
AddEventHandler('chat:addTemplate', function(id, html)
    SendNUIMessage({
        type = 'ON_TEMPLATE_ADD',
        template = {
            id = id,
            html = html
        }
    })
end)

RegisterNetEvent('chat:clear')
AddEventHandler('chat:clear', function(name)
    SendNUIMessage({
        type = 'ON_CLEAR'
    })
end)

RegisterNUICallback('chatResult', function(data, cb)
    chatInputActive = false
    
    SetNuiFocus(false)

    if not data.canceled then
        local id = PlayerId()

        if data.message:sub(1, 1) == '/' then
            ExecuteCommand(data.message:sub(2))
        end
    end

    cb('ok')
end)

local function refreshCommands()
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()

        local suggestions = {}

        for _, command in ipairs(registeredCommands) do
            if IsAceAllowed(('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
        end

        TriggerEvent('chat:addSuggestions', suggestions)
    end
end

local function refreshThemes()
    local themes = {}

    for resIdx = 0, GetNumResources() - 1 do
        local resource = GetResourceByFindIndex(resIdx)

        if GetResourceState(resource) == 'started' then
            local numThemes = GetNumResourceMetadata(resource, 'chat_theme')

            if numThemes > 0 then
                local themeName = GetResourceMetadata(resource, 'chat_theme')
                local themeData = json.decode(GetResourceMetadata(resource, 'chat_theme_extra') or 'null')

                if themeName and themeData then
                    themeData.baseUrl = 'nui://' .. resource .. '/'
                    themes[themeName] = themeData
                end
            end
        end
    end

    SendNUIMessage({
        type = 'ON_UPDATE_THEMES',
        themes = themes
    })
end

AddEventHandler('onClientResourceStart', function(resName)
    Wait(500)

    refreshCommands()
    refreshThemes()
end)

AddEventHandler('onClientResourceStop', function(resName)
    Wait(500)

    refreshCommands()
    refreshThemes()
end)

RegisterNUICallback('loaded', function(data, cb)
    TriggerServerEvent('chat:init');

    refreshCommands()
    refreshThemes()

    chatLoaded = true

    cb('ok')
end)

Citizen.CreateThread(function()
    SetTextChatEnabled(false)
    SetNuiFocus(false)

    while true do
        Wait(0)

        if not chatInputActive then
            if IsControlPressed(0, 245) then
                chatInputActive = true
                chatInputActivating = true

                SendNUIMessage({
                    type = 'ON_OPEN'
                })
            end
        end

        if chatInputActivating then
            if not IsControlPressed(0, 245) then
                SetNuiFocus(true)

                chatInputActivating = false
            end
        end

        if chatLoaded then
            local shouldBeHidden = false

            if IsScreenFadedOut() or IsPauseMenuActive() then
                shouldBeHidden = true
            end

            if (shouldBeHidden and not chatHidden) or (not shouldBeHidden and chatHidden) then
                chatHidden = shouldBeHidden

                SendNUIMessage({
                    type = 'ON_SCREEN_STATE_CHANGE',
                    shouldHide = shouldBeHidden
                })
            end
        end
    end
end)