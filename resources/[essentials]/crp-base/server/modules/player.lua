CRP.Player, CRP.Characters = {}, {}

function CRP.Player:LoadCharacter(source, data)
	CRP.Characters[source] = CRP.Player:CreateCharacter(source, data)

	TriggerEvent('crp-base:characterLoaded', source, CRP.Characters[source])

	local characterJob = CRP.Characters[source].job

	for i = 1, #CRP.CommandsList do
		local necessaryPerms = CRP.Commands[i][3]

		if necessaryPerms then
			local foundPerm = false

			for i = 1, #necessaryPerms do
				if not necessaryPerms[i] == characterJob then
					return
				end

				foundPerm = true
				break
			end

			if not foundPerm then
				return
			end
		end

        TriggerClientEvent('chat:addSuggestion', source, '/' .. CRP.Commands[i][1], CRP.Commands[i][2], CRP.Commands[i][5])
	end

	return CRP.Characters[source]
end

function CRP.Player:CreateCharacter(source, data)
	local self = {}

	self.source         = source
	self.id             = data.id
	self.identifier     = data.identifier
	self.firstname      = data.firstname
	self.lastname       = data.lastname
	self.money          = data.money
	self.bank           = data.bank
	self.job            = data.job
	self.grade          = data.grade
	self.phone          = data.phone
	self.dateofbirth    = data.dateofbirth
	self.gender         = data.gender

	self.getCharacterId = function()
		return self.id
	end

	self.getPhone = function()
		return self.phone
	end

	self.getGender = function()
		return self.gender
	end

	self.getMoney = function()
		return self.money
	end

	self.addMoney = function(quantity)
		if type(quantity) == 'number' then
			local newQuantity = self.money + quantity

			self.money = math.floor(newQuantity)

			TriggerClientEvent('crp-ui:addMoney', self.source, quantity)
		end
	end

	self.removeMoney = function(quantity)
		if type(quantity) == 'number' then
			local newQuantity = self.money - quantity

			self.money = math.floor(newQuantity)

			TriggerClientEvent('crp-ui:removeMoney', self.source, quantity)
		end
	end

	self.getBank = function()
		return self.bank
	end

	self.addBank = function(quantity)
		if type(quantity) == 'number' then
			local newQuantity = self.bank + quantity

			self.bank = math.floor(newQuantity)
		end
	end

	self.removeBank = function(quantity)
		if type(quantity) == 'number' then
			local newQuantity = self.bank - quantity

			self.bank = math.floor(newQuantity)
		end
	end

	self.getJob = function()
		return {
			name = self.job, grade = self.grade
		}
	end

	self.setJob = function(jobName, grade)
		if isJobValid(jobName, grade) then
			self.job, self.grade = jobName, grade

			TriggerClientEvent('crp-base:updateJob', self.source, self.job, CRP.JobsList[self.job])
		end
	end

	return self
end