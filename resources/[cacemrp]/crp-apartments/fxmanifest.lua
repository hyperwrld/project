fx_version 'adamant'

game 'gta5'

ui_page 'nui/ui.html'

client_scripts {
    'client/spawn.lua',
    'client/motel.lua',
    'client/functions.lua'
}

server_scripts {
	'server/main.lua'
}

server_exports {
    'GetMotelOwner'
}

files {
	'nui/ui.html',
	'nui/css/main.css',
	'nui/css/pdown.ttf',
	'nui/js/main.js'
}