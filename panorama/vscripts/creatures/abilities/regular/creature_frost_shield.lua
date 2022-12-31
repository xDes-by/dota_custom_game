LinkLuaModifier("modifier_creature_frost_shield", "creatures/abilities/regular/creature_frost_shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_frost_shield_debuff", "creatures/abilities/regular/creature_frost_shield", LUA_MODIFIER_MOTION_NONE)

creature_frost_shield = class({})

function creature_frost_shield:OnSpellStart()
	if IsServer() then
		local target = self:GetCursorTarget()
		if target:HasModifier("modifier_creature_frost_shield") then
			self:StartCooldown(1)
		else
			target:EmitSound("CreatureIceShield.Cast")
			target:AddNewModifier(self:GetCaster(), self, "modifier_creature_frost_shield", {duration = self:GetSpecialValueFor("duration"), damage_reduction = self:GetSpecialValueFor("damage_reduction")})
		end
	end
end



modifier_creature_frost_shield = class({})

function modifier_creature_frost_shield:IsHidden() return true end
function modifier_creature_frost_shield:IsDebuff() return false end
function modifier_creature_frost_shield:IsPurgable() return true end

function modifier_creature_frost_shield:OnCreated(keys)
	if IsServer() then
		self.damage_reduction = keys.damage_reduction

		local parent = self:GetParent()
		self.shield_pfx = ParticleManager:CreateParticle("particles/creature/frost_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt(self.shield_pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, -175), true)
		ParticleManager:SetParticleControlEnt(self.shield_pfx, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, -175), true)

		self:StartIntervalThink(1.0)
	end
end

function modifier_creature_frost_shield:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.shield_pfx, false)
		ParticleManager:ReleaseParticleIndex(self.shield_pfx)
	end
end

function modifier_creature_frost_shield:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

function modifier_creature_frost_shield:GetModifierIncomingDamage_Percentage()
	if IsServer() then
		return self.damage_reduction
	end
end

function modifier_creature_frost_shield:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		if ability and (not ability:IsNull()) then
			local parent = self:GetParent()
			local radius = ability:GetSpecialValueFor("radius")
			local slow_duration = ability:GetSpecialValueFor("slow_duration")
			local damage = ability:GetSpecialValueFor("damage")

			parent:EmitSound("CreatureIceShield.Tick")

			local pulse_pfx = ParticleManager:CreateParticle("particles/creature/frost_shield_pulse.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
			ParticleManager:SetParticleControlEnt(pulse_pfx, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 75), true)
			ParticleManager:SetParticleControl(pulse_pfx, 2, Vector(radius, 0, 0))
			ParticleManager:ReleaseParticleIndex(pulse_pfx)

			local enemies = FindUnitsInRadius(parent:GetTeam(), parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _, enemy in pairs(enemies) do

				parent:EmitSound("CreatureIceShield.Hit")

				local actual_damage = ApplyDamage({victim = enemy, attacker = parent, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, actual_damage, nil)

				enemy:AddNewModifier(parent, ability, "modifier_creature_frost_shield_debuff", {duration = slow_duration})
			end
		end
	end
end



modifier_creature_frost_shield_debuff = class({})

function modifier_creature_frost_shield_debuff:IsHidden() return false end
function modifier_creature_frost_shield_debuff:IsDebuff() return true end
function modifier_creature_frost_shield_debuff:IsPurgable() return true end

function modifier_creature_frost_shield_debuff:GetEffectName()
	return "particles/creature/frost_shield_debuff.vpcf"
end

function modifier_creature_frost_shield_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_creature_frost_shield_debuff:OnCreated( ... )
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then 
		self.move_slow = 0 
		self.attack_slow = 0 
		return
	end

	self.move_slow = ability:GetSpecialValueFor("move_slow")
	self.attack_slow = ability:GetSpecialValueFor("attack_slow")
end

function modifier_creature_frost_shield_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_creature_frost_shield_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.move_slow
end

function modifier_creature_frost_shield_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.attack_slow
end
