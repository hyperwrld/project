CRP.Player, CRP.Characters = {}, {}

function CRP.Player:LoadCharacter(source, data)
	CRP.Characters[source] = CRP.Player:CreateCharacter(source, data)

	TriggerEvent('crp-base:characterLoaded', source, CRP.Characters[source])

	local characterJob = CRP.Characters[source].job

	for i = 1, #CRP.CommandsList do
		CRP.Commands:AddSugestion(source, CRP.CommandsList[i], CRP.Characters[source].job)
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
	self.bank           = data.bank
	self.job            = data.job
	self.grade          = data.grade
	self.phone          = data.phone
	self.dateofbirth    = data.dateofbirth
	self.gender         = data.gender
	self.position       = data.position

	self.getCharacterId = function()
		return self.id
	end

	self.getPhone = function()
		return self.phone
	end

	self.getGender = function()
		return self.gender
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
		return self.job
	end

	self.getGrade = function()
		return self.grade
	end

	self.setJob = function(jobName, grade)
		if isJobValid(jobName, grade) then
			self.job, self.grade = jobName, grade

			TriggerClientEvent('crp-base:updateJob', self.source, self.job, CRP.JobsList[self.job])
		end
	end

	self.getPosition = function()
		return self.position
	end

	self.setPosition = function(coords)
		self.position = { x = coords.x, y = coords.y, z = coords.z }
	end

	return self
end