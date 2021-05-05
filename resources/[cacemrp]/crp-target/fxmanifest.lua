fx_version 'cerulean'

game 'gta5'

dependecies {
	'crp-lib',
	'crp-ui',
	'crp-binds'
}

client_scripts {
	'@polyzone/client/main.lua',
	'@polyzone/client/BoxZone.lua',
	'@crp-lib/client/main.lua',
	'client/utils.lua',
	'client/main.lua'
}

shared_script '@crp-lib/shared/util.lua'