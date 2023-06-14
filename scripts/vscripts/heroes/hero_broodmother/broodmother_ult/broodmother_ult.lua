LinkLuaModifier('modifier_broodmother_ult', "heroes/hero_broodmother/broodmother_ult/broodmother_ult", LUA_MODIFIER_MOTION_NONE)

broodmother_ult = class({})

function broodmother_ult:GetIntrinsicModifierName() 
    return 'modifier_broodmother_ult'
end

--------------------------------------------------------------------------

modifier_broodmother_ult = class({})

function modifier_broodmother_ult:IsHidden()
	return false
end

function modifier_broodmother_ult:IsPurgable()
	return false
end

function modifier_broodmother_ult:RemoveOnDeath()
	return false
end

function modifier_broodmother_ult:OnCreated( kv )
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.regen = self:GetAbility():GetSpecialValueFor("regen")
	self.ms = self:GetAbility():GetSpecialValueFor("ms")
	if IsServer() then
		self:SetStackCount(0)
	end
end

function modifier_broodmother_ult:OnRefresh( kv )
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.regen = self:GetAbility():GetSpecialValueFor("regen")
	self.ms = self:GetAbility():GetSpecialValueFor("ms")
end

function modifier_broodmother_ult:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
	return funcs
end

function modifier_broodmother_ult:OnTooltip()
    return calculated_damage(self:GetCaster(), self.damage, self)
end

function modifier_broodmother_ult:OnTooltip2()
	return calculated_hp(self:GetCaster(), self.regen, self)
end

function calculated_damage(caster, attr, modifier)
	if caster:FindAbilityByName("npc_dota_hero_broodmother_agi_last") then
		mn = 3
	else
		mn = 1
	end	
	return modifier:GetStackCount() * attr * mn
end

function calculated_hp(caster, attr, modifier)
	if caster:FindAbilityByName("npc_dota_hero_broodmother_str_last") then
		mn = 5
	else
		mn = 1
	end	
	return modifier:GetStackCount() * attr * mn
end

function modifier_broodmother_ult:OnDeath( params )
	local target = params.unit
	local attacker = params.attacker
	local unit_name = params.unit:GetUnitName()
	local pass = false
	if attacker==self:GetParent() and target~=self:GetParent() and attacker:IsAlive() then
		if (not target:IsIllusion()) and (not target:IsBuilding()) then
			pass = true
		end
	end
	if pass and (not self:GetParent():PassivesDisabled()) then
		self:IncrementStackCount()
	end
end

function modifier_broodmother_ult:GetModifierBaseAttack_BonusDamage()
	return calculated_damage(self:GetCaster(), self.damage, self)
end

function modifier_broodmother_ult:GetModifierConstantHealthRegen()
	return calculated_hp(self:GetCaster(), self.regen, self)
end

function modifier_broodmother_ult:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount() * self.ms
end

function modifier_broodmother_ult:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_broodmother_ult:GetModifierBonusStats_Strength()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_int_last") then
		return self:GetStackCount()
	end
end

function modifier_broodmother_ult:GetModifierBonusStats_Intellect()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_int_last") then
		return self:GetStackCount()
	end
end

function modifier_broodmother_ult:GetModifierBonusStats_Agility()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_int_last") then
		return self:GetStackCount()
	end
end

function modifier_broodmother_ult:GetModifierSpellAmplify_Percentage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_broodmother_int11") then
		return math.floor(self:GetStackCount() / 100)*10
	end
end



