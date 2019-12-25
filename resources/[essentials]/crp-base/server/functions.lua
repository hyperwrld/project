function SavePlayers()
    local players = GetPlayers()

    for i = 1, #players, 1 do
        local player = GetCharacter(players[i])

        exports.ghmattimysql:execute('UPDATE users SET money = @money, job = @job, status = @status, position = @position WHERE identifier = @identifier AND id = @id ;', {
            ['@money'] = player.getMoney(), ['@position'] = json.encode(player.getPosition()), ['@job'] = json.encode(player.getJob()),
            ['@status'] = json.encode(player.getStatus()), ['@id'] = player.getCharacterID(), ['@identifier'] = player.getIdentifier() 
        })
    end

    print('^3CRP-BASE:^0 All players on the server saved. ^7')
end

function GetPlayers()
    local sources = {}

    for k, v in pairs(users) do
        table.insert(sources, k)
    end

    return sources
end

function StartSavingPlayers()
    function saveData()
        SavePlayers()
        
		SetTimeout(10 * 60 * 1000, saveData)
	end

	SetTimeout(10 * 60 * 1000, saveData)
end

function DoesJobExist(job, grade)
    grade = tonumber(grade)

    if job and grade then
        if jobs[job] and grade >= jobs[job].mingrade and grade <= jobs[job].maxgrade then
            return true
        end
    end

    return false
end