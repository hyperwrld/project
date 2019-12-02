CRP.Player      = CRP.Player or {}
CRP.LocalPlayer = CRP.LocalPlayer or {}

local function GetUser()
	return CRP.LocalPlayer
end

function CRP.LocalPlayer.setVar(self, var, data)
	GetUser()[var] = data
end

function CRP.LocalPlayer.getVar(self, var)
    return GetUser()[var]
end

function CRP.LocalPlayer.setCurrentCharacter(self, data)
    if not data then return end

    GetUser():setVar('character', data)
end

function CRP.LocalPlayer.getCurrentCharacter(self)
    return GetUser():getVar('character')
end

-- maybe? \/

RegisterNetEvent('crp-base:networkVar')
AddEventHandler('crp-base:networkVar', function(var, value)
    CRP.LocalPlayer:setVar(var, value)
end)