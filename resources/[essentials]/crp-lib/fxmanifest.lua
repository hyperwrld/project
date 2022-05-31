fx_version 'cerulean'

game 'gta5'

client_scripts {
	'@polyzone/client/main.lua',
	'@polyzone/client/BoxZone.lua',
	'@polyzone/client/CircleZone.lua',
	'@polyzone/client/ComboZone.lua',
	'dist/client/*.*'
}

shared_scripts {
	'dist/shared/util.lua'
}

server_script 'dist/server/*.*'

files {
	'dist/shared/array.lua'
}