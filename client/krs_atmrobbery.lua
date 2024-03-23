local ox = exports.ox_inventory

function hasJob(jobs)
    local playerData = ESX.GetPlayerData()

    if type(jobs) == "table" then
        for index, jobName in pairs(jobs) do
            if playerData.job.name == jobName then return true end
        end
    else
        return playerData.job.name == jobs
    end

    return false
end

local gameData = {
    totalNumbers = 15,
    seconds = 30,
    timesToChangeNumbers = 4,
    amountOfGames = 2,
    incrementByAmount = 5,
}

RegisterNetEvent('krs_atmrobbery:activateBlip', function(position)
    local blip = AddBlipForCoord(position)
    SetBlipSprite(blip, 161)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 0)
    PulseBlip(blip)

    local seconds = 1000
    local minutes = seconds * 60

    Wait(1 * minutes) 
    RemoveBlip(blip)
end)

for k, v in pairs(cfg.robbery) do
    print(ESX.DumpTable(v))

    exports.ox_target:addModel(v.props, {
        {
            icon = 'fa-solid fa-sack-dollar', 
            label = 'Start atm robbery',
            canInteract = function(entity, distance, coords, name, bone)
                return not IsEntityDead(entity)
            end,         
            onSelect = function(data)
                if not IsPedArmed(cache.ped, 4) then
                    lib.notify({
                        id = 'some_identifier',
                        title = locale('title_notify'),
                        description = locale('description_not_have_weapon'),
                        position = 'top',
                        style = {
                            backgroundColor = '#141517',
                            color = '#C1C2C5',
                            ['.description'] = {
                                color = '#909296'
                            }
                        },
                        icon = 'fa-solid fa-gun', 
                        iconColor = '#FA5252'
                    })
                    return
                end
                local pistola = ox:Search('count', v.itemRequiredRobbery) 
                if pistola < 1 then
                    lib.notify({
                        id = 'some_identifier',
                        title = locale('title_notify'),
                        description = locale('description_not_have_item', v.itemRequiredRobbery),
                        position = 'top',
                        style = {
                            backgroundColor = '#141517',
                            color = '#C1C2C5',
                            ['.description'] = {
                                color = '#909296'
                            }
                        },
                        icon = 'fa-solid fa-gun', 
                        iconColor = '#FA5252'
                    })
                    return
                end
                local playerJob = ESX.GetPlayerData().job
                if playerJob and playerJob.name == 'police' then
                    lib.notify({
                        id = 'some_identifier',
                        title = locale('title_notify'),
                        description = locale('description_not_authorize_police'),
                        position = 'top',
                        style = {
                            backgroundColor = '#141517',
                            color = '#C1C2C5',
                            ['.description'] = {
                                color = '#909296'
                            }
                        },
                        icon = 'fa-solid fa-building-shield', 
                        iconColor = '#C53030'
                    })
                    return
                end
                lib.callback('krs_atmrobbery:getPoliceOniline', false, function(lspdCount)
                    print(lspdCount)
                    if type(lspdCount) == "number" and lspdCount >= v.Lspd then
                        if not cache.vehicle then
                            local result = exports['pure-minigames']:numberCounter(gameData)
                            if result then
                                TriggerServerEvent('krs_shoprobbery:callPolice', 'police') 
                                if lib.progressCircle({
                                    duration = v.duration,
                                    label = v.label,
                                    position = v.position,
                                    useWhileDead = false,
                                    canCancel = true,
                                    disable = {
                                        car = true,
                                        move = true
                                    },
                                    anim = {
                                        dict = v.dict,
                                        clip = v.clip
                                    },
                                }) then
                                    TriggerServerEvent('krs_atmrobbery:addBlackMoney')
                                end
                            else
                                lib.notify({
                                    id = 'some_identifier',
                                    title = locale('title_notify'),
                                    description = locale('description_minigame_failed'),
                                    position = 'top',
                                    style = {
                                        backgroundColor = '#141517',
                                        color = '#C1C2C5',
                                        ['.description'] = {
                                            color = '#909296'
                                        }
                                    },
                                    icon = 'fa-solid fa-puzzle-piece', 
                                    iconColor = '#FA5252'
                                })
                            end
                        else
                            lib.notify({
                                id = 'some_identifier',
                                title = locale('title_notify'),
                                description = locale('description_insufficient_police', v.Lspd),
                                position = 'top',
                                style = {
                                    backgroundColor = '#141517',
                                    color = '#C1C2C5',
                                    ['.description'] = {
                                        color = '#909296'
                                    }
                                },
                                icon = 'fa-solid fa-building-shield', 
                                iconColor = '#4263EB'
                            })
                        end
                    else
                        lib.notify({
                            id = 'some_identifier',
                            title = locale('title_notify'),
                            description = locale('description_insufficient_police', v.Lspd),
                            position = 'top',
                            style = {
                                backgroundColor = '#141517',
                                color = '#C1C2C5',
                                ['.description'] = {
                                    color = '#909296'
                                }
                            },
                            icon = 'fa-solid fa-building-shield', 
                            iconColor = '#4263EB'
                        })
                    end
                end)
            end
        }
    })
end
