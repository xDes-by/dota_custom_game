modifier_spell_ampl_creep = class({})

function modifier_spell_ampl_creep:IsHidden()
	return false
end

function modifier_spell_ampl_creep:IsPurgable()
	return false
end

function modifier_spell_ampl_creep:RemoveOnDeath()
	return false
end

function modifier_spell_ampl_creep:CheckState()
if not self:GetParent():IsAncient() then return end
    return {
     [MODIFIER_STATE_FORCED_FLYING_VISION] = true,
    }
end

function modifier_spell_ampl_creep:DeclareFunctions()
	return {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE}
end

function modifier_spell_ampl_creep:GetModifierProvidesFOWVision()
	return 1
end

function modifier_spell_ampl_creep:GetModifierSpellAmplify_Percentage()
	return self:GetStackCount()*25
end

function modifier_spell_ampl_creep:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	}
	return funcs
end

function modifier_spell_ampl_creep:GetModifierProcAttack_BonusDamage_Physical( params )
	if IsServer() then
		if params.target:IsBuilding() and params.attacker:GetUnitName() == "npc_invoker_boss" then
			return  params.attacker:GetBaseDamageMin()
		end		
	end
end