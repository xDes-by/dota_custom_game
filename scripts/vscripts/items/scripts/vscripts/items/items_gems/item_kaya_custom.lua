item_kaya_custom_lua1_gem1 = item_kaya_custom_lua1_gem1 or class({})
item_kaya_custom_lua2_gem1 = item_kaya_custom_lua1_gem1 or class({})
item_kaya_custom_lua3_gem1 = item_kaya_custom_lua1_gem1 or class({})
item_kaya_custom_lua4_gem1 = item_kaya_custom_lua1_gem1 or class({})
item_kaya_custom_lua5_gem1 = item_kaya_custom_lua1_gem1 or class({})
item_kaya_custom_lua6_gem1 = item_kaya_custom_lua1_gem1 or class({})
item_kaya_custom_lua7_gem1 = item_kaya_custom_lua1_gem1 or class({})

item_kaya_custom_lua1_gem2 = item_kaya_custom_lua1_gem2 or class({})
item_kaya_custom_lua2_gem2 = item_kaya_custom_lua1_gem2 or class({})
item_kaya_custom_lua3_gem2 = item_kaya_custom_lua1_gem2 or class({})
item_kaya_custom_lua4_gem2 = item_kaya_custom_lua1_gem2 or class({})
item_kaya_custom_lua5_gem2 = item_kaya_custom_lua1_gem2 or class({})
item_kaya_custom_lua6_gem2 = item_kaya_custom_lua1_gem2 or class({})
item_kaya_custom_lua7_gem2 = item_kaya_custom_lua1_gem2 or class({})

item_kaya_custom_lua1_gem3 = item_kaya_custom_lua1_gem3 or class({})
item_kaya_custom_lua2_gem3 = item_kaya_custom_lua1_gem3 or class({})
item_kaya_custom_lua3_gem3 = item_kaya_custom_lua1_gem3 or class({})
item_kaya_custom_lua4_gem3 = item_kaya_custom_lua1_gem3 or class({})
item_kaya_custom_lua5_gem3 = item_kaya_custom_lua1_gem3 or class({})
item_kaya_custom_lua6_gem3 = item_kaya_custom_lua1_gem3 or class({})
item_kaya_custom_lua7_gem3 = item_kaya_custom_lua1_gem3 or class({})

item_kaya_custom_lua1_gem4 = item_kaya_custom_lua1_gem4 or class({})
item_kaya_custom_lua2_gem4 = item_kaya_custom_lua1_gem4 or class({})
item_kaya_custom_lua3_gem4 = item_kaya_custom_lua1_gem4 or class({})
item_kaya_custom_lua4_gem4 = item_kaya_custom_lua1_gem4 or class({})
item_kaya_custom_lua5_gem4 = item_kaya_custom_lua1_gem4 or class({})
item_kaya_custom_lua6_gem4 = item_kaya_custom_lua1_gem4 or class({})
item_kaya_custom_lua7_gem4 = item_kaya_custom_lua1_gem4 or class({})

item_kaya_custom_lua1_gem5 = item_kaya_custom_lua1_gem5 or class({})
item_kaya_custom_lua2_gem5 = item_kaya_custom_lua1_gem5 or class({})
item_kaya_custom_lua3_gem5 = item_kaya_custom_lua1_gem5 or class({})
item_kaya_custom_lua4_gem5 = item_kaya_custom_lua1_gem5 or class({})
item_kaya_custom_lua5_gem5 = item_kaya_custom_lua1_gem5 or class({})
item_kaya_custom_lua6_gem5 = item_kaya_custom_lua1_gem5 or class({})
item_kaya_custom_lua7_gem5 = item_kaya_custom_lua1_gem5 or class({})

LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier( "modifier_item_kaya_custom1", "items/items_gems/item_kaya_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_kaya_custom2", "items/items_gems/item_kaya_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_kaya_custom3", "items/items_gems/item_kaya_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_kaya_custom4", "items/items_gems/item_kaya_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_kaya_custom5", "items/items_gems/item_kaya_custom", LUA_MODIFIER_MOTION_NONE )

function item_kaya_custom_lua1_gem1:GetIntrinsicModifierName()
	return "modifier_item_kaya_custom1"
end
function item_kaya_custom_lua1_gem2:GetIntrinsicModifierName()
	return "modifier_item_kaya_custom2"
end
function item_kaya_custom_lua1_gem3:GetIntrinsicModifierName()
	return "modifier_item_kaya_custom3"
end
function item_kaya_custom_lua1_gem4:GetIntrinsicModifierName()
	return "modifier_item_kaya_custom4"
end
function item_kaya_custom_lua1_gem5:GetIntrinsicModifierName()
	return "modifier_item_kaya_custom5"
end

modifier_item_kaya_custom1 = class({})

function modifier_item_kaya_custom1:IsHidden()
	return true
end

function modifier_item_kaya_custom1:IsPurgable()
	return false
end

function modifier_item_kaya_custom1:OnCreated( kv )
		
		
		self.caster = self:GetCaster()
		self.bonus_dmg = self:GetAbility():GetSpecialValueFor( "bonus_dmg" )
		self.bonus_life = self:GetAbility():GetSpecialValueFor( "bonus_life" )
		self.bonus_int = self:GetAbility():GetSpecialValueFor( "bonus_int" )
		self.bonus_manaregen = self:GetAbility():GetSpecialValueFor( "mana_regen" )
		
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
function modifier_item_kaya_custom1:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
--------------------------------------------------------------------------------

function modifier_item_kaya_custom1:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_kaya_custom1:GetModifierSpellAmplify_Percentage( params )
local intellect = self.caster:GetIntellect()
local truedmg = intellect * self.bonus_dmg
	return truedmg
end

function modifier_item_kaya_custom1:GetModifierBonusStats_Intellect( params )
	return self.bonus_int
end

function modifier_item_kaya_custom1:GetModifierConstantManaRegen( params )
	return self.bonus_manaregen
end

function modifier_item_kaya_custom1:OnTakeDamage(keys)
	if keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() then		
		if self:GetParent():FindAllModifiersByName(self:GetName())[1] == self and keys.damage_category == 0 and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
			
			if keys.attacker:GetHealth() <= (keys.original_damage * (self.bonus_life / 100)) and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
			keys.attacker:ForceKill(true)
			else
			keys.attacker:Heal(keys.original_damage * (self.bonus_life / 100), self)
			end
		end
	end
end

modifier_item_kaya_custom2 = class({})

function modifier_item_kaya_custom2:IsHidden()
	return true
end

function modifier_item_kaya_custom2:IsPurgable()
	return false
end

function modifier_item_kaya_custom2:OnCreated( kv )
		
		
		self.caster = self:GetCaster()
		self.bonus_dmg = self:GetAbility():GetSpecialValueFor( "bonus_dmg" )
		self.bonus_life = self:GetAbility():GetSpecialValueFor( "bonus_life" )
		self.bonus_int = self:GetAbility():GetSpecialValueFor( "bonus_int" )
		self.bonus_manaregen = self:GetAbility():GetSpecialValueFor( "mana_regen" )
		
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
function modifier_item_kaya_custom2:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
--------------------------------------------------------------------------------

function modifier_item_kaya_custom2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_kaya_custom2:GetModifierSpellAmplify_Percentage( params )
local intellect = self.caster:GetIntellect()
local truedmg = intellect * self.bonus_dmg
	return truedmg
end

function modifier_item_kaya_custom2:GetModifierBonusStats_Intellect( params )
	return self.bonus_int
end

function modifier_item_kaya_custom2:GetModifierConstantManaRegen( params )
	return self.bonus_manaregen
end

function modifier_item_kaya_custom2:OnTakeDamage(keys)
	if keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() then		
		if self:GetParent():FindAllModifiersByName(self:GetName())[1] == self and keys.damage_category == 0 and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
			
			if keys.attacker:GetHealth() <= (keys.original_damage * (self.bonus_life / 100)) and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
			keys.attacker:ForceKill(true)
			else
			keys.attacker:Heal(keys.original_damage * (self.bonus_life / 100), self)
			end
		end
	end
end

modifier_item_kaya_custom3 = class({})

function modifier_item_kaya_custom3:IsHidden()
	return true
end

function modifier_item_kaya_custom3:IsPurgable()
	return false
end

function modifier_item_kaya_custom3:OnCreated( kv )
		
		
		self.caster = self:GetCaster()
		self.bonus_dmg = self:GetAbility():GetSpecialValueFor( "bonus_dmg" )
		self.bonus_life = self:GetAbility():GetSpecialValueFor( "bonus_life" )
		self.bonus_int = self:GetAbility():GetSpecialValueFor( "bonus_int" )
		self.bonus_manaregen = self:GetAbility():GetSpecialValueFor( "mana_regen" )
		
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
function modifier_item_kaya_custom3:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
--------------------------------------------------------------------------------

function modifier_item_kaya_custom3:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_kaya_custom3:GetModifierSpellAmplify_Percentage( params )
local intellect = self.caster:GetIntellect()
local truedmg = intellect * self.bonus_dmg
	return truedmg
end

function modifier_item_kaya_custom3:GetModifierBonusStats_Intellect( params )
	return self.bonus_int
end

function modifier_item_kaya_custom3:GetModifierConstantManaRegen( params )
	return self.bonus_manaregen
end

function modifier_item_kaya_custom3:OnTakeDamage(keys)
	if keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() then		
		if self:GetParent():FindAllModifiersByName(self:GetName())[1] == self and keys.damage_category == 0 and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
			
			if keys.attacker:GetHealth() <= (keys.original_damage * (self.bonus_life / 100)) and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
			keys.attacker:ForceKill(true)
			else
			keys.attacker:Heal(keys.original_damage * (self.bonus_life / 100), self)
			end
		end
	end
end

modifier_item_kaya_custom4 = class({})

function modifier_item_kaya_custom4:IsHidden()
	return true
end

function modifier_item_kaya_custom4:IsPurgable()
	return false
end

function modifier_item_kaya_custom4:OnCreated( kv )
		
		
		self.caster = self:GetCaster()
		self.bonus_dmg = self:GetAbility():GetSpecialValueFor( "bonus_dmg" )
		self.bonus_life = self:GetAbility():GetSpecialValueFor( "bonus_life" )
		self.bonus_int = self:GetAbility():GetSpecialValueFor( "bonus_int" )
		self.bonus_manaregen = self:GetAbility():GetSpecialValueFor( "mana_regen" )
		
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
function modifier_item_kaya_custom4:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
--------------------------------------------------------------------------------

function modifier_item_kaya_custom4:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_kaya_custom4:GetModifierSpellAmplify_Percentage( params )
local intellect = self.caster:GetIntellect()
local truedmg = intellect * self.bonus_dmg
	return truedmg
end

function modifier_item_kaya_custom4:GetModifierBonusStats_Intellect( params )
	return self.bonus_int
end

function modifier_item_kaya_custom4:GetModifierConstantManaRegen( params )
	return self.bonus_manaregen
end

function modifier_item_kaya_custom4:OnTakeDamage(keys)
	if keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() then		
		if self:GetParent():FindAllModifiersByName(self:GetName())[1] == self and keys.damage_category == 0 and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
			
			if keys.attacker:GetHealth() <= (keys.original_damage * (self.bonus_life / 100)) and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
			keys.attacker:ForceKill(true)
			else
			keys.attacker:Heal(keys.original_damage * (self.bonus_life / 100), self)
			end
		end
	end
end

modifier_item_kaya_custom5 = class({})

function modifier_item_kaya_custom5:IsHidden()
	return true
end

function modifier_item_kaya_custom5:IsPurgable()
	return false
end

function modifier_item_kaya_custom5:OnCreated( kv )
		
		
		self.caster = self:GetCaster()
		self.bonus_dmg = self:GetAbility():GetSpecialValueFor( "bonus_dmg" )
		self.bonus_life = self:GetAbility():GetSpecialValueFor( "bonus_life" )
		self.bonus_int = self:GetAbility():GetSpecialValueFor( "bonus_int" )
		self.bonus_manaregen = self:GetAbility():GetSpecialValueFor( "mana_regen" )
		
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
function modifier_item_kaya_custom5:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
--------------------------------------------------------------------------------

function modifier_item_kaya_custom5:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_kaya_custom5:GetModifierSpellAmplify_Percentage( params )
local intellect = self.caster:GetIntellect()
local truedmg = intellect * self.bonus_dmg
	return truedmg
end

function modifier_item_kaya_custom5:GetModifierBonusStats_Intellect( params )
	return self.bonus_int
end

function modifier_item_kaya_custom5:GetModifierConstantManaRegen( params )
	return self.bonus_manaregen
end

function modifier_item_kaya_custom5:OnTakeDamage(keys)
	if keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() then		
		if self:GetParent():FindAllModifiersByName(self:GetName())[1] == self and keys.damage_category == 0 and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
			
			if keys.attacker:GetHealth() <= (keys.original_damage * (self.bonus_life / 100)) and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
			keys.attacker:ForceKill(true)
			else
			keys.attacker:Heal(keys.original_damage * (self.bonus_life / 100), self)
			end
		end
	end
end