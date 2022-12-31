enfos_wizard_plague_of_frogs = class({})

LinkLuaModifier("modifier_plague_of_frogs_debuff", "creatures/abilities/5v5/wizard/enfos_wizard_plague_of_frogs", LUA_MODIFIER_MOTION_NONE)

function enfos_wizard_plague_of_frogs:OnSpellStart()
	local caster = self:GetCaster()
	local team = caster:GetTeam()
	local duration = self:GetSpecialValueFor("duration")
	local all_heroes = HeroList:GetAllHeroes()

	for _, hero in pairs(all_heroes) do
		if hero:GetTeam() ~= team and (not hero:IsMagicImmune()) then
			if hero:IsIllusion() then
				hero:Destroy()
			else
				hero:EmitSound("Wizard.PlagueOfFrogs")

				local hex_pfx = ParticleManager:CreateParticle("particles/5v5/plague_of_frogs.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
				ParticleManager:ReleaseParticleIndex(hex_pfx)

				hero:AddNewModifier(caster, self, "modifier_plague_of_frogs_debuff", {duration = duration})
			end
		end
	end

	EnfosWizard:CastSpellResult(caster, "plague_of_frogs")
end



modifier_plague_of_frogs_debuff = class({})

function modifier_plague_of_frogs_debuff:IsHidden() return false end
function modifier_plague_of_frogs_debuff:IsDebuff() return true end
function modifier_plague_of_frogs_debuff:IsPurgable() return false end

function modifier_plague_of_frogs_debuff:GetTexture() return "lion_voodoo" end

function modifier_plague_of_frogs_debuff:OnCreated(keys)
	self.evasion = self:GetAbility():GetSpecialValueFor("evasion")
	self.movespeed = self:GetAbility():GetSpecialValueFor("movespeed")

	if IsClient() then return end

	self.croak_countdown = 0
	self:StartIntervalThink(0.5)
end

function modifier_plague_of_frogs_debuff:OnIntervalThink()
	if self.croak_countdown <= 0 and RollPercentage(20) then
		self:GetParent():EmitSound("Wizard.PlagueOfFrogs.Croak")
		self.croak_countdown = 4
	else
		self.croak_countdown = self.croak_countdown - 0.5
	end
end

function modifier_plague_of_frogs_debuff:CheckState()
	return {
		[MODIFIER_STATE_HEXED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_DISARMED] = true
	}
end

function modifier_plague_of_frogs_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}
end

function modifier_plague_of_frogs_debuff:GetModifierModelScale()
	return 50
end

function modifier_plague_of_frogs_debuff:GetModifierModelChange()
	return "models/props_gameplay/frog.vmdl"
end

function modifier_plague_of_frogs_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end

function modifier_plague_of_frogs_debuff:GetModifierEvasion_Constant()
	return self.evasion
end
