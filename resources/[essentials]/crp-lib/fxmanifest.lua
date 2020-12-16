fx_version 'cerulean'

game 'gta5'

client_scripts {
	'@PolyZone/client/main.lua',
	'@PolyZone/client/BoxZone.lua',
	'@PolyZone/client/CircleZone.lua',
	'@PolyZone/client/ComboZone.lua',
	'client/*.*'
}

shared_script 'shared/util.lua'

server_scripts {
	'server/database.lua',
	'server/rpc.lua',
	'server/polyzone.lua'
}