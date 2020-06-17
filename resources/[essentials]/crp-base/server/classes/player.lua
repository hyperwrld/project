function CreateCharacter(source, data)
	local self = {}

    -- Initialize all initial variables for a user

	self.source         = source
	self.id             = data.id
	self.identifier     = data.identifier
	self.license        = data.license
	self.money          = data.money
	self.bank           = data.bank
	self.job            = data.job
	self.firstname      = data.firstname
	self.lastname       = data.lastname
	self.dateofbirth    = data.dateofbirth
    self.sex            = data.sex
    self.phone          = data.phone
    self.position       = data.position
	self.moneyDisplayed = false

	if data.status == nil then
		self.status = data.status
	else
		self.status = json.decode(data.status)
	end

	if data.job == nil then
		self.job = data.job
	else
        self.job = json.decode(data.job)

        TriggerClientEvent('crp-jobmanager:updateJob', source, self.job.name, self.job.label, true)
    end

    if data.skin == nil then
        self.skin = data.skin
    else
        self.skin = json.decode(data.skin)
    end

	-- Sets money for the user

	self.setMoney = function(money)
		if type(money) == 'number' then
			local prevMoney = self.money
			local newMoney = money

			self.money = money

			-- Performs some math to see if money was added or removed, mainly for the UI component

			if ((prevMoney - newMoney) < 0) then
				TriggerClientEvent('crp-base:money', self.source, 'add', math.abs(prevMoney - newMoney))
			else
				TriggerClientEvent('crp-base:money', self.source, 'remove', math.abs(prevMoney - newMoney))
			end

			TriggerClientEvent('crp-base:money', self.source, 'activate', self.money)
		else
			print('ERROR: There seems to be an issue while setting money, something else then a number was entered.')
		end
	end

	-- Returns money for the player

	self.getMoney = function()
		return self.money
	end

	-- Sets a players bank balance

	self.setBankBalance = function(money)
		if type(money) == 'number' then
			-- Triggers an event to save it to the database

			TriggerEvent('crp-base:setPlayerData', self.source, 'bank', money, function(response, success)
				self.bank = money
			end)
		else
			print('ERROR: There seems to be an issue while setting bank, something else then a number was entered.')
		end
	end

	-- Returns the players bank

	self.getBank = function()
		return self.bank
	end

	-- Returns the player job

	self.getJob = function()
		return self.job
	end

	-- Sets the player job

	self.setJob = function(job, grade)
		local lastJob = json.decode(json.encode(self.job))

		grade = tonumber(grade)

		if DoesJobExist(job, grade) then
			local jobObject = jobs[job]

            self.job.name, self.job.label, self.job.grade = job, jobObject.label, grade

			TriggerClientEvent('crp-jobmanager:updateJob', self.source, job, jobObject.label, true)
		else
			print('ERROR: There seems to be an issue while setting a job, due to not founding the job.')
		end
	end

	-- Returns the player firstname

	self.getFirstName = function()
		return self.firstname
	end

	-- Returns the player lastname

	self.getLastName = function()
		return self.lastname
	end

	-- Returns the player fullname

	self.getFullName = function()
		return self.firstname .. ' ' .. self.lastname
	end

	-- Returns the player dateofbirth

	self.getDateOfBirth = function()
		return self.dateofbirth
	end

	-- Returns the player sex

	self.getSex = function()
		return self.sex
    end

    -- Returns the player phone number

    self.getPhoneNumber = function()
        return self.phone
    end

	-- Returns the player coords

	self.getPosition = function()
		return self.coords
	end

	-- Sets the player coords, note this won't actually set the players coords on the client.
	-- So don't use this, it's for internal use

	self.setPosition = function(x, y, z)
		self.coords = { x = x, y = y, z = z }
	end

	self.getStatus = function()
		return self.status
	end

	self.setStatus = function(status)
		if self.status == nil then
			self.status = {}
		end

		self.status = status
	end

	-- Kicks the player with the specified reason

	self.kick = function(reason)
		DropPlayer(self.source, reason)
	end

	-- Adds money to the user

	self.addMoney = function(money)
		if type(money) == 'number' then
			local newMoney = self.money + money

			self.money = newMoney

			-- This is used for every UI component to tell them money was just added

			TriggerClientEvent('crp-base:money', self.source, 'add', money)

			TriggerClientEvent('crp-base:money', self.source, 'activate', self.money)
		else
			print('ERROR: There seems to be an issue while adding money, a different type then number was trying to be added.')
		end
	end

	-- Removes money from the user

	self.removeMoney = function(money)
		if type(money) == 'number' then
			local newMoney = self.money - money

			self.money = newMoney

			-- This is used for every UI component to tell them money was just removed

			TriggerClientEvent('crp-base:money', self.source, 'remove', money)

			TriggerClientEvent('crp-base:money', self.source, 'activate', self.money)
		else
			print('ERROR: There seems to be an issue while removing money, a different type then number was trying to be removed.')
		end
	end

	-- Adds money to a users bank

	self.addBank = function(money)
		if type(money) == 'number' then
			local newBank = self.bank + money

			self.bank = newBank
		else
			print('ERROR: There seems to be an issue while adding to bank, a different type then number was trying to be added.')
		end
	end

	-- Removes money from a users bank

	self.removeBank = function(money)
		if type(money) == 'number' then
			local newBank = self.bank - money

			self.bank = newBank
		else
			print('ERROR: There seems to be an issue while removing from bank, a different type then number was trying to be removed.')
		end
	end

	-- This is used to initially start displaying money to the user

	self.displayMoney = function(money)
		if type(money) == 'number' then
			if not self.moneyDisplayed then

				TriggerClientEvent('crp-base:money', self.source, 'activate', self.money)

				self.moneyDisplayed = true
			end
		else
			print('ERROR: There seems to be an issue while displaying money, a different type then number was trying to be shown.')
		end
	end

	-- Returns the players identifier used in EssentialMode

	self.getIdentifier = function()
		return self.identifier
    end

    self.getSource = function()
        return self.source
    end

	-- Returns the character id

	self.getCharacterID = function()
		return self.id
    end

    -- Returns character inventory name

    self.getCharacterInventory = function()
        return 'character-' .. self.id
    end

	return self
end