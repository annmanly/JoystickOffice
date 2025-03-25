--!Type(ClientAndServer)

--!SerializeField
local collectibleCount : number = 2 -- Number of collectible items available
--!SerializeField
local collectibleMeshes : { GameObject } = nil -- List of collectible item meshes
local interval = nil -- Timer interval reference

--!SerializeField
local intervalLength : number = 10 -- Time interval (in seconds) for choosing a new collectible

-- Global variable to store the current random choice (1 or 2)
currentChoice = 0

-- Event to notify clients when a new collectible is chosen
local CollectibleChosenEvent = Event.new("CollectibleChosenEvent")

-----[Server Functions]-----

-- Function to randomly choose a collectible item and notify all clients
local function ChooseItem()
    currentChoice = math.random(1, collectibleCount) -- Randomly select an item
    print("Random Choice: " .. currentChoice) -- Log the chosen item

    CollectibleChosenEvent:FireAllClients(currentChoice) -- Notify all clients of the choice
end

function self:ServerAwake()
    -- Create a repeating timer that calls ChooseItem every 10 seconds.
    interval = Timer.Every(intervalLength, function()
        ChooseItem()
    end)

    -- Defer the first call to ChooseItem by 1 second to account for local player connecting
    Timer.After(1, function()
        ChooseItem()
    end)
end

-----[Client Functions]-----

-- Function to display the indicator for the chosen collectible
local function ShowIndicator()
    if currentChoice == 0 or currentChoice > #collectibleMeshes then
        print("Invalid choice: " .. currentChoice) -- Log an error if the choice is invalid
    else
        print("Chosen collectible: " .. collectibleMeshes[currentChoice].name) -- Log the chosen collectible
    end
    
    -- Activate the chosen collectible's mesh and deactivate others
    for i = 1, #collectibleMeshes do
        collectibleMeshes[i]:SetActive(i == currentChoice)
    end
end

function self:ClientAwake()
    -- Connect to the event to update the indicator when a new choice is made
    CollectibleChosenEvent:Connect(function(choice)
        currentChoice = choice
        ShowIndicator()
    end)

    -- Deactivate all collectible meshes initially
    for i = 1, #collectibleMeshes do
        collectibleMeshes[i]:SetActive(false)
    end
end

-----[Public Functions]-----

-- Function to allow another script to retrieve the current random choice
GetCurrentItemChoice = function()
  return currentChoice
end