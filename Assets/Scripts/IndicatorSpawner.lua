--!Type(Module)

--!SerializeField
local duckPrefab : GameObject = nil

--!SerializeField
local rocketPrefab : GameObject = nil

local interval = nil

-- Global variable to store the current random choice (1 or 2)
currentChoice = 0


function self:ServerAwake()
  ChooseItem()
  -- Create a repeating timer that calls ChooseItem every 10 seconds.
  local chooseItemTimer = Timer.Every(10, function()
      ChooseItem()
  end)
end


-- Function to allow another script to retrieve the current random choice
GetCurrentItemChoice = function()
  
function ChooseItem()
  currentChoice = math.random(1, 2) -- Update currentChoice every time
  if currentChoice == 1 then
    print("Random Choice Duck")
    GameObject.Instantiate(duckPrefab, self.gameObject.transform.position, self.gameObject.transform.rotation)
  else
    print("Random Choice Rocket")
    GameObject.Instantiate(rocketPrefab, self.gameObject.transform.position, self.gameObject.transform.rotation)
  end
end

  return currentChoice
end





