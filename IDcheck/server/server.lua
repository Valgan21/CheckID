local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-checkid:notifyTargetPlayer')
AddEventHandler('qb-checkid:notifyTargetPlayer', function(targetPlayerId, checkerPlayerId)
    local checkerName = GetPlayerName(checkerPlayerId)
    
    -- Enviar notificación al jugador objetivo
    TriggerClientEvent('qb-checkid:clientNotify', targetPlayerId, checkerName .. " está chequeando tu ID", "inform")
end)
