fx_version 'bodacious'

game 'gta5'

client_scripts {
    '@crp-base/shared.lua',
    '@crp-base/client/modules/rpc.lua',
    '@crp-base/client/modules/error.lua',
    'client/main.lua',
}

server_scripts {
    '@crp-base/shared.lua',
    '@crp-base/server/modules/rpc.lua',
    '@crp-base/server/modules/database.lua',
    'server/classes/inventory.lua',
    'server/items.lua',
    'server/main.lua'
}