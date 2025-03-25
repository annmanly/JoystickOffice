--[[
    
    Copyright (c) 2024 Pocket Worlds

    This software is provided 'as-is', without any express or implied
    warranty.  In no event will the authors be held liable for any damages
    arising from the use of this software.

    Permission is granted to anyone to use this software for any purpose,
    including commercial applications, and to alter it and redistribute it
    freely.
    
--]] 

--!Type(Client)

-------------------------------------------------------------------------------
-- Properties
-------------------------------------------------------------------------------

--!Header("Follow Settings")
--!SerializeField
local _followStartDistance : number = 4 --the distance from the player to start following
--!SerializeField
local _targetFollowDistance : number = 1 --the distance to stop from the player when following
--!SerializeField
local _useNavmesh : boolean = true --if false, pet will follow the player's direction
--!SerializeField
local _teleportIfNoPath : boolean = true --if true, the pet will teleport to the player if no navmesh path can be found

--!Header("Idle Wander Settings")
--!SerializeField
local _shouldIdleWander : boolean = true
--!SerializeField
local _percentToWander : number = 0.67 --percent chance to wander instead of playing idle animations
--!SerializeField
local _minTimeBeforeWander : number = 3 --minimum time before the pet will play idle animations/wander
--!SerializeField
local _maxTimeBeforeWander : number = 5 --maximum time before the pet will play idle animations/wander
--!SerializeField
local _idleAnimationsToPlay : {string} = nil --animations to play when the pet is not following the player

local _petController = require("PetCharacterController")
local _character : Character = nil
local _petInfo : PetInfo = nil
local _following : boolean = false
local _walkScale : number = 1
local _wanderTimer : Timer = nil

function self:ClientStart()
    --get the character from the parent
    _character = self:GetComponentInParent(Character)

    --when the character is created, get the PetInfo registered in the pet controller
    if not _petInfo then
        local petInfo = _petController.GetPetFromCharacter(_character)
        if petInfo then
            _petInfo = petInfo 
            SetFollowing(false)
        end
    end
end

function self:ClientOnDestroy()
    if _wanderTimer then
        _wanderTimer:Stop()
    end
end

function self:ClientUpdate()
    if IsPetValid() then
        UpdatePet()
    end
end

function UpdatePet()
    if not _following and IsOutOfRangeOfPlayer() then
        --start following the player if the pet is out of range
        SetFollowing(true)
        if _useNavmesh then
            FollowPlayerOnNavmesh()
        else
            _character:PlayEmote("walk", _walkScale, true)
        end
    end

    local character = _petInfo.character
    if(_following and _useNavmesh and not character.isMoving) then
        SetFollowing(false)
    end

    if _following and not _useNavmesh then
        -- if not using the navmesh, directly follow the player's direction
        FollowPlayerDirection()
    end
end

function FollowPlayerOnNavmesh()
    local player = _petInfo.player
    --the pet was out of range of the player, so move it to the player
    local foundPath = _petInfo.character:MoveWithinRangeOf(player.character.transform.position, _targetFollowDistance, -1, 
        function(character)
            SetFollowing(false)
        end)

    --if the character is separated from the pet and no path can be found, teleport the pet to the player
    if not foundPath and _teleportIfNoPath then
        SetFollowing(false)
        _petInfo.character:Teleport(player.character.transform.position)
    end
end

function SetTimerForIdleWander()
    if not _shouldIdleWander then
        return
    end

    if (_wanderTimer) then
        _wanderTimer:Stop()
    end
    --choose random time for next wander
    local timeBeforeWander = math.random(_minTimeBeforeWander, _maxTimeBeforeWander)
    _wanderTimer = Timer.After(timeBeforeWander, DoIdleWander)
end

function DoIdleWander()
    if not _following then
        --randomly choose to play an idle animation or wander
        local wander = math.random() < _percentToWander
        if not wander and #_idleAnimationsToPlay > 0 then
            PlayRandomIdleAnimation()
        else
            Wander()
        end
    end
end

function PlayRandomIdleAnimation()
    local randomIndex = math.random(1, #_idleAnimationsToPlay)
    local playingEmote = _character:PlayEmote(_idleAnimationsToPlay[randomIndex], 1, false, function()
        SetTimerForIdleWander()
    end)

    if not playingEmote then
        SetTimerForIdleWander()
    end
end

function Wander()
    if not _useNavmesh then
        SetTimerForIdleWander()
        return
    end

    local playerPosition = _petInfo.player.character.transform.position
    local randomPosition = Random.insideUnitCircle
    local targetPosition = playerPosition + Vector3.new(randomPosition.x, 0, randomPosition.y).normalized * _targetFollowDistance
    local foundMove = _petInfo.character:MoveTo(targetPosition, -1, function(character)
        if not _following then
            SetTimerForIdleWander()
        end
    end)
end

--Follow the player's direction when not using the navmesh
function FollowPlayerDirection()
    local petPos = _petInfo.character.transform.position
    local playerPos = _petInfo.player.character.transform.position
    local direction = (playerPos - petPos).normalized
    _petInfo.character.transform.forward = direction

    local withinRange = (playerPos - petPos).sqrMagnitude < TargetFollowDistanceSqr()
    if not withinRange then
        _petInfo.character.transform.position += (direction * _character.speed * Time.deltaTime)
    else
        SetFollowing(false)
    end
end

function SetFollowing(following : boolean)
    _following = following
    if not _following and IsPetValid() then
        _petInfo.character:SetIdle()
        SetTimerForIdleWander()
    end
end

function IsPetValid() : boolean
    return _character and _petInfo and _petInfo.character
end

function IsOutOfRangeOfPlayer() : boolean
    local playerPos = _petInfo.player.character.transform.position
    local petPos = _petInfo.character.transform.position
    --compare the squared distance for optimization
    return (playerPos - petPos).sqrMagnitude > FollowStartDistanceSqr()
end

function FollowStartDistanceSqr() : number
    return _followStartDistance * _followStartDistance
end

function TargetFollowDistanceSqr() : number
    return _targetFollowDistance * _targetFollowDistance
end