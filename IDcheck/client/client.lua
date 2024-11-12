local Config = {}
Config.ToggleKey = 303 -- Tecla U
Config.NotificationType = "chat" -- Cambiar a "chat" para usar mensajes en el chat, o "notify" para usar v42-notify
Config.TextColor = {r = 0, g = 153, b = 255} -- Cambia estos valores para personalizar el color RGB
Config.TextScale = 0.5 -- Ajusta el tamaño del texto
local rangeLimit = 10.0 -- Define el rango máximo en metros para ver las IDs

local showServerId = false

RegisterKeyMapping('toggleServerId', 'Toggle Server ID Display', 'keyboard', 'U')

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlJustReleased(0, Config.ToggleKey) then
            showServerId = not showServerId
            if showServerId then
                sendNotification("Estás verificando ID", "success")
                local playerCoords = GetEntityCoords(PlayerPedId())
                for _, player in ipairs(GetActivePlayers()) do
                    local ped = GetPlayerPed(player)
                    local targetCoords = GetEntityCoords(ped)
                    local distance = #(playerCoords - targetCoords)

                    if distance <= rangeLimit then
                        local serverId = GetPlayerServerId(player)
                        TriggerServerEvent('qb-checkid:notifyTargetPlayer', serverId, GetPlayerServerId(PlayerId()))
                    end
                end
            else
                sendNotification("Has desactivado la verificación de ID", "error")
            end
        end

        if showServerId then
            local playerCoords = GetEntityCoords(PlayerPedId())
            for _, player in ipairs(GetActivePlayers()) do
                local ped = GetPlayerPed(player)
                local targetCoords = GetEntityCoords(ped)
                local distance = #(playerCoords - targetCoords)

                if distance <= rangeLimit then
                    local serverId = GetPlayerServerId(player)

                    -- Mostrar la ID más alto y con un estilo moderno y minimalista
                    local x, y, z = table.unpack(targetCoords)
                    DrawText3D(x, y, z + 1.5, serverId) -- Ajuste de altura a 1.5
                end
            end
        end
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local fontScale = Config.TextScale or 0.5

    if onScreen then
        SetTextScale(fontScale, fontScale)
        SetTextFont(4) -- Puedes probar otras fuentes (0-4) para ver cuál te gusta más
        SetTextProportional(1)
        SetTextCentre(true)
        
        -- Colores RGB personalizados desde Config
        SetTextColour(Config.TextColor.r, Config.TextColor.g, Config.TextColor.b, 255)
        SetTextOutline()

        BeginTextCommandDisplayText("STRING")
        AddTextComponentString("ID: " .. text)
        EndTextCommandDisplayText(_x, _y)
    end
end

function sendNotification(message, messageType)
    if Config.NotificationType == "notify" then
        SendNUIMessage({
            action = 'testNotify',
            type = messageType,
            time = 7500,
            text = message
        })
    else
        TriggerEvent('chat:addMessage', {
            color = messageType == "success" and {0, 255, 0} or {255, 0, 0},
            multiline = true,
            args = {"Sistema", message}
        })
    end
end

RegisterNetEvent('qb-checkid:clientNotify')
AddEventHandler('qb-checkid:clientNotify', function(message, messageType)
    sendNotification(message, messageType)
end)
