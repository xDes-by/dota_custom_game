if not Wearable then
    Wearable = class({})
end

function Wearable:InitWearables()
    self.wear = {}
    for i=0, 4 do
        self.wear[i] = {}
    end
    self.abilities_particles = {} -- нужно добавить альтернативные партиклы героям
    self.items = {}
    self.wearable_particles = {}
    local WearableTable = LoadKeyValues("scripts/npc/cosmetics.txt")
    for model_name,table in pairs(WearableTable) do
        if not self.items[table.name] then
            self.items[table.name] = {}
            self.items[table.name]["default_items"] = {}
            self.items[table.name]["altenative_items"] = {}
        end
        if table["prefab"] == "default_item" then
            self.items[table.name]["default_items"][#self.items[table.name]["default_items"] + 1] = model_name 
        else
            self.items[table.name]["altenative_items"][#self.items[table.name]["altenative_items"] + 1] = model_name
        end
        if table["particles"] ~= nil then
            self.wearable_particles[model_name] = {}
            for particle_name,attach in pairs(table.particles) do
                self.wearable_particles[model_name][particle_name] = attach
            end
        end
    end
end

function Wearable:HasAlternativeSkin(sHreoName)
    return table.has_value({"npc_dota_hero_juggernaut","npc_dota_hero_slark","npc_dota_hero_nevermore"}, sHreoName)
end

function Wearable:SetDefault(Value)
    if type(Value) == "number" then
        hUnit = PlayerResource:GetSelectedHeroEntity(iPlayerID)
    else
        hUnit = Value
    end
    if hUnit.WearableStatus == "default" then
        print("Unit already default")
        return
    end
    local name = hUnit:GetUnitName()
    for _,model_name in pairs(self.items[name]["default_items"]) do
        hModel = SpawnEntityFromTableSynchronous("prop_dynamic", {model = model_name})
        hModel:SetModel(model_name)
        hModel:SetOwner(hUnit)
        hModel:SetParent(hUnit, "")
        hModel:FollowEntity(hUnit, true)
        hModel.particles = {}
        if self.wearable_particles[model_name] then
            for particle_name,attach in pairs(self.wearable_particles[model_name]) do
                local particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, hModel)
                ParticleManager:SetParticleControlEnt(particle, 0, hUnit, PATTACH_POINT_FOLLOW, attach, Vector(0,0,0), true)
                table.insert(hModel.particles, particle)
            end
        end
        table.insert( self.wear[iPlayerID], hModel )
    end
    hUnit.WearableStatus = "default"
end

function Wearable:ClearWear(Value)
    if type(Value) == "number" then
        hUnit = PlayerResource:GetSelectedHeroEntity(iPlayerID)
    else
        hUnit = Value
    end
    if hUnit.WearableStatus == "clear" then
        print("Unit already clear")
        return
    end
    for _,hModel in pairs(self.wear[iPlayerID]) do
        for _,particle in pairs(hModel.particles) do
            ParticleManager:DestroyParticle(particle, true)
            ParticleManager:ReleaseParticleIndex(particle)
        end
        hModel.particles = {}
        UTIL_Remove(hModel)
    end
    hUnit.WearableStatus = "clear"
    self[iPlayerID] = {}
end

function Wearable:SetAlternative(Value)
    if type(Value) == "number" then
        hUnit = PlayerResource:GetSelectedHeroEntity(iPlayerID)
    else
        hUnit = Value
    end
    local sHreoName = hUnit:GetUnitName()
    if not Wearable:HasAlternativeSkin(iPlayerID, sHreoName) then
        print("Alternative skin not unlocked")
        return
    end
    if hUnit.WearableStatus == "alternative" then
        print("Unit already alternative")
        return
    end
    hUnit.WearableStatus = "alternative"
    --дописать код
end

function CScriptParticleManager:GetAlternativeParticle(hUnit, ParticleName)
    if hUnit.WearableStatus == "alternative" then
        return self.abilities_particles[hUnit:GetUnitName()][ParticleName]
    end
    return ParticleName
end

if not Wearable.bInit then
    --@todo: ивент для смены облика или возвращения в первоначальный вид
    CustomGameEventManager:RegisterListener("SetAlternative", Dynamic_Wrap( Wearable, 'SetAlternative' ))
    CustomGameEventManager:RegisterListener("SetDefault", Dynamic_Wrap( Wearable, 'SetDefault' ))
    Wearable.bInit = true
    Wearable:InitWearables()
end

Convars:RegisterCommand( "set_default", function( cmd, player_id ) 
    Wearable:SetDefault(tonumber(player_id))
    end, "set_default", FCVAR_CHEAT
)
Convars:RegisterCommand( "set_alternative", function( cmd, player_id ) 
    Wearable:SetAlternative(tonumber(player_id))
    end, "set_alternative", FCVAR_CHEAT
)
Convars:RegisterCommand( "clear_wear", function( cmd, player_id ) 
    Wearable:ClearWear(tonumber(player_id))
    end, "clear_wear", FCVAR_CHEAT
)