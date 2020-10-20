fx_version 'cerulean'

game 'gta5'



client_scripts {
	'@PolyZone/client/main.lua',
	'@PolyZone/client/BoxZone.lua',
	'@PolyZone/client/CircleZone.lua',
	'@PolyZone/client/ComboZone.lua',
	'client/*.lua'
}

shared_script 'shared/util.lua'

server_scripts {
	'server/*.lua'
}