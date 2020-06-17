fx_version 'bodacious'

game 'gta5'

ui_page 'nui/dist/index.html'

client_scripts {
    'shared.lua',
    'client/modules/blips.lua',
    'client/modules/gameplay.lua',
    'client/modules/rpc.lua',
    'client/modules/spawn.lua',
    'client/main.lua'
}

server_scripts {
    'shared.lua',
    'server/classes/player.lua',
    'server/modules/commands.lua',
    'server/modules/database.lua',
    'server/modules/rpc.lua',
    'server/player/login.lua',
    'server/player/wrappers.lua',
    'server/functions.lua',
    'server/main.lua'
}

files {
    'nui/dist/index.html',

    'nui/dist/fonts/fa-brands-400.eot',
    'nui/dist/fonts/fa-brands-400.ttf',
    'nui/dist/fonts/fa-brands-400.woff',
    'nui/dist/fonts/fa-brands-400.woff2',

    'nui/dist/fonts/fa-regular-400.eot',
    'nui/dist/fonts/fa-regular-400.ttf',
    'nui/dist/fonts/fa-regular-400.woff',
    'nui/dist/fonts/fa-regular-400.woff2',

    'nui/dist/fonts/fa-solid-900.eot',
    'nui/dist/fonts/fa-solid-900.ttf',
    'nui/dist/fonts/fa-solid-900.woff',
    'nui/dist/fonts/fa-solid-900.woff2',

    'nui/dist/img/fa-brands-400.svg',
    'nui/dist/img/fa-regular-400.svg',
    'nui/dist/img/fa-solid-900.svg',

    'nui/dist/js/app.js',
    'nui/dist/js/chunk-vendors.js',
    'nui/dist/css/app.css',
    'nui/dist/css/chunk-vendors.css'
}