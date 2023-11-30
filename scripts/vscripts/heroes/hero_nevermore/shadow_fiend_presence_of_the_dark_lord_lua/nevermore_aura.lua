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
	return 850
end

function modifier_nevermore_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_nevermore_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function modifier_nevermore_aura:OnCreated( kv )
end

function modifier_nevermore_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end

function modifier_nevermore_aura:GetModifierPhysicalArmorBonus()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_nevermore_str10") ~= nil then 
		return self:GetAbility():GetSpecialValueFor( "reduction" ) * 5 
	end
	return 0
end

function modifier_nevermore_aura:GetModifierMagicalResistanceBonus()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_nevermore_str11") ~= nil then 
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
	if not IsServer() then
		return
	end
end

function modifier_nevermore_aura_effect:OnRefresh( kv )
	self.reduction = self:GetAbility():GetSpecialValueFor( "reduction" )
	if not IsServer() then
		return
	end
end

function modifier_nevermore_aura_effect:OnDestroy( kv )

end

function modifier_nevermore_aura_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_nevermore_aura_effect:GetModifierPhysicalArmorBonus()
	tal = 1
	if self:GetCaster():FindAbilityByName("npc_dota_hero_nevermore_agi6") ~= nil then 
		tal = 1.5
	end
	local reduction = self.reduction
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_nevermore_str50") then
		reduction = self.reduction * 3
	end
	local distance = (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D()
	if distance < 250 then
		return 5 * reduction * (-1) * tal
	end
	if distance >= 250 and  distance < 400 then
		return 4 * reduction * (-1) * tal
	end
	if distance >= 400 and  distance < 550 then
		return 3 * reduction * (-1) * tal
	end
	if distance >= 550 and  distance < 700 then
		return 2 * reduction * (-1) * tal
	end
	if distance >= 700 and  distance < 850 then
		return 1 * reduction * (-1) * tal
	end
end