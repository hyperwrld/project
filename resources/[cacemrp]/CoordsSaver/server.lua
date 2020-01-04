local CurrentVersion = '1.0.0'

RegisterServerEvent('CoordSaver:SaveCoords')
AddEventHandler('CoordSaver:SaveCoords', function(PlayerName, X, Y, Z, H)
	local Output
	local OldCoords = LoadResourceFile(GetCurrentResourceName(), 'Saved' .. GetOSSep() .. PlayerName .. ' - Coords.txt')
	if OldCoords == nil or OldCoords == '' then
		Output = '{x = ' .. X .. ', y = ' .. Y .. ', z = ' .. Z .. '} {H: ' .. H .. '}'
	else
		Output = OldCoords .. '\n{x = ' .. X .. ', y = ' .. Y .. ', z = ' .. Z .. '} {H: ' .. H .. '}'
	end
	local UnusedBool = SaveResourceFile(GetCurrentResourceName(), 'Saved' .. GetOSSep() .. PlayerName .. ' - Coords.txt', Output, -1)
end)

AddEventHandler('chatMessage', function(Source, Color, Message)
    if Message:sub(1, 1) == '/' then
        local fullcmd = stringsplit(Message, ' ')
        local cmd = fullcmd[1]
		local Comment

		if #fullcmd > 1 then
			Comment = fullcmd[2]
			if #fullcmd > 2 then
				for i=3, #fullcmd do
					Comment = Comment .. ' ' .. fullcmd[i]
				end
			end
		end
		
        if cmd:lower() == '/savepos' then
        	TriggerClientEvent('CoordSaver:GetCoords', Source, Comment)
        	CancelEvent()
        end
    end
end)

RegisterCommand('savepos', function(source, args)
    TriggerClientEvent('CoordSaver:GetCoords', source)
end)

function stringsplit(Input, Seperator)
	if Seperator == nil then
		Seperator = '%s'
	end
	
	local t={} ; i=1
	
	for str in string.gmatch(Input, '([^'..Seperator..']+)') do
		t[i] = str
		i = i + 1
	end
	
	return t
end

function GetOSSep()
	if os.getenv('HOME') then
		return '/'
	else
		return '\\'
	end
end

