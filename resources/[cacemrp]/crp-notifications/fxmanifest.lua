fx_version 'adamant'

games 'gta5'

ui_page 'nui/ui.html'

client_script 'client/main.lua'

files {
	'nui/ui.html',
	'nui/scripts.js',
	'nui/styles.css'
}

exports {
	'SendAlert',
	'SendCustomAlert',
	'SendPersistantAlert'
}