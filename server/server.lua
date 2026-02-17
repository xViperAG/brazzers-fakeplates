local BDs = lib.require('modules.server')

-- Functions

-- Functions

local function GeneratePlate()
    local plate = lib.string.random('1AA111AA')
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return GeneratePlate()
    else
        return plate:upper()
    end
end

local function isVehicleOwned(plate)
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return true
    end
end

local function isFakePlateOnVehicle(plate)
    local result = MySQL.scalar.await('SELECT * FROM player_vehicles WHERE fakeplate = ?', {plate})
    if result then
        return true
    end
end exports("isFakePlateOnVehicle", isFakePlateOnVehicle)

-- THIS GETS THE ORIGINAL PLATE FROM THE FAKE PLATE
local function getPlateFromFakePlate(fakeplate)
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE fakeplate = ?', {fakeplate})
    if result then
        return result
    end
end exports("getPlateFromFakePlate", getPlateFromFakePlate)

-- THIS GETS THE FAKEPLATE FROM THE ORIGINAL PLATE
local function getFakePlateFromPlate(plate)
    local result = MySQL.scalar.await('SELECT fakeplate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return result
    end
end exports("getFakePlateFromPlate", getFakePlateFromPlate)

-- Net Events

RegisterNetEvent('brazzers-fakeplates:server:usePlate', function(vehNetID, vehPlate, newPlate, hasKeys)
    local src = source

    if not vehNetID or not vehPlate or not newPlate then return end
    local vehicle = NetworkGetEntityFromNetworkId(vehNetID)

    if isFakePlateOnVehicle(vehPlate) then
        return BDs.Notify(src, 'Contains Fake Plate', 'This vehicle already has another plate over this plate', 'error', 7500, 'fas fa-address-card')
    end

    if not isVehicleOwned(vehPlate) then
        if not hasKeys then
            return BDs.Notify(src, 'Missing Keys', 'You do not have keys to this vehicle!', 'error', 7500, 'fas fa-key')
        end

        SetVehicleNumberPlateText(vehicle, newPlate)
        BDs.GiveKeys(src, newPlate)
        exports.ox_inventory:RemoveItem(src, 'fakeplate', 1)
        return
    end

    exports.ox_inventory:UpdateVehicle(vehPlate, newPlate)
    MySQL.update('UPDATE player_vehicles set fakeplate = ? WHERE plate = ?', { newPlate, vehPlate })

    SetVehicleNumberPlateText(vehicle, newPlate)

    exports.ox_inventory:RemoveItem(src, 'fakeplate', 1)
    if hasKeys then
        BDs.GiveKeys(src, newPlate)
    end
end)

RegisterNetEvent('brazzers-fakeplates:server:removePlate', function(vehNetID, vehPlate, hasKeys)
    local src = source

    if not vehNetID or not vehPlate then return end
    local vehicle = NetworkGetEntityFromNetworkId(vehNetID)

    if not isFakePlateOnVehicle(vehPlate) then
        return BDs.Notify(src, 'No Fake Plate', 'This vehicle does not contain any extra plate on it', 'error', 7500, 'fas fa-address-card')
    end

    local originalPlate = getPlateFromFakePlate(vehPlate)
    if not originalPlate then return end

    exports.ox_inventory:UpdateVehicle(vehPlate, originalPlate)
    MySQL.update('UPDATE player_vehicles set fakeplate = ? WHERE plate = ?', { nil, originalPlate })

    exports.ox_inventory:AddItem(src, 'fakeplate', 1)

    SetVehicleNumberPlateText(vehicle, originalPlate)
    if hasKeys then
        BDs.GiveKeys(src, originalPlate)
    end
end)

-- Callbacks

lib.callback.register('brazzers-fakeplates:server:checkPlateStatus', function(_, vehPlate)
    local retval = false
    local result = MySQL.query.await('SELECT fakeplate FROM player_vehicles WHERE fakeplate = ?', { vehPlate })
    if result then
        for _, v in pairs(result) do
            if vehPlate == v.fakeplate then
                retval = true
            end
        end
    end
    return retval
end)

-- Items

exports.qbx_core:CreateUseableItem('fakeplate', function(source)
    local src = source
    local plate = GeneratePlate()
    TriggerClientEvent("brazzers-fakeplates:client:usePlate", src, plate)
end)
