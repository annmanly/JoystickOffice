--!Type(Module)

-- Define events for requesting and responding to rocket-related actions
local GetRocketRequest = Event.new("GetRocketRequest") -- Event for requesting the player's rocket count
local GetDuckRequest = Event.new("GetDuckRequest") -- Event for requesting the player's rocket count
local GetCashRequest = Event.new("GetCashRequest") -- Event for requesting the player's rocket count
local GetRocketResponse = Event.new("GetRocketResponse") -- Event for responding with the player's rocket count
local GetCashResponse = Event.new("GetCashResponse") -- Event for responding with the player's rocket count
local GetDuckResponse = Event.new("GetDuckResponse") -- Event for responding with the player's rocket count
local UpdateRocketEvent = Event.new("UpdateRocketEvent") -- Event for updating the player's rocket count
local UpdateDuckEvent = Event.new("UpdateDuckEvent") -- Event for updating the player's rocket count
local UpdateCashEvent = Event.new("UpdateCashEvent") -- Event for updating the player's rocket count

local players = {} -- Table to store player information including their rocket count
local RocketUI = nil -- Reference to the UI component for displaying rocket, initialized to nil
local DuckUI = nil -- Reference to the UI component for displaying rocket, initialized to nil
local CashUI = nil -- Reference to the UI component for displaying rocket, initialized to nil
local topPlayers = {} -- Table to store the top players' information

-- Function to track players in the game and set up character change callbacks
local function TrackPlayers(game, callBack)
  game.PlayerConnected:Connect(function(player) -- Connect to the PlayerConnected event
    if players[player.name] == nil then -- Check if the player is not already being tracked
      players[player.name] = { -- Initialize player data
        playerName = player.name,
        rocket = 0, -- Start with 0 rocket
        duck = 0,
        cash = 0
      }

      player.CharacterChanged:Connect(function(player, character) -- Connect to the CharacterChanged event
        local playerInfo = players[player.name] -- Get the player's information
        if character == nil then return end -- Exit if the character is nil

        if callBack then
          callBack(playerInfo, player) -- Call the callback function if provided
        end
      end)
    end
  end)
end

-- Function to add rocket to the local player's total
AddRocket = function(rocket: number)
  local player = client.localPlayer -- Get the local player
  local playerInfo = players[player.name] -- Get the player's information

  local rocketSum = playerInfo.rocket + rocket -- Calculate the new rocket total
  playerInfo.rocket = rocketSum -- Update the player's rocket total

  UpdateRocketEvent:FireServer(rocket) -- Notify the server of the rocket update
  RocketUI.PopulateRocket(rocketSum) -- Update the UI to show the new rocket total
end

-- NEWFunction to add duck to the local player's total
AddDuck = function(duck: number)
  local player = client.localPlayer -- Get the local player
  local playerInfo = players[player.name] -- Get the player's information

  local duckSum = playerInfo.duck + duck -- Calculate the new rocket total
  playerInfo.duck = duckSum -- Update the player's rocket total

  UpdateDuckEvent:FireServer(duck) -- Notify the server of the rocket update
  DuckUI.PopulateDuck(duckSum) -- Update the UI to show the new rocket total
end

-- NEWFunction to add cash to the local player's total
AddCash = function(cash: number)
  local player = client.localPlayer -- Get the local player
  local playerInfo = players[player.name] -- Get the player's information

  local cashSum = playerInfo.cash + cash -- Calculate the new rocket total
  playerInfo.cash = cashSum -- Update the player's rocket total

  UpdateCashEvent:FireServer(cash) -- Notify the server of the rocket update
  CashUI.PopulateCash(cashSum) -- Update the UI to show the new rocket total
end

-- Function to get the list of top players sorted by rocket count
GetTopPlayers = function()
  table.sort(topPlayers, function(a, b)
    return a.cash > b.cash -- Sort players by rocket count in descending order
  end)

  return topPlayers -- Return the sorted list of top players
end

-- Function to initialize the client-side setup
function self:ClientAwake()
  if RocketUI == nil then -- Check if the RocketUI reference is not set
    RocketUI = self.gameObject:GetComponent(RocketHUD) -- Get the RocketHUD component from the game object
  end
  if DuckUI == nil then -- Check if the RocketUI reference is not set
    DuckUI = self.gameObject:GetComponent(DuckHUD) -- Get the RocketHUD component from the game object
  end
  if CashUI == nil then -- Check if the RocketUI reference is not set
    CashUI = self.gameObject:GetComponent(CashHUD) -- Get the RocketHUD component from the game object
  end

  GetRocketRequest:FireServer() -- Request the local player's coin count from the server
  GetDuckRequest:FireServer() -- Request the local player's coin count from the server
  GetCashRequest:FireServer() -- Request the local player's coin count from the server

  GetRocketResponse:Connect(function(rocket)
    local player = client.localPlayer -- Get the local player
    players[player.name].rocket = rocket -- Update the player's rocket count

    RocketUI.PopulateRocket(rocket) -- Update the UI to show the new rocket count
  end)
  
  GetDuckResponse:Connect(function(duck)
    local player = client.localPlayer -- Get the local player
    players[player.name].duck = duck -- Update the player's rocket count

    DuckUI.PopulateDuck(duck) -- Update the UI to show the new rocket count
  end)

  GetCashResponse:Connect(function(cash)
    local player = client.localPlayer -- Get the local player
    players[player.name].cash = cash -- Update the player's rocket count

    CashUI.PopulateCash(cash) -- Update the UI to show the new rocket count
  end)

  TrackPlayers(client) -- Start tracking players on the client side
end

-- Function to get rocket count
function GetRocketCount(player)
  local playerInfo = players[player.name]
  return playerInfo and playerInfo.rocket or 0
end

-- Function to get duck count
function GetDuckCount(player)
  local playerInfo = players[player.name]
  return playerInfo and playerInfo.duck or 0
end

-- Function to initialize the server-side setup
function self:ServerAwake()
  TrackPlayers(server) -- Start tracking players on the server side

  Storage.GetValue("TopPlayers", function(k)
    if k == nil then k = {} end -- Initialize topPlayers if not found
    topPlayers = k -- Load the top players from storage
  end)

  GetRocketRequest:Connect(function(player)
    Storage.GetPlayerValue(player, "Rocket", function(value)
      if value == nil then value = 0 end -- Default rocket value if not found
      players[player.name].rocket = value -- Update the player's rocket count
      GetRocketResponse:FireClient(player, value) -- Respond to the client with the rocket count
    end)
  end)

  GetDuckRequest:Connect(function(player)
    Storage.GetPlayerValue(player, "Duck", function(value)
      if value == nil then value = 0 end -- Default rocket value if not found
      players[player.name].duck = value -- Update the player's rocket count
      GetDuckResponse:FireClient(player, value) -- Respond to the client with the rocket count
    end)
  end)

  GetCashRequest:Connect(function(player)
    Storage.GetPlayerValue(player, "Cash", function(value)
      if value == nil then value = 0 end -- Default rocket value if not found
      players[player.name].cash = value -- Update the player's rocket count
      GetCashResponse:FireClient(player, value) -- Respond to the client with the rocket count
    end)
  end)

  UpdateRocketEvent:Connect(function(player, rocket)
    local playerInfo = players[player.name] -- Get the player's information
    
    if playerInfo == nil then
        print("Player info not found for player: " .. player.name) -- Log if player info is not found
        return
    end

    local newRocketValue = playerInfo.rocket + rocket -- Calculate the new rocket total
    playerInfo.rocket = newRocketValue -- Update the player's rocket total

    print(player.name .. " is updating rocket to " .. tostring(newRocketValue)) -- Log the rocket update
    Storage.IncrementPlayerValue(player, "Rocket", rocket) -- Increment the player's rocket count in storage

    local playerEntry = { name = player.name, rocket = newRocketValue } -- Create an entry for the player
    local found = false -- Flag to check if the player is already in the top players list

  end)

  -- NEW
  UpdateDuckEvent:Connect(function(player, duck)
    local playerInfo = players[player.name] -- Get the player's information
    
    if playerInfo == nil then
        print("Player info not found for player: " .. player.name) -- Log if player info is not found
        return
    end

    local newDuckValue = playerInfo.duck + duck -- Calculate the new rocket total
    playerInfo.duck = newDuckValue -- Update the player's rocket total

    print(player.name .. " is updating duck to " .. tostring(newDuckValue)) -- Log the rocket update
    Storage.IncrementPlayerValue(player, "Duck", duck) -- Increment the player's rocket count in storage

    local playerEntry = { name = player.name, duck = newDuckValue } -- Create an entry for the player
    local found = false -- Flag to check if the player is already in the top players list

  end)

  -- NEW
  UpdateCashEvent:Connect(function(player, cash)
    local playerInfo = players[player.name] -- Get the player's information
    
    if playerInfo == nil then
        print("Player info not found for player: " .. player.name) -- Log if player info is not found
        return
    end

    local newCashValue = playerInfo.cash + cash -- Calculate the new rocket total
    playerInfo.cash = newCashValue -- Update the player's rocket total

    print(player.name .. " is updating cash to " .. tostring(newCashValue)) -- Log the rocket update
    Storage.IncrementPlayerValue(player, "Cash", cash) -- Increment the player's rocket count in storage

    local playerEntry = { name = player.name, cash = newCashValue } -- Create an entry for the player
    local found = false -- Flag to check if the player is already in the top players list

  end)

end
