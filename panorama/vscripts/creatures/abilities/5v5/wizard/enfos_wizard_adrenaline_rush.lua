enfos_wizard_adrenaline_rush = class({})

LinkLuaModifier("modifier_adrenaline_rush_buff", "creatures/abilities/5v5/wizard/enfos_wizard_adrenaline_rush", LUA_MODIFIER_MOTION_NONE)

function enfos_wizard_adrenaline_rush:OnSpellStart()
	local caster = self:GetCaster()
	local team = caster:GetTeam()
	local duration = self:GetSpecialValueFor("duration")
	local all_heroes = Enfos:GetAllMainHeroes()

	EmitGlobalSound("wizard_adrenaline_rush")

	for _, hero in pairs(all_heroes) do
		if hero:GetTeam() == team then
			hero:AddNewModifier(caster, self, "modifier_adrenaline_rush_buff", {duration = duration})
		end
	end
	EnfosWizard:CastSpellResult(caster, "adrenaline_rush")
end



modifier_adrenaline_rush_buff = class({})

function modifier_adrenaline_rush_buff:IsHidden() return false end
function modifier_adrenaline_rush_buff:IsDebuff() return false end
function modifier_adrenaline_rush_buff:IsPurgable() return false end
function modifier_adrenaline_rush_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_adrenaline_rush_buff:GetTexture() return "enfos_wizard_adrenaline_rush" end

function modifier_adrenaline_rush_buff:GetEffectName()
	return "particles/5v5/enfos_wizard_adrenaline_rush_buff_attackspeed_owner.vpcf"
end

function modifier_adrenaline_rush_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_adrenaline_rush_buff:OnCreated()
	local parent = self:GetParent()
	local bonus = self:GetAbility():GetSpecialValueFor("bonus")

	local total_as = parent:GetAttackSpeed()

	self.bonus_as = bonus * total_as
	self.bonus_ms = bonus
end 

function modifier_adrenaline_rush_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_adrenaline_rush_buff:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_adrenaline_rush_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.bonus_ms
end

function modifier_adrenaline_rush_buff:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as
end
