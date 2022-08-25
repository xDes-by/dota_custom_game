babka_spell = class({})
LinkLuaModifier("modifier_babka_spell", "abilities/babka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_babka_spell_aura", "abilities/babka", LUA_MODIFIER_MOTION_NONE)

function babka_spell:GetIntrinsicModifierName()	
    return "modifier_babka_spell"
end

modifier_babka_spell = class({})

function modifier_babka_spell:OnCreated()
	self.caster = self:GetCaster()
	
	 
end

	
function modifier_babka_spell:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_babka_spell:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_babka_spell:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_babka_spell:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_babka_spell:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end
	
function modifier_babka_spell:GetModifierAura()
	return "modifier_babka_spell_aura"
end
	
function modifier_babka_spell:IsAura()
    if IsServer() then
	   return true
    end
end
	
function modifier_babka_spell:IsAuraActiveOnDeath()
	return false
end

function modifier_babka_spell:IsDebuff()
	return false
end

function modifier_babka_spell:IsHidden()
	return false
end

function modifier_babka_spell:IsPermanent()
	return true
end

function  modifier_babka_spell:IsPurgable()
	return false
end

modifier_babka_spell_aura = class({})

function modifier_babka_spell_aura:OnCreated()	    
	self.caster = self:GetCaster()
	
	
	self.aura_buff = "modifier_babka_spell"
	if not IsServer() then return end

    self.all = -self:GetAbility():GetSpecialValueFor("all")     
end

function modifier_babka_spell_aura:GetTexture()
    return "debuff"
end


function modifier_babka_spell_aura:DeclareFunctions()	
	local decFuncs = {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
					  MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
					  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
					  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
					  MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
					  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
	return decFuncs	
end

function modifier_babka_spell_aura:GetModifierBaseDamageOutgoing_Percentage()	 		
	return self.all		
end

function modifier_babka_spell_aura:GetModifierExtraHealthPercentage()	
	return self.all	
end

function modifier_babka_spell_aura:GetModifierPhysicalArmorBonus()
	armorcreeps = self:GetParent():GetPhysicalArmorBaseValue()
	local armor_increase = armorcreeps * self.all / 100
	return armor_increase	
end

function modifier_babka_spell_aura:GetModifierMagicalResistanceBonus()	
	magicarmorcreeps = self:GetParent():GetBaseMagicalResistanceValue()
	local magarmor_increase = magicarmorcreeps * self.all / 100
	return magarmor_increase	
end

function modifier_babka_spell_aura:GetModifierAttackSpeedBonus_Constant()	
	return self.all
end

function modifier_babka_spell_aura:GetModifierPercentageCooldown()
	return self.all--*(-1)
end