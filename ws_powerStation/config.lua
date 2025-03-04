Config = {}

-- Reward for the attack
Config.itemAmount = 4 -- Number of items received
Config.itemName = 'scrapmetal' -- Name of the item received

-- Ped
Config.itemPrice = 100 -- Price for each individual item
Config.pedCoords = vector3(1511.4927, -2135.5720, 76.5640) -- Ped coordinates
Config.pedHeading = 93.1999 -- Ped heading
Config.pedModel = 'mp_m_shopkeep_01' -- Ped model

-- First hack, 'letters'
Config.startHeistAttempt = 2 -- Number of attempts for the first hack
Config.timeLeft = 15 -- Time for the player to complete the hack
Config.numberElements = 10 -- Number of generated elements

-- Hack when destroying the generator, 'spamming'
Config.removePercent = 1 -- Number that is subtracted from the player's progress every 0.3s
Config.addPercentPerClick = 2 -- Number that is added to the progress for each player click

-- List of symbols from which the instruction is created
Config.symbols = {"α", "β", "γ", "δ", "ε", "ζ", "η", "θ", "ι", "κ", "λ", "μ"} 

-- Time to complete the heist, after which the data is reset
Config.resetTime = 30 -- 30 minutes

-- Enable debug zone
Config.debugZone = true 
