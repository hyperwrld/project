local groups = {}

function createGroup(source)
	local character, code = exports['crp-base']:getCharacter(source), getGroupCode()

	groups[code] = {
		code = code, leader = source, members = {}, value = 0
	}

	if joinGroup(source, code, false) then
		return true, returnGroup(source, code)
	end

	groups[code] = nil

	return false
end

RPC:register('createGroup', createGroup)

function joinGroup(source, code, isMember)
	if not groups[code] then
		return false
	end

	local length = #groups[code].members

	if length >= 4 then
		return false
	end

	local character = exports['crp-base']:getCharacter(source)

	groups[code].members[length + 1] = {
		source = source, isMember = isMember, name = character.firstname .. ' ' .. character.lastname, value = 0
	}

	if not isLeader then
		for k, v in ipairs(groups[code].members) do
			if v.source ~= source then
				TriggerClientEvent('crp-jobs:updateGroup', v.source, returnGroup(v.source, code))
			end
		end
	end

	return true
end

RPC:register('joinGroup', function(source, code)
	return joinGroup(source, code, true), returnGroup(source, code)
end)

function returnGroup(source, code)
	if not groups[code] then
		return
	end

	local isLeader = false

	if groups[code].leader == source then
		isLeader = true
	end

	return {
		code = code, source = source, members = groups[code].members, isLeader = isLeader, value = groups[code].value
	}
end

function getGroupCode()
	local canContinue, code = true, GetRandomString(4)

	while true do
		for k, v in ipairs(groups) do
			if k == code then
				canContinue = false
			end
		end

		if canContinue then break end

		canContinue, code = true, GetRandomString(4)
	end

	return code
end