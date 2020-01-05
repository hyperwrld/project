resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

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