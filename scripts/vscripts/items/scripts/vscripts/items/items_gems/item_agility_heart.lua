item_agility_heart_lua1_gem1 = item_agility_heart_lua1_gem1 or class({})
item_agility_heart_lua2_gem1 = item_agility_heart_lua1_gem1 or class({})
item_agility_heart_lua3_gem1 = item_agility_heart_lua1_gem1 or class({})
item_agility_heart_lua4_gem1 = item_agility_heart_lua1_gem1 or class({})
item_agility_heart_lua5_gem1 = item_agility_heart_lua1_gem1 or class({})
item_agility_heart_lua6_gem1 = item_agility_heart_lua1_gem1 or class({})
item_agility_heart_lua7_gem1 = item_agility_heart_lua1_gem1 or class({})

item_agility_heart_lua1_gem2 = item_agility_heart_lua1_gem2 or class({})
item_agility_heart_lua2_gem2 = item_agility_heart_lua1_gem2 or class({})
item_agility_heart_lua3_gem2 = item_agility_heart_lua1_gem2 or class({})
item_agility_heart_lua4_gem2 = item_agility_heart_lua1_gem2 or class({})
item_agility_heart_lua5_gem2 = item_agility_heart_lua1_gem2 or class({})
item_agility_heart_lua6_gem2 = item_agility_heart_lua1_gem2 or class({})
item_agility_heart_lua7_gem2 = item_agility_heart_lua1_gem2 or class({})

item_agility_heart_lua1_gem3 = item_agility_heart_lua1_gem3 or class({})
item_agility_heart_lua2_gem3 = item_agility_heart_lua1_gem3 or class({})
item_agility_heart_lua3_gem3 = item_agility_heart_lua1_gem3 or class({})
item_agility_heart_lua4_gem3 = item_agility_heart_lua1_gem3 or class({})
item_agility_heart_lua5_gem3 = item_agility_heart_lua1_gem3 or class({})
item_agility_heart_lua6_gem3 = item_agility_heart_lua1_gem3 or class({})
item_agility_heart_lua7_gem3 = item_agility_heart_lua1_gem3 or class({})

item_agility_heart_lua1_gem4 = item_agility_heart_lua1_gem4 or class({})
item_agility_heart_lua2_gem4 = item_agility_heart_lua1_gem4 or class({})
item_agility_heart_lua3_gem4 = item_agility_heart_lua1_gem4 or class({})
item_agility_heart_lua4_gem4 = item_agility_heart_lua1_gem4 or class({})
item_agility_heart_lua5_gem4 = item_agility_heart_lua1_gem4 or class({})
item_agility_heart_lua6_gem4 = item_agility_heart_lua1_gem4 or class({})
item_agility_heart_lua7_gem4 = item_agility_heart_lua1_gem4 or class({})

item_agility_heart_lua1_gem5 = item_agility_heart_lua1_gem5 or class({})
item_agility_heart_lua2_gem5 = item_agility_heart_lua1_gem5 or class({})
item_agility_heart_lua3_gem5 = item_agility_heart_lua1_gem5 or class({})
item_agility_heart_lua4_gem5 = item_agility_heart_lua1_gem5 or class({})
item_agility_heart_lua5_gem5 = item_agility_heart_lua1_gem5 or class({})
item_agility_heart_lua6_gem5 = item_agility_heart_lua1_gem5 or class({})
item_agility_heart_lua7_gem5 = item_agility_heart_lua1_gem5 or class({})

LinkLuaModifier("modifier_item_agility_heart_lua1_gem1", 'items/items_gems/item_agility_heart.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_agility_heart_lua1_gem2", 'items/items_gems/item_agility_heart.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_agility_heart_lua1_gem3", 'items/items_gems/item_agility_heart.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_agility_heart_lua1_gem4", 'items/items_gems/item_agility_heart.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_agility_heart_lua1_gem5", 'items/items_gems/item_agility_heart.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_agility_heart_hast", 'items/items_gems/item_agility_heart.lua', LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

function item_agility_heart_lua1_gem1:GetIntrinsicModifierName()
	return "modifier_item_agility_heart_lua1_gem1"
end

function item_agility_heart_lua1_gem1:OnSpellStart()
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		self.duration = self:GetSpecialValueFor( "duration" )	
		caster:AddNewModifier( self:GetCaster(), self, "modifier_item_agility_heart_hast", { duration = self.duration } )
		self:GetCaster():EmitSound("DOTA_Item.PhaseBoots.Activate")
	end
end
--item_agility_heart_lua1_gem2
function item_agility_heart_lua1_gem2:GetIntrinsicModifierName()
	return "modifier_item_agility_heart_lua1_gem2"
end

function item_agility_heart_lua1_gem2:OnSpellStart()
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		self.duration = self:GetSpecialValueFor( "duration" )	
		caster:AddNewModifier( self:GetCaster(), self, "modifier_item_agility_heart_hast", { duration = self.duration } )
		self:GetCaster():EmitSound("DOTA_Item.PhaseBoots.Activate")
	end
end
--item_agility_heart_lua1_gem3
function item_agility_heart_lua1_gem3:GetIntrinsicModifierName()
	return "modifier_item_agility_heart_lua1_gem3"
end

function item_agility_heart_lua1_gem3:OnSpellStart()
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		self.duration = self:GetSpecialValueFor( "duration" )	
		caster:AddNewModifier( self:GetCaster(), self, "modifier_item_agility_heart_hast", { duration = self.duration } )
		self:GetCaster():EmitSound("DOTA_Item.PhaseBoots.Activate")
	end
end
--item_agility_heart_lua1_gem4
function item_agility_heart_lua1_gem4:GetIntrinsicModifierName()
	return "modifier_item_agility_heart_lua1_gem4"
end

function item_agility_heart_lua1_gem4:OnSpellStart()
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		self.duration = self:GetSpecialValueFor( "duration" )	
		caster:AddNewModifier( self:GetCaster(), self, "modifier_item_agility_heart_hast", { duration = self.duration } )
		self:GetCaster():EmitSound("DOTA_Item.PhaseBoots.Activate")
	end
end
--item_agility_heart_lua1_gem5
function item_agility_heart_lua1_gem5:GetIntrinsicModifierName()
	return "modifier_item_agility_heart_lua1_gem5"
end

function item_agility_heart_lua1_gem5:OnSpellStart()
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		self.duration = self:GetSpecialValueFor( "duration" )	
		caster:AddNewModifier( self:GetCaster(), self, "modifier_item_agility_heart_hast", { duration = self.duration } )
		self:GetCaster():EmitSound("DOTA_Item.PhaseBoots.Activate")
	end
end
-----------------------------------------------------------------------------------------------

modifier_item_agility_heart_lua1_gem1 = class({})

function modifier_item_agility_heart_lua1_gem1:IsHidden()
	return true
end

function modifier_item_agility_heart_lua1_gem1:IsPurgable()
	return false
end

function modifier_item_agility_heart_lua1_gem1:DestroyOnExpire()
	return false
end

function modifier_item_agility_heart_lua1_gem1:OnCreated( kv )
	local caster = self:GetCaster()
	
	
	
	self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
    self.bonus_dmg = self:GetAbility():GetSpecialValueFor("bonus_dmg")
	
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_agility_heart_lua1_gem1:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_agility_heart_lua1_gem1:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}
	return funcs
end

function modifier_item_agility_heart_lua1_gem1:GetModifierBonusStats_Agility( params )
	return self.bonus_agi
end

function modifier_item_agility_heart_lua1_gem1:GetModifierBaseAttack_BonusDamage( params )
	return self.bonus_dmg
end

-----------------------------------------------------------------------------------------------

modifier_item_agility_heart_lua1_gem2 = class({})

function modifier_item_agility_heart_lua1_gem2:IsHidden()
	return true
end

function modifier_item_agility_heart_lua1_gem2:IsPurgable()
	return false
end

function modifier_item_agility_heart_lua1_gem2:DestroyOnExpire()
	return false
end

function modifier_item_agility_heart_lua1_gem2:OnCreated( kv )
	local caster = self:GetCaster()
	
	
	
	self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
    self.bonus_dmg = self:GetAbility():GetSpecialValueFor("bonus_dmg")
	
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_agility_heart_lua1_gem2:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_agility_heart_lua1_gem2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}
	return funcs
end

function modifier_item_agility_heart_lua1_gem2:GetModifierBonusStats_Agility( params )
	return self.bonus_agi
end

function modifier_item_agility_heart_lua1_gem2:GetModifierBaseAttack_BonusDamage( params )
	return self.bonus_dmg
end

-----------------------------------------------------------------------------------------------

modifier_item_agility_heart_lua1_gem3 = class({})

function modifier_item_agility_heart_lua1_gem3:IsHidden()
	return true
end

function modifier_item_agility_heart_lua1_gem3:IsPurgable()
	return false
end

function modifier_item_agility_heart_lua1_gem3:DestroyOnExpire()
	return false
end

function modifier_item_agility_heart_lua1_gem3:OnCreated( kv )
	local caster = self:GetCaster()
	
	
	
	self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
    self.bonus_dmg = self:GetAbility():GetSpecialValueFor("bonus_dmg")
	
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_agility_heart_lua1_gem3:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_agility_heart_lua1_gem3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}
	return funcs
end

function modifier_item_agility_heart_lua1_gem3:GetModifierBonusStats_Agility( params )
	return self.bonus_agi
end

function modifier_item_agility_heart_lua1_gem3:GetModifierBaseAttack_BonusDamage( params )
	return self.bonus_dmg
end

-----------------------------------------------------------------------------------------------

modifier_item_agility_heart_lua1_gem4 = class({})

function modifier_item_agility_heart_lua1_gem4:IsHidden()
	return true
end

function modifier_item_agility_heart_lua1_gem4:IsPurgable()
	return false
end

function modifier_item_agility_heart_lua1_gem4:DestroyOnExpire()
	return false
end

function modifier_item_agility_heart_lua1_gem4:OnCreated( kv )
	local caster = self:GetCaster()
	
	
	
	self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
    self.bonus_dmg = self:GetAbility():GetSpecialValueFor("bonus_dmg")
	
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_agility_heart_lua1_gem4:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_agility_heart_lua1_gem4:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}
	return funcs
end

function modifier_item_agility_heart_lua1_gem4:GetModifierBonusStats_Agility( params )
	return self.bonus_agi
end

function modifier_item_agility_heart_lua1_gem4:GetModifierBaseAttack_BonusDamage( params )
	return self.bonus_dmg
end

-----------------------------------------------------------------------------------------------

modifier_item_agility_heart_lua1_gem5 = class({})

function modifier_item_agility_heart_lua1_gem5:IsHidden()
	return true
end

function modifier_item_agility_heart_lua1_gem5:IsPurgable()
	return false
end

function modifier_item_agility_heart_lua1_gem5:DestroyOnExpire()
	return false
end

function modifier_item_agility_heart_lua1_gem5:OnCreated( kv )
	local caster = self:GetCaster()
	
	
	
	self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
    self.bonus_dmg = self:GetAbility():GetSpecialValueFor("bonus_dmg")
	
if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
		local gem = string.sub(self:GetAbility():GetName(), -4)
		if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			local modifierName = "modifier_" .. gem
			self.gem_bonus_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, {stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")})
		end
	end 
end

function modifier_item_agility_heart_lua1_gem5:OnDestroy()
	if self.gem_bonus_modifier then
		self.gem_bonus_modifier:Destroy()
	end
end

function modifier_item_agility_heart_lua1_gem5:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}
	return funcs
end

function modifier_item_agility_heart_lua1_gem5:GetModifierBonusStats_Agility( params )
	return self.bonus_agi
end

function modifier_item_agility_heart_lua1_gem5:GetModifierBaseAttack_BonusDamage( params )
	return self.bonus_dmg
end

-------------------------------------------------------------------------------------------------


modifier_item_agility_heart_hast = class({})

function modifier_item_agility_heart_hast:IsHidden()
	return false
end

function modifier_item_agility_heart_hast:IsPurgable()
	return false
end


function modifier_item_agility_heart_hast:OnCreated( kv )
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
    self.bonus_ms = self:GetAbility():GetSpecialValueFor("bonus_ms")

end

-----------------------

function modifier_item_agility_heart_hast:GetAttributes() 
    return MODIFIER_ATTRIBUTE_NONE
end

function modifier_item_agility_heart_hast:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_item_agility_heart_hast:GetModifierMoveSpeedBonus_Constant( params )
	return self.bonus_ms
end