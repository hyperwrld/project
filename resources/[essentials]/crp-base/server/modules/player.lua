CRP.Player, CRP.Characters = {}, {}

function CRP.Player:LoadCharacter(source, data)
	CRP.Characters[source] = CRP.Player:CreateCharacter(source, data)

	TriggerEvent('crp-base:characterLoaded', source, CRP.Characters[source])

	for i = 1, #CRP.Commands do
        TriggerClientEvent('chat:addSuggestion', source, '/' .. CRP.Commands[i][1], CRP.Commands[i][2], CRP.Commands[i][3])
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

	return self
end