fx_version 'bodacious'

game 'gta5'

client_scripts {
	'@crp-lib/client/main.lua',
    '@crp-base/shared.lua',
    '@crp-base/client/modules/rpc.lua',
    'client/functions.lua',
    'client/main.lua',
}

server_scripts {
    '@crp-base/shared.lua',
	'@crp-base/server/modules/rpc.lua',
	'server/items.lua',
	'server/classes/inventory.lua',
	'server/shops.lua',
    'server/main.lua'
}