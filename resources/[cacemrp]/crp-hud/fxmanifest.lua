fx_version 'cerulean'

game 'gta5'

dependecies {
	'crp-base', 'crp-ui', 'crp-lib'
}

client_scripts {
	'@crp-lib/client/main.lua',
    'client/*.lua'
}

shared_script '@crp-lib/shared/util.lua'

server_scripts {
	'server/*.lua'
}