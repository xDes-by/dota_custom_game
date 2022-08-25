item_kaya_lua1_gem1 = item_kaya_lua1_gem1 or class({})
item_kaya_lua2_gem1 = item_kaya_lua1_gem1 or class({})
item_kaya_lua3_gem1 = item_kaya_lua1_gem1 or class({})
item_kaya_lua4_gem1 = item_kaya_lua1_gem1 or class({})
item_kaya_lua5_gem1 = item_kaya_lua1_gem1 or class({})
item_kaya_lua6_gem1 = item_kaya_lua1_gem1 or class({})
item_kaya_lua7_gem1 = item_kaya_lua1_gem1 or class({})
item_kaya_lua8_gem1 = item_kaya_lua1_gem1 or class({})

item_kaya_lua1_gem2 = item_kaya_lua1_gem2 or class({})
item_kaya_lua2_gem2 = item_kaya_lua1_gem2 or class({})
item_kaya_lua3_gem2 = item_kaya_lua1_gem2 or class({})
item_kaya_lua4_gem2 = item_kaya_lua1_gem2 or class({})
item_kaya_lua5_gem2 = item_kaya_lua1_gem2 or class({})
item_kaya_lua6_gem2 = item_kaya_lua1_gem2 or class({})
item_kaya_lua7_gem2 = item_kaya_lua1_gem2 or class({})
item_kaya_lua8_gem2 = item_kaya_lua1_gem2 or class({})

item_kaya_lua1_gem3 = item_kaya_lua1_gem3 or class({})
item_kaya_lua2_gem3 = item_kaya_lua1_gem3 or class({})
item_kaya_lua3_gem3 = item_kaya_lua1_gem3 or class({})
item_kaya_lua4_gem3 = item_kaya_lua1_gem3 or class({})
item_kaya_lua5_gem3 = item_kaya_lua1_gem3 or class({})
item_kaya_lua6_gem3 = item_kaya_lua1_gem3 or class({})
item_kaya_lua7_gem3 = item_kaya_lua1_gem3 or class({})
item_kaya_lua8_gem3 = item_kaya_lua1_gem3 or class({})

item_kaya_lua1_gem4 = item_kaya_lua1_gem4 or class({})
item_kaya_lua2_gem4 = item_kaya_lua1_gem4 or class({})
item_kaya_lua3_gem4 = item_kaya_lua1_gem4 or class({})
item_kaya_lua4_gem4 = item_kaya_lua1_gem4 or class({})
item_kaya_lua5_gem4 = item_kaya_lua1_gem4 or class({})
item_kaya_lua6_gem4 = item_kaya_lua1_gem4 or class({})
item_kaya_lua7_gem4 = item_kaya_lua1_gem4 or class({})
item_kaya_lua8_gem4 = item_kaya_lua1_gem4 or class({})

item_kaya_lua1_gem5 = item_kaya_lua1_gem5 or class({})
item_kaya_lua2_gem5 = item_kaya_lua1_gem5 or class({})
item_kaya_lua3_gem5 = item_kaya_lua1_gem5 or class({})
item_kaya_lua4_gem5 = item_kaya_lua1_gem5 or class({})
item_kaya_lua5_gem5 = item_kaya_lua1_gem5 or class({})
item_kaya_lua6_gem5 = item_kaya_lua1_gem5 or class({})
item_kaya_lua7_gem5 = item_kaya_lua1_gem5 or class({})
item_kaya_lua8_gem5 = item_kaya_lua1_gem5 or class({})

LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier( "modifier_item_kaya_lua1", "items/items_gems/item_kaya_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_kaya_lua2", "items/items_gems/item_kaya_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_kaya_lua3", "items/items_gems/item_kaya_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_kaya_lua4", "items/items_gems/item_kaya_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_kaya_lua5", "items/items_gems/item_kaya_lua", LUA_MODIFIER_MOTION_NONE )

function item_kaya_lua1_gem1:GetIntrinsicModifierName()
	return "modifier_item_kaya_lua1"
end
function item_kaya_lua1_gem2:GetIntrinsicModifierName()
	return "modifier_item_kaya_lua2"
end
function item_kaya_lua1_gem3:GetIntrinsicModifierName()
	return "modifier_item_kaya_lua3"
end
function item_kaya_lua1_gem4:GetIntrinsicModifierName()
	return "modifier_item_kaya_lua4"
end
function item_kaya_lua1_gem5:GetIntrinsicModifierName()
	return "modifier_item_kaya_lua5"
end
-----------------------------------------------------------------------------

modifier_item_kaya_lua1 = class({})

function modifier_item_kaya_lua1:IsHidden()
	return true
end

function modifier_item_kaya_lua1:IsPurgable()
	return false
end

function modifier_item_kaya_lua1:OnCreated( kv )
		
		
		self.caster = self:GetCaster()
		self.bonus_dmg = self:GetAbility():GetSpecialValueFor( "spell_amp" )
		self.spell_lifesteal_amp = self:GetAbility():GetSpecialValueFor( "spell_lifesteal_amp" )
		self.bonus_int = self:GetAbility():GetSpecialValueFor( "bonus_intellect" )
		self.mana_regen_multiplier = self:GetAbility():GetSpecialValueFor( "mana_regen_multiplier" )
		
		self.particle_name = "particles/items3_fx/octarine_core_lifesteal.vpcf"
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_kaya_lua1:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
--------------------------------------------------------------------------------

function modifier_item_kaya_lua1:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_kaya_lua1:GetModifierSpellAmplify_Percentage( params )
	return self.bonus_dmg
end

function modifier_item_kaya_lua1:GetModifierBonusStats_Intellect( params )
	return self.bonus_int
end

function modifier_item_kaya_lua1:GetModifierSpellLifestealRegenAmplify_Percentage( params )
	return self.spell_lifesteal_amp
end

function modifier_item_kaya_lua1:GetModifierMPRegenAmplify_Percentage( params )
	return self.mana_regen_multiplier
end

-----------------------------------------------------------------------------

modifier_item_kaya_lua2 = class({})

function modifier_item_kaya_lua2:IsHidden()
	return true
end

function modifier_item_kaya_lua2:IsPurgable()
	return false
end

function modifier_item_kaya_lua2:OnCreated( kv )
		
		
		self.caster = self:GetCaster()
		self.bonus_dmg = self:GetAbility():GetSpecialValueFor( "spell_amp" )
		self.spell_lifesteal_amp = self:GetAbility():GetSpecialValueFor( "spell_lifesteal_amp" )
		self.bonus_int = self:GetAbility():GetSpecialValueFor( "bonus_intellect" )
		self.mana_regen_multiplier = self:GetAbility():GetSpecialValueFor( "mana_regen_multiplier" )
		
		self.particle_name = "particles/items3_fx/octarine_core_lifesteal.vpcf"
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_kaya_lua2:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
--------------------------------------------------------------------------------

function modifier_item_kaya_lua2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_kaya_lua2:GetModifierSpellAmplify_Percentage( params )
	return self.bonus_dmg
end

function modifier_item_kaya_lua2:GetModifierBonusStats_Intellect( params )
	return self.bonus_int
end

function modifier_item_kaya_lua2:GetModifierSpellLifestealRegenAmplify_Percentage( params )
	return self.spell_lifesteal_amp
end

function modifier_item_kaya_lua2:GetModifierMPRegenAmplify_Percentage( params )
	return self.mana_regen_multiplier
end

-----------------------------------------------------------------------------

modifier_item_kaya_lua3 = class({})

function modifier_item_kaya_lua3:IsHidden()
	return true
end

function modifier_item_kaya_lua3:IsPurgable()
	return false
end

function modifier_item_kaya_lua3:OnCreated( kv )
		
		
		self.caster = self:GetCaster()
		self.bonus_dmg = self:GetAbility():GetSpecialValueFor( "spell_amp" )
		self.spell_lifesteal_amp = self:GetAbility():GetSpecialValueFor( "spell_lifesteal_amp" )
		self.bonus_int = self:GetAbility():GetSpecialValueFor( "bonus_intellect" )
		self.mana_regen_multiplier = self:GetAbility():GetSpecialValueFor( "mana_regen_multiplier" )
		
		self.particle_name = "particles/items3_fx/octarine_core_lifesteal.vpcf"
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_kaya_lua3:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
--------------------------------------------------------------------------------

function modifier_item_kaya_lua3:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_kaya_lua3:GetModifierSpellAmplify_Percentage( params )
	return self.bonus_dmg
end

function modifier_item_kaya_lua3:GetModifierBonusStats_Intellect( params )
	return self.bonus_int
end

function modifier_item_kaya_lua3:GetModifierSpellLifestealRegenAmplify_Percentage( params )
	return self.spell_lifesteal_amp
end

function modifier_item_kaya_lua3:GetModifierMPRegenAmplify_Percentage( params )
	return self.mana_regen_multiplier
end

-----------------------------------------------------------------------------

modifier_item_kaya_lua4 = class({})

function modifier_item_kaya_lua4:IsHidden()
	return true
end

function modifier_item_kaya_lua4:IsPurgable()
	return false
end

function modifier_item_kaya_lua4:OnCreated( kv )
		
		
		self.caster = self:GetCaster()
		self.bonus_dmg = self:GetAbility():GetSpecialValueFor( "spell_amp" )
		self.spell_lifesteal_amp = self:GetAbility():GetSpecialValueFor( "spell_lifesteal_amp" )
		self.bonus_int = self:GetAbility():GetSpecialValueFor( "bonus_intellect" )
		self.mana_regen_multiplier = self:GetAbility():GetSpecialValueFor( "mana_regen_multiplier" )
		
		self.particle_name = "particles/items3_fx/octarine_core_lifesteal.vpcf"
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_kaya_lua4:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
--------------------------------------------------------------------------------

function modifier_item_kaya_lua4:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_kaya_lua4:GetModifierSpellAmplify_Percentage( params )
	return self.bonus_dmg
end

function modifier_item_kaya_lua4:GetModifierBonusStats_Intellect( params )
	return self.bonus_int
end

function modifier_item_kaya_lua4:GetModifierSpellLifestealRegenAmplify_Percentage( params )
	return self.spell_lifesteal_amp
end

function modifier_item_kaya_lua4:GetModifierMPRegenAmplify_Percentage( params )
	return self.mana_regen_multiplier
end

-----------------------------------------------------------------------------

modifier_item_kaya_lua5 = class({})

function modifier_item_kaya_lua5:IsHidden()
	return true
end

function modifier_item_kaya_lua5:IsPurgable()
	return false
end

function modifier_item_kaya_lua5:OnCreated( kv )
		
		
		self.caster = self:GetCaster()
		self.bonus_dmg = self:GetAbility():GetSpecialValueFor( "spell_amp" )
		self.spell_lifesteal_amp = self:GetAbility():GetSpecialValueFor( "spell_lifesteal_amp" )
		self.bonus_int = self:GetAbility():GetSpecialValueFor( "bonus_intellect" )
		self.mana_regen_multiplier = self:GetAbility():GetSpecialValueFor( "mana_regen_multiplier" )
		
		self.particle_name = "particles/items3_fx/octarine_core_lifesteal.vpcf"
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_kaya_lua5:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
--------------------------------------------------------------------------------

function modifier_item_kaya_lua5:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_kaya_lua5:GetModifierSpellAmplify_Percentage( params )
	return self.bonus_dmg
end

function modifier_item_kaya_lua5:GetModifierBonusStats_Intellect( params )
	return self.bonus_int
end

function modifier_item_kaya_lua5:GetModifierSpellLifestealRegenAmplify_Percentage( params )
	return self.spell_lifesteal_amp
end

function modifier_item_kaya_lua5:GetModifierMPRegenAmplify_Percentage( params )
	return self.mana_regen_multiplier
end
