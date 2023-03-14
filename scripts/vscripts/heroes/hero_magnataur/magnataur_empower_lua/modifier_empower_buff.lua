modifier_empower_buff = {}

function modifier_empower_buff:IsHidden()
	return false
end

function modifier_empower_buff:IsDebuff()
	return false
end

function modifier_empower_buff:IsPurgable()
	return true
end

function modifier_empower_buff:OnCreated( kv )
	self.ability = self:GetAbility()
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage_pct" )
	self.cleave = self:GetAbility():GetSpecialValueFor( "cleave_damage_pct" )
	self.mult = self:GetAbility():GetSpecialValueFor( "self_multiplier" )
	self.radius_start = self:GetAbility():GetSpecialValueFor( "cleave_starting_width" )
	self.radius_end = self:GetAbility():GetSpecialValueFor( "cleave_ending_width" )
	self.radius_dist = self:GetAbility():GetSpecialValueFor( "cleave_distance" )

	if self:GetParent()==self:GetCaster() then
		self.damage = self.damage*self.mult
		self.cleave = self.cleave*self.mult
	end
end

modifier_empower_buff.OnRefresh = modifier_empower_buff.OnCreated

function modifier_empower_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_empower_buff:GetModifierProcAttack_Feedback( params )
	if not IsServer() then return end
	if params.attacker:GetAttackCapability()~=DOTA_UNIT_CAP_MELEE_ATTACK then return end

	local damage = params.damage*(self.cleave/100)
    print(params.damage)
    print(self.cleave)
	DoCleaveAttack(
		params.attacker,
		params.target,
		self.ability,
		damage,
		self.radius_start,
		self.radius_end,
		self.radius_dist,
		"particles/units/heroes/hero_magnataur/magnataur_empower_cleave_effect.vpcf"
	)
end

function modifier_empower_buff:GetModifierDamageOutgoing_Percentage()
	return self.damage
end

function modifier_empower_buff:GetEffectName()
	return "particles/units/heroes/hero_magnataur/magnataur_empower.vpcf"
end

function modifier_empower_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end