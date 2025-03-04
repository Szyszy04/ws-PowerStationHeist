local ox_inventory = exports.ox_inventory
local authorizedPlayer = nil
local cableData = {}

local function generateCableList()
    cableData = {}
    for _, symbol in ipairs(Config.symbols) do
        local num1 = math.random(1, 4)
        local num2
        repeat
            num2 = math.random(1, 4)
        until num1 ~= num2

        table.insert(cableData, { 
            name = symbol,
            cables = "wire " .. num1 .. " wire " .. num2
        })
    end
end

local function isAuthorized(playerId)
    return authorizedPlayer == playerId
end

RegisterNetEvent('powerStationHeist:GiveInstruction')
AddEventHandler('powerStationHeist:GiveInstruction', function(playerId)
    if isAuthorized(playerId) then 
        generateCableList()
        local itemData = {
            name = 'sheet',
            content = cableData 
        }
    
        ox_inventory:AddItem(playerId, 'sheet', 1, itemData)
        TriggerClientEvent('powerStationHeist:sendRandomCable', playerId, cableData)
        TriggerClientEvent('ox_lib:notify', playerId, { type = 'success', description = 'Sheet added to inventory' })
    else
        print("Unauthorized access attempt by player: " .. playerId)
    end
end)

RegisterNetEvent('powerStationHeist:sendRandomCableAgain')
AddEventHandler('powerStationHeist:sendRandomCableAgain', function()
    local playerId = source
    if isAuthorized(playerId) then
        TriggerClientEvent('powerStationHeist:sendRandomCable', playerId, cableData)
    else
        print("Unauthorized access attempt by player: " .. playerId)
    end
end)

RegisterNetEvent('waveScript:useSheet')
AddEventHandler('waveScript:useSheet', function(data)
    TriggerClientEvent('powerStationHeist:showSheetContent', source, data)
end)

RegisterNetEvent('powerStationHeist:giveGeneratorParts')
AddEventHandler('powerStationHeist:giveGeneratorParts', function(bool)
    if bool then
        local playerId = source
        if isAuthorized(playerId) then 
            local success, response = ox_inventory:AddItem(playerId, Config.itemName, Config.itemAmount)
 
            if not success then
                return print(response)
            end
        else
            print("Unauthorized access attempt by player: " .. playerId)
        end
    end
end)

RegisterNetEvent('powerStationHeist:sellGeneratorParts')
AddEventHandler('powerStationHeist:sellGeneratorParts', function(data)
    local playerId = source
    if isAuthorized(playerId) then
        ox_inventory:RemoveItem(playerId, Config.itemName, data)
        ox_inventory:AddItem(playerId, 'money', Config.itemPrice * data)
    else
        print("Unauthorized access attempt by player: " .. playerId)
    end
end)

RegisterNetEvent('powerStationHeist:startHeistServer')
AddEventHandler('powerStationHeist:startHeistServer', function()
    local playerId = source 

    if authorizedPlayer == nil then
        authorizedPlayer = playerId
        TriggerClientEvent('powerStationHeist:startHeistClient', authorizedPlayer, playerId)
    elseif authorizedPlayer == playerId then
        TriggerClientEvent('powerStationHeist:startHeistClient', authorizedPlayer, playerId)
    else
        print("Unauthorized access attempt by player: " .. playerId)
    end
end)

RegisterNetEvent('powerStationHeist:resetData')
AddEventHandler('powerStationHeist:resetData', function(data)
    authorizedPlayer = nil
    cableData = {}
end)
