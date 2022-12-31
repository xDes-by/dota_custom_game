modifier_spell_amplify_controller = class({})

function modifier_spell_amplify_controller:IsHidden() return true end
function modifier_spell_amplify_controller:IsDebuff() return false end
function modifier_spell_amplify_controller:IsPurgable() return false end
function modifier_spell_amplify_controller:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_spell_amplify_controller:RemoveOnDeath() return false end

function modifier_spell_amplify_controller:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
end

if IsClient() then return end

function modifier_spell_amplify_controller:GetModifierSpellAmplify_Percentage(params)	
	local inflictor = params.inflictor

	if inflictor and not inflictor:IsNull() then
		local ability_name = inflictor:GetAbilityName()
		local parent = self:GetParent()

		if HeroBuilder.disable_spell_amp[ability_name] and (ability_name ~= "enigma_black_hole" or parent:HasScepter()) then
			local amp = parent:GetSpellAmplification(false)
			return -amp*100
		end
	end

	return 0
end
