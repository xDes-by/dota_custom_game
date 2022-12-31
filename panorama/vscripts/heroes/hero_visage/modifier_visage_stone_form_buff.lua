modifier_visage_stone_form_buff_lua = class({})

function modifier_visage_stone_form_buff_lua:IsPurgable() return false end
function modifier_visage_stone_form_buff_lua:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_visage_stone_form_buff_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_earth_spirit_petrify.vpcf"
end

function modifier_visage_stone_form_buff_lua:StatusEffectPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_visage_stone_form_buff_lua:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
end

function modifier_visage_stone_form_buff_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
end

function modifier_visage_stone_form_buff_lua:OnCreated()
	self.health_regen_pct = self:GetAbility():GetSpecialValueFor("shard_hp_restoration_pct") / self:GetDuration()
end

function modifier_visage_stone_form_buff_lua:OnDestroy()
	if IsClient() then return end

	ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_familiar_transform.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
end

function modifier_visage_stone_form_buff_lua:GetModifierHealthRegenPercentage()
	return self.health_regen_pct
end
