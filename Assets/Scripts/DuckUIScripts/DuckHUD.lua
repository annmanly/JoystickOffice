--!Type(UI)

--!SerializeField
local DuckImage : Texture = nil -- Texture for the duck icon, initialized to nil

--!Bind
local _DuckIcon : UIImage = nil -- UIImage for displaying the duck icon, initialized to nil

--!Bind
local _DuckLabel : UILabel = nil -- UILabel for displaying the number of ducks, initialized to nil

-- Function to update the duck icon image
function PopulateIcon(icon: Texture)
  _DuckIcon.image = icon -- Set the image of the duck icon to the provided texture
end

-- Function to update the duck count display
function PopulateDuck(duck: number)
  _DuckLabel:SetPrelocalizedText(tostring(duck)) -- Set the text of the duck label to the number of ducks
end

PopulateDuck(0) -- Initialize the duck display with 0 ducks
PopulateIcon(DuckImage) -- Initialize the duck icon with the provided DuckImage texture

