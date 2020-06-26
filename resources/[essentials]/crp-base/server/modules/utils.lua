CRP.Util = {}

local function GenerateRandomNumber(min, max)
    min, max = math.ceil(min), math.floor(max)

    return math.floor(math.random() * (max - min + 1)) + min
end

function CRP.Util:GeneratePhoneNumber()
    local phoneNumber, identifier

    repeat
        math.randomseed(os.time())

        phoneNumber = '96' .. GenerateRandomNumber(9999999, 0000000)

        exports.ghmattimysql:execute('SELECT * FROM users WHERE `phone` = @phone;', { ['phone'] = phoneNumber }, function(exists)
            identifier = exists[1]
        end)
    until identifier == nil

    return phoneNumber
end

function CRP.Util:GetPlayerIdentifier(source)
    local identifier

    for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.match(v, 'discord:') then
            identifier = string.sub(v, 9)
            break
        end
    end

    return identifier
end

function CRP.Util:Print(string, module)
    if not module then
        print('[^1crp-base^0]: ' .. string)
    else
        print('[^1crp-base^0] - [^3' .. module .. '^0]: ' .. string)
    end
end