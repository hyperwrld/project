fx_version 'bodacious'

game 'gta5'

dependency 'crp-ui'

client_scripts {
    '@crp-base/shared.lua',
    '@crp-base/client/modules/rpc.lua',
    'client/main.lua',
}

server_scripts {
    '@crp-base/shared.lua',
    '@crp-base/server/modules/rpc.lua',
    'server/classes/inventory.lua',
    'server/items.lua',
    'server/main.lua'
}