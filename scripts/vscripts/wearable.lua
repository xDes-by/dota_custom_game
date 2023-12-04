if not Wearable then
    _G.Wearable = class({})
end

function Wearable:InitWearables()
    self.wear = {}
    for i=0, 4 do
        self.wear[i] = {}
    end
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
    local t = {
        -- ["npc_dota_hero_juggernaut"] = true,
        -- ["npc_dota_hero_slark"] = true,
        ["npc_dota_hero_nevermore"] = true,
        ["npc_dota_hero_pudge"] = true,
        ["npc_dota_hero_spectre"] = true
    }
    return t[sHreoName] or false
end

function Wearable:SetDefault(Value)
    if type(Value) == "number" then
        hUnit = PlayerResource:GetSelectedHeroEntity(Value)
        iPlayerID = Value
    else
        hUnit = Value
        iPlayerID = hUnit:GetPlayerID()
    end
    if hUnit.WearableStatus == "default" then
        print("Unit already default")
        return
    end
	hUnit:AddNewModifier(hUnit, nil, "modifier_wearable_pet", {})
    Wearable:ChangeModel(hUnit, "SetDefault")
    if sHreoName == "npc_dota_hero_nevermore" then
        hUnit:SetRangedProjectileName("particles/units/heroes/hero_nevermore/nevermore_base_attack.vpcf")
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
        hUnit = PlayerResource:GetSelectedHeroEntity(Value)
        iPlayerID = Value
    else
        hUnit = Value
        iPlayerID = hUnit:GetPlayerID()
    end
    if hUnit.WearableStatus == "clear" then
        print("Unit already clear")
        return
    end
	hUnit:AddNewModifier(hUnit, nil, "modifier_wearable_pet", {})
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
        hUnit = PlayerResource:GetSelectedHeroEntity(Value)
        iPlayerID = Value
    else
        hUnit = Value
        iPlayerID = hUnit:GetPlayerID()
    end
    local sHreoName = hUnit:GetUnitName()
    if not Wearable:HasAlternativeSkin(sHreoName) then
        print("Alternative skin not unlocked")
        return
    end
    if hUnit.WearableStatus == "alternative" then
        print("Unit already alternative")
        return
    end
	hUnit:AddNewModifier(hUnit, nil, "modifier_wearable_pet", {})
    Wearable:ChangeModel(hUnit, "SetAlternative")
    if sHreoName == "npc_dota_hero_nevermore" then
        hUnit:SetRangedProjectileName("amir4an/particles/heroes/nevermore/amir4anmods_zxc/amir4anmods_zxc_base_attack.vpcf")
    end
    if sHreoName == "npc_dota_hero_pudge" then
        Wearable:SetAlternative_Pudge(hUnit)
        return
    end
    local name = hUnit:GetUnitName()
    for _,model_name in pairs(self.items[name]["altenative_items"]) do
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
                if Wearable.SpesialFixes[particle_name] then
                    for _,tbl in pairs(Wearable.SpesialFixes[particle_name]) do
                        for k,v in pairs(tbl) do
                            if k == "m_iControlPoint" then
                                m_iControlPoint = v
                            end
                            if k == "m_attachmentName" then
                                m_attachmentName = v
                            end
                        end
                        ParticleManager:SetParticleControlEnt(particle, m_iControlPoint, hUnit, PATTACH_POINT_FOLLOW, m_attachmentName, Vector(0,0,0), true)
                    end
                end
                table.insert(hModel.particles, particle)
            end
        end
        table.insert( self.wear[iPlayerID], hModel )
    end

    hUnit.WearableStatus = "alternative"
end

function CScriptParticleManager:GetAlternativeParticle(hUnit, ParticleName)
    if hUnit.WearableStatus == "alternative" then
        return Wearable.abilities_particles[hUnit:GetUnitName()][ParticleName]
    end
    return ParticleName
end

function Wearable:ChangeModel(hUnit, Type)
    local model = hUnit:GetModelName()
    local name = hUnit:GetUnitName()
    if name == "npc_dota_hero_nevermore" then
        if model == "models/heroes/shadow_fiend/shadow_fiend.vmdl" and Type == "SetAlternative" then
            hUnit:SetOriginalModel("denk/models/shadow_fiend/shadow_fiend_arcana/shadow_fiend_arcana_denk.vmdl")
            hUnit:SetModel("denk/models/shadow_fiend/shadow_fiend_arcana/shadow_fiend_arcana_denk.vmdl")
        end
        if model == "denk/models/shadow_fiend/shadow_fiend_arcana/shadow_fiend_arcana_denk.vmdl" and Type == "SetDefault" then
            hUnit:SetOriginalModel("models/heroes/shadow_fiend/shadow_fiend.vmdl")
            hUnit:SetModel("models/heroes/shadow_fiend/shadow_fiend.vmdl")
        end
    end
end

function Wearable:SetAlternative_Pudge(hUnit)
    local name = hUnit:GetUnitName()
    for _,model_name in pairs(self.items[name]["altenative_items"]) do
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
                if Wearable.SpesialFixes[particle_name] then
                    for _,tbl in pairs(Wearable.SpesialFixes[particle_name]) do
                        for k,v in pairs(tbl) do
                            if k == "m_iControlPoint" then
                                m_iControlPoint = v
                            end
                            if k == "m_attachmentName" then
                                m_attachmentName = v
                            end
                        end
                        ParticleManager:SetParticleControlEnt(particle, m_iControlPoint, hUnit, PATTACH_POINT_FOLLOW, m_attachmentName, Vector(0,0,0), true)
                    end
                end
                table.insert(hModel.particles, particle)
            end
        end
        table.insert( self.wear[iPlayerID], hModel )
    end
    hUnit.WearableStatus = "alternative"
end

Wearable.SpesialFixes = {
    ["amir4an/particles/heroes/nevermore/amir4anmods_zxc/amir4anmods_zxc_arcana_ambient.vpcf"] = {
        {
            ["m_iControlPoint"] = 1,
            ["m_iAttachType"] = "PATTACH_POINT_FOLLOW",
            ["m_attachmentName"] = "attach_wing_R0",
            ["m_entityName"] = "parent",
        },
        
        {
            ["m_iControlPoint"] = 2,
            ["m_iAttachType"] = "PATTACH_POINT_FOLLOW",
            ["m_attachmentName"] = "attach_wing_R1",
            ["m_entityName"] = "parent",
        },
        
        {
            ["m_iControlPoint"] = 3,
            ["m_iAttachType"] = "PATTACH_POINT_FOLLOW",
            ["m_attachmentName"] = "attach_wing_R2",
            ["m_entityName"] = "parent",
        },
        
        {
            ["m_iControlPoint"] = 4,
            ["m_iAttachType"] = "PATTACH_POINT_FOLLOW",
            ["m_attachmentName"] = "attach_wing_L0",
            ["m_entityName"] = "parent",
        },
        
        {
            ["m_iControlPoint"] = 5,
            ["m_iAttachType"] = "PATTACH_POINT_FOLLOW",
            ["m_attachmentName"] = "attach_wing_L1",
            ["m_entityName"] = "parent",
        },
        
        {
            ["m_iControlPoint"] = 6,
            ["m_iAttachType"] = "PATTACH_POINT_FOLLOW",
            ["m_attachmentName"] = "attach_wing_L2",
            ["m_entityName"] = "parent",
        },
        
        {
            ["m_iControlPoint"] = 10,
            ["m_iAttachType"] = "PATTACH_POINT_FOLLOW",
            ["m_attachmentName"] = "attach_head",
            ["m_entityName"] = "parent",
        },
        
        {
            ["m_iControlPoint"] = 13,
            ["m_iAttachType"] = "PATTACH_POINT_FOLLOW",
            ["m_attachmentName"] = "attach_hitloc",
            ["m_entityName"] = "parent",
        },
    },
    ["amir4an/particles/heroes/nevermore/amir4anmods_zxc/amir4anmods_zxc_arcana_ambient_eyes_new.vpcf"] = {
        {
            ["m_iControlPoint"] = 1,
            ["m_iAttachType"] = "PATTACH_POINT_FOLLOW",
            ["m_attachmentName"] = "attach_eyeL",
            ["m_entityName"] = "parent",
        },
        
        {
            ["m_iControlPoint"] = 2,
            ["m_iAttachType"] = "PATTACH_POINT_FOLLOW",
            ["m_attachmentName"] = "attach_eyeR",
            ["m_entityName"] = "parent",
        },
    },
    ["amir4an/particles/heroes/spectre/amir4anmods_crescent/amir4anmods_crescent_base_ambient.vpcf"] = {
        {
            ["m_iControlPoint"] = 2,
            ["m_iAttachType"] = "PATTACH_POINT_FOLLOW",
            ["m_attachmentName"] = "attach_hitloc",
            ["m_entityName"] = "self",
        },
    },
    ["amir4an/particles/heroes/spectre/amir4anmods_crescent/amir4anmods_crescent_belt_ambient.vpcf"] = {
        {
            ["m_iControlPoint"] = 6,
            ["m_iAttachType"] = "PATTACH_WORLDORIGIN",
            ["m_entityName"] = "self",
        },
    },
    ["amir4an/particles/heroes/spectre/amir4anmods_crescent/amir4anmods_crescent_shoulder_ambient.vpcf"] = {
        {
            ["m_iControlPoint"] = 6,
            ["m_iAttachType"] = "PATTACH_WORLDORIGIN",
            ["m_entityName"] = "self",
        },
    },
    ["amir4an/particles/heroes/spectre/amir4anmods_crescent/amir4anmods_crescent_weapon_ambient.vpcf"] = {
        {
            ["m_iControlPoint"] = 6,
            ["m_iAttachType"] = "PATTACH_WORLDORIGIN",
            ["m_entityName"] = "self",
        },
    },
    ["amir4an/particles/heroes/spectre/amir4anmods_crescent/amir4anmods_crescent_head_ambient.vpcf"] = {
        {
            ["m_iControlPoint"] = 6,
            ["m_iAttachType"] = "PATTACH_WORLDORIGIN",
            ["m_entityName"] = "self",
        },
    },
}

Wearable.abilities_particles = {
    ["npc_dota_hero_nevermore"] = {
        ["particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf"] = "amir4an/particles/heroes/nevermore/amir4anmods_zxc/amir4anmods_zxc_shadowraze.vpcf"
    }
}

if not Wearable.bInit then
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