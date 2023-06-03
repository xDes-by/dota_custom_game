LinkLuaModifier( "modifier_shapeshifter_ability4_buff", "abilities/bosses/shapeshifter/shapeshifter_ability4", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

shapeshifter_ability4 = class({})

function shapeshifter_ability4:GetIntrinsicModifierName()	
    return "modifier_shapeshifter_ability4_buff"
end


---------------------------------------------------------------

modifier_shapeshifter_ability4_buff = class({})

function modifier_shapeshifter_ability4_buff:IsPurgable()		return false end
function modifier_shapeshifter_ability4_buff:RemoveOnDeath()	return false end
function modifier_shapeshifter_ability4_buff:IsHidden() return true end


function modifier_shapeshifter_ability4_buff:OnCreated()
end

function modifier_shapeshifter_ability4_buff:DeclareFunctions()	
	local decFuncs = {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
					  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
	
	return decFuncs	
end

function modifier_shapeshifter_ability4_buff:GetModifierBaseDamageOutgoing_Percentage()
    -- if not GameRules:IsDaytime() then
	--     return self:GetAbility():GetSpecialValueFor( "damage" )
    -- end
    return self:GetAbility():GetSpecialValueFor( "damage" )
end

function modifier_shapeshifter_ability4_buff:GetModifierPhysicalArmorBonus()
    -- if not GameRules:IsDaytime() then
	--     return self:GetAbility():GetSpecialValueFor( "armor" )
    -- end
    return self:GetAbility():GetSpecialValueFor( "armor" )
end