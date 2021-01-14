fx_version 'cerulean'

game 'gta5'

client_scripts {
	'@polyzone/client/main.lua',
	'@polyzone/client/BoxZone.lua',
	'@polyzone/client/CircleZone.lua',
	'@polyzone/client/ComboZone.lua',
	'client/*.lua',
	'client/util.js'
}

shared_script 'shared/util.lua'

server_scripts {
	'server/database.lua',
	'server/rpc.lua',
	'server/polyzone.lua'
}