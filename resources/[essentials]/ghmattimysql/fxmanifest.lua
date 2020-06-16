fx_version 'bodacious'

game 'common'

server_scripts {
    'ghmattimysql-server.js',
    'ghmattimysql-server.lua',
}

client_script 'ghmattimysql-client.js'

files {
    'ui/index.html',
    'ui/js/app.js',
    'ui/css/app.css',
    'ui/fonts/*.woff',
    'ui/fonts/*.woff2',
    'ui/fonts/*.eot',
    'ui/fonts/*.ttf',
}

ui_page 'ui/index.html'