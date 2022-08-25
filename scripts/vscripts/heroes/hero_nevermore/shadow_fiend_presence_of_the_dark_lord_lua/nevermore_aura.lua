nevermore_aura = class({})
LinkLuaModifier( "modifier_nevermore_aura", "heroes/hero_nevermore/shadow_fiend_presence_of_the_dark_lord_lua/nevermore_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_nevermore_aura_effect", "heroes/hero_nevermore/shadow_fiend_presence_of_the_dark_lord_lua/nevermore_aura", LUA_MODIFIER_MOTION_NONE )

function nevermore_aura:GetIntrinsicModifierName()
	return "modifier_nevermore_aura"
end

----------------------------------------------------------------------------------------------------

modifier_nevermore_aura = class({})


function modifier_nevermore_aura:IsHidden()
	return true
end

function modifier_nevermore_aura:IsDebuff()
	return false
end

function modifier_nevermore_aura:IsPurgable()
	return false
end

function modifier_nevermore_aura:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_nevermore_aura:GetModifierAura()
	return "modifier_nevermore_aura_effect"
end

function modifier_nevermore_aura:GetAuraRadius()
return 750
end

function modifier_nevermore_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_nevermore_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC
end

function modifier_nevermore_aura:OnCreated( kv )
end

function modifier_nevermore_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}

	return funcs
end

function modifier_nevermore_aura:GetModifierPhysicalArmorBonus()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_nevermore_str10")    
	if abil ~= nil then 
	return self:GetAbility():GetSpecialValueFor( "reduction" ) * 5 
	end
	return 0
end

function modifier_nevermore_aura:GetModifierMagicalResistanceBonus()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_nevermore_str11")    
	if abil ~= nil then 
	return self:GetAbility():GetSpecialValueFor( "reduction" ) * 5 
	end
	return 0
end
----------------------------------------------------------------------------------------------------

modifier_nevermore_aura_effect = class({})

function modifier_nevermore_aura_effect:IsHidden()
	return false
end

function modifier_nevermore_aura_effect:IsDebuff()
	return false
end

function modifier_nevermore_aura_effect:IsPurgable()
	return false
end


function modifier_nevermore_aura_effect:OnCreated( kv )
	self.reduction = self:GetAbility():GetSpecialValueFor( "reduction" )
end

function modifier_nevermore_aura_effect:OnRefresh( kv )
	self.reduction = self:GetAbility():GetSpecialValueFor( "reduction" )
end

function modifier_nevermore_aura_effect:OnDestroy( kv )

end

function modifier_nevermore_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

function modifier_nevermore_aura_effect:GetModifierPhysicalArmorBonus()
	tal = 1
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_nevermore_agi6")             
	if abil ~= nil then 
	tal = 1.5
	end
		local distance = (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D()
		if distance < 150 then
		return 5 * self.reduction * (-1) * tal
		end
		if distance >= 150 and  distance < 300 then
		return 4 * self.reduction * (-1) * tal
		end
		if distance >= 300 and  distance < 450 then
		return 3 * self.reduction * (-1) * tal
		end
		if distance >= 450 and  distance < 600 then
		return 2 * self.reduction * (-1) * tal
		end
		if distance >= 600 and  distance < 750 then
		return 1 * self.reduction * (-1) * tal
		end
end