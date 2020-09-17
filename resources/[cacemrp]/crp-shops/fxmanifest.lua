fx_version 'cerulean'

game 'gta5'

dependecies {
	'PolyZone',
	'crp-ui',
	'crp-lib'
}

client_scripts {
	'@PolyZone/client/main.lua',
	'@PolyZone/client/BoxZone.lua',
	'@PolyZone/client/CircleZone.lua',
	'@PolyZone/client/ComboZone.lua',
	'client/main.lua'
}

shared_script '@crp-lib/shared/util.lua'