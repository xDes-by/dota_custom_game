LinkLuaModifier("modifier_boss_10_chain", "abilities/bosses/line/boss_10/boss_10_chain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_10_chain_debuff", "abilities/bosses/line/boss_10/boss_10_chain", LUA_MODIFIER_MOTION_NONE)

boss_10_chain = class({})

function boss_10_chain:GetIntrinsicModifierName()
	return "modifier_boss_10_chain"
end

function boss_10_chain:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()
		local duration = self:GetSpecialValueFor("duration")

		caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)

		caster:EmitSound("Hero_EmberSpirit.SearingChains.Cast")
		local cast_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_cast.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(cast_pfx, 0, caster_loc)
		ParticleManager:SetParticleControl(cast_pfx, 1, Vector(self:GetSpecialValueFor("effect_radius"), 1, 1))
		ParticleManager:ReleaseParticleIndex(cast_pfx)

		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			ApplySearingChains(caster, caster, enemy, self, duration)
		end
	end
end

function ApplySearingChains(caster, source, target, ability, duration)
	target:EmitSound("Hero_EmberSpirit.SearingChains.Target")
	target:AddNewModifier(caster, ability, "modifier_boss_10_chain_debuff", {damage = ability:GetSpecialValueFor("damage"), tick_interval = 0.25, duration = duration * (1 - target:GetStatusResistance())})
	local impact_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_start.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(impact_pfx, 0, source:GetAbsOrigin())
	ParticleManager:SetParticleControl(impact_pfx, 1, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(impact_pfx)
end

---------------------------------------------------------------

modifier_boss_10_chain_debuff = class ({})

function modifier_boss_10_chain_debuff:IsDebuff() return true end
function modifier_boss_10_chain_debuff:IsHidden() return false end
function modifier_boss_10_chain_debuff:IsPurgable() return true end

function modifier_boss_10_chain_debuff:GetEffectName()
	return "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_debuff.vpcf"
end

function modifier_boss_10_chain_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_boss_10_chain_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true
	}
	return state
end

function modifier_boss_10_chain_debuff:OnCreated(keys)
	if IsServer() then
		self.tick_interval = keys.tick_interval
		self.damage = keys.damage
		self:StartIntervalThink(self.tick_interval)
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 0.3 * (1 - self:GetParent():GetStatusResistance())})
	end
end

function modifier_boss_10_chain_debuff:OnIntervalThink()
	if IsServer() then
		ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
	end
end