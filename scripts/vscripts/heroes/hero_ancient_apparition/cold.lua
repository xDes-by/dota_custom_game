LinkLuaModifier( "modifier_npc_dota_hero_ancient_apparition_agi8", "heroes/hero_ancient_apparition/cold", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "npc_dota_hero_ancient_apparition_agi8_effect", "heroes/hero_ancient_apparition/cold", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "npc_dota_hero_ancient_apparition_agi8_cd", "heroes/hero_ancient_apparition/cold", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_ancient_apparition_agi8 = class({})

function npc_dota_hero_ancient_apparition_agi8:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_ancient_apparition_agi8"
end

--------------------------------------------------------------------------------

modifier_npc_dota_hero_ancient_apparition_agi8 = class({})

function modifier_npc_dota_hero_ancient_apparition_agi8:IsHidden()
	return true
end

function modifier_npc_dota_hero_ancient_apparition_agi8:IsDebuff( kv )
	return false
end

function modifier_npc_dota_hero_ancient_apparition_agi8:IsPurgable( kv )
	return false
end

function modifier_npc_dota_hero_ancient_apparition_agi8:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_npc_dota_hero_ancient_apparition_agi8:OnAttackLanded(keys)
    if not IsServer() then return end
	if self:GetCaster() == keys.attacker and keys.attacker:GetTeamNumber() ~= keys.target:GetTeamNumber() and not self:GetCaster():PassivesDisabled() and not keys.target:HasModifier("npc_dota_hero_ancient_apparition_agi8_cd") and RandomInt(1,100) <= 15 then
		local ability = self:GetCaster():FindAbilityByName("ancient_apparition_cold_feet_lua")
		if ability ~= nil then 
			keys.target:AddNewModifier(self:GetCaster(), ability, "npc_dota_hero_ancient_apparition_agi8_cd", {duration = 7})
			keys.target:AddNewModifier(self:GetCaster(), ability, "npc_dota_hero_ancient_apparition_agi8_effect", {duration = 2})
		end
	end
end

------------------------------------------------------------------------------------------------------------------------------

npc_dota_hero_ancient_apparition_agi8_cd = class({})

function npc_dota_hero_ancient_apparition_agi8_cd:IsHidden()
	return true
end

function npc_dota_hero_ancient_apparition_agi8_cd:IsPurgable( kv )
	return false
end

-----------------------------------------------------------------------------------------------------------------------------

npc_dota_hero_ancient_apparition_agi8_effect = class({})

function npc_dota_hero_ancient_apparition_agi8_effect:IsHidden() return true end
function npc_dota_hero_ancient_apparition_agi8_effect:IsPurgable() return false end

function npc_dota_hero_ancient_apparition_agi8_effect:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet_frozen.vpcf"
end

function npc_dota_hero_ancient_apparition_agi8_effect:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function npc_dota_hero_ancient_apparition_agi8_effect:OnCreated()
	if not IsServer() then return end
	self:GetParent():EmitSound("Hero_Ancient_Apparition.ColdFeetFreeze")
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_str7") ~= nil then 	
		self.damage = self.damage + self:GetCaster():GetStrength()
	end
	self:StartIntervalThink(0.5)
end

function npc_dota_hero_ancient_apparition_agi8_effect:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true
	}
	return state
end

function npc_dota_hero_ancient_apparition_agi8_effect:OnIntervalThink()
	if not IsServer() then return end
	ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), damage = self.damage/2, damage_type = DAMAGE_TYPE_MAGICAL})
end

function npc_dota_hero_ancient_apparition_agi8_effect:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return decFuncs
end

function npc_dota_hero_ancient_apparition_agi8_effect:GetModifierPhysicalArmorBonus()
	self.resist = self:GetAbility():GetSpecialValueFor( "resist" )
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_str11") ~= nil then 	
		self.resist = self.resist * 2
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_str_last") ~= nil then 
		self.armor = self:GetParent():GetPhysicalArmorBaseValue()/100 * self.resist * (-1)
		return self.armor
	end
	return 0
end

function npc_dota_hero_ancient_apparition_agi8_effect:GetModifierMagicalResistanceBonus()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_str_last") ~= nil then 
		return 0
	end
	self.resist = self:GetAbility():GetSpecialValueFor( "resist" )
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_str11") ~= nil then 	
		self.resist = self.resist * 2
	end
		self.magic_resist = self.resist * (-1)
	return self.magic_resist
end