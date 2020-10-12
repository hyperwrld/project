game 'gta5'

fx_version 'cerulean'

description 'Define polygonal zones and test whether a point is inside or outside of the zone'
version '2.1.0'

client_scripts {
  	'client/main.lua',
  	'client/BoxZone.lua',
  	'client/EntityZone.lua',
  	'client/CircleZone.lua',
  	'client/ComboZone.lua',
  	'client/creation/*.lua'
}

server_scripts {
  	'server/main.lua'
}