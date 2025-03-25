--!Type(UI)

--!SerializeField
local BossIndicatorImage01 : Texture = nil -- Texture for the coin icon

--!SerializeField
local BossIndicatorImage02 : Texture = nil -- Texture for the coin icon

--!Bind
local _BossIndicatorIcon : UIImage = nil -- UIImage for displaying the coin icon

--!Bind
local _BossIndicatorLabel : UILabel = nil -- UILabel for displaying the number of coins

local bossCollectorScript = require("BossCollectorScript") -- Manages the current item selection

-- Function to update the coin icon image
local function PopulateIcon(icon: Texture)
  _BossIndicatorIcon.image = icon
end

-- Function to update the coin count display
local function PopulateBossIndicator(boss: number)
  _BossIndicatorLabel:SetPrelocalizedText(tostring(boss))
end

local choice = bossCollectorScript.GetCurrentItemChoice()
if choice == 1 then
  print("Random Choice Duck")
  PopulateIcon(BossIndicatorImage01)
else
  print("Random Choice Rocket")
  PopulateIcon(BossIndicatorImage02)
end


PopulateBossIndicator(0) -- Initialize the coin display with 0 coins
