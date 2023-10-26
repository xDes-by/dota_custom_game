spectre_step = spectre_step or class({})
LinkLuaModifier("modifier_step", "heroes/hero_spectre/spectre_step/spectre_step.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_step_debuff", "heroes/hero_spectre/spectre_step/spectre_step.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_step_buff", "heroes/hero_spectre/spectre_step/spectre_step.lua", LUA_MODIFIER_MOTION_NONE)

function spectre_step:GetIntrinsicModifierName()
	return "modifier_step"
end

function spectre_step:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Spectre.DaggerCast")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_step_buff", {duration = 7})
end

function spectre_step:GetBehavior()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_int_last") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	end
	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function spectre_step:GetCooldown()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_int_last") then
		return 60
	end
	return 0
end

function spectre_step:GetManaCost(iLevel)
    if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_int_last") then
		return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
	end
    return 0
end

function spectre_step:GetCastRange(location, target)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_int6") then
		return self:GetSpecialValueFor("radius") + 100
	end
	return self:GetSpecialValueFor("radius")
end

-----------------------------------------------------------------------------
modifier_step = class({})

function modifier_step:IsHidden()
	return true
end

function modifier_step:IsPurgable()
	return false
end

function modifier_step:IsPurgeException()
	return false 
end

function modifier_step:IsAura() 
	return true 
end

function modifier_step:GetModifierAura() 
	return "modifier_step_debuff" 
end

function modifier_step:GetAuraRadius()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_int6") then
		return self:GetAbility():GetSpecialValueFor("radius") + 100
	end
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_step:GetAuraSearchFlags() 
	return DOTA_UNIT_TARGET_FLAG_NONE 
end

function modifier_step:GetAuraSearchTeam() 
	return DOTA_UNIT_TARGET_TEAM_ENEMY 
end

function modifier_step:GetAuraSearchType() 
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_step:OnCreated( kv )
	self.caster = self:GetCaster()
	
	
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.dmg = self:GetAbility():GetSpecialValueFor("dmg")
	self.speed = self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_step:OnRefresh( kv )
	self.caster = self:GetCaster()
	
	
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.dmg = self:GetAbility():GetSpecialValueFor("dmg")
	self.speed = self:GetAbility():GetSpecialValueFor("speed")
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_agi9")
	if abil ~= nil then 
	self.dmg = self.dmg * 2
	end
end

function modifier_step:OnDestroy( kv )
end

function modifier_step:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	}

	return funcs
end

function modifier_step:GetModifierMoveSpeedBonus_Constant()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_str6") then
		return self.speed * 2
	end
	return self.speed
end

function modifier_step:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end


function modifier_step:GetModifierIgnoreMovespeedLimit()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_str6") then
		return 1
	end
	return 0
end

modifier_step_debuff = class({})

function modifier_step_debuff:IsDebuff()			
	return true 
end

function modifier_step_debuff:IsHidden() 			
	return false 
end

function modifier_step_debuff:IsPurgable() 		
	return false 
end

function modifier_step_debuff:IsPurgeException() 	
	return false 
end

function modifier_step_debuff:OnCreated()
	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("tick"))
	end
end

function modifier_step_debuff:OnIntervalThink()
	local caster = self:GetCaster()
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	local base_attribute_multi = self:GetAbility():GetSpecialValueFor("main_attribute_dmg")
	if caster:FindAbilityByName("npc_dota_hero_spectre_agi6") then
		base_attribute_multi = base_attribute_multi + 1
	end
	if caster:GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH then
		self.damage = self.damage + caster:GetStrength() * base_attribute_multi
	end
	if caster:GetPrimaryAttribute() == DOTA_ATTRIBUTE_AGILITY then
		self.damage = self.damage + caster:GetAgility() * base_attribute_multi
	end
	if caster:GetPrimaryAttribute() == DOTA_ATTRIBUTE_INTELLECT then
		self.damage = self.damage + caster:GetIntellect() * base_attribute_multi
	end
	
	if caster:FindAbilityByName("npc_dota_hero_spectre_str9") then
		self.damage = self.damage + caster:GetStrength() * 1
	end
	if caster:FindAbilityByName("npc_dota_hero_spectre_int9") then
		self.damage = self.damage + caster:GetIntellect() * 1
	end
	if caster:HasModifier("modifier_step_buff") then
		self.damage = self.damage * 2
	end
	if caster:FindAbilityByName("special_bonus_unique_npc_dota_hero_spectre_int50") then
		self.damage = self.damage * 2
	end
	ApplyDamage({attacker = caster, victim = self:GetParent(), damage = self.damage / 5, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
end


modifier_step_buff = class({})

function modifier_step_buff:GetEffectName()
	return "particles/creatures/aghanim/aghanim_debug_ring.vpcf"
end

function modifier_step_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

