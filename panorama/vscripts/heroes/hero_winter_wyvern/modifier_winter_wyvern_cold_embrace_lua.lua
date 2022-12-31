modifier_winter_wyvern_cold_embrace_lua = class({})
function modifier_winter_wyvern_cold_embrace_lua:IsHidden() return true end
function modifier_winter_wyvern_cold_embrace_lua:IsPurgable() return false end
function modifier_winter_wyvern_cold_embrace_lua:IsDebuff() return false end

function modifier_winter_wyvern_cold_embrace_lua:GetTexture() return "winter_wyvern_cold_embrace" end

function modifier_winter_wyvern_cold_embrace_lua:GetEffectName()
	return "particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf"
end

function modifier_winter_wyvern_cold_embrace_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_winter_wyvern_cold_embrace_lua:DeclareFunctions() 
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	}
	return funcs
end

function modifier_winter_wyvern_cold_embrace_lua:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_winter_wyvern_cold_embrace_lua:CheckState()
	local state = {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

function modifier_winter_wyvern_cold_embrace_lua:OnCreated()
    if IsServer() then self:StartIntervalThink(0.25) end
end

function modifier_winter_wyvern_cold_embrace_lua:OnIntervalThink()
    if not IsServer() then return end
	local parent = self:GetParent()
    local caster = self:GetCaster()
    local ability = self:GetAbility()

    local heal_additive = ability:GetSpecialValueFor("heal_additive")
    local heal_percentage = ability:GetSpecialValueFor("heal_percentage") * 0.01

    if caster:HasTalent("special_bonus_unique_winter_wyvern_5") then		-- extra heal percent
        local extra_heal = caster:FindTalentValue("special_bonus_unique_winter_wyvern_5") * 0.01
        heal_percentage = heal_percentage + extra_heal
    end
    
    local heal_per_tick = ( heal_additive + heal_percentage * parent:GetMaxHealth()) * 0.25
    parent:Heal(heal_per_tick, caster)
end

function modifier_winter_wyvern_cold_embrace_lua:OnDestroy()
    if not IsServer() then return end

    local parent = self:GetParent()
    local caster = self:GetCaster()
    local ability = self:GetAbility()

    if caster and caster:HasShard() and ability then
        ability:CastProjectile({target = parent})
    end	

end