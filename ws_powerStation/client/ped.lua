local ox_target = exports.ox_target
local ox_inventory = exports.ox_inventory

function createPed(model, coords, heading)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    local ped = CreatePed(4, model, coords.x, coords.y, coords.z - 1.0, heading, false, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedFleeAttributes(ped, 0, 0)
    SetPedDiesWhenInjured(ped, false)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    FreezeEntityPosition(ped, true)
    return ped
end

function ShowSubtitle(text, duration)
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandPrint(duration, true)
end

local ped = createPed(Config.pedModel, Config.pedCoords, Config.pedHeading)

local function sellGeneratorParts()

    local count = exports.ox_inventory:Search('count', 'scrapmetal')
    if count > 0 then        
        RegisterNetEvent('powerStationHeist:sellGeneratorParts')
        TriggerServerEvent('powerStationHeist:sellGeneratorParts', count)
        ShowSubtitle("It's a pleasure doing business with you", 3000)
    else
        ShowSubtitle("You have nothing interesting", 3000)
    end
end

ox_target:addLocalEntity(ped, {
    {
        name = 'sell_items',
        label = 'Sell ​​items',
        icon = 'fa-solid fa-handshake',
        onSelect = function()
            sellGeneratorParts()
        end        
    },
    {
        name = 'talk_to_ped',
        label = 'Talk',
        icon = 'fa-solid fa-comments',
        onSelect = function()
            ShowSubtitle("I heard something is happening at the power plant... Watch out!", 3000)
        end
    }
})
