modifier_chc_mastery_evasion = class({})

function modifier_chc_mastery_evasion:IsHidden() return true end
function modifier_chc_mastery_evasion:IsDebuff() return false end
function modifier_chc_mastery_evasion:IsPurgable() return false end
function modifier_chc_mastery_evasion:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_evasion:GetTexture() return "masteries/evasion" end


function modifier_chc_mastery_evasion:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE
	}
end

function modifier_chc_mastery_evasion:GetModifierAvoidDamage(params)
	if IsBitOff(params.damage_flags, DOTA_DAMAGE_FLAG_MASTERY_NUMB) and RollPercentage(self.backtrack_chance) then
		return 1 
	end
end

modifier_chc_mastery_evasion_1 = class(modifier_chc_mastery_evasion)
modifier_chc_mastery_evasion_2 = class(modifier_chc_mastery_evasion)
modifier_chc_mastery_evasion_3 = class(modifier_chc_mastery_evasion)

function modifier_chc_mastery_evasion_1:OnCreated(keys)
	if IsClient() then return end

	self.backtrack_chance = 14
end

function modifier_chc_mastery_evasion_2:OnCreated(keys)
	if IsClient() then return end

	self.backtrack_chance = 25
end

function modifier_chc_mastery_evasion_3:OnCreated(keys)
	if IsClient() then return end

	self.backtrack_chance = 40
end
