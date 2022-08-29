item_ring_of_flux_lua1_gem1 = item_ring_of_flux_lua1_gem1 or class({})
item_ring_of_flux_lua2_gem1 = item_ring_of_flux_lua1_gem1 or class({})
item_ring_of_flux_lua3_gem1 = item_ring_of_flux_lua1_gem1 or class({})
item_ring_of_flux_lua4_gem1 = item_ring_of_flux_lua1_gem1 or class({})
item_ring_of_flux_lua5_gem1 = item_ring_of_flux_lua1_gem1 or class({})
item_ring_of_flux_lua6_gem1 = item_ring_of_flux_lua1_gem1 or class({})
item_ring_of_flux_lua7_gem1 = item_ring_of_flux_lua1_gem1 or class({})
item_ring_of_flux_lua8_gem1 = item_ring_of_flux_lua1_gem1 or class({})

item_ring_of_flux_lua1_gem2 = item_ring_of_flux_lua1_gem2 or class({})
item_ring_of_flux_lua2_gem2 = item_ring_of_flux_lua1_gem2 or class({})
item_ring_of_flux_lua3_gem2 = item_ring_of_flux_lua1_gem2 or class({})
item_ring_of_flux_lua4_gem2 = item_ring_of_flux_lua1_gem2 or class({})
item_ring_of_flux_lua5_gem2 = item_ring_of_flux_lua1_gem2 or class({})
item_ring_of_flux_lua6_gem2 = item_ring_of_flux_lua1_gem2 or class({})
item_ring_of_flux_lua7_gem2 = item_ring_of_flux_lua1_gem2 or class({})
item_ring_of_flux_lua8_gem2 = item_ring_of_flux_lua1_gem2 or class({})

item_ring_of_flux_lua1_gem3 = item_ring_of_flux_lua1_gem3 or class({})
item_ring_of_flux_lua2_gem3 = item_ring_of_flux_lua1_gem3 or class({})
item_ring_of_flux_lua3_gem3 = item_ring_of_flux_lua1_gem3 or class({})
item_ring_of_flux_lua4_gem3 = item_ring_of_flux_lua1_gem3 or class({})
item_ring_of_flux_lua5_gem3 = item_ring_of_flux_lua1_gem3 or class({})
item_ring_of_flux_lua6_gem3 = item_ring_of_flux_lua1_gem3 or class({})
item_ring_of_flux_lua7_gem3 = item_ring_of_flux_lua1_gem3 or class({})
item_ring_of_flux_lua8_gem3 = item_ring_of_flux_lua1_gem3 or class({})

item_ring_of_flux_lua1_gem4 = item_ring_of_flux_lua1_gem4 or class({})
item_ring_of_flux_lua2_gem4 = item_ring_of_flux_lua1_gem4 or class({})
item_ring_of_flux_lua3_gem4 = item_ring_of_flux_lua1_gem4 or class({})
item_ring_of_flux_lua4_gem4 = item_ring_of_flux_lua1_gem4 or class({})
item_ring_of_flux_lua5_gem4 = item_ring_of_flux_lua1_gem4 or class({})
item_ring_of_flux_lua6_gem4 = item_ring_of_flux_lua1_gem4 or class({})
item_ring_of_flux_lua7_gem4 = item_ring_of_flux_lua1_gem4 or class({})
item_ring_of_flux_lua8_gem4 = item_ring_of_flux_lua1_gem4 or class({})

item_ring_of_flux_lua1_gem5 = item_ring_of_flux_lua1_gem5 or class({})
item_ring_of_flux_lua2_gem5 = item_ring_of_flux_lua1_gem5 or class({})
item_ring_of_flux_lua3_gem5 = item_ring_of_flux_lua1_gem5 or class({})
item_ring_of_flux_lua4_gem5 = item_ring_of_flux_lua1_gem5 or class({})
item_ring_of_flux_lua5_gem5 = item_ring_of_flux_lua1_gem5 or class({})
item_ring_of_flux_lua6_gem5 = item_ring_of_flux_lua1_gem5 or class({})
item_ring_of_flux_lua7_gem5 = item_ring_of_flux_lua1_gem5 or class({})
item_ring_of_flux_lua8_gem5 = item_ring_of_flux_lua1_gem5 or class({})

LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier( "modifier_item_ring_of_flux_lua1", "items/items_gems/item_ring_of_flux", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_ring_of_flux_lua2", "items/items_gems/item_ring_of_flux", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_ring_of_flux_lua3", "items/items_gems/item_ring_of_flux", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_ring_of_flux_lua4", "items/items_gems/item_ring_of_flux", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_ring_of_flux_lua5", "items/items_gems/item_ring_of_flux", LUA_MODIFIER_MOTION_NONE )

function item_ring_of_flux_lua1_gem1:GetIntrinsicModifierName()
	return "modifier_item_ring_of_flux_lua1"
end
function item_ring_of_flux_lua1_gem2:GetIntrinsicModifierName()
	return "modifier_item_ring_of_flux_lua2"
end
function item_ring_of_flux_lua1_gem3:GetIntrinsicModifierName()
	return "modifier_item_ring_of_flux_lua3"
end
function item_ring_of_flux_lua1_gem4:GetIntrinsicModifierName()
	return "modifier_item_ring_of_flux_lua4"
end
function item_ring_of_flux_lua1_gem5:GetIntrinsicModifierName()
	return "modifier_item_ring_of_flux_lua5"
end

modifier_item_ring_of_flux_lua1 = class({})

function modifier_item_ring_of_flux_lua1:IsHidden()
	return true
end

function modifier_item_ring_of_flux_lua1:IsPurgable()
	return false
end

function modifier_item_ring_of_flux_lua1:OnCreated( kv )
caster = self:GetCaster()
		self.caster = self:GetCaster()
		self.cast_range = self:GetAbility():GetSpecialValueFor( "cast_range" )
		self.mana_back_chance = self:GetAbility():GetSpecialValueFor( "mana_back_chance" )
		self.spell_amp = self:GetAbility():GetSpecialValueFor( "spell_amp" )
		self.manacostred = self:GetAbility():GetSpecialValueFor( "manacostred")

	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_ring_of_flux_lua1:OnDestroy()
-- caster:ForceKill(false)
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end


--------------------------------------------------------------------------------

function modifier_item_ring_of_flux_lua1:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS,
		MODIFIER_EVENT_ON_SPENT_MANA,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_ring_of_flux_lua1:GetModifierSpellAmplify_Percentage( params )
	return self.spell_amp
end

function modifier_item_ring_of_flux_lua1:GetModifierCastRangeBonus( params )
	return self.cast_range
end

function modifier_item_ring_of_flux_lua1:GetModifierPercentageManacost( params )
	return self.manacostred
end

function modifier_item_ring_of_flux_lua1:OnSpentMana(keys)
	if keys.unit == self:GetParent() and not keys.ability:IsToggle() and not keys.ability:IsItem() and self:GetParent().GetMaxMana then
		self:RollForProc()
	end
end

function modifier_item_ring_of_flux_lua1:RollForProc()
	chance = self:GetAbility():GetSpecialValueFor( "mana_back_chance" )
	local ran = RandomInt(1,100)
		if ran <= chance then
		self.proc_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.proc_particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(self.proc_particle)
	
		self:GetParent():GiveMana(self:GetParent():GetMaxMana() * self:GetAbility():GetSpecialValueFor( "mana_back" ) * 0.01)
	end
end

modifier_item_ring_of_flux_lua2 = class({})

function modifier_item_ring_of_flux_lua2:IsHidden()
	return true
end

function modifier_item_ring_of_flux_lua2:IsPurgable()
	return false
end

function modifier_item_ring_of_flux_lua2:OnCreated( kv )
		
		
		self.caster = self:GetCaster()
		self.cast_range = self:GetAbility():GetSpecialValueFor( "cast_range" )
		self.mana_back_chance = self:GetAbility():GetSpecialValueFor( "mana_back_chance" )
		self.spell_amp = self:GetAbility():GetSpecialValueFor( "spell_amp" )
		self.manacostred = self:GetAbility():GetSpecialValueFor( "manacostred")

if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_ring_of_flux_lua2:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
--------------------------------------------------------------------------------

function modifier_item_ring_of_flux_lua2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS,
		MODIFIER_EVENT_ON_SPENT_MANA,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_ring_of_flux_lua2:GetModifierSpellAmplify_Percentage( params )
	return self.spell_amp
end

function modifier_item_ring_of_flux_lua2:GetModifierCastRangeBonus( params )
	return self.cast_range
end

function modifier_item_ring_of_flux_lua2:GetModifierPercentageManacost( params )
	return self.manacostred
end

function modifier_item_ring_of_flux_lua2:OnSpentMana(keys)
	if keys.unit == self:GetParent() and not keys.ability:IsToggle() and not keys.ability:IsItem() and self:GetParent().GetMaxMana then
		self:RollForProc()
	end
end

function modifier_item_ring_of_flux_lua2:RollForProc()
	chance = self:GetAbility():GetSpecialValueFor( "mana_back_chance" )
	local ran = RandomInt(1,100)
		if ran <= chance then
		self.proc_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.proc_particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(self.proc_particle)
	
		self:GetParent():GiveMana(self:GetParent():GetMaxMana() * self:GetAbility():GetSpecialValueFor( "mana_back" ) * 0.01)
	end
end

modifier_item_ring_of_flux_lua3 = class({})

function modifier_item_ring_of_flux_lua3:IsHidden()
	return true
end

function modifier_item_ring_of_flux_lua3:IsPurgable()
	return false
end

function modifier_item_ring_of_flux_lua3:OnCreated( kv )
		
		
		self.caster = self:GetCaster()
		self.cast_range = self:GetAbility():GetSpecialValueFor( "cast_range" )
		self.mana_back_chance = self:GetAbility():GetSpecialValueFor( "mana_back_chance" )
		self.spell_amp = self:GetAbility():GetSpecialValueFor( "spell_amp" )
		self.manacostred = self:GetAbility():GetSpecialValueFor( "manacostred")

if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_ring_of_flux_lua3:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
--------------------------------------------------------------------------------

function modifier_item_ring_of_flux_lua3:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS,
		MODIFIER_EVENT_ON_SPENT_MANA,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_ring_of_flux_lua3:GetModifierSpellAmplify_Percentage( params )
	return self.spell_amp
end

function modifier_item_ring_of_flux_lua3:GetModifierCastRangeBonus( params )
	return self.cast_range
end

function modifier_item_ring_of_flux_lua3:GetModifierPercentageManacost( params )
	return self.manacostred
end

function modifier_item_ring_of_flux_lua3:OnSpentMana(keys)
	if keys.unit == self:GetParent() and not keys.ability:IsToggle() and not keys.ability:IsItem() and self:GetParent().GetMaxMana then
		self:RollForProc()
	end
end

function modifier_item_ring_of_flux_lua3:RollForProc()
	chance = self:GetAbility():GetSpecialValueFor( "mana_back_chance" )
	local ran = RandomInt(1,100)
		if ran <= chance then
		self.proc_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.proc_particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(self.proc_particle)
	
		self:GetParent():GiveMana(self:GetParent():GetMaxMana() * self:GetAbility():GetSpecialValueFor( "mana_back" ) * 0.01)
	end
end

modifier_item_ring_of_flux_lua4 = class({})

function modifier_item_ring_of_flux_lua4:IsHidden()
	return true
end

function modifier_item_ring_of_flux_lua4:IsPurgable()
	return false
end

function modifier_item_ring_of_flux_lua4:OnCreated( kv )
		
		
		self.caster = self:GetCaster()
		self.cast_range = self:GetAbility():GetSpecialValueFor( "cast_range" )
		self.mana_back_chance = self:GetAbility():GetSpecialValueFor( "mana_back_chance" )
		self.spell_amp = self:GetAbility():GetSpecialValueFor( "spell_amp" )
		self.manacostred = self:GetAbility():GetSpecialValueFor( "manacostred")

if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_ring_of_flux_lua4:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
--------------------------------------------------------------------------------

function modifier_item_ring_of_flux_lua4:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS,
		MODIFIER_EVENT_ON_SPENT_MANA,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_ring_of_flux_lua4:GetModifierSpellAmplify_Percentage( params )
	return self.spell_amp
end

function modifier_item_ring_of_flux_lua4:GetModifierCastRangeBonus( params )
	return self.cast_range
end

function modifier_item_ring_of_flux_lua4:GetModifierPercentageManacost( params )
	return self.manacostred
end

function modifier_item_ring_of_flux_lua4:OnSpentMana(keys)
	if keys.unit == self:GetParent() and not keys.ability:IsToggle() and not keys.ability:IsItem() and self:GetParent().GetMaxMana then
		self:RollForProc()
	end
end

function modifier_item_ring_of_flux_lua4:RollForProc()
	chance = self:GetAbility():GetSpecialValueFor( "mana_back_chance" )
	local ran = RandomInt(1,100)
		if ran <= chance then
		self.proc_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.proc_particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(self.proc_particle)
	
		self:GetParent():GiveMana(self:GetParent():GetMaxMana() * self:GetAbility():GetSpecialValueFor( "mana_back" ) * 0.01)
	end
end

modifier_item_ring_of_flux_lua5 = class({})

function modifier_item_ring_of_flux_lua5:IsHidden()
	return true
end

function modifier_item_ring_of_flux_lua5:IsPurgable()
	return false
end

function modifier_item_ring_of_flux_lua5:OnCreated( kv )
		
		
		self.caster = self:GetCaster()
		self.cast_range = self:GetAbility():GetSpecialValueFor( "cast_range" )
		self.mana_back_chance = self:GetAbility():GetSpecialValueFor( "mana_back_chance" )
		self.spell_amp = self:GetAbility():GetSpecialValueFor( "spell_amp" )
		self.manacostred = self:GetAbility():GetSpecialValueFor( "manacostred")

if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end
function modifier_item_ring_of_flux_lua5:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end
--------------------------------------------------------------------------------

function modifier_item_ring_of_flux_lua5:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS,
		MODIFIER_EVENT_ON_SPENT_MANA,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_ring_of_flux_lua5:GetModifierSpellAmplify_Percentage( params )
	return self.spell_amp
end

function modifier_item_ring_of_flux_lua5:GetModifierCastRangeBonus( params )
	return self.cast_range
end

function modifier_item_ring_of_flux_lua5:GetModifierPercentageManacost( params )
	return self.manacostred
end

function modifier_item_ring_of_flux_lua5:OnSpentMana(keys)
	if keys.unit == self:GetParent() and not keys.ability:IsToggle() and not keys.ability:IsItem() and self:GetParent().GetMaxMana then
		self:RollForProc()
	end
end

function modifier_item_ring_of_flux_lua5:RollForProc()
	chance = self:GetAbility():GetSpecialValueFor( "mana_back_chance" )
	local ran = RandomInt(1,100)
		if ran <= chance then
		self.proc_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.proc_particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(self.proc_particle)
	
		self:GetParent():GiveMana(self:GetParent():GetMaxMana() * self:GetAbility():GetSpecialValueFor( "mana_back" ) * 0.01)
	end
end