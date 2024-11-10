--A SgtBlackDeer's mod--

local AmandineMod = RegisterMod("Amandine",1);
local Amandine = Isaac.GetPlayerTypeByName("Amandine", false);
local TaintedAmandine = Isaac.GetPlayerTypeByName("Tainted Amandine", true);
local AmandineHair = Isaac.GetCostumeIdByPath("gfx/characters/amandinehair.anm2");
local TaintedAmandineHair = Isaac.GetCostumeIdByPath("gfx/characters/taintedamandinehair.anm2");
local dmgUp = false;

local AmandineStats = { 
    DAMAGE = 1.25,
    SPEED = 0.3,
    SHOTSPEED = 0.80,
    TEARHEIGHT = 0,
    TEARFALLINGSPEED = 0,
    LUCK = 1,
    FLYING = false,                                 
    TEARCOLOR = Color(1.0, 0.5, 0.8, 0.9, 0, 0, 0)
}

local TaintedAmandineStats = { 
    DAMAGE = 1,
    SPEED = 0.1,
    SHOTSPEED = 0.80,
    TEARHEIGHT = 0,
    TEARFALLINGSPEED = 0,
    LUCK = -1,
    FLYING = false,                                 
    TEARCOLOR = Color(1, 0, 0, 1, 0, 0, 0)
}

local specialTearsLuck = {
	BASE_CHANCE = 30,
    LOW_LUCK = 2,
    MID_LUCK = 4,
	MAX_LUCK = 6
}

--Equiping hairs--
function AmandineMod:onPlayerInit(player)    
    if player:GetPlayerType() == Amandine then
        player:AddNullCostume(AmandineHair);
        costumeEquipped = true;
	end
    if player:GetPlayerType() == TaintedAmandine then
        player:AddNullCostume(TaintedAmandineHair);
        costumeEquipped = true;
	end
end

--Hearts limit & damage up with special items--
function AmandineMod:onUpdate(player)
    local game = Game();
    local red = player:GetMaxHearts();
    local soul = player:GetSoulHearts();
    local limit = red - 12;
    
    if game:GetFrameCount() == 1 then
        dmgUp = false;
    end
    
    if player:GetPlayerType() == Amandine then        
		if red > 12 then
            player:AddMaxHearts(-limit);
            player:AddSoulHearts(limit);
		end
        
        if dmgUp == false then
            if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_EYESHADOW) == true then
                player.Damage = player.Damage + 1;
                dmgUp = true;
            end
        end
	end
    if player:GetPlayerType() == TaintedAmandine then
        if soul > 0 then 
            player:AddSoulHearts(-soul);
            player:AddHearts(soul);
        end
        
        if dmgUp == false then
            if player:HasCollectible(CollectibleType.COLLECTIBLE_ROTTEN_TOMATO) == true then
                player.Damage = player.Damage + 1;
                dmgUp = true;
            end
        end
	end
end

--Creeps conditions--
function AmandineMod:PostUpdate()
    local player = Isaac.GetPlayer(0);
    
    if player:GetPlayerType() == Amandine and not player:IsDead() then
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) == false then
            if player:GetSoulHearts() >= 6 then
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL, 1, player.Position, Vector(0, 0), player)
                creep:Update();
            end
        else
            if player:GetSoulHearts() >= 3 then
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL, 1, player.Position, Vector(0, 0), player)
                creep:Update();
            end
        end
    end
    if player:GetPlayerType() == TaintedAmandine and not player:IsDead() then
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) == false then
            if player:GetHearts() >= 8 then
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 1, player.Position, Vector(0, 0), player)
                creep:Update();
            end
        else
            if player:GetHearts() >= 4 then
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 1, player.Position, Vector(0, 0), player)
                creep:Update();
            end
        end
    end
    
    if (player:GetPlayerType() == Amandine and player:GetSprite():IsFinished("Death") == true) or (player:GetPlayerType() == TaintedAmandine and player:GetSprite():IsFinished("Death") == true) then
        dmgUp = false;
    end
end
 
--Amandine stats--
function AmandineStats:onCache(player, cacheFlag)
    if player:GetPlayerType() == Amandine then
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage * AmandineStats.DAMAGE;
        end
        if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
            player.ShotSpeed = player.ShotSpeed * AmandineStats.SHOTSPEED;
        end
        if cacheFlag == CacheFlag.CACHE_RANGE then
            player.TearHeight = player.TearHeight - AmandineStats.TEARHEIGHT;
            player.TearFallingSpeed = player.TearFallingSpeed + AmandineStats.TEARFALLINGSPEED;
        end
        if cacheFlag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + AmandineStats.SPEED;
        end
        if cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + AmandineStats.LUCK;
        end
        if cacheFlag == CacheFlag.CACHE_FLYING and AmandineStats.FLYING then
            player.CanFly = true
        end
        if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
            player.TearColor = AmandineStats.TEARCOLOR;
        end
    end
end

--Tainted Amandine stats--
function TaintedAmandineStats:onCache(player, cacheFlag)
    if player:GetPlayerType() == TaintedAmandine then
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage * TaintedAmandineStats.DAMAGE;
        end
        if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
            player.ShotSpeed = player.ShotSpeed * TaintedAmandineStats.SHOTSPEED;
        end
        if cacheFlag == CacheFlag.CACHE_RANGE then
            player.TearHeight = player.TearHeight - TaintedAmandineStats.TEARHEIGHT;
            player.TearFallingSpeed = player.TearFallingSpeed + TaintedAmandineStats.TEARFALLINGSPEED;
        end
        if cacheFlag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + TaintedAmandineStats.SPEED;
        end
        if cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + TaintedAmandineStats.LUCK;
        end
        if cacheFlag == CacheFlag.CACHE_FLYING and TaintedAmandineStats.FLYING then
            player.CanFly = true
        end
        if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
            player.TearColor = TaintedAmandineStats.TEARCOLOR;
        end
    end
end

--Special tears chance--
function AmandineMod:onFireTear(tear)
    local player = Isaac.GetPlayer(0);
    local roll = math.random(100);
    
    for _, entity in pairs(Isaac.GetRoomEntities()) do   
        if entity.Type == EntityType.ENTITY_TEAR then
            local tear = entity:ToTear();

            if player:GetPlayerType() == Amandine then
                if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) == false then
                    if roll <= ((100 - specialTearsLuck.BASE_CHANCE) * player.Luck / specialTearsLuck.MID_LUCK) + specialTearsLuck.BASE_CHANCE then

                        tear.TearFlags = tear.TearFlags | TearFlags.TEAR_CHARM;
                    end
                else
                    if roll <= ((100 - specialTearsLuck.BASE_CHANCE) * player.Luck / specialTearsLuck.MAX_LUCK) + specialTearsLuck.BASE_CHANCE then

                        tear.TearFlags = tear.TearFlags | TearFlags.TEAR_CHARM;
                    end
                end
            end
            if player:GetPlayerType() == TaintedAmandine then
                if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) == false then
                    if roll <= ((100 - specialTearsLuck.BASE_CHANCE) * player.Luck / specialTearsLuck.MID_LUCK) + specialTearsLuck.BASE_CHANCE then

                        tear.TearFlags = tear.TearFlags | TearFlags.TEAR_BAIT;
                    end
                else
                    if roll <= ((100 - specialTearsLuck.BASE_CHANCE) * player.Luck / specialTearsLuck.MAX_LUCK) + specialTearsLuck.BASE_CHANCE then

                        tear.TearFlags = tear.TearFlags | TearFlags.TEAR_BAIT;
                    end
                end
            end
        end
    end
end


AmandineMod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, AmandineMod.onPlayerInit);
AmandineMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, AmandineMod.onUpdate);
AmandineMod:AddCallback(ModCallbacks.MC_POST_UPDATE, AmandineMod.PostUpdate);
AmandineMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, AmandineStats.onCache);
AmandineMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, TaintedAmandineStats.onCache);
AmandineMod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, AmandineMod.onFireTear);