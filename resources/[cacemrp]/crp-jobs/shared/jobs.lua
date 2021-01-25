jobsList ={
	{
		identifier = 'unemployed',
		name = 'Desempregado',
		maxGrade = 0
	},
	{
		identifier = 'police',
		name = 'Polícia',
		maxGrade = 0
	},
	{
		identifier = 'medic',
		name = 'Médico',
		maxGrade = 0
	},
	{
		identifier = 'garbageman',
		name = 'Lixeiro',
		maxGrade = 0
	}
}

function getJobIndex(identifier)
	for i = 1, #jobsList, 1 do
		if jobsList[i].identifier == identifier then
			return i
		end
	end

	return false
end