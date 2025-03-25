--!Type(Module)

--!SerializeField
local BossSound : AudioShader = nil -- AudioShader for the sound effect
--!SerializeField
local Amount : number = 0 -- Number of item to add; ensure it's initialized
--!SerializeField
local collectibleIndicator : CollectibleIndicator = nil

local itemTracker = require("ItemTracker") -- Manage the player's item inventory

local currentItemChoice = nil

GetItemChoice = function()
  currentItemChoice = collectibleIndicator.GetCurrentItemChoice()
  print("current item choice " .. currentItemChoice)
end

function self:Awake()
  self.interval = nil  -- Variable to store the timer reference
end

function self:OnTriggerEnter(other : Collider)
  local playerCharacter = other.gameObject:GetComponent(Character)
  if playerCharacter == nil then return end

  local player = playerCharacter.player
  if client.localPlayer ~= player then return end

  if BossSound ~= nil then
    Audio:PlayShader(BossSound)
  end

  GetItemChoice()

  if currentItemChoice == 1 then
    -- Duck logic
    self.interval = Timer.Every(0.1, function()
      local currentDuck = itemTracker.GetDuckCount(client.localPlayer)
      if currentDuck <= 0 then
        if self.interval then
          self.interval:Stop()
          self.interval = nil
        end
        return
      end
      itemTracker.AddDuck(Amount)
      itemTracker.AddCash(10)
    end)
  else
    -- Rocket logic
    self.interval = Timer.Every(0.1, function()
      local currentRocket = itemTracker.GetRocketCount(client.localPlayer)
      if currentRocket <= 0 then
        if self.interval then
          self.interval:Stop()
          self.interval = nil
        end
        return
      end
      itemTracker.AddRocket(Amount)
      itemTracker.AddCash(10)
    end)
  end
end

function self:OnTriggerExit(other : Collider)
  local playerCharacter = other.gameObject:GetComponent(Character)
  if playerCharacter == nil then return end

  local player = playerCharacter.player
  if client.localPlayer ~= player then return end

  if self.interval then
    self.interval:Stop()
    self.interval = nil
  end
end