objectList = {
    [`prop_vend_coffe_01`] = {
        eventName = 'crp-inventory:openShop', type = 1, label = 'Máquina de vendas', data = { 3 }
    }
}

function RotationToDirection(rotation)
	local adjustedRotation = {
		x = (math.pi / 180) * rotation.x, y = (math.pi / 180) * rotation.y, z = (math.pi / 180) * rotation.z
	}

	return {
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), z = math.sin(adjustedRotation.x)
	}
end