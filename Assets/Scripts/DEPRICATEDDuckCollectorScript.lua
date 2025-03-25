--!Type(Client)

--!SerializeField
local CoinSound : AudioShader = nil -- AudioShader for the sound effect to play when collecting a coin, initialized to nil

--!SerializeField
local Amount : number = 1 -- Number of rocket to add to the player's total when collecting a coin

local rocketTracker = require("RocketTracker") -- Require the RocketTracker module to manage and update the player's coin count
local rocketSpawner = require("RocketSpawner") -- Require the RocketSpawner module to handle coin spawning and destruction

local shader = nil -- Variable for storing a shader, initialized to nil (currently unused)

-- Function called when the script's object is initialized
function self:Awake()
  -- Function called when another collider enters the trigger collider attached to this game object
  function self:OnTriggerEnter(other : Collider)
    local playerCharacter = other.gameObject:GetComponent(Character) -- Get the Character component from the other game object
    if playerCharacter == nil then return end -- If the other game object does not have a Character component, exit the function

    local player = playerCharacter.player -- Get the player associated with the character
    if client.localPlayer == player then -- Check if the local player is the same as the player associated with the character
      if CoinSound ~= nil then -- If CoinSound is not nil (i.e., a sound has been assigned)
        Audio:PlayShader(CoinSound) -- Play the coin collection sound effect
      end

      rocketTracker.AddRocket(Amount) -- Add the specified amount of rocket to the player's total
      -- rocketSpawner.DestroyCoin(self.gameObject) -- Destroy the rocket game object that this script is attached to
    end
  end
end
