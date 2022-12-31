modifier_chc_mastery_speed_of_thought = class({})

function modifier_chc_mastery_speed_of_thought:IsHidden() return true end
function modifier_chc_mastery_speed_of_thought:IsDebuff() return false end
function modifier_chc_mastery_speed_of_thought:IsPurgable() return false end
function modifier_chc_mastery_speed_of_thought:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_speed_of_thought:GetTexture() return "masteries/speed_of_thought" end


function modifier_chc_mastery_speed_of_thought:DeclareFunctions()
	return { MODIFIER_PROPERTY_CASTTIME_PERCENTAGE }
end


function modifier_chc_mastery_speed_of_thought:_GetModifierPercentageCasttime()
	return self.cast_reduction
end


modifier_chc_mastery_speed_of_thought_1 = class(modifier_chc_mastery_speed_of_thought)
modifier_chc_mastery_speed_of_thought_2 = class(modifier_chc_mastery_speed_of_thought)
modifier_chc_mastery_speed_of_thought_3 = class(modifier_chc_mastery_speed_of_thought)

function modifier_chc_mastery_speed_of_thought_1:OnCreated(keys)
	self.cast_reduction = 20
end

function modifier_chc_mastery_speed_of_thought_2:OnCreated(keys)
	self.cast_reduction = 33
end

function modifier_chc_mastery_speed_of_thought_3:OnCreated(keys)
	self.cast_reduction = 50
end
