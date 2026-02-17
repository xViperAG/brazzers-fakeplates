local BDc = require 'modules.client'

-- Net Events

RegisterNetEvent('brazzers-fakeplates:client:usePlate', function(plate)
    if not plate then return end
    local vehicle = lib.getClosestVehicle(GetEntityCoords(cache.ped), 5.0)
    local hasKeys = false

    if not vehicle then return end

    local currentPlate = qbx.getVehiclePlate(vehicle)

    if BDc.HasKeys(currentPlate) then hasKeys = true end

    TaskTurnPedToFaceEntity(cache.ped, vehicle, 3.0)

    if lib.progressCircle({
        label = "Attaching Plate",
        duration = 4000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, combat = true, car = true },
        anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer', flag = 1 }
    }) then
        TriggerServerEvent('brazzers-fakeplates:server:usePlate', VehToNet(vehicle), currentPlate, plate, hasKeys)
        ClearPedTasks(cache.ped)
    else
        ClearPedTasks(cache.ped)
    end
end)

RegisterNetEvent('brazzers-fakeplates:client:removePlate', function()
    local vehicle = lib.getClosestVehicle(GetEntityCoords(cache.ped), 5.0)
    local hasKeys = false

    if not vehicle then return end

    local currentPlate = qbx.getVehiclePlate(vehicle)

    if BDc.HasKeys(currentPlate) then hasKeys = true end

    TaskTurnPedToFaceEntity(cache.ped, vehicle, 3.0)
    if lib.progressCircle({
        label = 'Removing Plate',
        duration = 4000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, combat = true, },
        anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer', flag = 1 }
    }) then
        TriggerServerEvent('brazzers-fakeplates:server:removePlate', VehToNet(vehicle), currentPlate, hasKeys)
        ClearPedTasks(cache.ped)
    else
        ClearPedTasks(cache.ped)
    end
end)

exports.ox_target:addGlobalVehicle({
    {
        name = 'fake_plate_install',
        event = 'brazzers-fakeplates:client:removePlate',
        icon = 'fas fa-closed-captioning',
        label = 'Remove Plate',
        bones = { 'boot' },

        -- Commented out the screwdriver portion as it seems I may have left it out because I had used it in my old server. kekw
        -- items = { 'screwdriver' },

        canInteract = function(entity)
            local hasPlate = lib.callback.await('brazzers-fakeplates:server:checkPlateStatus', false, qbx.getVehiclePlate(entity))
            return hasPlate
        end,
        distance = 2.5,
    }
})