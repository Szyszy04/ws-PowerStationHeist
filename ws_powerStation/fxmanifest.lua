fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Szyszy'
description 'Power station heist'
version '1.0.0'

server_scripts {
    'server/server.lua'
}

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    'client/client.lua',
    'client/target.lua',
    'client/ped.lua',
}

ui_page 'nui/index.html'

files {
    'nui/index.html',
    'nui/hackGame.js',
    'nui/instruction.js',
    'nui/cables.js',
    'nui/spamming.js',
    'nui/style.css',
    'nui/*'
}

dependencies {
    'ox_target',
    'ox_inventory'
}