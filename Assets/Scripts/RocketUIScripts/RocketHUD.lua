--!Type(UI)

--!SerializeField
local RocketImage : Texture = nil -- Texture for the rocket icon, initialized to nil

--!Bind
local _RocketIcon : UIImage = nil -- UIImage for displaying the rocket icon, initialized to nil

--!Bind
local _RocketLabel : UILabel = nil -- UILabel for displaying the number of rockets, initialized to nil

-- Function to update the rocket icon image
function PopulateIcon(icon: Texture)
  _RocketIcon.image = icon -- Set the image of the rocket icon to the provided texture
end

-- Function to update the rocket count display
function PopulateRocket(rocket: number)
  _RocketLabel:SetPrelocalizedText(tostring(rocket)) -- Set the text of the rocket label to the number of rockets
end

PopulateRocket(0) -- Initialize the rocket display with 0 rockets
PopulateIcon(RocketImage) -- Initialize the rocket icon with the provided RocketImage texture

