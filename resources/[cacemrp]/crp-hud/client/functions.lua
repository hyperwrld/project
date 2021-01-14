function updateMinimap()
	SetScriptGfxAlign(string.byte('L'), string.byte('B'))

	local topX, topY = GetScriptGfxPosition(-0.0045, 0.002 + (-0.188888))

	ResetScriptGfxAlign()

	exports['crp-ui']:updateMinimap(topX, topY)
end

function checkUpdate(health, armour, breath)
	if _lastHealth == health and _lastArmour == armour and _lastBreath == breath then
		return false
	end

	_lastHealth, _lastArmour, _lastBreath = health, armour, breath

	return true
end

local function calculateRangePercent(min, max, amt)
	return (((amt - min) * 100) / (max - min)) / 100
end

function getDirectionHeading()
    local camRot = GetGameplayCamRot(0)
	local heading = 360.0 - ((camRot.z + 360.0) % 360.0)

    if (heading < 90) then
        local rangePercent = heading / 90

        return math.floor((1 - rangePercent) * (-100 * 3) + rangePercent * (-100 * 4))
    elseif (heading < 180) then
        local rangePercent = calculateRangePercent(90, 180, heading)

        return math.floor((1 - rangePercent) * (-100 * 4) + rangePercent * (-100 * 5))
    elseif (heading < 270) then
        local rangePercent = calculateRangePercent(180, 270, heading)

        return math.floor((1 - rangePercent) * (-100) + rangePercent * (-100 * 2))
    elseif (heading <= 360) then
        local rangePercent = calculateRangePercent(270, 360, heading)

        return math.floor((1 - rangePercent) * (-100 * 2) + rangePercent * (-100 * 3))
    end
end

function getCurrentTime()
	local hours, minutes = GetClockHours(), GetClockMinutes()

    if hours >= 0 and hours < 10 then
        hours = '0' .. hours
    end

    if minutes >= 0 and minutes < 10 then
        minutes = '0' .. minutes
	end

    return hours .. ':' .. minutes
end