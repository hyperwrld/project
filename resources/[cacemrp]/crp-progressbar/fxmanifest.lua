fx_version 'adamant'

game 'gta5'

ui_page 'nui/ui.html'

client_scripts {
	'client/main.lua'
}

files {
	'nui/ui.html',
	'nui/styles.css',
	'nui/scripts.js',
}

exports {
    'StartProgressBar',
    'CancelAction'
}