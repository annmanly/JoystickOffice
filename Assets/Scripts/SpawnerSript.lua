--!Type(Server)

--!SerializeField
local duckPrefab : GameObject = nil

local interval = nil

function self:ServerStart()
    interval = Timer.Every(2, function()
        GameObject.Instantiate(duckPrefab, self.gameObject.transform.position, self.gameObject.transform.rotation)
    end)
end