modifier_necrolyte_reapers_scythe_lua = class({})

function modifier_necrolyte_reapers_scythe_lua:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_necrolyte_reapers_scythe_lua:IsPurgable() return false end

function modifier_necrolyte_reapers_scythe_lua:GetEffectName()
	return "particles/units/heroes/hero_necrolyte/necrolyte_scythe.vpcf"
end

function modifier_necrolyte_reapers_scythe_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_necrolyte_reapers_scythe_lua:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

function modifier_necrolyte_reapers_scythe_lua:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end

function modifier_necrolyte_reapers_scythe_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end

function modifier_necrolyte_reapers_scythe_lua:OnCreated()
	if IsClient() then return end

	local caster = self:GetCaster()
	local target = self:GetParent()

	local stun_fx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_stunned.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
	self:AddParticle(stun_fx, false, false, -1, false, false)
	
	local orig_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_orig.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	self:AddParticle(orig_fx, false, false, -1, false, false)

	local scythe_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(scythe_fx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(scythe_fx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(scythe_fx)
end

function modifier_necrolyte_reapers_scythe_lua:OnDestroy()
	if IsClient()  then return end

	local caster = self:GetCaster()
	local target = self:GetParent()
	local ability = self:GetAbility()

	if not IsValidEntity(ability) or not IsValidEntity(caster) then return end

	if target:IsAlive() then
		local damage = ability:GetSpecialValueFor("damage_per_health") * (target:GetMaxHealth() - target:GetHealth())

		local actually_dmg = ApplyDamage({
			attacker = caster, 
			victim = target, 
			ability = ability, 
			damage = damage, 
			damage_type = DAMAGE_TYPE_MAGICAL
		})

		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, actually_dmg, nil)
	end

	if not target:IsAlive() then
		local hp_regen = ability:GetSpecialValueFor(target:IsHero() and "hp_per_kill" or "hp_per_kill_creep")
		local mana_regen = ability:GetSpecialValueFor(target:IsHero() and "mana_per_kill" or "mana_per_kill_creep")

		caster:AddNewModifier(caster, ability, "modifier_necrolyte_reapers_scythe_buff_lua", { hp_regen = hp_regen, mana_regen = mana_regen})
	end

end
