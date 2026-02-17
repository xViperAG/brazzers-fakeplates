local BDc = {}

function BDc.HasKeys(plate)
    if GetResourceState('qbx_vehiclekeys'):match('started') then
        exports.qbx_vehiclekeys:HasKeys(plate)
    elseif GetResourceState('Renewed-Vehiclekeys'):match('started') then
        exports['Renewed-Vehiclekeys']:hasKey()
    else
        -- Insert your own key here!
    end
end

function BDc.Notify(title, description, type, length, icon)
    local notifType = type

    if type == 'primary' then
        notifType = 'info'
    end

    return lib.notify({
        title = title,
        description = description,
        icon = icon,
        type = notifType,
        duration = length
    })
end

return BDc