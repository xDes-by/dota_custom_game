item_hood_sword_lua1_gem1 = item_hood_sword_lua1_gem1 or class({})
item_hood_sword_lua2_gem1 = item_hood_sword_lua1_gem1 or class({})
item_hood_sword_lua3_gem1 = item_hood_sword_lua1_gem1 or class({})
item_hood_sword_lua4_gem1 = item_hood_sword_lua1_gem1 or class({})
item_hood_sword_lua5_gem1 = item_hood_sword_lua1_gem1 or class({})
item_hood_sword_lua6_gem1 = item_hood_sword_lua1_gem1 or class({})
item_hood_sword_lua7_gem1 = item_hood_sword_lua1_gem1 or class({})

item_hood_sword_lua1_gem2 = item_hood_sword_lua1_gem2 or class({})
item_hood_sword_lua2_gem2 = item_hood_sword_lua1_gem2 or class({})
item_hood_sword_lua3_gem2 = item_hood_sword_lua1_gem2 or class({})
item_hood_sword_lua4_gem2 = item_hood_sword_lua1_gem2 or class({})
item_hood_sword_lua5_gem2 = item_hood_sword_lua1_gem2 or class({})
item_hood_sword_lua6_gem2 = item_hood_sword_lua1_gem2 or class({})
item_hood_sword_lua7_gem2 = item_hood_sword_lua1_gem2 or class({})

item_hood_sword_lua1_gem3 = item_hood_sword_lua1_gem3 or class({})
item_hood_sword_lua2_gem3 = item_hood_sword_lua1_gem3 or class({})
item_hood_sword_lua3_gem3 = item_hood_sword_lua1_gem3 or class({})
item_hood_sword_lua4_gem3 = item_hood_sword_lua1_gem3 or class({})
item_hood_sword_lua5_gem3 = item_hood_sword_lua1_gem3 or class({})
item_hood_sword_lua6_gem3 = item_hood_sword_lua1_gem3 or class({})
item_hood_sword_lua7_gem3 = item_hood_sword_lua1_gem3 or class({})

item_hood_sword_lua1_gem4 = item_hood_sword_lua1_gem4 or class({})
item_hood_sword_lua2_gem4 = item_hood_sword_lua1_gem4 or class({})
item_hood_sword_lua3_gem4 = item_hood_sword_lua1_gem4 or class({})
item_hood_sword_lua4_gem4 = item_hood_sword_lua1_gem4 or class({})
item_hood_sword_lua5_gem4 = item_hood_sword_lua1_gem4 or class({})
item_hood_sword_lua6_gem4 = item_hood_sword_lua1_gem4 or class({})
item_hood_sword_lua7_gem4 = item_hood_sword_lua1_gem4 or class({})

item_hood_sword_lua1_gem5 = item_hood_sword_lua1_gem5 or class({})
item_hood_sword_lua2_gem5 = item_hood_sword_lua1_gem5 or class({})
item_hood_sword_lua3_gem5 = item_hood_sword_lua1_gem5 or class({})
item_hood_sword_lua4_gem5 = item_hood_sword_lua1_gem5 or class({})
item_hood_sword_lua5_gem5 = item_hood_sword_lua1_gem5 or class({})
item_hood_sword_lua6_gem5 = item_hood_sword_lua1_gem5 or class({})
item_hood_sword_lua7_gem5 = item_hood_sword_lua1_gem5 or class({})

LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_hood_sword_passive1", 'items/items_gems/item_hood_sword.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hood_sword_passive2", 'items/items_gems/item_hood_sword.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hood_sword_passive3", 'items/items_gems/item_hood_sword.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hood_sword_passive4", 'items/items_gems/item_hood_sword.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hood_sword_passive5", 'items/items_gems/item_hood_sword.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hood_sword_passive_debuff", 'items/items_gems/item_hood_sword.lua', LUA_MODIFIER_MOTION_NONE)

function item_hood_sword_lua1_gem1:GetIntrinsicModifierName()
	return "modifier_item_hood_sword_passive1"
end
function item_hood_sword_lua1_gem2:GetIntrinsicModifierName()
	return "modifier_item_hood_sword_passive2"
end
function item_hood_sword_lua1_gem3:GetIntrinsicModifierName()
	return "modifier_item_hood_sword_passive3"
end
function item_hood_sword_lua1_gem4:GetIntrinsicModifierName()
	return "modifier_item_hood_sword_passive4"
end
function item_hood_sword_lua1_gem5:GetIntrinsicModifierName()
	return "modifier_item_hood_sword_passive5"
end
-----------------------------------------------------------------------------------------------

modifier_item_hood_sword_passive1 = class({})

function modifier_item_hood_sword_passive1:IsHidden()
	return true
end

function modifier_item_hood_sword_passive1:IsPurgable()
	return false
end

function modifier_item_hood_sword_passive1:OnCreated( kv )
	
	
    self.bonus_magic_resist = self:GetAbility():GetSpecialValueFor("bonus_magic_resist")
    self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
    self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
    self.bonus_dmg = self:GetAbility():GetSpecialValueFor("bonus_dmg")
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    self.bonus_status = self:GetAbility():GetSpecialValueFor("bonus_status")
    self.bonus_amp_hp = self:GetAbility():GetSpecialValueFor("bonus_amp_hp")
   
	self.magic_debuff = self:GetAbility():GetSpecialValueFor("magic_debuff")
    self.phis_debuff = self:GetAbility():GetSpecialValueFor("phis_debuff")
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_hood_sword_passive1:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_hood_sword_passive1:DeclareFunctions()
	local funcs = {    
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,		
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,    
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE, 
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_item_hood_sword_passive1:GetModifierMagicalResistanceBonus( params )
	return self.bonus_magic_resist
end

function modifier_item_hood_sword_passive1:GetModifierBonusStats_Agility( params )
	return self.bonus_agi
end

function modifier_item_hood_sword_passive1:GetModifierBonusStats_Strength( params )
	return self.bonus_str
end

function modifier_item_hood_sword_passive1:GetModifierBaseAttack_BonusDamage( params )
	return self.bonus_dmg
end

function modifier_item_hood_sword_passive1:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end

function modifier_item_hood_sword_passive1:GetModifierStatusResistanceStacking()
	return self.bonus_status
end

function modifier_item_hood_sword_passive1:GetModifierHPRegenAmplify_Percentage()
	return self.bonus_amp_hp
end

function modifier_item_hood_sword_passive1:OnAttackLanded(params)
	if IsServer() then
		local target = params.target if target==nil then target = params.unit end
			if target:GetTeamNumber()==self:GetParent():GetTeamNumber() and self:GetCaster():HasModifier("modifier_item_hood_sword_passive1") then
				return 0
			end
			local modifier = target:FindModifierByNameAndCaster("modifier_item_hood_sword_passive_debuff", self:GetAbility():GetCaster())
			if modifier==nil then
				if not self:GetParent():PassivesDisabled() then

					target:AddNewModifier(
						self:GetAbility():GetCaster(),
						self:GetAbility(),
						"modifier_item_hood_sword_passive_debuff",
						{ duration = self.duration }
					)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------

modifier_item_hood_sword_passive2 = class({})

function modifier_item_hood_sword_passive2:IsHidden()
	return true
end

function modifier_item_hood_sword_passive2:IsPurgable()
	return false
end

function modifier_item_hood_sword_passive2:OnCreated( kv )
	
	
    self.bonus_magic_resist = self:GetAbility():GetSpecialValueFor("bonus_magic_resist")
    self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
    self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
    self.bonus_dmg = self:GetAbility():GetSpecialValueFor("bonus_dmg")
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    self.bonus_status = self:GetAbility():GetSpecialValueFor("bonus_status")
    self.bonus_amp_hp = self:GetAbility():GetSpecialValueFor("bonus_amp_hp")
   
	self.magic_debuff = self:GetAbility():GetSpecialValueFor("magic_debuff")
    self.phis_debuff = self:GetAbility():GetSpecialValueFor("phis_debuff")
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_hood_sword_passive2:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_hood_sword_passive2:DeclareFunctions()
	local funcs = {    
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,		
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,    
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE, 
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_item_hood_sword_passive2:GetModifierMagicalResistanceBonus( params )
	return self.bonus_magic_resist
end

function modifier_item_hood_sword_passive2:GetModifierBonusStats_Agility( params )
	return self.bonus_agi
end

function modifier_item_hood_sword_passive2:GetModifierBonusStats_Strength( params )
	return self.bonus_str
end

function modifier_item_hood_sword_passive2:GetModifierBaseAttack_BonusDamage( params )
	return self.bonus_dmg
end

function modifier_item_hood_sword_passive2:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end

function modifier_item_hood_sword_passive2:GetModifierStatusResistanceStacking()
	return self.bonus_status
end

function modifier_item_hood_sword_passive2:GetModifierHPRegenAmplify_Percentage()
	return self.bonus_amp_hp
end

function modifier_item_hood_sword_passive2:OnAttackLanded(params)
	if IsServer() then
		local target = params.target if target==nil then target = params.unit end
			if target:GetTeamNumber()==self:GetParent():GetTeamNumber() and self:GetCaster():HasModifier("modifier_item_hood_sword_passive2") then
				return 0
			end
			local modifier = target:FindModifierByNameAndCaster("modifier_item_hood_sword_passive_debuff", self:GetAbility():GetCaster())
			if modifier==nil then
				if not self:GetParent():PassivesDisabled() then

					target:AddNewModifier(
						self:GetAbility():GetCaster(),
						self:GetAbility(),
						"modifier_item_hood_sword_passive_debuff",
						{ duration = self.duration }
					)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------

modifier_item_hood_sword_passive3 = class({})

function modifier_item_hood_sword_passive3:IsHidden()
	return true
end

function modifier_item_hood_sword_passive3:IsPurgable()
	return false
end

function modifier_item_hood_sword_passive3:OnCreated( kv )
	
	
    self.bonus_magic_resist = self:GetAbility():GetSpecialValueFor("bonus_magic_resist")
    self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
    self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
    self.bonus_dmg = self:GetAbility():GetSpecialValueFor("bonus_dmg")
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    self.bonus_status = self:GetAbility():GetSpecialValueFor("bonus_status")
    self.bonus_amp_hp = self:GetAbility():GetSpecialValueFor("bonus_amp_hp")
   
	self.magic_debuff = self:GetAbility():GetSpecialValueFor("magic_debuff")
    self.phis_debuff = self:GetAbility():GetSpecialValueFor("phis_debuff")
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_hood_sword_passive3:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_hood_sword_passive3:DeclareFunctions()
	local funcs = {    
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,		
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,    
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE, 
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_item_hood_sword_passive3:GetModifierMagicalResistanceBonus( params )
	return self.bonus_magic_resist
end

function modifier_item_hood_sword_passive3:GetModifierBonusStats_Agility( params )
	return self.bonus_agi
end

function modifier_item_hood_sword_passive3:GetModifierBonusStats_Strength( params )
	return self.bonus_str
end

function modifier_item_hood_sword_passive3:GetModifierBaseAttack_BonusDamage( params )
	return self.bonus_dmg
end

function modifier_item_hood_sword_passive3:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end

function modifier_item_hood_sword_passive3:GetModifierStatusResistanceStacking()
	return self.bonus_status
end

function modifier_item_hood_sword_passive3:GetModifierHPRegenAmplify_Percentage()
	return self.bonus_amp_hp
end

function modifier_item_hood_sword_passive3:OnAttackLanded(params)
	if IsServer() then
		local target = params.target if target==nil then target = params.unit end
			if target:GetTeamNumber()==self:GetParent():GetTeamNumber() and self:GetCaster():HasModifier("modifier_item_hood_sword_passive3") then
				return 0
			end
			local modifier = target:FindModifierByNameAndCaster("modifier_item_hood_sword_passive_debuff", self:GetAbility():GetCaster())
			if modifier==nil then
				if not self:GetParent():PassivesDisabled() then

					target:AddNewModifier(
						self:GetAbility():GetCaster(),
						self:GetAbility(),
						"modifier_item_hood_sword_passive_debuff",
						{ duration = self.duration }
					)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------

modifier_item_hood_sword_passive4 = class({})

function modifier_item_hood_sword_passive4:IsHidden()
	return true
end

function modifier_item_hood_sword_passive4:IsPurgable()
	return false
end

function modifier_item_hood_sword_passive4:OnCreated( kv )
	
	
    self.bonus_magic_resist = self:GetAbility():GetSpecialValueFor("bonus_magic_resist")
    self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
    self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
    self.bonus_dmg = self:GetAbility():GetSpecialValueFor("bonus_dmg")
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    self.bonus_status = self:GetAbility():GetSpecialValueFor("bonus_status")
    self.bonus_amp_hp = self:GetAbility():GetSpecialValueFor("bonus_amp_hp")
   
	self.magic_debuff = self:GetAbility():GetSpecialValueFor("magic_debuff")
    self.phis_debuff = self:GetAbility():GetSpecialValueFor("phis_debuff")
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_hood_sword_passive4:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_hood_sword_passive4:DeclareFunctions()
	local funcs = {    
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,		
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,    
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE, 
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_item_hood_sword_passive4:GetModifierMagicalResistanceBonus( params )
	return self.bonus_magic_resist
end

function modifier_item_hood_sword_passive4:GetModifierBonusStats_Agility( params )
	return self.bonus_agi
end

function modifier_item_hood_sword_passive4:GetModifierBonusStats_Strength( params )
	return self.bonus_str
end

function modifier_item_hood_sword_passive4:GetModifierBaseAttack_BonusDamage( params )
	return self.bonus_dmg
end

function modifier_item_hood_sword_passive4:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end

function modifier_item_hood_sword_passive4:GetModifierStatusResistanceStacking()
	return self.bonus_status
end

function modifier_item_hood_sword_passive4:GetModifierHPRegenAmplify_Percentage()
	return self.bonus_amp_hp
end

function modifier_item_hood_sword_passive4:OnAttackLanded(params)
	if IsServer() then
		local target = params.target if target==nil then target = params.unit end
			if target:GetTeamNumber()==self:GetParent():GetTeamNumber() and self:GetCaster():HasModifier("modifier_item_hood_sword_passive4") then
				return 0
			end
			local modifier = target:FindModifierByNameAndCaster("modifier_item_hood_sword_passive_debuff", self:GetAbility():GetCaster())
			if modifier==nil then
				if not self:GetParent():PassivesDisabled() then

					target:AddNewModifier(
						self:GetAbility():GetCaster(),
						self:GetAbility(),
						"modifier_item_hood_sword_passive_debuff",
						{ duration = self.duration }
					)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------

modifier_item_hood_sword_passive5 = class({})

function modifier_item_hood_sword_passive5:IsHidden()
	return true
end

function modifier_item_hood_sword_passive5:IsPurgable()
	return false
end

function modifier_item_hood_sword_passive5:OnCreated( kv )
	
	
    self.bonus_magic_resist = self:GetAbility():GetSpecialValueFor("bonus_magic_resist")
    self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
    self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
    self.bonus_dmg = self:GetAbility():GetSpecialValueFor("bonus_dmg")
    self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    self.bonus_status = self:GetAbility():GetSpecialValueFor("bonus_status")
    self.bonus_amp_hp = self:GetAbility():GetSpecialValueFor("bonus_amp_hp")
   
	self.magic_debuff = self:GetAbility():GetSpecialValueFor("magic_debuff")
    self.phis_debuff = self:GetAbility():GetSpecialValueFor("phis_debuff")
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_hood_sword_passive5:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_hood_sword_passive5:DeclareFunctions()
	local funcs = {    
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,		
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,    
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE, 
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_item_hood_sword_passive5:GetModifierMagicalResistanceBonus( params )
	return self.bonus_magic_resist
end

function modifier_item_hood_sword_passive5:GetModifierBonusStats_Agility( params )
	return self.bonus_agi
end

function modifier_item_hood_sword_passive5:GetModifierBonusStats_Strength( params )
	return self.bonus_str
end

function modifier_item_hood_sword_passive5:GetModifierBaseAttack_BonusDamage( params )
	return self.bonus_dmg
end

function modifier_item_hood_sword_passive5:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end

function modifier_item_hood_sword_passive5:GetModifierStatusResistanceStacking()
	return self.bonus_status
end

function modifier_item_hood_sword_passive5:GetModifierHPRegenAmplify_Percentage()
	return self.bonus_amp_hp
end

function modifier_item_hood_sword_passive5:OnAttackLanded(params)
	if IsServer() then
		local target = params.target if target==nil then target = params.unit end
			if target:GetTeamNumber()==self:GetParent():GetTeamNumber() and self:GetCaster():HasModifier("modifier_item_hood_sword_passive5") then
				return 0
			end
			local modifier = target:FindModifierByNameAndCaster("modifier_item_hood_sword_passive_debuff", self:GetAbility():GetCaster())
			if modifier==nil then
				if not self:GetParent():PassivesDisabled() then

					target:AddNewModifier(
						self:GetAbility():GetCaster(),
						self:GetAbility(),
						"modifier_item_hood_sword_passive_debuff",
						{ duration = self.duration }
					)
			end
		end
	end
end
-----------------------------------------------------

modifier_item_hood_sword_passive_debuff = class({})

function modifier_item_hood_sword_passive_debuff:IsHidden()
	return false
end

function modifier_item_hood_sword_passive_debuff:IsPurgable()
	return false
end

function modifier_item_hood_sword_passive_debuff:OnCreated( kv )  
	self.magic_debuff = self:GetAbility():GetSpecialValueFor("magic_debuff")
    self.phis_debuff = self:GetAbility():GetSpecialValueFor("phis_debuff")
end

function modifier_item_hood_sword_passive_debuff:GetAttributes() 
    return MODIFIER_ATTRIBUTE_NONE
end

function modifier_item_hood_sword_passive_debuff:DeclareFunctions()
	local funcs = {    
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_ATTRIBUTE_NONE
	}
	return funcs
end

function modifier_item_hood_sword_passive_debuff:GetModifierDamageOutgoing_Percentage( params )
	return self.phis_debuff
end

function modifier_item_hood_sword_passive_debuff:GetModifierMagicDamageOutgoing_Percentage( params )
	return self.magic_debuff
end