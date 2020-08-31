function SendUiMessage(data)
    TriggerEvent('crp-ui:sendNuiMessage', data)
end

function RegisterUiCallback(name, func)
    TriggerEvent('crp-ui:registerNuiCallback', name, func)
end