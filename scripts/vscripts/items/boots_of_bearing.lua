item_boots_of_bearing_lua = item_boots_of_bearing_lua or class({})
item_boots_of_bearing_lua2 = item_boots_of_bearing_lua or class({})
item_boots_of_bearing_lua3 = item_boots_of_bearing_lua or class({})
item_boots_of_bearing_lua4 = item_boots_of_bearing_lua or class({})
item_boots_of_bearing_lua5 = item_boots_of_bearing_lua or class({})
item_boots_of_bearing_lua6 = item_boots_of_bearing_lua or class({})
item_boots_of_bearing_lua7 = item_boots_of_bearing_lua or class({})
item_boots_of_bearing_lua8 = item_boots_of_bearing_lua or class({})

LinkLuaModifier("modifier_boots_of_bearing_lua", "items/boots_of_bearing", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boots_of_bearing_lua_speed_aura", "items/boots_of_bearing", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boots_of_bearing_lua_yaskorost", "items/boots_of_bearing", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boots_of_bearing_lua_active", "items/boots_of_bearing", LUA_MODIFIER_MOTION_NONE)

modifier_boots_of_bearing_lua = class({})
modifier_boots_of_bearing_lua_speed_aura = class({})
modifier_boots_of_bearing_lua_aura_positive = class({})
modifier_boots_of_bearing_lua_aura_positive_effect = class({})
modifier_boots_of_bearing_lua_yaskorost = class ({})
modifier_boots_of_bearing_lua_active = class ({})

function item_boots_of_bearing_lua:GetIntrinsicModifierName()
    return "modifier_boots_of_bearing_lua"
end

function modifier_boots_of_bearing_lua:IsHidden() return true end
function modifier_boots_of_bearing_lua:IsPurgable() return false end
function modifier_boots_of_bearing_lua:RemoveOnDeath() return false end


function modifier_boots_of_bearing_lua:OnCreated()
    if not IsServer() then
        return end
    self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_boots_of_bearing_lua_speed_aura",nil)
end

function modifier_boots_of_bearing_lua:OnRefresh()
    local charges = self:GetAbility():GetCurrentCharges()
    self:GetAbility():SetCurrentCharges(charges)
end

function modifier_boots_of_bearing_lua:OnRemoved()
    if not IsServer() then
        return end 
    self:GetParent():RemoveModifierByName("modifier_boots_of_bearing_lua_speed_aura")
end

function modifier_boots_of_bearing_lua:DeclareFunctions()
return {
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    MODIFIER_EVENT_ON_DEATH
}
end

function modifier_boots_of_bearing_lua:OnDeath(data)
    local ability = self:GetAbility()
    local charges = self:GetAbility():GetCurrentCharges()
    if self:GetParent() == data.attacker then
        ability:SetCurrentCharges(charges + 1)
    end
end

function modifier_boots_of_bearing_lua:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_boots_of_bearing_lua:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_boots_of_bearing_lua:GetModifierConstantHealthRegen()
    return self:GetAbility():GetSpecialValueFor("bonus_health_regen")
end

function modifier_boots_of_bearing_lua:GetModifierMoveSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
end



function modifier_boots_of_bearing_lua_speed_aura:IsHidden() return true end
function modifier_boots_of_bearing_lua_speed_aura:IsPurgable() return false end
function modifier_boots_of_bearing_lua_speed_aura:RemoveOnDeath() return false end
function modifier_boots_of_bearing_lua_speed_aura:IsDebuff() return false end


function modifier_boots_of_bearing_lua_speed_aura:GetAuraRadius()
    if self:GetAbility() then
        return self:GetAbility():GetSpecialValueFor("radius")
    end
end


function modifier_boots_of_bearing_lua_speed_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_boots_of_bearing_lua_speed_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_boots_of_bearing_lua_speed_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_boots_of_bearing_lua_yaskorost:IsHidden() return false end
function modifier_boots_of_bearing_lua_yaskorost:IsPurgable() return false end
function modifier_boots_of_bearing_lua_yaskorost:RemoveOnDeath() return false end

function modifier_boots_of_bearing_lua_yaskorost:GetTexture()
    return "boots_of_bearing"
end
function modifier_boots_of_bearing_lua_active:GetTexture()
    return "boots_of_bearing"
end
function modifier_boots_of_bearing_lua_speed_aura:GetTexture()
    return "boots_of_bearing"
end

function modifier_boots_of_bearing_lua_speed_aura:GetModifierAura()
    return "modifier_boots_of_bearing_lua_yaskorost"
end

function modifier_boots_of_bearing_lua_speed_aura:IsAura()
    return true
end


function modifier_boots_of_bearing_lua_yaskorost:DeclareFunctions()
return {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
}
end

function modifier_boots_of_bearing_lua_yaskorost:GetModifierMoveSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("aura_movement_speed")
end

function modifier_boots_of_bearing_lua_active:IsHidden() return false end
function modifier_boots_of_bearing_lua_active:IsPurgable() return false end
function modifier_boots_of_bearing_lua_active:RemoveOnDeath() return true end

function modifier_boots_of_bearing_lua_active:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end

function modifier_boots_of_bearing_lua_active:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("bonus_movement_speed_pct")
end

function modifier_boots_of_bearing_lua_active:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("bonus_attack_speed_pct")
end

function modifier_boots_of_bearing_lua_active:OnCreated()
    if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

    -- Ability properties
    self.particle_buff = "particles/items_fx/drum_of_endurance_buff.vpcf"
    -- Apply particle effects
    local particle_buff_fx = ParticleManager:CreateParticle(self.particle_buff, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(particle_buff_fx, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_buff_fx, 1, Vector(0,0,0))
    self:AddParticle(particle_buff_fx, false, false, -1, false, false)
end

function item_boots_of_bearing_lua:OnSpellStart()
    if self:GetCurrentCharges() < self:GetSpecialValueFor("charges")
    then return
    end
    EmitSoundOn("DOTA_Item.DoE.Activate", self:GetCaster())
    self:SetCurrentCharges(self:GetCurrentCharges() - self:GetSpecialValueFor("charges"))
    local units = FindUnitsInRadius(self:GetCaster():GetTeam(),
    self:GetCaster():GetOrigin(),
    nil, 
    self:GetSpecialValueFor('radius'),
    DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    DOTA_UNIT_TARGET_FLAG_NONE,
    FIND_ANY_ORDER,
    false)
    for __,v in pairs(units) do 
        v:AddNewModifier(self:GetCaster(),self,"modifier_boots_of_bearing_lua_active",{duration = self:GetSpecialValueFor("duration")})
    end
end