AddEventHandler('crp-base:createdCharacter', function(characterId)
	exports['crp-banking']:createAccount(1, characterId, 'Conta Pessoal', 5000)
end)

RPC:register('fetchBank', function(source)
    return fetchBank(source)
end)

function createAccount(accountType, characterId, accountName, startingMoney)
	if not accountType or type(accountType) ~= 'number' then return false end
	if not characterId or type(characterId) ~= 'number' then return false end
	if not accountName or type(accountName) ~= 'string' then return false end
	if not startingMoney or type(startingMoney) ~= 'number' then return false end

	local query = [[INSERT INTO accounts (type, owner, name, money) VALUES (?, ?, ?, ?);]]
    local result = Citizen.Await(DB:Execute(query, accountType, characterId, accountName, startingMoney))

	if not result.changedRows then
		return false
	end

	return true
end

function fetchBank(source)
	local character = exports['crp-base']:getCharacter(source)
	local characterId = character.getCharacterId()

	local query = [[
		SELECT
			accounts.id, accounts.owner, type.name AS type, CONCAT(characters.firstname, ' ',  characters.lastname) AS owner_name, accounts.name,
			holders.permissions, accounts.money
	  	FROM accounts
			INNER JOIN accounts_holders holders
		  		ON accounts.owner = ?
		  		OR holders.`character` = ?
		  		AND holders.account = accounts.id
			INNER JOIN accounts_type type
		  		ON accounts.type = type.id JOIN characters ON accounts.owner = characters.id
	  	GROUP BY accounts.id
	  	ORDER BY FIELD(accounts.owner, ?) DESC;
	]]
    local result = Citizen.Await(DB:Execute(query, characterId, characterId, characterId))

	if #result == 0 then
		return false
	end

	return true, characterId, result
end

exports('createAccount', createAccount)