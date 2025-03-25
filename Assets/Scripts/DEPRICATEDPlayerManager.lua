local addDucksRequest = Event.new("AddDucksRequest")
local players = {}


local function TrackPlayers(game, characterCallback)
    scene.PlayerJoined:Connect(function(scene, player)
        players[player] = {
            player = player,
            ducks = IntValue.new("ducks".. tostring(player.id), 0)
        }

        player.CharacterChanged:Connect(function(player, character)
            local playerinfo = players[player]
            if (character == nil) then
                return
            end

            if characterCallback then  
                characterCallback(playerinfo)
            end
        end)
    end)

    scene.PlayerLeft:Connect(function(player)
        players[player] = nil
    end)
end

--[[

    Client

--]]

function self:ClientAwake()

    function OnCharacterInstantiate(playerinfo)
        local player = playerinfo.player
        local character = player.character

        playerinfo.ducks.Changed:Connect(function(newVal, oldVal)
            print(player.name .. ":" .. tostring(newVal))
        end)
    end

    function AddDucks()
        addDucksRequest:FireServer()
    end


    TrackPlayers(client, OnCharacterInstantiate)

end

--[[

    Server

--]]

function self:ServerAwake()
    TrackPlayers()

    addDucksRequest:Connect(function(player)
        local playerInfo = players[player]
        local playerDucks = playerInfo.ducks.value
        playerDucks = playerDucks + 1
        playerInfo.ducks.value = playerDucks
    end)

end
--!Type(Module)