resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page 'html/ui.html'

client_scripts {
	'shared.lua',
	'client/blips.lua',
	'client/events.lua',
	'client/gameplay.lua',
	'client/player.lua',
	'client/spawn.lua',
	'core/shared-core.lua',
	'core/client-core.lua',
	'core/shared-enums.lua',
	'core/shared-util.lua',
}

export {
	'addModule',
	'getModule'
}

server_scripts {
	'shared.lua',
	'core/shared-core.lua',
	'core/shared-enums.lua',
	'core/shared-util.lua',
	'server/classes/player.lua',
	'server/player/login.lua',
	'server/functions.lua',
	'server/common.lua',
	'server/util.lua',
    'server/main.lua',
    'server/commands.lua'
}

server_exports {
	'GetCharacter',
	'CheckIfHigherRank'
}

files {
	'html/ui.html',
	'html/css/main.css',
	'html/css/pdown.ttf',
	'html/js/main.js',
	'html/ui.html'
}