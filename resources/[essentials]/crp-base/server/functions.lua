function SavePlayers()
    local players = GetPlayers()

    for i = 1, #players, 1 do
        local player = GetCharacter(players[i])

        exports.ghmattimysql:execute('UPDATE users SET money = @money, bank = @bank, job = @job, status = @status, position = @position WHERE identifier = @identifier AND id = @id ;', {
            ['@money'] = player.getMoney(), ['@bank'] = player.getBank(), ['@position'] = json.encode(player.getPosition()), ['@job'] = json.encode(player.getJob()),
            ['@status'] = json.encode(player.getStatus()), ['@id'] = player.getCharacterID(), ['@identifier'] = player.getIdentifier()
        })
    end

    print('^3CRP-BASE:^0 All the players on the server were saved sucessefully. ^7')
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

		SetTimeout(15 * 60000, saveData)
	end

	SetTimeout(15 * 60000, saveData)
end

function StartPayChecks()
    local players = GetPlayers()

    for i = 1, #players, 1 do
        local player = GetCharacter(players[i])
        local playerJob = player.getJob()

        local salary = (jobs[playerJob.name].salary) + (jobs[playerJob.name].salary * (tonumber(playerJob.grade) / 10))

        player.addBank(math.floor(salary))

        TriggerClientEvent('crp-notifications:SendAlert', players[i], { type = 'inform', text = 'Acabaste de receber o teu salario de ' .. math.floor(salary) .. '€.' })
    end

    SetTimeout(5 * 60000, StartPayChecks)
end

function CheckIfHigherRank(name, grade)
    if jobs[name] and grade == jobs[name].maxgrade then
        return true
    end

    return false
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