item_hood_sword_lua = class({})

item_hood_sword_lua1 = item_hood_sword_lua
item_hood_sword_lua2 = item_hood_sword_lua
item_hood_sword_lua3 = item_hood_sword_lua
item_hood_sword_lua4 = item_hood_sword_lua
item_hood_sword_lua5 = item_hood_sword_lua
item_hood_sword_lua6 = item_hood_sword_lua
item_hood_sword_lua7 = item_hood_sword_lua
item_hood_sword_lua8 = item_hood_sword_lua

item_hood_sword_lua1_gem1 = item_hood_sword_lua
item_hood_sword_lua2_gem1 = item_hood_sword_lua
item_hood_sword_lua3_gem1 = item_hood_sword_lua
item_hood_sword_lua4_gem1 = item_hood_sword_lua
item_hood_sword_lua5_gem1 = item_hood_sword_lua
item_hood_sword_lua6_gem1 = item_hood_sword_lua
item_hood_sword_lua7_gem1 = item_hood_sword_lua
item_hood_sword_lua8_gem1 = item_hood_sword_lua

item_hood_sword_lua1_gem2 = item_hood_sword_lua
item_hood_sword_lua2_gem2 = item_hood_sword_lua
item_hood_sword_lua3_gem2 = item_hood_sword_lua
item_hood_sword_lua4_gem2 = item_hood_sword_lua
item_hood_sword_lua5_gem2 = item_hood_sword_lua
item_hood_sword_lua6_gem2 = item_hood_sword_lua
item_hood_sword_lua7_gem2 = item_hood_sword_lua
item_hood_sword_lua8_gem2 = item_hood_sword_lua

item_hood_sword_lua1_gem3 = item_hood_sword_lua
item_hood_sword_lua2_gem3 = item_hood_sword_lua
item_hood_sword_lua3_gem3 = item_hood_sword_lua
item_hood_sword_lua4_gem3 = item_hood_sword_lua
item_hood_sword_lua5_gem3 = item_hood_sword_lua
item_hood_sword_lua6_gem3 = item_hood_sword_lua
item_hood_sword_lua7_gem3 = item_hood_sword_lua
item_hood_sword_lua8_gem3 = item_hood_sword_lua

item_hood_sword_lua1_gem4 = item_hood_sword_lua
item_hood_sword_lua2_gem4 = item_hood_sword_lua
item_hood_sword_lua3_gem4 = item_hood_sword_lua
item_hood_sword_lua4_gem4 = item_hood_sword_lua
item_hood_sword_lua5_gem4 = item_hood_sword_lua
item_hood_sword_lua6_gem4 = item_hood_sword_lua
item_hood_sword_lua7_gem4 = item_hood_sword_lua
item_hood_sword_lua8_gem4 = item_hood_sword_lua

item_hood_sword_lua1_gem5 = item_hood_sword_lua
item_hood_sword_lua2_gem5 = item_hood_sword_lua
item_hood_sword_lua3_gem5 = item_hood_sword_lua
item_hood_sword_lua4_gem5 = item_hood_sword_lua
item_hood_sword_lua5_gem5 = item_hood_sword_lua
item_hood_sword_lua6_gem5 = item_hood_sword_lua
item_hood_sword_lua7_gem5 = item_hood_sword_lua
item_hood_sword_lua8_gem5 = item_hood_sword_lua

LinkLuaModifier("modifier_item_hood_sword_passive", 'items/custom_items/item_hood_sword.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hood_sword_passive_debuff", 'items/custom_items/item_hood_sword.lua', LUA_MODIFIER_MOTION_NONE)

function item_hood_sword_lua:GetIntrinsicModifierName()
	return "modifier_item_hood_sword_passive"
end

-----------------------------------------------------------------------------------------------

modifier_item_hood_sword_passive = class({})

function modifier_item_hood_sword_passive:IsHidden()
	return true
end

function modifier_item_hood_sword_passive:RemoveOnDeath()
	return false
end

function modifier_item_hood_sword_passive:IsPurgable()
	return false
end

function modifier_item_hood_sword_passive:OnCreated( kv )
	self.parent = self:GetParent()
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
	if not IsServer() then
		return
	end
	self.value = self:GetAbility():GetSpecialValueFor("bonus_gem")
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {ability = self:GetAbility():entindex(), value = self.value})
	end
end

function modifier_item_hood_sword_passive:OnDestroy()
	if not IsServer() then
		return
	end
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {ability = self:GetAbility():entindex(), value = self.value * -1})
	end
end

function modifier_item_hood_sword_passive:DeclareFunctions()
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

function modifier_item_hood_sword_passive:GetModifierMagicalResistanceBonus( params )
	return self.bonus_magic_resist
end

function modifier_item_hood_sword_passive:GetModifierBonusStats_Agility( params )
	return self.bonus_agi
end

function modifier_item_hood_sword_passive:GetModifierBonusStats_Strength( params )
	return self.bonus_str
end

function modifier_item_hood_sword_passive:GetModifierBaseAttack_BonusDamage( params )
	return self.bonus_dmg
end

function modifier_item_hood_sword_passive:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end

function modifier_item_hood_sword_passive:GetModifierStatusResistanceStacking()
	return self.bonus_status
end

function modifier_item_hood_sword_passive:GetModifierHPRegenAmplify_Percentage()
	return self.bonus_amp_hp
end

function modifier_item_hood_sword_passive:OnAttackLanded(params)
if IsServer() then
	if self:GetParent():PassivesDisabled() then return end
	if self:GetParent() ~= params.attacker then return end
		if not params.target:HasModifier("modifier_item_hood_sword_passive_debuff") then
			params.target:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_item_hood_sword_passive_debuff", {duration = self.duration})
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