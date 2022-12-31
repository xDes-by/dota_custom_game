enfos_wizard_lethargy = class({})

LinkLuaModifier("modifier_lethargy_debuff", "creatures/abilities/5v5/wizard/enfos_wizard_lethargy", LUA_MODIFIER_MOTION_NONE)

function enfos_wizard_lethargy:OnSpellStart()
	local caster = self:GetCaster()
	local team = caster:GetTeam()
	local target_loc = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")

	EmitSoundOnLocationWithCaster(target_loc, "Wizard.Lethargy", caster)

	local cast_pfx = ParticleManager:CreateParticle("particles/5v5/lethargy_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(cast_pfx, 0, target_loc)
	ParticleManager:SetParticleControl(cast_pfx, 1, Vector(radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(cast_pfx)

	local enemies = FindUnitsInRadius(team, target_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if enemy:GetTeam() ~= DOTA_TEAM_NEUTRALS or (enemy.spawner_team and enemy.spawner_team == team) then
			enemy:AddNewModifier(caster, self, "modifier_lethargy_debuff", {duration = duration})
		end
	end

	EnfosWizard:CastSpellResult(caster, "lethargy")
end

function enfos_wizard_lethargy:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end



modifier_lethargy_debuff = class({})

function modifier_lethargy_debuff:IsHidden() return false end
function modifier_lethargy_debuff:IsDebuff() return true end
function modifier_lethargy_debuff:IsPurgable() return false end
function modifier_lethargy_debuff:IsPurgeException() return false end

function modifier_lethargy_debuff:GetTexture() return "enfos_wizard_lethargy" end

function modifier_lethargy_debuff:GetEffectName()
	return "particles/5v5/lethargy_debuff.vpcf"
end

function modifier_lethargy_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_lethargy_debuff:OnCreated()
	local parent = self:GetParent()
	local slow = self:GetAbility():GetSpecialValueFor("slow")

	local total_as = parent:GetAttackSpeed()

	self.bonus_as = slow * total_as
	self.bonus_ms = slow
end

function modifier_lethargy_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_lethargy_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.bonus_ms
end

function modifier_lethargy_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as
end
