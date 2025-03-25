--!Type(ClientAndServer)

--!SerializeField
local lifetime : number = 10

function self:OnTriggerEnter(collider)
    colliderCharacter = collider.gameObject:GetComponent(Character)
    if(colliderCharacter == nil)then
        print("No Character component found on " .. collider.gameObject.name)
        return
    end
    player = colliderCharacter.player -- player info
    if(client.localPlayer == player)then
        
    end
    Object.Destroy(self.gameObject)
end

function self:Start()
    Timer.After(lifetime, function()
        GameObject.Destroy(self.gameObject)
    end)
end