local groups = {}

function createGroup(source, jobIdentifier)
	local character, code = exports['crp-base']:getCharacter(source), getGroupCode()

	if inService[character.getJob()] then
		return false
	end

	groups[code] = {
		code = code, job = jobIdentifier, leader = source, members = {}, value = 0
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

	local length, character = #groups[code].members, exports['crp-base']:getCharacter(source)

	if length >= 4 or inService[character.getJob()] then
		return false
	end

	groups[code].members[length + 1] = {
		source = source, isMember = isMember, name = character.firstname .. ' ' .. character.lastname, value = 0
	}

	if not isLeader then
		updateGroupMembers(source, code)
	end

	character.setJob(groups[code].job, 0)

	return true
end

RPC:register('joinGroup', function(source, code)
	return joinGroup(source, code, true), returnGroup(source, code)
end)

function kickMember(source, code, target)
	if not groups[code] or groups[code].leader ~= source then
		return false
	end

	for k, v in ipairs(groups[code].members) do
		if v.source == target then
			table.remove(groups[code].members, k)

			TriggerClientEvent('crp-jobs:updateGroup', target, {})

			updateGroupMembers(source, code)

			return true, returnGroup(source, code)
		end
	end

	return false
end

RPC:register('kickMember', kickMember)

function leaveGroup(source, code)
	if not groups[code] then
		return false
	end

	for k, v in ipairs(groups[code].members) do
		if v.source == source then
			table.remove(groups[code].members, k)

			if groups[code].leader == source then
				if #groups[code].members > 0 then
					groups[code].leader, groups[code].members[1].isMember = groups[code].members[1].source, false

					updateGroupMembers(source, code)
				else
					groups[code] = nil
				end
			end

			return true
		end
	end

	return false
end

RPC:register('leaveGroup', leaveGroup)

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

function updateGroupMembers(source, code)
	for k, v in ipairs(groups[code].members) do
		if v.source ~= source then
			TriggerClientEvent('crp-jobs:updateGroup', v.source, returnGroup(v.source, code))
		end
	end
end