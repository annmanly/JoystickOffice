--!Type(Module)

--!SerializeField
local Coins : { Transform } = nil -- Array of Transform objects for coin spawn points, initialized to nil

--!SerializeField
local CoinPrefab : GameObject = nil -- Prefab for the coin to be spawned, initialized to nil

--!SerializeField
local SpawnDelay : number = 10 -- Delay time in seconds before a coin respawns after being collected

local spawnedCoins = {} -- Table to keep track of currently spawned coins

-- Function to spawn a coin at a specific position
function SpawnCoin(position: Transform)
  local coin = Object.Instantiate(CoinPrefab) -- Create a new coin instance from the prefab
  coin.transform.position = position.position -- Set the coin's position to the specified position
  coin:SetActive(true) -- Ensure the coin is active when first spawned
end

-- Function to destroy a coin and respawn it after a delay
function DestroyCoin(coin)
  coin:SetActive(false) -- Deactivate the coin to simulate destruction

  Timer.After(SpawnDelay, function() -- Schedule a function to run after the spawn delay
    coin:SetActive(true) -- Reactivate the coin after the delay
  end)
end

-- Function called when the client starts
function self:ClientStart()
  for i = 1, #Coins do -- Iterate through all the coin spawn points
    local coin = Coins[i] -- Get the coin spawn point at index i
    if coin then SpawnCoin(coin) end -- If the spawn point is valid, spawn a coin there
  end
end
