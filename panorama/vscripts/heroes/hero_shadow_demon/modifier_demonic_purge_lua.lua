modifier_demonic_purge_lua = class({})

function modifier_demonic_purge_lua:IsPurgable() return false end
function modifier_demonic_purge_lua:IsDebuff() return true end
function modifier_demonic_purge_lua:GetEffectName()
	return "particles/units/heroes/hero_shadow_demon/shadow_demon_demonic_purge.vpcf"
end

function modifier_demonic_purge_lua:OnCreated()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then return end

	self.max_slow = -ability:GetSpecialValueFor("max_slow")
	self.min_slow = -ability:GetSpecialValueFor("min_slow")
	local damage = ability:GetSpecialValueFor("purge_damage")

	if not IsServer() then return end

	local parent = self:GetParent()
	if not parent or parent:IsNull() then return end
	self.parent = parent

	local caster = self:GetCaster()

	parent:Purge(true, false, false, false, false)

	self.scepter = caster:HasScepter()

	local talent = caster:FindAbilityByName("special_bonus_unique_shadow_demon_1")
	if talent and talent:GetLevel() > 0 then
		damage = damage + talent:GetSpecialValueFor("value")
	end

	self.damage_table = {
		victim = parent,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability
	}

	self:StartIntervalThink(0.5)
end

function modifier_demonic_purge_lua:OnIntervalThink()
	if not IsServer() then return end
	if not self or self:IsNull() then return end
	if self.parent and not self.parent:IsNull() then
		self.parent:Purge(true, false, false, false, false)
	end
end

function modifier_demonic_purge_lua:OnRemoved()
	if not IsServer() then return end
	-- Damage is proportional to the debuff's duration
	self.damage_table["damage"] = self.damage_table["damage"] * (self:GetElapsedTime()/self:GetDuration())
	ApplyDamage(self.damage_table)
	self:GetParent():EmitSound("Hero_ShadowDemon.DemonicPurge.Damage")
end

function modifier_demonic_purge_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, -- GetModifierMoveSpeedBonus_Percentage
	}
end

function modifier_demonic_purge_lua:CheckState()
	return {
		[MODIFIER_STATE_PASSIVES_DISABLED] = self.scepter
	}
end

function modifier_demonic_purge_lua:GetModifierMoveSpeedBonus_Percentage()
	local slow_fraction = (self:GetRemainingTime() / self:GetDuration())
	local slow = slow_fraction * self.max_slow
	if slow < self.min_slow then
		return slow
	end
	return self.min_slow
end
