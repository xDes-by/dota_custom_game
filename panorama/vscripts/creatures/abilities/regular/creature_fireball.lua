LinkLuaModifier("modifier_creature_fireball", "creatures/abilities/regular/creature_fireball", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_fireball_debuff", "creatures/abilities/regular/creature_fireball", LUA_MODIFIER_MOTION_NONE)

creature_fireball = class({})

function creature_fireball:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local duration = self:GetSpecialValueFor("duration")
		local target_loc = self:GetCursorPosition()
		
		caster:EmitSound("CreatureFireball.Cast")

		local fireball_pfx = ParticleManager:CreateParticle("particles/creature/creature_fireball.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(fireball_pfx, 0, target_loc)
		ParticleManager:SetParticleControl(fireball_pfx, 1, target_loc)
		ParticleManager:SetParticleControl(fireball_pfx, 2, Vector(duration, 0, 0))
		ParticleManager:ReleaseParticleIndex(fireball_pfx)

		CreateModifierThinker(caster, self, "modifier_creature_fireball", {duration = duration}, target_loc, DOTA_TEAM_NEUTRALS, false)
	end
end



modifier_creature_fireball = class({})

function modifier_creature_fireball:IsHidden() return true end
function modifier_creature_fireball:IsDebuff() return false end
function modifier_creature_fireball:IsPurgable() return false end
function modifier_creature_fireball:RemoveOnDeath() return false end

function modifier_creature_fireball:OnCreated( ... )
	local ability = self:GetAbility()

	if not ability or ability:IsNull() then return end

	self.radius = ability:GetSpecialValueFor("radius")
	self.linger_time = ability:GetSpecialValueFor("linger_time")
end

function modifier_creature_fireball:IsAura() return true end
function modifier_creature_fireball:GetAuraRadius() return self.radius end
function modifier_creature_fireball:GetAuraDuration() return self.linger_time end
function modifier_creature_fireball:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creature_fireball:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_creature_fireball:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_creature_fireball:GetModifierAura() return "modifier_creature_fireball_debuff" end

function modifier_creature_fireball:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_creature_fireball:OnDeath(keys)
	if IsServer() then
		if keys.unit == self:GetCaster() then
			self:Destroy()
		end
	end
end



modifier_creature_fireball_debuff = class({})

function modifier_creature_fireball_debuff:IsHidden() return false end
function modifier_creature_fireball_debuff:IsDebuff() return true end
function modifier_creature_fireball_debuff:IsPurgable() return true end

function modifier_creature_fireball_debuff:OnCreated(keys)
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then return end

	self.dps = ability:GetSpecialValueFor("dps")
	self.magic_resist = ability:GetSpecialValueFor("magic_resist")

	if IsServer() then
		self:OnIntervalThink()
		self:StartIntervalThink(1.0)
	end
end

function modifier_creature_fireball_debuff:OnIntervalThink()
	if IsServer() then
		local actual_damage = ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self.dps, damage_type = DAMAGE_TYPE_MAGICAL})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), actual_damage, nil)
	end
end

function modifier_creature_fireball_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return funcs
end

function modifier_creature_fireball_debuff:GetModifierMagicalResistanceBonus()
	return self.magic_resist
end
