LinkLuaModifier("modifier_ancient_apparition_ice_vortex_lua_aura", "heroes/hero_ancient_apparition/ancient_apparition_ice_vortex_lua/ancient_apparition_ice_vortex_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ancient_apparition_ice_vortex_lua_aura_effect", "heroes/hero_ancient_apparition/ancient_apparition_ice_vortex_lua/ancient_apparition_ice_vortex_lua", LUA_MODIFIER_MOTION_NONE)

ancient_apparition_ice_vortex_lua = class({})

function ancient_apparition_ice_vortex_lua:GetManaCost(iLevel)
	return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function ancient_apparition_ice_vortex_lua:OnSpellStart()
	if not IsServer() then return end
	
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	
	self:GetCaster():EmitSound("Hero_Ancient_Apparition.IceVortexCast")

	caster:AddNewModifier(caster, self, "modifier_ancient_apparition_ice_vortex_lua_aura", {duration = duration})
end

---------------------------------------------------------------------------------------------------

modifier_ancient_apparition_ice_vortex_lua_aura = class({})

function modifier_ancient_apparition_ice_vortex_lua_aura:IsHidden()
	return true
end

function modifier_ancient_apparition_ice_vortex_lua_aura:OnCreated()
	local vortex_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_anti_abrasion.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(vortex_particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(vortex_particle, 5, Vector(700, 0, 0))
	self:AddParticle(vortex_particle, false, false, -1, false, false)
	
	self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	-- self.effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 700, 700, 1 ) )
	self:AddParticle( self.effect_cast, false, false, -1, false, false )
end

function modifier_ancient_apparition_ice_vortex_lua_aura:IsDebuff()
	return false
end

function modifier_ancient_apparition_ice_vortex_lua_aura:IsPurgable()
	return false
end

function modifier_ancient_apparition_ice_vortex_lua_aura:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_ancient_apparition_ice_vortex_lua_aura:GetModifierAura()
	return "modifier_ancient_apparition_ice_vortex_lua_aura_effect"
end

function modifier_ancient_apparition_ice_vortex_lua_aura:GetAuraRadius()
	return 700
end

function modifier_ancient_apparition_ice_vortex_lua_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_ancient_apparition_ice_vortex_lua_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

------------------------------------------------------------------------------------------------

modifier_ancient_apparition_ice_vortex_lua_aura_effect = class({})

function modifier_ancient_apparition_ice_vortex_lua_aura_effect:IsHidden()
	return false
end

function modifier_ancient_apparition_ice_vortex_lua_aura_effect:IsDebuff()
	return false
end

function modifier_ancient_apparition_ice_vortex_lua_aura_effect:IsPurgable()
	return false
end

function modifier_ancient_apparition_ice_vortex_lua_aura_effect:OnCreated( kv )
	self.slow = self:GetAbility():GetSpecialValueFor( "slow" ) * (-1)
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_int8") ~= nil then 
		self.slow = self.slow * 2
		self.damage = self.damage * 2
	end
end


function modifier_ancient_apparition_ice_vortex_lua_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_DISABLE_HEALING,
	}
	return funcs
end


function modifier_ancient_apparition_ice_vortex_lua_aura_effect:GetModifierMoveSpeedBonus_Percentage(keys)
	return self.slow
end

function modifier_ancient_apparition_ice_vortex_lua_aura_effect:GetModifierIncomingDamage_Percentage(keys)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_agi7") ~= nil and keys.attacker == self:GetCaster() then 
		return 15
	end	

	if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then
		if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_agi7") ~= nil and keys.attacker == self:GetCaster() then 
			return self.damage - 15
		end
		return self.damage	
	end
end

function modifier_ancient_apparition_ice_vortex_lua_aura_effect:GetDisableHealing()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_str6") ~= nil then 
		return 1
	end
	return 0	
end