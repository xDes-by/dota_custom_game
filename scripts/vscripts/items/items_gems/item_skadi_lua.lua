item_skadi_lua1_gem1 = item_skadi_lua1_gem1 or class({})
item_skadi_lua2_gem1 = item_skadi_lua1_gem1 or class({})
item_skadi_lua3_gem1 = item_skadi_lua1_gem1 or class({})
item_skadi_lua4_gem1 = item_skadi_lua1_gem1 or class({})
item_skadi_lua5_gem1 = item_skadi_lua1_gem1 or class({})
item_skadi_lua6_gem1 = item_skadi_lua1_gem1 or class({})
item_skadi_lua7_gem1 = item_skadi_lua1_gem1 or class({})
item_skadi_lua8_gem1 = item_skadi_lua1_gem1 or class({})

item_skadi_lua1_gem2 = item_skadi_lua1_gem2 or class({})
item_skadi_lua2_gem2 = item_skadi_lua1_gem2 or class({})
item_skadi_lua3_gem2 = item_skadi_lua1_gem2 or class({})
item_skadi_lua4_gem2 = item_skadi_lua1_gem2 or class({})
item_skadi_lua5_gem2 = item_skadi_lua1_gem2 or class({})
item_skadi_lua6_gem2 = item_skadi_lua1_gem2 or class({})
item_skadi_lua7_gem2 = item_skadi_lua1_gem2 or class({})
item_skadi_lua8_gem2 = item_skadi_lua1_gem2 or class({})

item_skadi_lua1_gem3 = item_skadi_lua1_gem3 or class({})
item_skadi_lua2_gem3 = item_skadi_lua1_gem3 or class({})
item_skadi_lua3_gem3 = item_skadi_lua1_gem3 or class({})
item_skadi_lua4_gem3 = item_skadi_lua1_gem3 or class({})
item_skadi_lua5_gem3 = item_skadi_lua1_gem3 or class({})
item_skadi_lua6_gem3 = item_skadi_lua1_gem3 or class({})
item_skadi_lua7_gem3 = item_skadi_lua1_gem3 or class({})
item_skadi_lua8_gem3 = item_skadi_lua1_gem3 or class({})

item_skadi_lua1_gem4 = item_skadi_lua1_gem4 or class({})
item_skadi_lua2_gem4 = item_skadi_lua1_gem4 or class({})
item_skadi_lua3_gem4 = item_skadi_lua1_gem4 or class({})
item_skadi_lua4_gem4 = item_skadi_lua1_gem4 or class({})
item_skadi_lua5_gem4 = item_skadi_lua1_gem4 or class({})
item_skadi_lua6_gem4 = item_skadi_lua1_gem4 or class({})
item_skadi_lua7_gem4 = item_skadi_lua1_gem4 or class({})
item_skadi_lua8_gem4 = item_skadi_lua1_gem4 or class({})

item_skadi_lua1_gem5 = item_skadi_lua1_gem5 or class({})
item_skadi_lua2_gem5 = item_skadi_lua1_gem5 or class({})
item_skadi_lua3_gem5 = item_skadi_lua1_gem5 or class({})
item_skadi_lua4_gem5 = item_skadi_lua1_gem5 or class({})
item_skadi_lua5_gem5 = item_skadi_lua1_gem5 or class({})
item_skadi_lua6_gem5 = item_skadi_lua1_gem5 or class({})
item_skadi_lua7_gem5 = item_skadi_lua1_gem5 or class({})
item_skadi_lua8_gem5 = item_skadi_lua1_gem5 or class({})

LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_skadi_lua1", 'items/items_gems/item_skadi_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_skadi_lua2", 'items/items_gems/item_skadi_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_skadi_lua3", 'items/items_gems/item_skadi_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_skadi_lua4", 'items/items_gems/item_skadi_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_skadi_lua5", 'items/items_gems/item_skadi_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_skadi_slow_lua", 'items/items_gems/item_skadi_lua.lua', LUA_MODIFIER_MOTION_NONE)

function item_skadi_lua1_gem1:GetIntrinsicModifierName()
	return "modifier_item_skadi_lua1"
end
function item_skadi_lua1_gem2:GetIntrinsicModifierName()
	return "modifier_item_skadi_lua2"
end
function item_skadi_lua1_gem3:GetIntrinsicModifierName()
	return "modifier_item_skadi_lua3"
end
function item_skadi_lua1_gem4:GetIntrinsicModifierName()
	return "modifier_item_skadi_lua4"
end
function item_skadi_lua1_gem5:GetIntrinsicModifierName()
	return "modifier_item_skadi_lua5"
end

modifier_item_skadi_lua1 = class({})

function modifier_item_skadi_lua1:IsHidden()
	return true
end

function modifier_item_skadi_lua1:IsPurgable()
	return false
end

function modifier_item_skadi_lua1:DestroyOnExpire()
	return false
end

function modifier_item_skadi_lua1:RemoveOnDeath()	
	return false 
end

function modifier_item_skadi_lua1:OnCreated()
	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")

if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 

end
function modifier_item_skadi_lua1:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
function modifier_item_skadi_lua1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_item_skadi_lua1:GetModifierBonusStats_Strength()
	return self.bonus_all_stats
end

function modifier_item_skadi_lua1:GetModifierBonusStats_Agility()
	return self.bonus_all_stats
end

function modifier_item_skadi_lua1:GetModifierBonusStats_Intellect()
	return self.bonus_all_stats
end

function modifier_item_skadi_lua1:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_skadi_lua1:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_skadi_lua1:OnAttackLanded(params)
		local attacker = self:GetParent()
		
		if attacker ~= params.attacker then
			return
		end

		if attacker:IsIllusion() then
			return
		end
		
		local target = params.target if target==nil then target = params.unit end
			if target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
				return 0
			end
			local modifier = target:FindModifierByNameAndCaster("modifier_item_skadi_slow_lua", self:GetAbility():GetCaster())
			if modifier==nil then
				if not self:GetParent():PassivesDisabled() then

					target:AddNewModifier(
						attacker,
						self:GetAbility(),
						"modifier_item_skadi_slow_lua",
						{ duration = 3 }
					)
			end
	end
end
modifier_item_skadi_lua2 = class({})

function modifier_item_skadi_lua2:IsHidden()
	return true
end

function modifier_item_skadi_lua2:IsPurgable()
	return false
end

function modifier_item_skadi_lua2:DestroyOnExpire()
	return false
end

function modifier_item_skadi_lua2:RemoveOnDeath()	
	return false 
end

function modifier_item_skadi_lua2:OnCreated()
	
	

	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")

if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 

end
function modifier_item_skadi_lua2:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
function modifier_item_skadi_lua2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_item_skadi_lua2:GetModifierBonusStats_Strength()
	return self.bonus_all_stats
end

function modifier_item_skadi_lua2:GetModifierBonusStats_Agility()
	return self.bonus_all_stats
end

function modifier_item_skadi_lua2:GetModifierBonusStats_Intellect()
	return self.bonus_all_stats
end

function modifier_item_skadi_lua2:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_skadi_lua2:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_skadi_lua2:OnAttackLanded(params)
		local attacker = self:GetParent()
		
		if attacker ~= params.attacker then
			return
		end

		if attacker:IsIllusion() then
			return
		end
		
		local target = params.target if target==nil then target = params.unit end
			if target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
				return 0
			end
			local modifier = target:FindModifierByNameAndCaster("modifier_item_skadi_slow_lua", self:GetAbility():GetCaster())
			if modifier==nil then
				if not self:GetParent():PassivesDisabled() then

					target:AddNewModifier(
						attacker,
						self:GetAbility(),
						"modifier_item_skadi_slow_lua",
						{ duration = 3 }
					)
			end
	end
end
modifier_item_skadi_lua3 = class({})

function modifier_item_skadi_lua3:IsHidden()
	return true
end

function modifier_item_skadi_lua3:IsPurgable()
	return false
end

function modifier_item_skadi_lua3:DestroyOnExpire()
	return false
end

function modifier_item_skadi_lua3:RemoveOnDeath()	
	return false 
end

function modifier_item_skadi_lua3:OnCreated()
	
	

	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")

if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 

end
function modifier_item_skadi_lua3:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
function modifier_item_skadi_lua3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_item_skadi_lua3:GetModifierBonusStats_Strength()
	return self.bonus_all_stats
end

function modifier_item_skadi_lua3:GetModifierBonusStats_Agility()
	return self.bonus_all_stats
end

function modifier_item_skadi_lua3:GetModifierBonusStats_Intellect()
	return self.bonus_all_stats
end

function modifier_item_skadi_lua3:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_skadi_lua3:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_skadi_lua3:OnAttackLanded(params)
		local attacker = self:GetParent()
		
		if attacker ~= params.attacker then
			return
		end

		if attacker:IsIllusion() then
			return
		end
		
		local target = params.target if target==nil then target = params.unit end
			if target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
				return 0
			end
			local modifier = target:FindModifierByNameAndCaster("modifier_item_skadi_slow_lua", self:GetAbility():GetCaster())
			if modifier==nil then
				if not self:GetParent():PassivesDisabled() then

					target:AddNewModifier(
						attacker,
						self:GetAbility(),
						"modifier_item_skadi_slow_lua",
						{ duration = 3 }
					)
			end
	end
end
modifier_item_skadi_lua4 = class({})

function modifier_item_skadi_lua4:IsHidden()
	return true
end

function modifier_item_skadi_lua4:IsPurgable()
	return false
end

function modifier_item_skadi_lua4:DestroyOnExpire()
	return false
end

function modifier_item_skadi_lua4:RemoveOnDeath()	
	return false 
end

function modifier_item_skadi_lua4:OnCreated()
	
	

	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")

if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 

end
function modifier_item_skadi_lua4:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
function modifier_item_skadi_lua4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_item_skadi_lua4:GetModifierBonusStats_Strength()
	return self.bonus_all_stats
end

function modifier_item_skadi_lua4:GetModifierBonusStats_Agility()
	return self.bonus_all_stats
end

function modifier_item_skadi_lua4:GetModifierBonusStats_Intellect()
	return self.bonus_all_stats
end

function modifier_item_skadi_lua4:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_skadi_lua4:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_skadi_lua4:OnAttackLanded(params)
		local attacker = self:GetParent()
		
		if attacker ~= params.attacker then
			return
		end

		if attacker:IsIllusion() then
			return
		end
		
		local target = params.target if target==nil then target = params.unit end
			if target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
				return 0
			end
			local modifier = target:FindModifierByNameAndCaster("modifier_item_skadi_slow_lua", self:GetAbility():GetCaster())
			if modifier==nil then
				if not self:GetParent():PassivesDisabled() then

					target:AddNewModifier(
						attacker,
						self:GetAbility(),
						"modifier_item_skadi_slow_lua",
						{ duration = 3 }
					)
			end
	end
end

modifier_item_skadi_lua5 = class({})

function modifier_item_skadi_lua5:IsHidden()
	return true
end

function modifier_item_skadi_lua5:IsPurgable()
	return false
end

function modifier_item_skadi_lua5:DestroyOnExpire()
	return false
end

function modifier_item_skadi_lua5:RemoveOnDeath()	
	return false 
end

function modifier_item_skadi_lua5:OnCreated()
	
	

	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")

if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 

end
function modifier_item_skadi_lua5:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
function modifier_item_skadi_lua5:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_item_skadi_lua5:GetModifierBonusStats_Strength()
	return self.bonus_all_stats
end

function modifier_item_skadi_lua5:GetModifierBonusStats_Agility()
	return self.bonus_all_stats
end

function modifier_item_skadi_lua5:GetModifierBonusStats_Intellect()
	return self.bonus_all_stats
end

function modifier_item_skadi_lua5:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_skadi_lua5:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_skadi_lua5:OnAttackLanded(params)
		local attacker = self:GetParent()
		
		if attacker ~= params.attacker then
			return
		end

		if attacker:IsIllusion() then
			return
		end
		
		local target = params.target if target==nil then target = params.unit end
			if target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
				return 0
			end
			local modifier = target:FindModifierByNameAndCaster("modifier_item_skadi_slow_lua", self:GetAbility():GetCaster())
			if modifier==nil then
				if not self:GetParent():PassivesDisabled() then

					target:AddNewModifier(
						attacker,
						self:GetAbility(),
						"modifier_item_skadi_slow_lua",
						{ duration = 3 }
					)
			end
	end
end

--------------------------------------------------------------------
modifier_item_skadi_slow_lua = class({})

function modifier_item_skadi_slow_lua:IsHidden()
	return false
end

function modifier_item_skadi_slow_lua:IsPurgable()
	return false
end

function modifier_item_skadi_slow_lua:OnCreated( kv )

	self.cold_slow_melee = self:GetAbility():GetSpecialValueFor("cold_slow_melee")
	self.cold_slow_melee = self:GetAbility():GetSpecialValueFor("cold_slow_melee")
	self.heal_reduction = self:GetAbility():GetSpecialValueFor("heal_reduction")
	self.cold_duration = self:GetAbility():GetSpecialValueFor("cold_duration")

end

function modifier_item_skadi_slow_lua:GetAttributes() 
    return MODIFIER_ATTRIBUTE_NONE
end

function modifier_item_skadi_slow_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	}
end

function modifier_item_skadi_slow_lua:GetModifierAttackSpeedBonus_Constant()
	return self.cold_slow_melee
end

function modifier_item_skadi_slow_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.cold_slow_melee
end

function modifier_item_skadi_slow_lua:GetModifierHPRegenAmplify_Percentage()
	return ( self.heal_reduction * (-1) )
end

function modifier_item_skadi_slow_lua:GetModifierLifestealAmplify()
	return ( self.heal_reduction * (-1) )
end


---------------------------------------------------

