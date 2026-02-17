local BDs = {}

function BDs.GiveKeys(source, plate)
    if GetResourceState('qbx_vehiclekeys'):match('started') then
        TriggerClientEvent('vehiclekeys:client:SetOwner', source, plate)
    elseif GetResourceState('Renewed-Vehiclekeys'):match('started') then
        exports['Renewed-Vehiclekeys']:addKey(source, plate)
    else
        -- Insert your own key here!
    end
end

function BDs.Notify(source, title, description, type, length, icon)
    return lib.notify(source, {
        title = title,
        description = description,
        type = type,
        duration = length,
        icon = icon,
    })
end

return BDs