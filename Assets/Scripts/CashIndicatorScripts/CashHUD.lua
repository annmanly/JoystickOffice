--!Type(UI)

--!SerializeField
local CashImage : Texture = nil -- Texture for the coin icon, initialized to nil

--!Bind
local _CashIcon : UIImage = nil -- UIImage for displaying the coin icon, initialized to nil

--!Bind
local _CashLabel : UILabel = nil -- UILabel for displaying the number of coins, initialized to nil

-- Function to update the coin icon image
function PopulateIcon(icon: Texture)
  _CashIcon.image = icon -- Set the image of the coin icon to the provided texture
end

-- Function to update the coin count display
function PopulateCash(cash: number)
  _CashLabel:SetPrelocalizedText(tostring(cash)) -- Set the text of the coin label to the number of coins
end

PopulateCash(0) -- Initialize the coin display with 0 coins
PopulateIcon(CashImage) -- Initialize the coin icon with the provided CoinImage texture
