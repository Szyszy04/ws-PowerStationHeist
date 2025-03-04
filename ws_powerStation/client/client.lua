local displayCables = false
local displaySpamming = false
local displayHack = false
local randomCable = nil

local function sendToNUI(typeName, content)
    SendNUIMessage({
        type = typeName,
        status = content.status or false,
        instruction = content.instruction or nil,
        newTime = content.time or nil,
        numberElements = content.elements or nil,
        removePer = content.removePercent or nil,
        percentPerClick = content.addPercentPerClick or nil,
    })
end

local function toggleNuiFocus(status)
    SetNuiFocus(status, status)
end

RegisterNetEvent('powerStationHeist:sendRandomCable')
AddEventHandler('powerStationHeist:sendRandomCable', function(content)
    local randomIndex = math.random(1, #content)
    randomCable = content[randomIndex]
end)

RegisterNUICallback("exitCabels", function(data, cb)
    displayCables = false
    toggleNuiFocus(false)
    TriggerEvent('powerStationHeist:endCables', data.success)
    cb('ok')
end)

RegisterNetEvent('powerStationHeist:startCables')
AddEventHandler('powerStationHeist:startCables', function(bool)
    displayCables = true
    if displayCables then
        toggleNuiFocus(bool)
        sendToNUI("sendCabels", {instruction = randomCable, status = true})
    end
end)

RegisterNetEvent('powerStationHeist:startSpamming')
AddEventHandler('powerStationHeist:startSpamming', function(bool)
    displaySpamming = true
    if displaySpamming then
        toggleNuiFocus(bool)
        sendToNUI("sendSpamming", {
            status = bool,
            removePercent = Config.removePercent,
            addPercentPerClick = Config.addPercentPerClick
        })
    end
end)

RegisterNUICallback("exitSpamming", function(data, cb)
    displaySpamming = false
    toggleNuiFocus(false)
    TriggerEvent('powerStationHeist:endSpamming', data.success)
    cb('ok')
end)

RegisterNetEvent('powerStationHeist:showSheetContent')
AddEventHandler('powerStationHeist:showSheetContent', function(content)
    toggleNuiFocus(true)
    sendToNUI("showSheetContent", {status = true, instruction = content})
end)

RegisterNUICallback('closeUISheet', function(data, cb)
    toggleNuiFocus(false)
    cb('ok')
end)

RegisterNUICallback("exitHack", function(data, cb)
    displayHack = false
    toggleNuiFocus(false)
    TriggerEvent('powerStationHeist:endHack', data.success)
    cb('ok')
end)

Citizen.CreateThread(function()
    while displayHack do
        Citizen.Wait(0)
        local controls = {1, 2, 142, 18, 322, 106}
        for _, control in ipairs(controls) do
            DisableControlAction(0, control, displayHack)
        end
    end
end)

RegisterNetEvent('powerStationHeist:showHack')
AddEventHandler('powerStationHeist:showHack', function(content)
    displayHack = true
    toggleNuiFocus(displayHack)
    sendToNUI("sendHackGame", {status = displayHack}, {time = Config.timeLeft}, {elements = Config.numberElements})
end)

RegisterNetEvent('powerStationHeist:resetDataClient')
AddEventHandler('powerStationHeist:resetDataClient', function(data)
    displayCables = false
    displaySpamming = false
    displayHack = false
    randomCable = nil
    SendNUIMessage({
        type = "resetDataNUI"
    })
end)
