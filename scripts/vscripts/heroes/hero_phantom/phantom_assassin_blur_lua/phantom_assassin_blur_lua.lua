phantom_assassin_blur_lua = phantom_assassin_blur_lua or class({})
LinkLuaModifier("modifier_blur_aura", "heroes/hero_phantom/phantom_assassin_blur_lua/phantom_assassin_blur_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_blur_passive", "heroes/hero_phantom/phantom_assassin_blur_lua/phantom_assassin_blur_lua", LUA_MODIFIER_MOTION_NONE)

function phantom_assassin_blur_lua:GetIntrinsicModifierName()
	return "modifier_blur_aura"
end

function phantom_assassin_blur_lua:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_phantom_assassin_str_last") ~= nil	then 
        return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
    end
	return 0
end

function phantom_assassin_blur_lua:GetCooldown(level)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_phantom_assassin_str_last") ~= nil	then 
		return self.BaseClass.GetCooldown( self, level )
    end
	return 0	
end

function phantom_assassin_blur_lua:GetBehavior()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_phantom_assassin_str_last") ~= nil	then 
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	end
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function phantom_assassin_blur_lua:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_magic_immune",{ duration = 3 }	)
end

modifier_blur_aura = class({})

function modifier_blur_aura:OnCreated()
	self.caster = self:GetCaster()
	

	self.aura_radius = self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_blur_aura:GetAuraEntityReject(target)
	if self.caster == target then
		return false 
	else
	
	local abil = self.caster:FindAbilityByName("npc_dota_hero_phantom_assassin_str11")
	if abil ~= nil then
			return false
		end
	end

	return true
end

function modifier_blur_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_blur_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_blur_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_blur_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_blur_aura:GetModifierAura()
	return "modifier_blur_passive"
end

function modifier_blur_aura:IsAura()
	return true
end

function modifier_blur_aura:IsHidden()
	return true
end

function modifier_blur_aura:IsPurgable()
	return false
end

modifier_blur_passive = class({})

function modifier_blur_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}
end

function modifier_blur_passive:GetModifierEvasion_Constant(keys)
	--if IsServer() and self:GetAbility() then
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local bonus_evasion = ability:GetSpecialValueFor("bonus_evasion")
		if self:GetCaster() == self:GetParent() then
		return bonus_evasion
		end
		if self:GetCaster() ~= self:GetParent() then
		return bonus_evasion/4
		end
	
	--end
end


function modifier_blur_passive:IsHidden()
	return true
end

function modifier_blur_passive:IsPurgable()
	return false
end