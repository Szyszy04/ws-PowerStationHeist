local ox_target = exports.ox_target
local ox_inventory = exports.ox_inventory
local startHeistAttempt = Config.startHeistAttempt
local zoneStartHeist
local zoneInstruction
local zoneCable
local zoneGenerator
local activeZone
local activeZone2
local generatorOptions = {
    {
        name = "Generator1",
        coords = vector3(742.53, -1975.33, 29.0),
        size = vector3(0.75, 0.5, 3),
        rotation = 175.0
    },
    {
        name = "Generator2",
        coords = vector3(748.6, -1976.0, 29.0),
        size = vector3(0.9, 0.5, 3),
        rotation = 355.0
    },
    {
        name = "generator3",
        coords = vector3(741.5, -1987.5, 29.0),
        size = vector3(0.7, 0.3, 3.0),
        rotation = 355.0
    },
    {
        name = "generator4",
        coords = vector3(747.5, -1988.0, 29.0),
        size = vector3(0.75, 0.5, 2.5),
        rotation = 355.0
    },
    {
        name = "generator5",
        coords = vector3(740.4, -1999.6, 29.0),
        size = vector3(0.75, 0.5, 2.75),
        rotation = 355.0
    },
    {
        name = "generator6",
        coords = vector3(746.5, -2000.4, 29.0),
        size = vector3(1, 1, 3.0),
        rotation = 356.0
    }
}
local generatorOptions2 = {
    {
        name = "Generator1",
        coords = vector3(743.77, -1977.13, 29.0),
        size = vector3(4.75, 4, 4),
        rotation = 175.0
    },
    {
        name = "Generator2",
        coords = vector3(749.9, -1977.35, 29.0),
        size = vector3(5.0, 3.4, 5.1),
        rotation = 355.0
    },
    {
        name = "generator3",
        coords = vector3(742.7, -1989.0, 29.0),
        size = vector3(4.6, 3.2, 5.0),
        rotation = 355.0
    },
    {
        name = "generator4",
        coords = vector3(748.75, -1989.75, 29.0),
        size = vector3(4.5, 3.25, 4.0),
        rotation = 355.0
    },
    {
        name = "generator5",
        coords = vector3(741.75, -2001.25, 29.0),
        size = vector3(5.0, 4.0, 5.0),
        rotation = 355.0
    },
    {
        name = "generator6",
        coords = vector3(747.8, -2002.0, 29.0),
        size = vector3(5.0, 4.0, 5.0),
        rotation = 356.0
    }
}
local remainingOptions = {}
local selectedGeneratorAltSettings = {}
local firstAttempt = true
local firstAttemptLockpick = true

local function initializeGenerators()
    remainingOptions = {}
    for i = 1, #generatorOptions do
        table.insert(remainingOptions, generatorOptions[i])
    end
end

local function findAlternativeSettings(name)
    for _, altGenerator in ipairs(generatorOptions2) do
        if altGenerator.name == name then
            return altGenerator
        end
    end
end

local function loadParticleDict(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        RequestNamedPtfxAsset(dict)
        Wait(10)
    end
end

local function removeZoneWithParticles(zone, duration)
    ox_target:removeZone(zone)
    local coords = GetEntityCoords(PlayerPedId()) 

    loadParticleDict("core")
    UseParticleFxAssetNextCall("core")
    local particle = StartParticleFxLoopedAtCoord("exp_grd_bzgas_smoke", coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    
    Citizen.SetTimeout(duration, function()
        StopParticleFxLooped(particle, 0)
    end)
end

local function createRandomZone()
    local randomIndex = math.random(#remainingOptions)
    local selectedGenerator = table.remove(remainingOptions, randomIndex)

    if activeZone2 then
        removeZoneWithParticles(activeZone2, 10000)
    end

    local altSettings = findAlternativeSettings(selectedGenerator.name)
    if altSettings then
        selectedGeneratorAltSettings = {
            coords = altSettings.coords,
            size = altSettings.size,
            rotation = altSettings.rotation
        }
    end

    activeZone = ox_target:addBoxZone({
        coords = selectedGenerator.coords,
        size = selectedGenerator.size,
        rotation = selectedGenerator.rotation,
        debug = Config.debugZone,
        options = {
            {
                event = 'powerStationHeist:generator',
                icon = 'fas fa-calendar-plus',
                label = 'Turn off the generator',
            }
        },
        minZ = 72.0,
        maxZ = 74.0,
        distance = 1
    })
end

local function createRandomAltZone()

    if activeZone then
        ox_target:removeZone(activeZone)
    end

    activeZone2 = ox_target:addBoxZone({
        coords = selectedGeneratorAltSettings.coords,
        size = selectedGeneratorAltSettings.size,
        rotation = selectedGeneratorAltSettings.rotation,
        debug = Config.debugZone,
        options = {
            {
                event = 'powerStationHeist:generatorDestroy', 
                icon = 'fas fa-calendar-plus',
                label = 'Destroy the generator', 
            }
        },
        minZ = 72.0,
        maxZ = 74.0,
        distance = 1
    })
end

RegisterNetEvent('powerStationHeist:startHeistClient')
AddEventHandler('powerStationHeist:startHeistClient', function(data)
    if data == GetPlayerServerId(PlayerId()) then 
        TriggerEvent('powerStationHeist:showHack', true)
        startHeistAttempt = startHeistAttempt - 1

        if firstAttempt then 

        -- Here is a notification for PD

            startCountdown()
            firstAttempt = false
        end
    else
        TriggerEvent('chat:addMessage', { args = { '^1Only the player who started the heist can continue it!' } })
    end
end)

RegisterNetEvent('powerStationHeist:endHack')
AddEventHandler('powerStationHeist:endHack', function(bool)
    if bool then
        ox_target:removeZone(zoneStartHeist)

        zoneInstruction = ox_target:addBoxZone({
            coords = vector3(748.5, -1946.25, 29.0), 
            size = vector3(2, 1, 4), 
            rotation = 355.0, 
            debug = Config.debugZone, 
            options = {
                {
                    event = 'powerStationHeist:Instruction', 
                    icon = 'fas fa-crosshairs',
                    label = 'Break in', 
                }
            },
            minZ = 72.0,
            maxZ = 74.0, 
            distance = 1 
        })
    else 
        lib.notify({ description = 'Remaining attempts: ' .. startHeistAttempt })
        if startHeistAttempt == 0 then 
            ox_target:removeZone(zoneStartHeist)
        end 
    end
end)

RegisterNetEvent('powerStationHeist:Instruction')
AddEventHandler('powerStationHeist:Instruction', function()
    local count = ox_inventory:Search('count', 'lockpick')
    if count > 0 then

        Citizen.CreateThread(function()
            if GetResourceState("ws-lockpick") == "started" then
                local wynik = exports["ws-lockpick"]:startWsLockpick()
                
                if wynik and firstAttemptLockpick then 
                    Citizen.CreateThread(function()
                        Citizen.Wait(1000)
                        TriggerServerEvent('powerStationHeist:GiveInstruction', GetPlayerServerId(PlayerId()))
                        ox_target:removeZone(zoneInstruction)
                        createRandomZone()
                        firstAttemptLockpick = false
                    end)
                else 
                    lib.notify({ description = 'Hack failed' })
                    ox_target:removeZone(zoneInstruction)
                    firstAttemptLockpick = false
                end
            else
                print("Resource ws-lockpick is not running")
            end
        end)
    else
        lib.notify({ description = 'You do not have the required items' })
    end
end)

RegisterNetEvent('powerStationHeist:generator')
AddEventHandler('powerStationHeist:generator', function()
    TriggerEvent('powerStationHeist:startCables', true)
    TriggerServerEvent('powerStationHeist:sendRandomCableAgain', GetPlayerServerId(PlayerId()))
end)

RegisterNetEvent('powerStationHeist:endCables')
AddEventHandler('powerStationHeist:endCables', function(bool)
    if bool then
        lib.notify({ description = 'Generator power off' })

        createRandomAltZone()
    else 
        ox_target:removeZone(activeZone)
    end
end)

local function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

local function hasCrowbar()
    local count = ox_inventory:Search('count', 'WEAPON_CROWBAR')
    if count > 0 and GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("WEAPON_CROWBAR") then
        return true
    end
    return false
end

local function playCrowbarAnimation()
    local animDict = "melee@large_wpn@streamed_core_fps"
    local animName = "ground_attack_on_spot"
    loadAnimDict(animDict)
    TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)
end

RegisterNetEvent('powerStationHeist:generatorDestroy')
AddEventHandler('powerStationHeist:generatorDestroy', function()
    if hasCrowbar() then
        playCrowbarAnimation()
        TriggerEvent('powerStationHeist:startSpamming', true)
    else
        lib.notify({ description = 'You do not have the required items' })
    end
end)

RegisterNetEvent('powerStationHeist:endSpamming')
AddEventHandler('powerStationHeist:endSpamming', function(bool)
    ClearPedTasks(PlayerPedId())
        if bool then
            if #remainingOptions == 0 then
                RegisterNetEvent('powerStationHeist:giveGeneratorParts')
                TriggerServerEvent('powerStationHeist:giveGeneratorParts', true)
                ox_target:removeZone(activeZone2)
            else 
                createRandomZone()
            end
        else
            ox_target:removeZone(activeZone2)
        end
end)

RegisterNetEvent('powerStationHeist:startHeist')
AddEventHandler('powerStationHeist:startHeist', function()
    TriggerServerEvent('powerStationHeist:startHeistServer')
end)

local function createStartHeistZone()
    zoneStartHeist = ox_target:addBoxZone({
        coords = vector3(747.05, -1945.75, 29.0), 
        size = vector3(1.0, 0.5, 3.5), 
        rotation = 355.0, 
        debug = Config.debugZone, 
        options = {
            {
                event = 'powerStationHeist:startHeist', 
                icon = 'fas fa-crosshairs',
                label = 'Break in', 
            }
        },
        minZ = 72.0,
        maxZ = 74.0, 
        distance = 1 
    })
end

function resetData()
    TriggerServerEvent('powerStationHeist:resetData', true)
    TriggerEvent('powerStationHeist:resetDataClient', true)
    initializeGenerators()
    startHeistAttempt = Config.startHeistAttempt
    firstAttempt = true
    firstAttemptLockpick = true
    createStartHeistZone()
end

function startCountdown()
    SetTimeout(Config.resetTime * 60 * 1000, function()  
        resetData()
    end)
end

createStartHeistZone()
initializeGenerators()
