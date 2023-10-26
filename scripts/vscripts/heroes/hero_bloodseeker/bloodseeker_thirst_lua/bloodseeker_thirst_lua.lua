LinkLuaModifier( "modifier_bloodseeker_thirst_lua", "heroes/hero_bloodseeker/bloodseeker_thirst_lua/bloodseeker_thirst_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bloodseeker_thirst_lua_stack", "heroes/hero_bloodseeker/bloodseeker_thirst_lua/bloodseeker_thirst_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_special_bonus_unique_npc_dota_hero_bloodseeker_agi50", "heroes/hero_bloodseeker/bloodseeker_thirst_lua/bloodseeker_thirst_lua", LUA_MODIFIER_MOTION_NONE )

bloodseeker_thirst_lua = class({})

function bloodseeker_thirst_lua:GetIntrinsicModifierName()
    return "modifier_bloodseeker_thirst_lua"
end

function bloodseeker_thirst_lua:GetBehavior()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_str7") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	end
	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function bloodseeker_thirst_lua:GetCooldown()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_str7") then
		return 60
	end
	return 0
end

function bloodseeker_thirst_lua:GetHealthCost()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_str7") then
		return self:GetCaster():GetHealth() / 2
	end
	return 0
end

function bloodseeker_thirst_lua:OnSpellStart()
	modifier = self:GetCaster():FindModifierByName("modifier_bloodseeker_thirst_lua")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_str10") then
		modifier:AddStack(self:GetCaster():GetLevel() * 0.2, 120)
		modifier:AddStack(self:GetCaster():GetLevel() * 0.8, self:GetSpecialValueFor("duration"))
	else
		modifier:AddStack(self:GetCaster():GetLevel(), self:GetSpecialValueFor("duration"))
	end
end



-- 
---------------------------------------------------------------------------------------
-- if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_str7") then
-- 	return self:GetAbility():GetSpecialValueFor("bonus_movespeed") * self:GetStackCount() * 2
-- end
modifier_bloodseeker_thirst_lua = class({})

function modifier_bloodseeker_thirst_lua:IsHidden()
	return false
end

function modifier_bloodseeker_thirst_lua:IsPurgable()
	return false
end

function modifier_bloodseeker_thirst_lua:OnCreated( kv )
	
	-- local particle_2 = ParticleManager:CreateParticle("particles/econ/items/bloodseeker/bloodseeker_ti7/bloodseeker_ti7_thirst_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	-- ParticleManager:SetParticleControl(particle_2, 0, self:GetParent():GetAbsOrigin())
	-- self:AddParticle(particle_2, false, false, -1, false, false)
	-- self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	-- self.bonus_lifesteal = self:GetAbility():GetSpecialValueFor( "bonus_lifesteal" )
	-- self.bonus_movespeed = self:GetAbility():GetSpecialValueFor( "bonus_movespeed" )
	
	-- self.try_damage = self.bonus_damage
	
	-- if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_agi6") ~= nil then
	-- 	self.try_damage = self.bonus_damage + self:GetCaster():GetAgility()
	-- end
	self.original_model = self:GetCaster():GetModelName()
	self:StartIntervalThink(1)
end

function modifier_bloodseeker_thirst_lua:OnIntervalThink()
	duration = self:GetAbility():GetSpecialValueFor("duration")
	if self:GetStackCount() > duration and self.particle then return end
	if self:GetStackCount() > duration then
		self.particle = ParticleManager:CreateParticle("particles/econ/items/bloodseeker/bloodseeker_ti7/bloodseeker_ti7_thirst_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		-- ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(self.particle, false, false, -1, false, false)
	end
	if self:GetStackCount() < duration and self.particle then
		ParticleManager:DestroyParticle(self.particle, false)
		self.particle = nil
	end
end

function modifier_bloodseeker_thirst_lua:DeclareFunctions()
	local funcs = {
		
		
		-- MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		-- MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		-- MODIFIER_EVENT_ON_TAKEDAMAGE,
		-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_DEATH,
		--Talent
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end

function modifier_bloodseeker_thirst_lua:OnDeath(params)
	if self:GetCaster() ~= params.attacker then return end
	self:AddStack()
	heal = self:GetParent():GetMaxHealth() / 100 * self:GetAbility():GetSpecialValueFor("bonus_lifesteal")
	SendOverheadEventMessage( self:GetCaster(), OVERHEAD_ALERT_HEAL , self:GetCaster(), heal, nil )
	self:GetParent():Heal(heal, self:GetAbility())
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_bloodseeker_agi50") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_special_bonus_unique_npc_dota_hero_bloodseeker_agi50", {duration = 10})
	end
end

function modifier_bloodseeker_thirst_lua:AddStack(count, duration)
	count = count or 1
	if not duration then
		duration = self:GetAbility():GetSpecialValueFor("duration")
		if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_str10") and RandomInt(1, 100) <= 20 then
			duration = 120
		end
	end
	local mod = self:GetParent():AddNewModifier(
		self:GetParent(), -- player source
		self:GetAbility(), -- ability source
		"modifier_bloodseeker_thirst_lua_stack", -- modifier name
		{
			duration = duration,
		}
	)
	mod:SetStackCount( mod:GetStackCount() +  count)
	self:SetStackCount( self:GetStackCount() +  count )
end

function modifier_bloodseeker_thirst_lua:GetModifierBonusStats_Agility()
	bonus = self:GetAbility():GetSpecialValueFor("bonus_agility") * self:GetStackCount()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_agi11") then
		bonus = bonus * 2
	end
	return bonus
end

function modifier_bloodseeker_thirst_lua:GetModifierBonusStats_Intellect()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_int6") then
		if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_agi6") then
			return self:GetAbility():GetSpecialValueFor("bonus_agility") * self:GetStackCount() * 2
		end
		return self:GetAbility():GetSpecialValueFor("bonus_agility") * self:GetStackCount()
	end
	return 0
end

function modifier_bloodseeker_thirst_lua:OnAttackLanded(params)
	if IsServer() then
		if params.attacker==self:GetParent() and self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_agi9") ~= nil then
			local damage = params.original_damage / 100 * self:GetStackCount() * 4
			DoCleaveAttack(self:GetParent(),params.target,self:GetAbility(),damage, 150, 360, 360, 'particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf')
		end
	end
end

function modifier_bloodseeker_thirst_lua:GetModifierSpellAmplify_Percentage()
	local value = 0 
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_int9") then
		value = value + self:GetStackCount() * 5
	end
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_bloodseeker_int50") then
		value = value + self:GetCaster():GetMoveSpeedModifier(true, false)
	end
	if self:GetCaster():GetModelName() ~= self.original_model then
		return 0
	end
	return value
end

-- function modifier_bloodseeker_thirst_lua:GetModifierTotalDamageOutgoing_Percentage(k)
-- 	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_int9") ~= nil then
-- 		if k.damage_type ~= 1 then
-- 			return 15
-- 		end
-- 	end
-- end

function modifier_bloodseeker_thirst_lua:GetModifierMoveSpeedBonus_Constant()
	-- if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_str7") then
	-- 	return self:GetAbility():GetSpecialValueFor("bonus_movespeed") * self:GetStackCount() * 2
	-- end
	return self:GetAbility():GetSpecialValueFor("bonus_movespeed") * self:GetStackCount()
end

function modifier_bloodseeker_thirst_lua:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_bloodseeker_thirst_lua:GetModifierMoveSpeed_Max()
	return 10000
end

-- function modifier_bloodseeker_thirst_lua:GetModifierPreAttack_BonusDamage()
-- 	return self.try_damage
-- end

-- function modifier_bloodseeker_thirst_lua:GetModifierProcAttack_Feedback( params )
-- 	if IsServer() then
-- 		local pass = false
-- 		if params.target:GetTeamNumber()~=self:GetParent():GetTeamNumber() then
-- 			if (not params.target:IsBuilding()) and (not params.target:IsOther()) then
-- 				pass = true
-- 			end
-- 		end
-- 		if pass then
-- 			self.attack_record = params.record
-- 		end
-- 	end
-- end

-- function modifier_bloodseeker_thirst_lua:OnTakeDamage( params )
-- 	if IsServer() then	
-- 		local pass = false
-- 		if self.attack_record and params.record == self.attack_record then
-- 			pass = true
-- 			self.attack_record = nil
-- 		end
-- 		if pass then
-- 			local heal = params.damage * self.bonus_lifesteal/100
-- 			self:GetParent():Heal( heal, self:GetAbility() )
-- 			self:PlayEffects2( self:GetParent() )
-- 		end
-- 	end
-- end

function modifier_bloodseeker_thirst_lua:PlayEffects2( target )
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end








modifier_bloodseeker_thirst_lua_stack = class({})
-- local tempTable = require("util/tempTable")

--------------------------------------------------------------------------------
-- Classifications
function modifier_bloodseeker_thirst_lua_stack:IsHidden()
	return true
end

function modifier_bloodseeker_thirst_lua_stack:IsPurgable()
	return false
end

function modifier_bloodseeker_thirst_lua_stack:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_bloodseeker_thirst_lua_stack:OnCreated( kv )
end

function modifier_bloodseeker_thirst_lua_stack:OnRemoved()
	if IsServer() then
		-- decrement stack
		if not self:GetCaster():FindModifierByName("modifier_bloodseeker_thirst_lua"):IsNull() then
			local modifier_bloodseeker_thirst_lua = self:GetCaster():FindModifierByName("modifier_bloodseeker_thirst_lua")
			modifier_bloodseeker_thirst_lua:SetStackCount(modifier_bloodseeker_thirst_lua:GetStackCount() - self:GetStackCount())
		end
	end
end

function modifier_bloodseeker_thirst_lua_stack:OnDestroy()
end

modifier_special_bonus_unique_npc_dota_hero_bloodseeker_agi50 = class({})
--Classifications template
function modifier_special_bonus_unique_npc_dota_hero_bloodseeker_agi50:IsHidden()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_bloodseeker_agi50:IsDebuff()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_bloodseeker_agi50:IsPurgable()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_bloodseeker_agi50:IsPurgeException()
	return false
end

-- Optional Classifications
function modifier_special_bonus_unique_npc_dota_hero_bloodseeker_agi50:IsStunDebuff()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_bloodseeker_agi50:RemoveOnDeath()
	return true
end

function modifier_special_bonus_unique_npc_dota_hero_bloodseeker_agi50:DestroyOnExpire()
	return true
end

function modifier_special_bonus_unique_npc_dota_hero_bloodseeker_agi50:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_special_bonus_unique_npc_dota_hero_bloodseeker_agi50:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_special_bonus_unique_npc_dota_hero_bloodseeker_agi50:GetModifierMoveSpeedBonus_Percentage()
	return 50
end

function modifier_special_bonus_unique_npc_dota_hero_bloodseeker_agi50:GetModifierAttackSpeedBonus_Constant()
	return 75
end