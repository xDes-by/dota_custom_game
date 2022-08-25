item_agility_heart_lua1 = item_agility_heart_lua1 or class({})
item_agility_heart_lua2 = item_agility_heart_lua1 or class({})
item_agility_heart_lua3 = item_agility_heart_lua1 or class({})
item_agility_heart_lua4 = item_agility_heart_lua1 or class({})
item_agility_heart_lua5 = item_agility_heart_lua1 or class({})
item_agility_heart_lua6 = item_agility_heart_lua1 or class({})
item_agility_heart_lua7 = item_agility_heart_lua1 or class({})
item_agility_heart_lua8 = item_agility_heart_lua1 or class({})

LinkLuaModifier("modifier_item_agility_heart_passive", 'items/item_agility_heart.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_agility_heart_hast", 'items/item_agility_heart.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

function item_agility_heart_lua1:GetIntrinsicModifierName()
	return "modifier_item_agility_heart_passive"
end

function item_agility_heart_lua1:OnSpellStart()
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		self.duration = self:GetSpecialValueFor( "duration" )	
		caster:AddNewModifier( self:GetCaster(), self, "modifier_item_agility_heart_hast", { duration = self.duration } )
		self:GetCaster():EmitSound("DOTA_Item.PhaseBoots.Activate")
	end
end

-----------------------------------------------------------------------------------------------

modifier_item_agility_heart_passive = class({})

function modifier_item_agility_heart_passive:IsHidden()
	return true
end

function modifier_item_agility_heart_passive:IsPurgable()
	return false
end

function modifier_item_agility_heart_passive:DestroyOnExpire()
	return false
end
function modifier_item_agility_heart_passive:RemoveOnDeath()
	return false
end
function modifier_item_agility_heart_passive:OnCreated( kv )
	local caster = self:GetCaster()
	
    self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
    self.bonus_dmg = self:GetAbility():GetSpecialValueFor("bonus_dmg")
end
-----------------------

function modifier_item_agility_heart_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}
	return funcs
end

function modifier_item_agility_heart_passive:GetModifierBonusStats_Agility( params )
	return self.bonus_agi
end

function modifier_item_agility_heart_passive:GetModifierBaseAttack_BonusDamage( params )
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
    self.crit = self:GetAbility():GetSpecialValueFor("bonus_ms")
end

function modifier_item_agility_heart_hast:GetAttributes() 
    return MODIFIER_ATTRIBUTE_NONE
end

function modifier_item_agility_heart_hast:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}
	return funcs
end

function modifier_item_agility_heart_hast:GetModifierPreAttack_CriticalStrike( params )
	return self.crit
end
