resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

server_scripts {
	'server/queue-config.lua',
	'connectqueue.lua',
	'shared/queue.lua'
}

client_script 'shared/queue.lua'