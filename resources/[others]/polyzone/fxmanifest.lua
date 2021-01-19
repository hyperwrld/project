fx_version 'cerulean'

game 'gta5'

client_scripts {
	'client/main.lua',
	'client/BoxZone.lua',
  	'client/EntityZone.lua',
  	'client/CircleZone.lua',
	'client/ComboZone.lua',
	'client/creation/*.lua'
}

server_scripts {
  'server/creation.lua',
  'server/main.lua'
}