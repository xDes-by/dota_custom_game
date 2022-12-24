modifier_centaur_repel_lua_disarmor = class({})

function modifier_centaur_repel_lua_disarmor:IsDebuff()
	return self:GetParent()~=self:GetAbility():GetCaster()
end

function modifier_centaur_repel_lua_disarmor:IsHidden()
	return self:GetParent()==self:GetAbility():GetCaster()
end

function modifier_centaur_repel_lua_disarmor:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------

function modifier_centaur_repel_lua_disarmor:IsAura()
	if self:GetCaster() == self:GetParent() then
		if not self:GetCaster():PassivesDisabled() then
			return true
		end
	end
	return false
end

function modifier_centaur_repel_lua_disarmor:GetModifierAura()
	return "modifier_centaur_repel_lua_disarmor"
end


function modifier_centaur_repel_lua_disarmor:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end


function modifier_centaur_repel_lua_disarmor:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC 
end

function modifier_centaur_repel_lua_disarmor:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_centaur_repel_lua_disarmor:GetAuraRadius()
	return self.aura_radius
end

function modifier_centaur_repel_lua_disarmor:GetAuraEntityReject( hEntity )
	return not hEntity:CanEntityBeSeenByMyTeam(self:GetCaster())
end
--------------------------------------------------------------------------------

function modifier_centaur_repel_lua_disarmor:OnCreated( kv )
    
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.armor_reduction = self:GetAbility():GetSpecialValueFor( "armor" )
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_centaur_str7")
	if abil ~= nil then
	self.armor_reduction = 50
	end
end

function modifier_centaur_repel_lua_disarmor:OnRefresh( kv )
    
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.armor_reduction = self:GetAbility():GetSpecialValueFor( "armor" )
end

--------------------------------------------------------------------------------

function modifier_centaur_repel_lua_disarmor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_centaur_repel_lua_disarmor:GetModifierPhysicalArmorBonus( params )
	if self:GetParent() == self:GetCaster() then
		return 0
	end	
	armorcreeps = self:GetParent():GetPhysicalArmorBaseValue()
	local armor_increase = armorcreeps / 100 * self.armor_reduction
	return armor_increase*(-1)
end

--------------------------------------------------------------------------------
