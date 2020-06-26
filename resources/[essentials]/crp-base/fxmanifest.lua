fx_version 'bodacious'

game 'gta5'

client_scripts {
    'shared.lua',
    'client/modules/blips.lua',
    'client/modules/gameplay.lua',
    'client/modules/rpc.lua',
    'client/modules/spawn.lua',
    'client/modules/error.lua',
    'client/main.lua'
}

server_scripts {
    'shared.lua',
    'server/modules/player.lua',
    'server/modules/commands.lua',
    'server/modules/utils.lua',
    'server/modules/rpc.lua',
    'server/modules/database.lua',
    'server/main.lua'
}