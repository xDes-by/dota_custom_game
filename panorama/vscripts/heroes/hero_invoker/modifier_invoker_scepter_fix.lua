modifier_invoker_scepter_fix = class({})

local ability_list = {
    invoker_ghost_walk_ad = true,
    invoker_deafening_blast_ad = true,
    invoker_chaos_meteor_ad = true,
    invoker_ice_wall_ad = true,
    invoker_tornado_ad = true,
    invoker_emp_ad = true,
    invoker_sun_strike_ad = true,
    invoker_cold_snap_ad = true,
} 

function modifier_invoker_scepter_fix:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_invoker_scepter_fix:IsHidden() return true end
function modifier_invoker_scepter_fix:IsDebuff() return false end
function modifier_invoker_scepter_fix:IsPurgable() return false end

if IsClient() then return end

function modifier_invoker_scepter_fix:OnCreated()
    self:RefreshAbilities()
end

function modifier_invoker_scepter_fix:OnRefresh()
    self:RefreshAbilities()
end

function modifier_invoker_scepter_fix:RefreshAbilities()
    local parent = self:GetParent()
    
    for ability_name,_ in pairs(ability_list) do
        local ability = parent:FindAbilityByName(ability_name)

        if ability and ability:IsTrained() then
            ability:OnUpgrade()
        end
    end
end

function modifier_invoker_scepter_fix:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
        MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
    }

    return funcs
end

function modifier_invoker_scepter_fix:GetModifierOverrideAbilitySpecial(params)
    return ability_list[params.ability:GetAbilityName()] and 1 or 0
end

function modifier_invoker_scepter_fix:GetModifierOverrideAbilitySpecialValue(params)
    return params.ability:GetLevelSpecialValueNoOverride(params.ability_special_value, params.ability:GetLevel() - 1)
end