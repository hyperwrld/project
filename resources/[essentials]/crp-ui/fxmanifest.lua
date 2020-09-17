fx_version 'cerulean'

game 'gta5'

ui_page 'nui/dist/index.html'

client_scripts {
    'client/main.lua',
    'client/modules/*.lua',
}

files {
    'nui/dist/index.html',
    'nui/dist/js/app.js',
    'nui/dist/js/chunk-vendors.js',
    'nui/dist/fonts/pdown.ttf',

	'nui/dist/img/*.png',

    'nui/dist/img/seatbelt.svg',
    'nui/dist/img/speed-limiter.svg',

    'nui/dist/css/app.css',
    'nui/dist/css/chunk-vendors.css'
}