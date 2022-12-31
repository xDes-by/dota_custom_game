enfos_wizard_sanctuary = class({})

LinkLuaModifier("modifier_sanctuary_buff", "creatures/abilities/5v5/wizard/enfos_wizard_sanctuary", LUA_MODIFIER_MOTION_NONE)

function enfos_wizard_sanctuary:OnSpellStart()
	local caster = self:GetCaster()
	local team = caster:GetTeam()
	local duration = self:GetSpecialValueFor("duration")
	local all_heroes = Enfos:GetAllMainHeroes()

	EmitGlobalSound("wizard_sanctuary_cast")

	for _, hero in pairs(all_heroes) do
		if hero:GetTeam() == team then
			hero:AddNewModifier(caster, self, "modifier_sanctuary_buff", {duration = duration})
		end
	end

	EnfosWizard:CastSpellResult(caster, "sanctuary")
end



modifier_sanctuary_buff = class({})

function modifier_sanctuary_buff:IsHidden() return false end
function modifier_sanctuary_buff:IsDebuff() return false end
function modifier_sanctuary_buff:IsPurgable() return false end

function modifier_sanctuary_buff:GetTexture() return "enfos_wizard_sanctuary" end

function modifier_sanctuary_buff:GetEffectName()
	return "particles/5v5/sanctuary_buff.vpcf"
end

function modifier_sanctuary_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_sanctuary_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE
	}
end

function modifier_sanctuary_buff:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_sanctuary_buff:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_sanctuary_buff:GetAbsoluteNoDamagePure()
	return 1
end
