local ox = exports.ox_inventory

local black_money = 'black_money'

RegisterNetEvent('krs_atmrobbery:addBlackMoney', function()
    local source = source
    local randomMoney = math.random(10000, 20000) 
    
    ox:AddItem(source, black_money, randomMoney)
   
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Krs Atm Robbery', 
        description = locale('description_atm_robbery_receive', randomMoney),
        position = 'top',
        style = {
            backgroundColor = '#141517',
            color = '#C1C2C5',
            ['.description'] = {
              color = '#909296'
            }
        },
        icon = 'fa-solid fa-sack-dollar',
        iconColor = '#FFE066'
    })
end)

function hasJob(target, jobs)
    local x = ESX.GetPlayerFromId(target)

    if type(jobs) == "table" then
        for index, jobName in pairs(jobs) do
            if x.job.name == jobName then return true end
        end
    else
        return x.job.name == jobs
    end

    return false
end

lib.callback.register('krs_atmrobbery:getPoliceOniline', function(source)
    local count = 0
    local players = GetPlayers()

    for i = 1, #players do
        local id = tonumber(players[i])

        if hasJob(id, 'police') then
            count += 1
        end
    end
    return count
end)

RegisterNetEvent("krs_shoprobbery:callPolice", function(job)
    local Player = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetExtendedPlayers('job', job)
    local playerPed = GetPlayerPed(source)
    local coords = GetEntityCoords(playerPed)

    for _, xPlayer in pairs(xPlayers) do
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Krs Atm Robbery', 
            description = locale('description_notify_police'),
            position = 'top',
            style = {
                backgroundColor = '#141517',
                color = '#C1C2C5',
                ['.description'] = {
                  color = '#909296'
                }
            },
            icon = 'fa-solid fa-mask', 
            iconColor = '#4C6EF5'
        })

        TriggerClientEvent("krs_atmrobbery:activateBlip", xPlayer.source, coords)
    end
end)