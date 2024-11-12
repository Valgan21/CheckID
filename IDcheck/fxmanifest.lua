fx_version 'cerulean'
game 'gta5'

description 'Script para chequear el ID de otros jugadores y enviar notificaciones a través de qb-core.'
author 'Rolito'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua', -- Archivo de localización de qb-core (opcional si se utiliza)
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua', -- Si utilizas oxmysql (opcional)
    'server/server.lua'
}

dependencies {
    'qb-core',  -- Dependencia de qb-core
    'oxmysql'   -- Dependencia de oxmysql si se utiliza en el servidor
}
